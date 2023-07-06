const std = @import("std");

const types = @import("types.zig");
const descriptions = @import("descriptions.zig");

// export all the types and descriptors for ease of use
pub usingnamespace descriptions;
pub usingnamespace types;

pub const gl = zgl.gl; //@import("gl_4v1.zig");
const zgl = @import("zopengl.zig");
const translations = @import("gl_translations.zig");

var in_pass: bool = false;

const HandledCache = @import("handles.zig").HandledCache;
const RenderCache = @import("render_cache.zig").RenderCache;
const GLuint = gl.Uint;
const GLint = gl.Int;
const GLenum = gl.Enum;
const GLsizei = gl.Sizei;
const GLbitfield = gl.Bitfield;

var cache = RenderCache.init();
var pip_cache: types.RenderState = undefined;
var vao: GLuint = undefined;
var cur_bindings: types.BufferBindings = undefined;

var image_cache: HandledCache(GLImage) = undefined;
var pass_cache: HandledCache(GLPass) = undefined;
var buffer_cache: HandledCache(GLBuffer) = undefined;
var shader_cache: HandledCache(GLShaderProgram) = undefined;

var frame_index: u32 = 1;
var cur_pass_h: c_int = 0; // used to flip scissor rects to be top-left origin to match Metal

// setup and state
pub fn setup(desc: descriptions.RendererDesc, allocator: std.mem.Allocator) void {
    image_cache = HandledCache(GLImage).init(allocator, desc.pool_sizes.texture);
    pass_cache = HandledCache(GLPass).init(allocator, desc.pool_sizes.offscreen_pass);
    buffer_cache = HandledCache(GLBuffer).init(allocator, desc.pool_sizes.buffers);
    shader_cache = HandledCache(GLShaderProgram).init(allocator, desc.pool_sizes.shaders);

    // gl.load(desc.gl_loader.?) catch unreachable;
    zgl.loadCoreProfile(desc.gl_loader.?, 3, 3) catch {};

    pip_cache = std.mem.zeroes(types.RenderState);
    setRenderState(.{});

    gl.genVertexArrays(1, &vao);
    cache.bindVertexArray(vao);
}

pub fn shutdown() void {
    // TODO: destroy the items in the caches as well
    image_cache.deinit();
    pass_cache.deinit();
    buffer_cache.deinit();
    shader_cache.deinit();
}

fn checkError(src: std.builtin.SourceLocation) void {
    var err_code: GLenum = gl.getError();
    while (err_code != gl.NO_ERROR) {
        var error_name = switch (err_code) {
            gl.INVALID_ENUM => "GL_INVALID_ENUM",
            gl.INVALID_VALUE => "GL_INVALID_VALUE",
            gl.INVALID_OPERATION => "GL_INVALID_OPERATION",
            gl.STACK_OVERFLOW_KHR => "GL_STACK_OVERFLOW_KHR",
            gl.STACK_UNDERFLOW_KHR => "GL_STACK_UNDERFLOW_KHR",
            gl.OUT_OF_MEMORY => "GL_OUT_OF_MEMORY",
            gl.INVALID_FRAMEBUFFER_OPERATION => "GL_INVALID_FRAMEBUFFER_OPERATION",
            else => "Unknown Error Enum",
        };

        std.debug.print("error: {}, file: {}, func: {}, line: {}\n", .{ error_name, src.file, src.fn_name, src.line });
        err_code = gl.getError();
    }
}

fn checkShaderError(shader: GLuint) bool {
    var status: GLint = gl.FALSE;
    gl.getShaderiv(shader, gl.COMPILE_STATUS, &status);
    if (status != gl.TRUE) {
        var buf: [2048]u8 = undefined;
        var total_len: GLsizei = -1;
        gl.getShaderInfoLog(shader, 2048, &total_len, buf[0..]);
        if (total_len == -1) {
            // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
            unreachable;
        }

        std.debug.print("shader compilation error:\n{s}", .{buf[0..@as(usize, @intCast(total_len))]});
        return false;
    }
    return true;
}

fn checkProgramError(shader: GLuint) bool {
    var status: GLint = gl.FALSE;
    gl.getProgramiv(shader, gl.LINK_STATUS, &status);
    if (status != gl.TRUE) {
        var buf: [2048]u8 = undefined;
        var total_len: GLsizei = -1;
        gl.getProgramInfoLog(shader, 2048, &total_len, buf[0..]);
        if (total_len == -1) {
            // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
            unreachable;
        }

        std.debug.print("program link error:\n{s}", .{buf[0..@as(usize, @intCast(total_len))]});
        return false;
    }
    return true;
}

