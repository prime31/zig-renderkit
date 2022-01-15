const std = @import("std");
const translations = @import("gl_translations.zig");
const decls = @import("gl_decls.zig");
// usingnamespace decls;
const descriptions = @import("../descriptions.zig");
usingnamespace descriptions;
const types = @import("../types.zig");
usingnamespace types;

const HandledCache = @import("../handles.zig").HandledCache;
const RenderCache = @import("render_cache.zig").RenderCache;
const GLuint = decls.GLuint;
const GLint = decls.GLint;
const GLenum = decls.GLenum;
const GLsizei = decls.GLsizei;
const GLvoid = decls.GLvoid;
const GLbitfield = decls.GLbitfield;

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

// setup
pub fn setup(desc: descriptions.RendererDesc, allocator: std.mem.Allocator) void {
    image_cache = HandledCache(GLImage).init(allocator, desc.pool_sizes.texture);
    pass_cache = HandledCache(GLPass).init(allocator, desc.pool_sizes.offscreen_pass);
    buffer_cache = HandledCache(GLBuffer).init(allocator, desc.pool_sizes.buffers);
    shader_cache = HandledCache(GLShaderProgram).init(allocator, desc.pool_sizes.shaders);

    if (desc.gl_loader) |loader| {
        decls.loadFunctions(loader);
    } else {
        decls.loadFunctionsZig();
    }

    setRenderState(.{});

    decls.glGenVertexArrays(1, &vao);
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
    var err_code: GLenum = decls.glGetError();
    while (err_code != decls.GL_NO_ERROR) {
        var error_name = switch (err_code) {
            decls.GL_INVALID_ENUM => "GL_INVALID_ENUM",
            decls.GL_INVALID_VALUE => "GL_INVALID_VALUE",
            decls.GL_INVALID_OPERATION => "GL_INVALID_OPERATION",
            decls.GL_STACK_OVERFLOW_KHR => "GL_STACK_OVERFLOW_KHR",
            decls.GL_STACK_UNDERFLOW_KHR => "GL_STACK_UNDERFLOW_KHR",
            decls.GL_OUT_OF_MEMORY => "GL_OUT_OF_MEMORY",
            decls.GL_INVALID_FRAMEBUFFER_OPERATION => "GL_INVALID_FRAMEBUFFER_OPERATION",
            else => "Unknown Error Enum",
        };

        std.debug.print("error: {}, file: {}, func: {}, line: {}\n", .{ error_name, src.file, src.fn_name, src.line });
        err_code = decls.glGetError();
    }
}

fn checkShaderError(shader: GLuint) bool {
    var status: GLint = undefined;
    decls.glGetShaderiv(shader, decls.GL_COMPILE_STATUS, &status);
    if (status != decls.GL_TRUE) {
        var buf: [2048]u8 = undefined;
        var total_len: GLsizei = -1;
        decls.glGetShaderInfoLog(shader, 2048, &total_len, buf[0..]);
        if (total_len == -1) {
            // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
            unreachable;
        }

        std.debug.print("shader compilation error:\n{s}", .{buf[0..@intCast(usize, total_len)]});
        return false;
    }
    return true;
}

fn checkProgramError(shader: GLuint) bool {
    var status: GLint = undefined;
    decls.glGetProgramiv(shader, decls.GL_LINK_STATUS, &status);
    if (status != decls.GL_TRUE) {
        var buf: [2048]u8 = undefined;
        var total_len: GLsizei = -1;
        decls.glGetProgramInfoLog(shader, 2048, &total_len, buf[0..]);
        if (total_len == -1) {
            // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
            unreachable;
        }

        std.debug.print("program link error:\n{s}", .{buf[0..@intCast(usize, total_len)]});
        return false;
    }
    return true;
}