pub fn setRenderState(state: types.RenderState) void {
    // depth
    if (state.depth.enabled != pip_cache.depth.enabled) {
        if (state.depth.enabled) gl.enable(gl.DEPTH_TEST) else gl.disable(gl.DEPTH_TEST);
        gl.depthMask(if (state.depth.enabled) gl.TRUE else gl.FALSE);
        pip_cache.depth.enabled = state.depth.enabled;
    }

    if (state.depth.compare_func != pip_cache.depth.compare_func) {
        gl.depthFunc(translations.compareFuncToGl(state.depth.compare_func));
        pip_cache.depth.compare_func = state.depth.compare_func;
    }

    // stencil
    if (state.stencil.enabled != pip_cache.stencil.enabled) {
        if (state.stencil.enabled) gl.enable(gl.STENCIL_TEST) else gl.disable(gl.STENCIL_TEST);
        pip_cache.stencil.enabled = state.stencil.enabled;
    }

    if (state.stencil.write_mask != pip_cache.stencil.write_mask) {
        gl.stencilMask(@as(GLuint, @intCast(state.stencil.write_mask)));
        pip_cache.stencil.write_mask = state.stencil.write_mask;
    }

    if (state.stencil.compare_func != pip_cache.stencil.compare_func or
        state.stencil.read_mask != pip_cache.stencil.read_mask or
        state.stencil.ref != pip_cache.stencil.ref)
    {
        gl.stencilFunc(translations.compareFuncToGl(state.stencil.compare_func), @as(GLint, @intCast(state.stencil.ref)), @as(GLuint, @intCast(state.stencil.read_mask)));
        pip_cache.stencil.compare_func = state.stencil.compare_func;
        pip_cache.stencil.ref = state.stencil.ref;
        pip_cache.stencil.read_mask = state.stencil.read_mask;
    }

    if (state.stencil.fail_op != pip_cache.stencil.fail_op or
        state.stencil.depth_fail_op != pip_cache.stencil.depth_fail_op or
        state.stencil.pass_op != pip_cache.stencil.pass_op)
    {
        gl.stencilOp(translations.stencilOpToGl(state.stencil.fail_op), translations.stencilOpToGl(state.stencil.depth_fail_op), translations.stencilOpToGl(state.stencil.pass_op));
        pip_cache.stencil.fail_op = state.stencil.fail_op;
        pip_cache.stencil.depth_fail_op = state.stencil.depth_fail_op;
        pip_cache.stencil.pass_op = state.stencil.pass_op;
    }

    // blend
    if (state.blend.enabled != pip_cache.blend.enabled) {
        if (state.blend.enabled) gl.enable(gl.BLEND) else gl.disable(gl.BLEND);
        pip_cache.blend.enabled = state.blend.enabled;
    }

    if (state.blend.src_factor_rgb != pip_cache.blend.src_factor_rgb or
        state.blend.dst_factor_rgb != pip_cache.blend.dst_factor_rgb or
        state.blend.src_factor_alpha != pip_cache.blend.src_factor_alpha or
        state.blend.dst_factor_alpha != pip_cache.blend.dst_factor_alpha)
    {
        gl.blendFuncSeparate(translations.blendFactorToGl(state.blend.src_factor_rgb), translations.blendFactorToGl(state.blend.dst_factor_rgb), translations.blendFactorToGl(state.blend.src_factor_alpha), translations.blendFactorToGl(state.blend.dst_factor_alpha));
        pip_cache.blend.src_factor_rgb = state.blend.src_factor_rgb;
        pip_cache.blend.dst_factor_rgb = state.blend.dst_factor_rgb;
        pip_cache.blend.src_factor_alpha = state.blend.src_factor_alpha;
        pip_cache.blend.dst_factor_alpha = state.blend.dst_factor_alpha;
    }

    if (state.blend.op_rgb != pip_cache.blend.op_rgb or state.blend.op_alpha != pip_cache.blend.op_alpha) {
        gl.blendEquationSeparate(translations.blendOpToGl(state.blend.op_rgb), translations.blendOpToGl(state.blend.op_alpha));
        pip_cache.blend.op_rgb = state.blend.op_rgb;
        pip_cache.blend.op_alpha = state.blend.op_alpha;
    }

    if (state.blend.color_write_mask != pip_cache.blend.color_write_mask) {
        const r = (@intFromEnum(state.blend.color_write_mask) & @intFromEnum(types.ColorMask.r)) != 0;
        const g = (@intFromEnum(state.blend.color_write_mask) & @intFromEnum(types.ColorMask.g)) != 0;
        const b = (@intFromEnum(state.blend.color_write_mask) & @intFromEnum(types.ColorMask.b)) != 0;
        const a = (@intFromEnum(state.blend.color_write_mask) & @intFromEnum(types.ColorMask.a)) != 0;
        gl.colorMask(if (r) 1 else 0, if (g) 1 else 0, if (b) 1 else 0, if (a) 1 else 0);
        pip_cache.blend.color_write_mask = state.blend.color_write_mask;
    }

    if (std.math.approxEqAbs(f32, state.blend.color[0], pip_cache.blend.color[0], 0.0001) or
        std.math.approxEqAbs(f32, state.blend.color[1], pip_cache.blend.color[1], 0.0001) or
        std.math.approxEqAbs(f32, state.blend.color[2], pip_cache.blend.color[2], 0.0001) or
        std.math.approxEqAbs(f32, state.blend.color[3], pip_cache.blend.color[3], 0.0001))
    {
        gl.blendColor(state.blend.color[0], state.blend.color[1], state.blend.color[2], state.blend.color[3]);
        pip_cache.blend.color = state.blend.color;
    }

    // scissor
    if (state.scissor != pip_cache.scissor) {
        if (state.scissor) gl.enable(gl.SCISSOR_TEST) else gl.disable(gl.SCISSOR_TEST);
        pip_cache.scissor = state.scissor;
    }

    // cull mode
    if (state.cull_mode != pip_cache.cull_mode) {
        if (state.cull_mode == .none) gl.enable(gl.CULL_FACE) else gl.disable(gl.CULL_FACE);
        switch (state.cull_mode) {
            .front => gl.cullFace(gl.FRONT),
            .back => gl.cullFace(gl.BACK),
            else => {},
        }
        pip_cache.cull_mode = state.cull_mode;
    }

    // face winding
    if (state.face_winding != pip_cache.face_winding) {
        gl.frontFace(if (state.face_winding == .ccw) gl.CCW else gl.CW);
        pip_cache.face_winding = state.face_winding;
    }
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    std.debug.assert(in_pass);
    cache.viewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    std.debug.assert(in_pass);
    cache.scissor(x, y, width, height, cur_pass_h);
}