// render state
pub fn setRenderState(state: types.RenderState) void {
    // depth
    if (state.depth.enabled != pip_cache.depth.enabled) {
        decls.glDepthMask(if (state.depth.enabled) 1 else 0);
        pip_cache.depth.enabled = state.depth.enabled;
    }

    if (state.depth.compare_func != pip_cache.depth.compare_func) {
        decls.glDepthFunc(translations.compareFuncToGl(state.depth.compare_func));
        pip_cache.depth.compare_func = state.depth.compare_func;
    }

    // stencil
    if (state.stencil.enabled != pip_cache.stencil.enabled) {
        if (state.stencil.enabled) decls.glEnable(decls.GL_STENCIL_TEST) else decls.glDisable(decls.GL_STENCIL_TEST);
        pip_cache.stencil.enabled = state.stencil.enabled;
    }

    if (state.stencil.write_mask != pip_cache.stencil.write_mask) {
        decls.glStencilMask(@intCast(GLuint, state.stencil.write_mask));
        pip_cache.stencil = state.stencil;
        pip_cache.stencil.write_mask = state.stencil.write_mask;
    }

    if (state.stencil.compare_func != pip_cache.stencil.compare_func or
        state.stencil.read_mask != pip_cache.stencil.read_mask or
        state.stencil.ref != pip_cache.stencil.ref)
    {
        decls.glStencilFuncSeparate(decls.GL_FRONT, translations.compareFuncToGl(state.stencil.compare_func), @intCast(GLint, state.stencil.ref), @intCast(GLuint, state.stencil.read_mask));
        pip_cache.stencil.compare_func = state.stencil.compare_func;
        pip_cache.stencil.read_mask = state.stencil.read_mask;
        pip_cache.stencil.ref = state.stencil.ref;
    }

    if (state.stencil.fail_op != pip_cache.stencil.fail_op or
        state.stencil.depth_fail_op != pip_cache.stencil.depth_fail_op or
        state.stencil.pass_op != pip_cache.stencil.pass_op)
    {
        decls.glStencilOpSeparate(decls.GL_FRONT, translations.stencilOpToGl(state.stencil.fail_op), translations.stencilOpToGl(state.stencil.depth_fail_op), translations.stencilOpToGl(state.stencil.pass_op));
        pip_cache.stencil.fail_op = state.stencil.fail_op;
        pip_cache.stencil.depth_fail_op = state.stencil.depth_fail_op;
        pip_cache.stencil.pass_op = state.stencil.pass_op;
    }

    // blend
    if (state.blend.enabled != pip_cache.blend.enabled) {
        if (state.blend.enabled) decls.glEnable(decls.GL_BLEND) else decls.glDisable(decls.GL_BLEND);
        pip_cache.blend.enabled = state.blend.enabled;
    }

    if (state.blend.src_factor_rgb != pip_cache.blend.src_factor_rgb or
        state.blend.dst_factor_rgb != pip_cache.blend.dst_factor_rgb or
        state.blend.src_factor_alpha != pip_cache.blend.src_factor_alpha or
        state.blend.dst_factor_alpha != pip_cache.blend.dst_factor_alpha)
    {
        decls.glBlendFuncSeparate(translations.blendFactorToGl(state.blend.src_factor_rgb), translations.blendFactorToGl(state.blend.dst_factor_rgb), translations.blendFactorToGl(state.blend.src_factor_alpha), translations.blendFactorToGl(state.blend.dst_factor_alpha));
        pip_cache.blend.src_factor_rgb = state.blend.src_factor_rgb;
        pip_cache.blend.dst_factor_rgb = state.blend.dst_factor_rgb;
        pip_cache.blend.src_factor_alpha = state.blend.src_factor_alpha;
        pip_cache.blend.dst_factor_alpha = state.blend.dst_factor_alpha;
    }

    if (state.blend.op_rgb != pip_cache.blend.op_rgb or state.blend.op_alpha != pip_cache.blend.op_alpha) {
        decls.glBlendEquationSeparate(translations.blendOpToGl(state.blend.op_rgb), translations.blendOpToGl(state.blend.op_alpha));
        pip_cache.blend.op_rgb = state.blend.op_rgb;
        pip_cache.blend.op_alpha = state.blend.op_alpha;
    }

    if (state.blend.color_write_mask != pip_cache.blend.color_write_mask) {
        const r = (@enumToInt(state.blend.color_write_mask) & @enumToInt(types.ColorMask.r)) != 0;
        const g = (@enumToInt(state.blend.color_write_mask) & @enumToInt(types.ColorMask.g)) != 0;
        const b = (@enumToInt(state.blend.color_write_mask) & @enumToInt(types.ColorMask.b)) != 0;
        const a = (@enumToInt(state.blend.color_write_mask) & @enumToInt(types.ColorMask.a)) != 0;
        decls.glColorMask(if (r) 1 else 0, if (g) 1 else 0, if (b) 1 else 0, if (a) 1 else 0);
        pip_cache.blend.color_write_mask = state.blend.color_write_mask;
    }

    if (std.math.approxEqAbs(f32, state.blend.color[0], pip_cache.blend.color[0], 0.0001) or
        std.math.approxEqAbs(f32, state.blend.color[1], pip_cache.blend.color[1], 0.0001) or
        std.math.approxEqAbs(f32, state.blend.color[2], pip_cache.blend.color[2], 0.0001) or
        std.math.approxEqAbs(f32, state.blend.color[3], pip_cache.blend.color[3], 0.0001))
    {
        decls.glBlendColor(state.blend.color[0], state.blend.color[1], state.blend.color[2], state.blend.color[3]);
        pip_cache.blend.color = state.blend.color;
    }

    // scissor
    if (state.scissor != pip_cache.scissor) {
        if (state.scissor) decls.glEnable(decls.GL_SCISSOR_TEST) else decls.glDisable(decls.GL_SCISSOR_TEST);
        pip_cache.scissor = state.scissor;
    }
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    decls.glViewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    var y_tl = cur_pass_h - (y + height);
    decls.glScissor(x, y_tl, width, height);
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
        decls.glGenRenderbuffers(1, &img.tid);
        decls.glBindRenderbuffer(decls.GL_RENDERBUFFER, img.tid);
        decls.glRenderbufferStorage(decls.GL_RENDERBUFFER, decls.GL_DEPTH24_STENCIL8_OES, desc.width, desc.height);
        img.depth = true;
        img.stencil = true;
    } else if (desc.pixel_format == .stencil) {
        std.debug.assert(desc.usage == .immutable);
        decls.glGenRenderbuffers(1, &img.tid);
        decls.glBindRenderbuffer(decls.GL_RENDERBUFFER, img.tid);
        decls.glRenderbufferStorage(decls.GL_RENDERBUFFER, decls.GL_STENCIL_INDEX8, desc.width, desc.height);
        img.stencil = true;
    } else {
        decls.glGenTextures(1, &img.tid);
        cache.bindImage(img.tid, 0);

        const wrap_u: GLint = if (desc.wrap_u == .clamp) decls.GL_CLAMP_TO_EDGE else decls.GL_REPEAT;
        const wrap_v: GLint = if (desc.wrap_v == .clamp) decls.GL_CLAMP_TO_EDGE else decls.GL_REPEAT;
        decls.glTexParameteri(decls.GL_TEXTURE_2D, decls.GL_TEXTURE_WRAP_S, wrap_u);
        decls.glTexParameteri(decls.GL_TEXTURE_2D, decls.GL_TEXTURE_WRAP_T, wrap_v);

        const filter_min: GLint = if (desc.min_filter == .nearest) decls.GL_NEAREST else decls.GL_LINEAR;
        const filter_mag: GLint = if (desc.mag_filter == .nearest) decls.GL_NEAREST else decls.GL_LINEAR;
        decls.glTexParameteri(decls.GL_TEXTURE_2D, decls.GL_TEXTURE_MIN_FILTER, filter_min);
        decls.glTexParameteri(decls.GL_TEXTURE_2D, decls.GL_TEXTURE_MAG_FILTER, filter_mag);

        if (desc.content) |content| {
            decls.glTexImage2D(decls.GL_TEXTURE_2D, 0, decls.GL_RGBA, desc.width, desc.height, 0, decls.GL_RGBA, decls.GL_UNSIGNED_BYTE, content);
        } else {
            decls.glTexImage2D(decls.GL_TEXTURE_2D, 0, decls.GL_RGBA, desc.width, desc.height, 0, decls.GL_RGBA, decls.GL_UNSIGNED_BYTE, null);
        }

        cache.bindImage(0, 0);
    }

    return image_cache.append(img);
}