// images
const GLImage = struct {
    tid: GLuint,
    width: i32,
    height: i32,
    depth: bool,
    stencil: bool,
};

pub fn createImage(desc: descriptions.ImageDesc) types.Image {
    var img = std.mem.zeroes(GLImage);
    img.width = desc.width;
    img.height = desc.height;

    if (desc.pixel_format == .depth_stencil) {
        std.debug.assert(desc.usage == .immutable);
        gl.genRenderbuffers(1, &img.tid);
        gl.bindRenderbuffer(gl.RENDERBUFFER, img.tid);
        gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH24_STENCIL8, desc.width, desc.height);
        img.depth = true;
        img.stencil = true;
    } else if (desc.pixel_format == .stencil) {
        std.debug.assert(desc.usage == .immutable);
        gl.genRenderbuffers(1, &img.tid);
        gl.bindRenderbuffer(gl.RENDERBUFFER, img.tid);
        gl.renderbufferStorage(gl.RENDERBUFFER, gl.STENCIL_INDEX8, desc.width, desc.height);
        img.stencil = true;
    } else {
        gl.genTextures(1, &img.tid);
        cache.bindImage(img.tid, 0);

        const wrap_u: GLint = if (desc.wrap_u == .clamp) gl.CLAMP_TO_EDGE else gl.REPEAT;
        const wrap_v: GLint = if (desc.wrap_v == .clamp) gl.CLAMP_TO_EDGE else gl.REPEAT;
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, wrap_u);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, wrap_v);

        const filter_min: GLint = if (desc.min_filter == .nearest) gl.NEAREST else gl.LINEAR;
        const filter_mag: GLint = if (desc.mag_filter == .nearest) gl.NEAREST else gl.LINEAR;
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, filter_min);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, filter_mag);

        if (desc.content) |content| {
            gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, desc.width, desc.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, content);
        } else {
            gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, desc.width, desc.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
        }

        cache.bindImage(0, 0);
    }

    return image_cache.append(img);
}

pub fn destroyImage(image: types.Image) void {
    var img = image_cache.free(image);
    cache.invalidateTexture(img.tid);
    gl.deleteTextures(1, &img.tid);
}

pub fn updateImage(comptime T: type, image: types.Image, content: []const T) void {
    var img = image_cache.get(image);

    cache.bindImage(img.tid, 0);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, img.width, img.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, content.ptr);
    cache.bindImage(0, 0);
}

pub fn getNativeTid(image: types.Image) c_uint {
    return image_cache.get(image).tid;
}

// offscreen pass
const GLPass = struct {
    framebuffer_tid: GLuint = 0,
    color_atts: [4]types.Image = [_]types.Image{0} ** 4,
    num_color_atts: usize = 1,
    depth_stencil_img: ?types.Image = null,
};