pub fn destroyImage(image: types.Image) void {
    var img = image_cache.free(image);
    cache.invalidateTexture(img.tid);
    decls.glDeleteTextures(1, &img.tid);
}

pub fn updateImage(comptime T: type, image: types.Image, content: []const T) void {
    var img = image_cache.get(image);

    cache.bindImage(img.tid, 0);
    decls.glTexImage2D(decls.GL_TEXTURE_2D, 0, decls.GL_RGBA, img.width, img.height, 0, decls.GL_RGBA, decls.GL_UNSIGNED_BYTE, content.ptr);
    cache.bindImage(0, 0);
}

// offscreen pass
const GLPass = struct {
    framebuffer_tid: GLuint,
    color_img: types.Image,
    depth_stencil_img: ?types.Image,
};

pub fn createPass(desc: descriptions.PassDesc) types.Pass {
    var pass = std.mem.zeroes(GLPass);
    pass.depth_stencil_img = null;

    var orig_fb: GLint = undefined;
    decls.glGetIntegerv(decls.GL_FRAMEBUFFER_BINDING, &orig_fb);
    defer decls.glBindFramebuffer(decls.GL_FRAMEBUFFER, @intCast(GLuint, orig_fb));

    pass.color_img = desc.color_img;

    // create a framebuffer object
    decls.glGenFramebuffers(1, &pass.framebuffer_tid);
    decls.glBindFramebuffer(decls.GL_FRAMEBUFFER, pass.framebuffer_tid);
    defer decls.glBindFramebuffer(decls.GL_FRAMEBUFFER, 0);

    // bind depth-stencil
    if (desc.depth_stencil_img) |depth_stencil_handle| {
        const depth_stencil = image_cache.get(depth_stencil_handle);
        if (depth_stencil.depth) decls.glFramebufferRenderbuffer(decls.GL_FRAMEBUFFER, decls.GL_DEPTH_ATTACHMENT, decls.GL_RENDERBUFFER, depth_stencil.tid);
        if (depth_stencil.stencil) decls.glFramebufferRenderbuffer(decls.GL_FRAMEBUFFER, decls.GL_STENCIL_ATTACHMENT, decls.GL_RENDERBUFFER, depth_stencil.tid);
        pass.depth_stencil_img = depth_stencil_handle;
    }

    // Set color_img as our color attachement #0
    const color_img = image_cache.get(desc.color_img);
    decls.glFramebufferTexture(decls.GL_FRAMEBUFFER, decls.GL_COLOR_ATTACHMENT0, color_img.tid, 0);

    // Set the list of draw buffers
    var draw_buffers: [4]GLenum = [_]GLenum{ decls.GL_COLOR_ATTACHMENT0, decls.GL_COLOR_ATTACHMENT1_EXT, decls.GL_COLOR_ATTACHMENT2_EXT, decls.GL_COLOR_ATTACHMENT3_EXT };
    decls.glDrawBuffers(1, &draw_buffers);

    if (decls.glCheckFramebufferStatus(decls.GL_FRAMEBUFFER) != decls.GL_FRAMEBUFFER_COMPLETE) std.debug.print("framebuffer failed\n", .{});

    return pass_cache.append(pass);
}

pub fn destroyPass(offscreen_pass: types.Pass) void {
    var pass = pass_cache.free(offscreen_pass);
    decls.glDeleteFramebuffers(1, &pass.framebuffer_tid);
    if (pass.depth_stencil_img) |depth_stencil_handle| {
        var depth_stencil = image_cache.get(depth_stencil_handle);
        decls.glDeleteRenderbuffers(1, &depth_stencil.tid);
    }
}

pub fn beginDefaultPass(action: types.ClearCommand, width: c_int, height: c_int) void {
    beginDefaultOrOffscreenPass(0, action, width, height);
}

pub fn beginPass(offscreen_pass: types.Pass, action: types.ClearCommand) void {
    beginDefaultOrOffscreenPass(offscreen_pass, action, -1, -1);
}

fn beginDefaultOrOffscreenPass(offscreen_pass: types.Pass, action: types.ClearCommand, width: c_int, height: c_int) void {
    // pass 0 is invalid so if its greater than 0 this is an offscreen pass
    if (offscreen_pass > 0) {
        const pass = pass_cache.get(offscreen_pass);
        const img = image_cache.get(pass.color_img);
        decls.glBindFramebuffer(decls.GL_FRAMEBUFFER, pass.framebuffer_tid);
        decls.glViewport(0, 0, img.width, img.height);
        cur_pass_h = img.height;
    } else {
        decls.glViewport(0, 0, width, height);
        cur_pass_h = height;
    }

    var clear_mask: GLbitfield = 0;
    if (action.color_action == .clear) {
        clear_mask |= decls.GL_COLOR_BUFFER_BIT;
        decls.glClearColor(action.color[0], action.color[1], action.color[2], action.color[3]);
    }
    if (action.stencil_action == .clear) {
        clear_mask |= decls.GL_STENCIL_BUFFER_BIT;
        decls.glClearStencil(@intCast(GLint, action.stencil));
    }
    if (action.depth_action == .clear) {
        clear_mask |= decls.GL_DEPTH_BUFFER_BIT;
        decls.glClearDepth(action.depth);
    }

    decls.glClear(clear_mask);
}