pub fn createPass(desc: descriptions.PassDesc) types.Pass {
    var pass = GLPass{};
    pass.depth_stencil_img = null;

    var orig_fb: GLint = undefined;
    gl.getIntegerv(gl.FRAMEBUFFER_BINDING, &orig_fb);
    defer gl.bindFramebuffer(gl.FRAMEBUFFER, @as(GLuint, @intCast(orig_fb)));

    pass.color_atts[0] = desc.color_img;

    // create a framebuffer object
    gl.genFramebuffers(1, &pass.framebuffer_tid);
    gl.bindFramebuffer(gl.FRAMEBUFFER, pass.framebuffer_tid);
    defer gl.bindFramebuffer(gl.FRAMEBUFFER, 0);

    // bind depth-stencil
    if (desc.depth_stencil_img) |depth_stencil_handle| {
        const depth_stencil = image_cache.get(depth_stencil_handle);
        if (depth_stencil.depth) gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, depth_stencil.tid);
        if (depth_stencil.stencil) gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.STENCIL_ATTACHMENT, gl.RENDERBUFFER, depth_stencil.tid);
        pass.depth_stencil_img = depth_stencil_handle;
    }

    // Set color_img as our color attachement #0
    const color_img = image_cache.get(desc.color_img);
    gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, color_img.tid, 0);

    // set additional attachments if present
    if (desc.color_img2) |img| {
        pass.num_color_atts += 1;
        pass.color_atts[1] = img;
        gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT1, gl.TEXTURE_2D, image_cache.get(img).tid, 0);
    }
    if (desc.color_img3) |img| {
        pass.num_color_atts += 1;
        pass.color_atts[2] = img;
        gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT2, gl.TEXTURE_2D, image_cache.get(img).tid, 0);
    }
    if (desc.color_img4) |img| {
        pass.num_color_atts += 1;
        pass.color_atts[2] = img;
        gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT3, gl.TEXTURE_2D, image_cache.get(img).tid, 0);
    }

    // Set the list of draw buffers
    var draw_buffers: [4]GLenum = [_]GLenum{ gl.COLOR_ATTACHMENT0, gl.COLOR_ATTACHMENT1, gl.COLOR_ATTACHMENT2, gl.COLOR_ATTACHMENT3 };
    gl.drawBuffers(@as(gl.Sizei, @intCast(pass.num_color_atts)), &draw_buffers);

    if (gl.checkFramebufferStatus(gl.FRAMEBUFFER) != gl.FRAMEBUFFER_COMPLETE) std.debug.print("framebuffer failed\n", .{});

    return pass_cache.append(pass);
}

pub fn destroyPass(offscreen_pass: types.Pass) void {
    var pass = pass_cache.free(offscreen_pass);
    gl.deleteFramebuffers(1, &pass.framebuffer_tid);
    if (pass.depth_stencil_img) |depth_stencil_handle| {
        var depth_stencil = image_cache.get(depth_stencil_handle);
        gl.deleteRenderbuffers(1, &depth_stencil.tid);
    }
}

pub fn beginDefaultPass(action: types.ClearCommand, width: c_int, height: c_int) void {
    std.debug.assert(!in_pass);
    in_pass = true;
    beginDefaultOrOffscreenPass(0, action, width, height);
}

pub fn beginPass(pass: types.Pass, action: types.ClearCommand) void {
    std.debug.assert(!in_pass);
    in_pass = true;
    beginDefaultOrOffscreenPass(pass, action, -1, -1);
}

fn beginDefaultOrOffscreenPass(offscreen_pass: types.Pass, action: types.ClearCommand, width: c_int, height: c_int) void {
    var num_color_atts: usize = 1;

    // pass 0 is invalid so if its greater than 0 this is an offscreen pass
    if (offscreen_pass > 0) {
        const pass = pass_cache.get(offscreen_pass);
        const img = image_cache.get(pass.color_atts[0]);
        gl.bindFramebuffer(gl.FRAMEBUFFER, pass.framebuffer_tid);
        gl.viewport(0, 0, img.width, img.height);
        cur_pass_h = img.height;
        num_color_atts = pass.num_color_atts;
    } else {
        gl.viewport(0, 0, width, height);
        cur_pass_h = height;
    }

    var clear_mask: GLbitfield = 0;
    if (action.colors[0].clear) {
        clear_mask |= gl.COLOR_BUFFER_BIT;
        gl.clearColor(action.colors[0].color[0], action.colors[0].color[1], action.colors[0].color[2], action.colors[0].color[3]);
    }
    if (action.clear_stencil) {
        clear_mask |= gl.STENCIL_BUFFER_BIT;
        if (pip_cache.stencil.write_mask != 0xFF) {
            pip_cache.stencil.write_mask = 0xFF;
            gl.stencilMask(0xFF);
        }
    }
    if (action.clear_depth) {
        clear_mask |= gl.DEPTH_BUFFER_BIT;
        if (!pip_cache.depth.enabled) {
            pip_cache.depth.enabled = true;
            gl.enable(gl.DEPTH_TEST);
            gl.depthMask(gl.TRUE);
        }
    }

    if (num_color_atts == 1) {
        if (action.colors[0].clear) gl.clearColor(action.colors[0].color[0], action.colors[0].color[1], action.colors[0].color[2], action.colors[0].color[3]);
        if (action.clear_stencil) gl.clearStencil(@as(GLint, @intCast(action.stencil)));
        if (action.clear_depth) gl.clearDepth(action.depth);
        if (clear_mask != 0) gl.clear(clear_mask);
    } else {
        for (action.colors, 0..) |color_action, i| {
            const index: c_int = @as(c_int, @intCast(i));

            if (color_action.clear) gl.clearBufferfv(gl.COLOR, index, &color_action.color);

            if (action.clear_depth and action.clear_stencil) {
                gl.clearBufferfi(gl.DEPTH_STENCIL, index, @as(f32, @floatCast(action.depth)), action.stencil);
            } else if (action.clear_depth) {
                gl.clearBufferfv(gl.DEPTH, index, &@as(f32, @floatCast(action.depth)));
            } else if (action.clear_stencil) {
                gl.clearBufferiv(gl.STENCIL, index, &@as(gl.Int, @intCast(action.stencil)));
            }
        }
    }
}

pub fn endPass() void {
    std.debug.assert(in_pass);
    in_pass = false;
    gl.bindFramebuffer(gl.FRAMEBUFFER, 0);
}

pub fn commitFrame() void {
    std.debug.assert(!in_pass);
    frame_index += 1;
}

// buffers
const GLBuffer = struct {
    vbo: GLuint,
    stream: bool,
    size: u32,
    append_frame_index: u32,
    append_pos: u32,
    append_overflow: bool,
    index_buffer_type: GLenum,
    vert_buffer_step_func: GLuint,
    setVertexAttributes: ?*const fn (attr_index: *GLuint, step_func: GLuint, vertex_buffer_offset: u32) void,
};

pub fn createBuffer(comptime T: type, desc: descriptions.BufferDesc(T)) types.Buffer {
    var buffer = std.mem.zeroes(GLBuffer);
    buffer.stream = desc.usage == .stream;
    buffer.vert_buffer_step_func = if (desc.step_func == .per_vertex) 0 else 1;
    buffer.size = @as(u32, @intCast(desc.getSize()));

    if (@typeInfo(T) == .Struct) {
        buffer.setVertexAttributes = struct {
            fn cb(attr_index: *GLuint, step_func: GLuint, vertex_buffer_offset: u32) void {
                inline for (@typeInfo(T).Struct.fields, 0..) |field, i| {
                    const offset: ?usize = if (i + vertex_buffer_offset == 0) null else vertex_buffer_offset + @offsetOf(T, field.name);

                    switch (@typeInfo(field.type)) {
                        .Int => |type_info| {
                            if (type_info.signedness == .signed) {
                                unreachable;
                            } else {
                                switch (type_info.bits) {
                                    32 => {
                                        // u32 is color
                                        const off = if (offset) |o| @as(*anyopaque, @ptrFromInt(o)) else null;
                                        gl.vertexAttribPointer(attr_index.*, 4, gl.UNSIGNED_BYTE, gl.TRUE, @sizeOf(T), off);
                                        gl.enableVertexAttribArray(attr_index.*);
                                        gl.vertexAttribDivisor(attr_index.*, step_func);
                                        attr_index.* += 1;
                                    },
                                    else => unreachable,
                                }
                            }
                        },
                        .Float => {
                            gl.vertexAttribPointer(i, 1, gl.FLOAT, gl.FALSE, @sizeOf(T), offset);
                            gl.enableVertexAttribArray(i);
                        },
                        .Struct => |type_info| {
                            const field_type = type_info.fields[0].type;
                            std.debug.assert(@sizeOf(field_type) == 4);

                            switch (@typeInfo(field_type)) {
                                .Float => {
                                    switch (type_info.fields.len) {
                                        2, 3, 4 => {
                                            const off = if (offset) |o| @as(*anyopaque, @ptrFromInt(o)) else null;
                                            gl.vertexAttribPointer(attr_index.*, type_info.fields.len, gl.FLOAT, gl.FALSE, @sizeOf(T), off);
                                            gl.enableVertexAttribArray(attr_index.*);
                                            gl.vertexAttribDivisor(attr_index.*, step_func);
                                            attr_index.* += 1;
                                        },
                                        else => unreachable,
                                    }
                                },
                                else => unreachable,
                            }
                        },
                        else => unreachable,
                    }
                }
            }
        }.cb;
    } else {
        buffer.index_buffer_type = if (T == u16) gl.UNSIGNED_SHORT else gl.UNSIGNED_INT;
    }

    const buffer_kind: GLenum = if (desc.type == .index) gl.ELEMENT_ARRAY_BUFFER else gl.ARRAY_BUFFER;
    gl.genBuffers(1, &buffer.vbo);
    cache.bindBuffer(buffer_kind, buffer.vbo);

    const usage: GLenum = switch (desc.usage) {
        .stream => gl.STREAM_DRAW,
        .immutable => gl.STATIC_DRAW,
        .dynamic => gl.DYNAMIC_DRAW,
    };

    gl.bufferData(buffer_kind, @as(c_long, @intCast(buffer.size)), if (desc.usage == .immutable) desc.content.?.ptr else null, usage);
    return buffer_cache.append(buffer);
}