pub fn endPass() void {
    decls.glBindFramebuffer(decls.GL_FRAMEBUFFER, 0);
}

pub fn commitFrame() void {
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
    setVertexAttributes: ?fn (attr_index: *GLuint, step_func: GLuint, vertex_buffer_offset: u32) void,
};

pub fn createBuffer(comptime T: type, desc: descriptions.BufferDesc(T)) types.Buffer {
    var buffer = std.mem.zeroes(GLBuffer);
    buffer.stream = desc.usage == .stream;
    buffer.vert_buffer_step_func = if (desc.step_func == .per_vertex) 0 else 1;
    buffer.size = @intCast(u32, desc.getSize());

    if (@typeInfo(T) == .Struct) {
        buffer.setVertexAttributes = struct {
            fn cb(attr_index: *GLuint, step_func: GLuint, vertex_buffer_offset: u32) void {
                inline for (@typeInfo(T).Struct.fields) |field, i| {
                    const offset: ?usize = if (i + vertex_buffer_offset == 0) null else vertex_buffer_offset + @offsetOf(T, field.name);

                    switch (@typeInfo(field.field_type)) {
                        .Int => |type_info| {
                            if (type_info.signedness == .signed) {
                                unreachable;
                            } else {
                                switch (type_info.bits) {
                                    32 => {
                                        // u32 is color
                                        decls.glVertexAttribPointer(attr_index.*, 4, decls.GL_UNSIGNED_BYTE, decls.GL_TRUE, @sizeOf(T), offset);
                                        decls.glEnableVertexAttribArray(attr_index.*);
                                        decls.glVertexAttribDivisor(attr_index.*, step_func);
                                        attr_index.* += 1;
                                    },
                                    else => unreachable,
                                }
                            }
                        },
                        .Float => {
                            decls.glVertexAttribPointer(i, 1, decls.GL_FLOAT, decls.GL_FALSE, @sizeOf(T), offset);
                            decls.glEnableVertexAttribArray(i);
                        },
                        .Struct => |type_info| {
                            const field_type = type_info.fields[0].field_type;
                            std.debug.assert(@sizeOf(field_type) == 4);

                            switch (@typeInfo(field_type)) {
                                .Float => {
                                    switch (type_info.fields.len) {
                                        2, 3, 4 => {
                                            decls.glVertexAttribPointer(attr_index.*, type_info.fields.len, decls.GL_FLOAT, decls.GL_FALSE, @sizeOf(T), offset);
                                            decls.glEnableVertexAttribArray(attr_index.*);
                                            decls.glVertexAttribDivisor(attr_index.*, step_func);
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
        buffer.index_buffer_type = if (T == u16) decls.GL_UNSIGNED_SHORT else decls.GL_UNSIGNED_INT;
    }

    const buffer_kind: GLenum = if (desc.type == .index) decls.GL_ELEMENT_ARRAY_BUFFER else decls.GL_ARRAY_BUFFER;
    decls.glGenBuffers(1, &buffer.vbo);
    cache.bindBuffer(buffer_kind, buffer.vbo);

    const usage: GLenum = switch (desc.usage) {
        .stream => decls.GL_STREAM_DRAW,
        .immutable => decls.GL_STATIC_DRAW,
        .dynamic => decls.GL_DYNAMIC_DRAW,
    };

    decls.glBufferData(buffer_kind, @intCast(c_long, buffer.size), if (desc.usage == .immutable) desc.content.?.ptr else null, usage);
    return buffer_cache.append(buffer);
}

pub fn destroyBuffer(buffer: types.Buffer) void {
    var buff = buffer_cache.free(buffer);
    cache.invalidateBuffer(buff.vbo);
    decls.glDeleteBuffers(1, &buff.vbo);
}

pub fn updateBuffer(comptime T: type, buffer: types.Buffer, data: []const T) void {
    const buff = buffer_cache.get(buffer);
    cache.bindBuffer(decls.GL_ARRAY_BUFFER, buff.vbo);

    // orphan the buffer for streamed so we can reset our append_pos and overflow state
    if (buff.stream) {
        decls.glBufferData(decls.GL_ARRAY_BUFFER, @intCast(c_long, data.len * @sizeOf(T)), null, decls.GL_STREAM_DRAW);
        buff.append_pos = 0;
        buff.append_overflow = false;
    }
    decls.glBufferSubData(decls.GL_ARRAY_BUFFER, 0, @intCast(c_long, data.len * @sizeOf(T)), data.ptr);
}

pub fn appendBuffer(comptime T: type, buffer: types.Buffer, data: []const T) u32 {
    const buff = buffer_cache.get(buffer);
    cache.bindBuffer(decls.GL_ARRAY_BUFFER, buff.vbo);

    const num_bytes = @intCast(c_long, data.len * @sizeOf(T));

    // rewind append cursor in a new frame
    if (buff.append_frame_index != frame_index) {
        buff.append_pos = 0;
        buff.append_overflow = false;
    }

    // check for overflow
    if ((buff.append_pos + @intCast(u32, num_bytes)) > buff.size)
        buff.append_overflow = true;

    const start_pos = buff.append_pos;
    if (!buff.append_overflow and num_bytes > 0) {
        decls.glBufferSubData(decls.GL_ARRAY_BUFFER, @intCast(c_long, buff.append_pos), num_bytes, data.ptr);
        buff.append_pos += @intCast(u32, num_bytes);
        buff.append_frame_index = frame_index;
    }

    return start_pos;
}

// bindings and drawing
// TODO: this feels a little bit janky, storing just the index buffer offset here
var cur_ib_offset: c_int = 0;

pub fn applyBindings(bindings: types.BufferBindings) void {
    cur_bindings = bindings;

    if (bindings.index_buffer != 0) {
        var ibuffer = buffer_cache.get(bindings.index_buffer);
        cache.bindBuffer(decls.GL_ELEMENT_ARRAY_BUFFER, ibuffer.vbo);
        cur_ib_offset = @intCast(c_int, bindings.index_buffer_offset);
    }

    var vert_attr_index: GLuint = 0;
    for (bindings.vert_buffers) |buff, i| {
        if (buff == 0) break;

        var vbuffer = buffer_cache.get(buff);
        if (vbuffer.setVertexAttributes) |setter| {
            cache.bindBuffer(decls.GL_ARRAY_BUFFER, vbuffer.vbo);
            setter(&vert_attr_index, vbuffer.vert_buffer_step_func, bindings.vertex_buffer_offsets[i]);
        }
    }

    // bind images
    for (bindings.images) |image, slot| {
        const tid = if (image == 0) 0 else image_cache.get(image).tid;
        cache.bindImage(tid, @intCast(c_uint, slot));
    }
}

pub fn draw(base_element: c_int, element_count: c_int, instance_count: c_int) void {
    if (cur_bindings.index_buffer == 0) {
        // no index buffer, so we draw non-indexed
        if (instance_count <= 1) {
            decls.glDrawArrays(decls.GL_TRIANGLES, base_element, element_count);
        } else {
            decls.glDrawArraysInstanced(decls.GL_TRIANGLE_FAN, base_element, element_count, instance_count);
        }
    } else {
        const ibuffer = buffer_cache.get(cur_bindings.index_buffer);

        const i_size: c_int = if (ibuffer.index_buffer_type == decls.GL_UNSIGNED_SHORT) 2 else 4;
        var ib_offset = @intCast(usize, base_element * i_size + cur_ib_offset);

        if (instance_count <= 1) {
            decls.glDrawElements(decls.GL_TRIANGLES, element_count, ibuffer.index_buffer_type, @intToPtr(?*GLvoid, ib_offset));
        } else {
            decls.glDrawElementsInstanced(decls.GL_TRIANGLES, element_count, ibuffer.index_buffer_type, @intToPtr(?*GLvoid, ib_offset), instance_count);
        }
    }
}

// shader
const GLShaderProgram = struct {
    program: GLuint,
    vs_uniform_cache: [16]GLint = [_]GLint{-1} ** 16,
    fs_uniform_cache: [16]GLint = [_]GLint{-1} ** 16,
};

fn compileShader(stage: GLenum, src: [:0]const u8) GLuint {
    const shader = decls.glCreateShader(stage);
    var shader_src = src;
    decls.glShaderSource(shader, 1, &shader_src, null);
    decls.glCompileShader(shader);
    if (!checkShaderError(shader)) {
        decls.glDeleteShader(shader);
        return 0;
    }
    return shader;
}

pub fn createShaderProgram(comptime VertUniformT: type, comptime FragUniformT: type, desc: descriptions.ShaderDesc) types.ShaderProgram {
    std.debug.assert(@typeInfo(VertUniformT) == .Struct);
    std.debug.assert(@typeInfo(FragUniformT) == .Struct);

    var shader = std.mem.zeroes(GLShaderProgram);

    const vertex_shader = compileShader(decls.GL_VERTEX_SHADER, desc.vs);
    const frag_shader = compileShader(decls.GL_FRAGMENT_SHADER, desc.fs);

    if (vertex_shader == 0 and frag_shader == 0) return 0;

    const id = decls.glCreateProgram();
    decls.glAttachShader(id, vertex_shader);
    decls.glAttachShader(id, frag_shader);
    decls.glLinkProgram(id);
    decls.glDeleteShader(vertex_shader);
    decls.glDeleteShader(frag_shader);

    if (!checkProgramError(id)) {
        decls.glDeleteProgram(id);
        return 0;
    }

    shader.program = id;

    // store currently bound program and rebind when done
    var cur_prog: GLint = 0;
    decls.glGetIntegerv(decls.GL_CURRENT_PROGRAM, &cur_prog);
    decls.glUseProgram(id);

    // resolve all images to their bound locations
    inline for (.{ VertUniformT, FragUniformT }) |UniformT| {
        if (@hasDecl(UniformT, "metadata") and @hasField(@TypeOf(UniformT.metadata), "images")) {
            var image_slot: GLint = 0;
            inline for (@field(UniformT.metadata, "images")) |img| {
                const loc = decls.glGetUniformLocation(id, img);
                if (loc != 1) {
                    decls.glUniform1i(loc, image_slot);
                    image_slot += 1;
                } else {
                    std.debug.print("Could not find uniform for image [{s}]!\n", .{img});
                }
            }
        }
    }

    // fetch and cache all uniforms from our metadata.uniforms fields for both the vert and frag types
    inline for (.{ VertUniformT, FragUniformT }) |UniformT, j| {
        var uniform_cache = if (j == 0) &shader.vs_uniform_cache else &shader.fs_uniform_cache;
        if (@hasDecl(UniformT, "metadata") and @hasField(@TypeOf(UniformT.metadata), "uniforms")) {
            const uniforms = @field(UniformT.metadata, "uniforms");
            inline for (@typeInfo(@TypeOf(uniforms)).Struct.fields) |field, i| {
                uniform_cache[i] = decls.glGetUniformLocation(id, field.name ++ "\x00");
                if (@import("builtin").mode == .Debug and uniform_cache[i] == -1) std.debug.print("Uniform [{s}] not found!\n", .{field.name});
            }
        } else {
            // cache a uniform for each struct fields. It is prefered to use the `metadata` approach above but this path is supported as well.
            inline for (@typeInfo(UniformT).Struct.fields) |field, i| {
                uniform_cache[i] = decls.glGetUniformLocation(id, field.name ++ "\x00");
                if (@import("builtin").mode == .Debug and uniform_cache[i] == -1) std.debug.print("Uniform [{s}] not found!\n", .{field.name});
            }
        }
    }

    decls.glUseProgram(@intCast(GLuint, cur_prog));

    return shader_cache.append(shader);
}

pub fn destroyShaderProgram(shader: types.ShaderProgram) void {
    const shdr = shader_cache.free(shader);
    cache.invalidateProgram(shdr.program);
    decls.glDeleteProgram(shdr.program);
}

pub fn useShaderProgram(shader: types.ShaderProgram) void {
    const shdr = shader_cache.get(shader);
    cache.useShaderProgram(shdr.program);
}

pub fn setShaderProgramUniformBlock(comptime UniformT: type, shader: types.ShaderProgram, stage: types.ShaderStage, value: *UniformT) void {
    std.debug.assert(@typeInfo(UniformT) == .Struct);
    const shdr = shader_cache.get(shader);

    // in debug builds ensure the shader we are setting the uniform on is bound
    if (@import("builtin").mode == .Debug) {
        var cur_prog: GLint = 0;
        decls.glGetIntegerv(decls.GL_CURRENT_PROGRAM, &cur_prog);
        std.debug.assert(cur_prog == shdr.program);
    }

    // choose the right uniform cache
    const uniform_cache = if (stage == .vs) shdr.vs_uniform_cache else shdr.fs_uniform_cache;

    if (@hasDecl(UniformT, "metadata") and @hasField(@TypeOf(UniformT.metadata), "uniforms")) {
        const uniforms = @field(UniformT.metadata, "uniforms");
        inline for (@typeInfo(@TypeOf(uniforms)).Struct.fields) |field, i| {
            const location = uniform_cache[i];
            const uni = @field(UniformT.metadata.uniforms, field.name);

            // we only support f32s so just get a pointer to the struct reinterpreted as an []f32
            var f32_slice = std.mem.bytesAsSlice(f32, std.mem.asBytes(value));
            switch (@field(uni, "type")) {
                .float => decls.glUniform1fv(location, @field(uni, "array_count"), f32_slice.ptr),
                .float2 => decls.glUniform2fv(location, @field(uni, "array_count"), f32_slice.ptr),
                .float3 => decls.glUniform3fv(location, @field(uni, "array_count"), f32_slice.ptr),
                .float4 => decls.glUniform4fv(location, @field(uni, "array_count"), f32_slice.ptr),
                else => unreachable,
            }
        }
    } else {
        // set all the fields of the struct as uniforms. It is prefered to use the `metadata` approach above.
        inline for (@typeInfo(UniformT).Struct.fields) |field, i| {
            const location = uniform_cache[i];
            if (location > -1) {
                switch (@typeInfo(field.field_type)) {
                    .Float => decls.glUniform1f(location, @field(value, field.name)),
                    .Int => decls.glUniform1i(location, @field(value, field.name)),
                    .Struct => |type_info| {
                        // special case for matrix, which is often "struct { data[n] }". We also support vec2/3/4
                        switch (@typeInfo(type_info.fields[0].field_type)) {
                            .Array => |array_ti| {
                                const struct_value = @field(value, field.name);
                                var array_value = &@field(struct_value, type_info.fields[0].name);
                                switch (array_ti.len) {
                                    6 => decls.glUniformMatrix3x2fv(location, 1, decls.GL_FALSE, array_value),
                                    9 => decls.glUniformMatrix3fv(location, 1, decls.GL_FALSE, array_value),
                                    else => @compileError("Structs with array fields must be 6/9 elements: " ++ @typeName(field.field_type)),
                                }
                            },
                            .Float => {
                                const struct_value = @field(value, field.name);
                                var struct_field_value = &@field(struct_value, type_info.fields[0].name);
                                switch (type_info.fields.len) {
                                    2 => decls.glUniform2fv(location, 1, struct_field_value),
                                    3 => decls.glUniform3fv(location, 1, struct_field_value),
                                    4 => decls.glUniform4fv(location, 1, struct_field_value),
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
                                decls.glUniform1iv(location, @intCast(c_int, array_type_info.len), &array_value);
                            },
                            .Float => |type_info| {
                                std.debug.assert(type_info.bits == 32);
                                decls.glUniform1fv(location, @intCast(c_int, array_type_info.len), &array_value);
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