pub fn destroyBuffer(buffer: types.Buffer) void {
    var buff = buffer_cache.free(buffer);
    cache.invalidateBuffer(buff.vbo);
    gl.deleteBuffers(1, &buff.vbo);
}

pub fn updateBuffer(comptime T: type, buffer: types.Buffer, data: []const T) void {
    const buff = buffer_cache.get(buffer);
    cache.bindBuffer(gl.ARRAY_BUFFER, buff.vbo);

    // orphan the buffer for streamed so we can reset our append_pos and overflow state
    if (buff.stream) {
        gl.bufferData(gl.ARRAY_BUFFER, @as(c_long, @intCast(data.len * @sizeOf(T))), null, gl.STREAM_DRAW);
        buff.append_pos = 0;
        buff.append_overflow = false;
    }
    gl.bufferSubData(gl.ARRAY_BUFFER, 0, @as(c_long, @intCast(data.len * @sizeOf(T))), data.ptr);
}

pub fn appendBuffer(comptime T: type, buffer: types.Buffer, data: []const T) u32 {
    const buff = buffer_cache.get(buffer);
    cache.bindBuffer(gl.ARRAY_BUFFER, buff.vbo);

    const num_bytes = @as(isize, @intCast(data.len * @sizeOf(T)));

    // rewind append cursor in a new frame
    if (buff.append_frame_index != frame_index) {
        buff.append_pos = 0;
        buff.append_overflow = false;
    }

    // check for overflow
    if ((buff.append_pos + @as(u32, @intCast(num_bytes))) > buff.size)
        buff.append_overflow = true;

    const start_pos = buff.append_pos;
    if (!buff.append_overflow and num_bytes > 0) {
        gl.bufferSubData(gl.ARRAY_BUFFER, buff.append_pos, num_bytes, data.ptr);
        buff.append_pos += @as(u32, @intCast(num_bytes));
        buff.append_frame_index = frame_index;
    }

    return start_pos;
}

// bindings and drawing
// TODO: this feels a little bit janky, storing just the index buffer offset here
var cur_ib_offset: c_int = 0;

pub fn applyBindings(bindings: types.BufferBindings) void {
    std.debug.assert(in_pass);
    cur_bindings = bindings;

    if (bindings.index_buffer != 0) {
        var ibuffer = buffer_cache.get(bindings.index_buffer);
        cache.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuffer.vbo);
        cur_ib_offset = @as(c_int, @intCast(bindings.index_buffer_offset));
    }

    var vert_attr_index: GLuint = 0;
    for (bindings.vert_buffers, 0..) |buff, i| {
        if (buff == 0) break;

        var vbuffer = buffer_cache.get(buff);
        if (vbuffer.setVertexAttributes) |setter| {
            cache.bindBuffer(gl.ARRAY_BUFFER, vbuffer.vbo);
            setter(&vert_attr_index, vbuffer.vert_buffer_step_func, bindings.vertex_buffer_offsets[i]);
        }
    }

    // bind images
    for (bindings.images, 0..) |image, slot| {
        const tid = if (image == 0) 0 else image_cache.get(image).tid;
        cache.bindImage(tid, @as(c_uint, @intCast(slot)));
    }
}

pub fn draw(base_element: c_int, element_count: c_int, instance_count: c_int) void {
    std.debug.assert(in_pass);
    if (cur_bindings.index_buffer == 0) {
        // no index buffer, so we draw non-indexed
        if (instance_count <= 1) {
            gl.drawArrays(gl.TRIANGLES, base_element, element_count);
        } else {
            gl.drawArraysInstanced(gl.TRIANGLE_FAN, base_element, element_count, instance_count);
        }
    } else {
        const ibuffer = buffer_cache.get(cur_bindings.index_buffer);

        const i_size: c_int = if (ibuffer.index_buffer_type == gl.UNSIGNED_SHORT) 2 else 4;
        var ib_offset = @as(usize, @intCast(base_element * i_size + cur_ib_offset));

        if (instance_count <= 1) {
            gl.drawElements(gl.TRIANGLES, element_count, ibuffer.index_buffer_type, @as(?*anyopaque, @ptrFromInt(ib_offset)));
        } else {
            gl.drawElementsInstanced(gl.TRIANGLES, element_count, ibuffer.index_buffer_type, @as(?*anyopaque, @ptrFromInt(ib_offset)), instance_count);
        }
    }
}

// shaders
const GLShaderProgram = struct {
    program: GLuint,
    vs_uniform_cache: [16]GLint = [_]GLint{-1} ** 16,
    fs_uniform_cache: [16]GLint = [_]GLint{-1} ** 16,
};

fn compileShader(stage: GLenum, src: [:0]const u8) GLuint {
    const shader = zgl.gl.createShader(stage);
    var shader_src = src;
    gl.shaderSource(shader, 1, &shader_src, null);
    gl.compileShader(shader);

    if (!checkShaderError(shader)) {
        gl.deleteShader(shader);
        return 0;
    }
    return shader;
}

pub fn createShaderProgram(comptime VertUniformT: type, comptime FragUniformT: type, desc: descriptions.ShaderDesc) types.ShaderProgram {
    std.debug.assert(@typeInfo(VertUniformT) == .Struct);
    std.debug.assert(@typeInfo(FragUniformT) == .Struct);

    var shader = std.mem.zeroes(GLShaderProgram);

    const vertex_shader = compileShader(gl.VERTEX_SHADER, desc.vs);
    const frag_shader = compileShader(gl.FRAGMENT_SHADER, desc.fs);

    if (vertex_shader == 0 and frag_shader == 0) return 0;

    const id = gl.createProgram();
    gl.attachShader(id, vertex_shader);
    gl.attachShader(id, frag_shader);
    gl.linkProgram(id);
    gl.deleteShader(vertex_shader);
    gl.deleteShader(frag_shader);

    if (!checkProgramError(id)) {
        gl.deleteProgram(id);
        return 0;
    }

    shader.program = id;

    // store currently bound program and rebind when done
    var cur_prog: GLint = 0;
    gl.getIntegerv(gl.CURRENT_PROGRAM, &cur_prog);
    gl.useProgram(id);

    // resolve all images to their bound locations
    inline for (.{ VertUniformT, FragUniformT }) |UniformT| {
        if (@hasDecl(UniformT, "metadata") and @hasField(@TypeOf(UniformT.metadata), "images")) {
            var image_slot: GLint = 0;
            inline for (@field(UniformT.metadata, "images")) |img| {
                const loc = gl.getUniformLocation(id, img);
                if (loc != -1) {
                    gl.uniform1i(loc, image_slot);
                    image_slot += 1;
                } else {
                    std.debug.print("Could not find uniform for image [{s}]!\n", .{img});
                }
            }
        }
    }

    // fetch and cache all uniforms from our metadata.uniforms fields for both the vert and frag types
    inline for (.{ VertUniformT, FragUniformT }, 0..) |UniformT, j| {
        var uniform_cache = if (j == 0) &shader.vs_uniform_cache else &shader.fs_uniform_cache;
        if (@hasDecl(UniformT, "metadata") and @hasField(@TypeOf(UniformT.metadata), "uniforms")) {
            const uniforms = @field(UniformT.metadata, "uniforms");
            inline for (@typeInfo(@TypeOf(uniforms)).Struct.fields, 0..) |field, i| {
                uniform_cache[i] = gl.getUniformLocation(id, field.name ++ "\x00");
                if (@import("builtin").mode == .Debug and uniform_cache[i] == -1) std.debug.print("Uniform [{s}] not found!\n", .{field.name});
            }
        } else {
            // cache a uniform for each struct fields. It is prefered to use the `metadata` approach above but this path is supported as well.
            inline for (@typeInfo(UniformT).Struct.fields, 0..) |field, i| {
                uniform_cache[i] = gl.getUniformLocation(id, field.name ++ "\x00");
                if (@import("builtin").mode == .Debug and uniform_cache[i] == -1) std.debug.print("Uniform [{s}] not found!\n", .{field.name});
            }
        }
    }

    gl.useProgram(@as(GLuint, @intCast(cur_prog)));

    return shader_cache.append(shader);
}

pub fn destroyShaderProgram(shader: types.ShaderProgram) void {
    const shdr = shader_cache.free(shader);
    cache.invalidateProgram(shdr.program);
    gl.deleteProgram(shdr.program);
}

pub fn useShaderProgram(shader: types.ShaderProgram) void {
    const shdr = shader_cache.get(shader);
    cache.useShaderProgram(shdr.program);
}

pub fn setShaderProgramUniformBlock(comptime UniformT: type, shader: types.ShaderProgram, stage: types.ShaderStage, value: *UniformT) void {
    std.debug.assert(in_pass);
    std.debug.assert(@typeInfo(UniformT) == .Struct);
    const shdr = shader_cache.get(shader);

    // in debug builds ensure the shader we are setting the uniform on is bound
    if (@import("builtin").mode == .Debug) {
        var cur_prog: GLint = 0;
        gl.getIntegerv(gl.CURRENT_PROGRAM, &cur_prog);
        std.debug.assert(cur_prog == shdr.program);
    }

    // choose the right uniform cache
    const uniform_cache = if (stage == .vs) shdr.vs_uniform_cache else shdr.fs_uniform_cache;

    if (@hasDecl(UniformT, "metadata") and @hasField(@TypeOf(UniformT.metadata), "uniforms")) {
        const uniforms = @field(UniformT.metadata, "uniforms");
        inline for (@typeInfo(@TypeOf(uniforms)).Struct.fields, 0..) |field, i| {
            const location = uniform_cache[i];
            const uni = @field(UniformT.metadata.uniforms, field.name);

            // we only support f32s so just get a pointer to the struct reinterpreted as an []f32
            var f32_slice = std.mem.bytesAsSlice(f32, std.mem.asBytes(value));
            switch (@field(uni, "type")) {
                .float => gl.uniform1fv(location, @field(uni, "array_count"), f32_slice.ptr),
                .float2 => gl.uniform2fv(location, @field(uni, "array_count"), f32_slice.ptr),
                .float3 => gl.uniform3fv(location, @field(uni, "array_count"), f32_slice.ptr),
                .float4 => gl.uniform4fv(location, @field(uni, "array_count"), f32_slice.ptr),
                else => unreachable,
            }
        }
    } else {
        // set all the fields of the struct as uniforms. It is prefered to use the `metadata` approach above.
        inline for (@typeInfo(UniformT).Struct.fields, 0..) |field, i| {
            const location = uniform_cache[i];
            if (location > -1) {
                switch (@typeInfo(field.field_type)) {
                    .Float => gl.uniform1f(location, @field(value, field.name)),
                    .Int => gl.uniform1i(location, @field(value, field.name)),
                    .Struct => |type_info| {
                        // special case for matrix, which is often "struct { data[n] }". We also support vec2/3/4
                        switch (@typeInfo(type_info.fields[0].field_type)) {
                            .Array => |array_ti| {
                                const struct_value = @field(value, field.name);
                                var array_value = &@field(struct_value, type_info.fields[0].name);
                                switch (array_ti.len) {
                                    6 => gl.uniformMatrix3x2fv(location, 1, gl.FALSE, array_value),
                                    9 => gl.uniformMatrix3fv(location, 1, gl.FALSE, array_value),
                                    else => @compileError("Structs with array fields must be 6/9 elements: " ++ @typeName(field.field_type)),
                                }
                            },
                            .Float => {
                                const struct_value = @field(value, field.name);
                                var struct_field_value = &@field(struct_value, type_info.fields[0].name);
                                switch (type_info.fields.len) {
                                    2 => gl.uniform2fv(location, 1, struct_field_value),
                                    3 => gl.uniform3fv(location, 1, struct_field_value),
                                    4 => gl.uniform4fv(location, 1, struct_field_value),
                                    else => @compileError("Structs of f32 must be 2/3/4 elements: " ++ @typeName(field.field_type)),
                                }
                            },
                            else => @compileError("Structs of f32 must be 2/3/4 elements: " ++ @typeName(field.field_type)),
                        }
                    },
                    .Array => |array_type_info| {
                        var array_value = @field(value, field.name);
                        switch (@typeInfo(array_type_info.child)) {
                            .Int => |type_info| {
                                std.debug.assert(type_info.bits == 32);
                                gl.uniform1iv(location, @as(c_int, @intCast(array_type_info.len)), &array_value);
                            },
                            .Float => |type_info| {
                                std.debug.assert(type_info.bits == 32);
                                gl.uniform1fv(location, @as(c_int, @intCast(array_type_info.len)), &array_value);
                            },
                            .Struct => @panic("array of structs not supported"),
                            else => unreachable,
                        }
                    },
                    else => @compileError("Need support for uniform type: " ++ @typeName(field.field_type)),
                }
            }
        }
    }
}
