const std = @import("std");
usingnamespace @import("../types.zig");
usingnamespace @import("../descriptions.zig");

const HandledCache = @import("../handles.zig").HandledCache;

var image_cache: HandledCache(*MtlImage) = undefined;
var pass_cache: HandledCache(*MtlPass) = undefined;
var buffer_cache: HandledCache(*MtlBuffer) = undefined;
var shader_cache: HandledCache(*MtlShader) = undefined;

pub fn setup(desc: RendererDesc) void {
    image_cache = HandledCache(*MtlImage).init(desc.allocator, desc.pool_sizes.texture);
    pass_cache = HandledCache(*MtlPass).init(desc.allocator, desc.pool_sizes.offscreen_pass);
    buffer_cache = HandledCache(*MtlBuffer).init(desc.allocator, desc.pool_sizes.buffers);
    shader_cache = HandledCache(*MtlShader).init(desc.allocator, desc.pool_sizes.shaders);

    mtl_setup(desc);
    setRenderState(.{});
}

pub fn shutdown() void {
    // TODO: destroy the items in the caches as well
    image_cache.deinit();
    pass_cache.deinit();
    buffer_cache.deinit();
    shader_cache.deinit();
    mtl_shutdown();
}

pub fn setRenderState(state: RenderState) void {
    mtl_set_render_state(state);
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    mtl_viewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    mtl_scissor(x, y, width, height);
}

// images
pub fn createImage(desc: ImageDesc) Image {
    const img = mtl_create_image(desc);
    return image_cache.append(img);
}

pub fn destroyImage(image: Image) void {
    var img = image_cache.free(image);
    mtl_destroy_image(img.*);
}

pub fn updateImage(comptime T: type, image: Image, content: []const T) void {
    var img = image_cache.get(image);
    mtl_update_image(img.*, content.ptr);
}

pub fn getImageNativeId(image: Image) u32 {
    @panic("not implemented");
    return 0;
}

// passes
pub fn createPass(desc: PassDesc) Pass {
    const pass = mtl_create_pass(MtlPassDesc.init(desc));
    return pass_cache.append(pass);
}

pub fn destroyPass(pass: Pass) void {
    var p = pass_cache.free(pass);
    mtl_destroy_pass(p.*);
}

pub fn beginDefaultPass(action: ClearCommand, width: c_int, height: c_int) void {
    mtl_begin_pass(null, action, width, height);
}

pub fn beginPass(pass: Pass, action: ClearCommand) void {
    var p = pass_cache.get(pass);
    mtl_begin_pass(p.*, action, -1, -1);
}

pub fn endPass() void {
    mtl_end_pass();
}

pub fn commitFrame() void {
    mtl_commit_frame();
}

// buffers
pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer {
    const buffer = mtl_create_buffer(MtlBufferDesc.init(T, desc));
    return buffer_cache.append(buffer);
}

pub fn destroyBuffer(buffer: Buffer) void {
    var buff = buffer_cache.free(buffer);
    mtl_destroy_buffer(buff.*);
}

pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {
    var buff = buffer_cache.get(buffer);
    mtl_update_buffer(buff.*, verts.ptr, @intCast(u32, verts.len * @sizeOf(T)));
}

// shaders
pub fn createShaderProgram(comptime FragUniformT: type, desc: ShaderDesc) ShaderProgram {
    const shader = mtl_create_shader(MtlShaderDesc.init(desc));
    return shader_cache.append(shader);
}

pub fn destroyShaderProgram(shader: ShaderProgram) void {
    var shd = shader_cache.free(shader);
    mtl_destroy_shader(shd.*);
}

pub fn useShaderProgram(shader: ShaderProgram) void {
    var shdr = shader_cache.get(shader);
    mtl_use_shader(shdr.*);
}

pub fn setShaderProgramUniformBlock(comptime FragUniformT: type, shader: ShaderProgram, stage: ShaderStage, value: FragUniformT) void {
    var shdr = shader_cache.get(shader);
}

pub fn setShaderProgramUniform(comptime T: type, shader: ShaderProgram, name: [:0]const u8, value: T) void {
    var shdr = shader_cache.get(shader);
}

// bindings and drawing
pub fn applyBindings(bindings: BufferBindings) void {
    mtl_apply_bindings(MtlBufferBindings.init(bindings));
}

pub fn draw(base_element: c_int, element_count: c_int, instance_count: c_int) void {
    mtl_draw(base_element, element_count, instance_count);
}

// C api
// we need these due to the normal descriptors either being generic or not able to be extern
const MtlVertexFormat = extern enum {
    float,
    float2,
    float3,
    float4,
    u_byte_4n,
};

const MtlIndexType = extern enum {
    uint16,
    uint32,
};

const MtlVertexAttribute = extern struct {
    format: MtlVertexFormat = .float,
    offset: c_int = 0,
};

pub const MtlVertexStep = extern enum {
    per_vertex,
    per_instance,
};

const MtlVertexLayout = extern struct {
    stride: c_int = 0,
    step_func: VertexStep = .per_vertex,
};

const MtlBufferDesc = extern struct {
    size: c_long = 0, // either size (for stream buffers) or content (for static/dynamic) must be set
    type: BufferType = .vertex,
    usage: Usage = .immutable,
    content: ?*const c_void = null,
    index_type: MtlIndexType = .uint16,
    vertex_layout: [4]MtlVertexLayout,
    vertex_attrs: [8]MtlVertexAttribute,

    pub fn init(comptime T: type, buffer_desc: BufferDesc(T)) MtlBufferDesc {
        var vertex_attrs: [8]MtlVertexAttribute = [_]MtlVertexAttribute{.{}} ** 8;

        if (@typeInfo(T) == .Struct) {
            var attr_index: usize = 0;
            inline for (@typeInfo(T).Struct.fields) |field, i| {
                const offset: c_int = if (i == 0) 0 else @byteOffsetOf(T, field.name);

                switch (@typeInfo(field.field_type)) {
                    .Int => |type_info| {
                        if (type_info.is_signed) {
                            unreachable;
                        } else {
                            switch (type_info.bits) {
                                32 => {
                                    // u32 is color by default so we use normalized
                                    vertex_attrs[attr_index].format = .u_byte_4n;
                                    vertex_attrs[attr_index].offset = offset;
                                    attr_index += 1;
                                },
                                else => unreachable,
                            }
                        }
                    },
                    .Float => {
                        vertex_attrs[attr_index].format = .float;
                        vertex_attrs[attr_index].offset = offset;
                        attr_index += 1;
                    },
                    .Struct => |type_info| {
                        const field_type = type_info.fields[0].field_type;
                        std.debug.assert(@sizeOf(field_type) == 4);

                        switch (@typeInfo(field_type)) {
                            .Float => {
                                switch (type_info.fields.len) {
                                    2, 3, 4 => {
                                        var buf: [6]u8 = undefined;
                                        var enum_name = std.fmt.bufPrint(&buf, "float{}", .{type_info.fields.len}) catch unreachable;

                                        vertex_attrs[attr_index].format = std.meta.stringToEnum(MtlVertexFormat, enum_name).?;
                                        vertex_attrs[attr_index].offset = offset;
                                        attr_index += 1;
                                    },
                                    else => @panic("unsupported struct of float size"),
                                }
                            },
                            else => @panic("only float supported so far"),
                        }
                    },
                    else => @panic("unsupported struct type"),
                }
            }
        }

        var vertex_layout: [4]MtlVertexLayout = [_]MtlVertexLayout{.{}} ** 4;
        vertex_layout[0].stride = @sizeOf(T);
        vertex_layout[0].step_func = buffer_desc.step_func;

        return .{
            .size = buffer_desc.getSize(),
            .type = buffer_desc.type,
            .usage = buffer_desc.usage,
            .content = if (buffer_desc.content) |content| content.ptr else null,
            .index_type = if (T == u16) .uint16 else .uint32,
            .vertex_layout = vertex_layout,
            .vertex_attrs = vertex_attrs,
        };
    }
};

const MtlPassDesc = extern struct {
    color_img: ?*MtlImage,
    depth_stencil_img: ?*MtlImage = null,

    pub fn init(desc: PassDesc) MtlPassDesc {
        var mtl_desc = MtlPassDesc{
            .color_img = image_cache.get(desc.color_img).*,
        };

        if (desc.depth_stencil_img) |depth_stencil_handle| {
            mtl_desc.depth_stencil_img = image_cache.get(depth_stencil_handle).*;
        }
        return mtl_desc;
    }
};

const MtlShaderDesc = extern struct {
    vs: [*c]const u8,
    fs: [*c]const u8,

    pub fn init(desc: ShaderDesc) MtlShaderDesc {
        return .{
            .vs = desc.vs,
            .fs = desc.fs,
        };
    }
};

const MtlBufferBindings = extern struct {
    index_buffer: ?*MtlBuffer,
    vert_buffers: [4]?*MtlBuffer = [_]?*MtlBuffer{null} ** 4,
    images: [8]?*MtlImage = [_]?*MtlImage{null} ** 8,

    pub fn init(bindings: BufferBindings) MtlBufferBindings {
        var mtl_bindings = MtlBufferBindings{
            .index_buffer = buffer_cache.get(bindings.index_buffer).*,
        };

        for (bindings.vert_buffers) |vb, i| {
            if (vb == 0) break;
            mtl_bindings.vert_buffers[i] = buffer_cache.get(vb).*;
        }

        for (bindings.images) |img, i| {
            if (img == 0) break;
            mtl_bindings.images[i] = image_cache.get(img).*;
        }

        return mtl_bindings;
    }
};

// TODO: make all these opaque
const MtlImage = extern struct {
    tex: u32,
    depth_tex: u32,
    stencil_tex: u32,
    sampler_state: u32,
    width: u32,
    height: u32,
};

const MtlNativeVertexLayout = extern struct {
    stride: c_int = 0,
    step_func: c_ulong = 0,
};

const MtlNativeVertexAttribute = extern struct {
    format: c_ulong = 0,
    offset: c_int = 0,
};

const MtlBuffer = extern struct {
    buffer: u32,
    vertex_layout: [4]MtlNativeVertexLayout,
    vertex_attrs: [8]MtlNativeVertexAttribute,
    index_type: c_ulong,
};

const MtlPass = extern struct {
    color_tex: ?*MtlImage,
    stencil_tex: ?*MtlImage,
};

const MtlShader = extern struct {
    vs_lib: u32,
    vs_func: u32,
    fs_lib: u32,
    fs_func: u32,
};

extern fn mtl_setup(desc: RendererDesc) void;
extern fn mtl_shutdown() void;

extern fn mtl_set_render_state(state: RenderState) void;
extern fn mtl_viewport(x: c_int, y: c_int, w: c_int, h: c_int) void;
extern fn mtl_scissor(x: c_int, y: c_int, w: c_int, h: c_int) void;

extern fn mtl_create_image(desc: ImageDesc) *MtlImage;
extern fn mtl_destroy_image(image: *MtlImage) void;
extern fn mtl_update_image(image: *MtlImage, arg1: ?*const c_void) void;

extern fn mtl_create_pass(desc: MtlPassDesc) *MtlPass;
extern fn mtl_destroy_pass(pass: *MtlPass) void;
extern fn mtl_begin_pass(pass: ?*MtlPass, arg0: ClearCommand, w: c_int, h: c_int) void;
extern fn mtl_end_pass() void;
extern fn mtl_commit_frame() void;

extern fn mtl_create_buffer(desc: MtlBufferDesc) *MtlBuffer;
extern fn mtl_destroy_buffer(buffer: *MtlBuffer) void;
extern fn mtl_update_buffer(buffer: *MtlBuffer, data: ?*const c_void, data_size: u32) void;

extern fn mtl_create_shader(desc: MtlShaderDesc) *MtlShader;
extern fn mtl_destroy_shader(shader: *MtlShader) void;
extern fn mtl_use_shader(shader: *MtlShader) void;
extern fn mtl_set_shader_uniform(shader: *MtlShader, arg1: [*c]u8, arg2: ?*const c_void) void;

extern fn mtl_apply_bindings(bindings: MtlBufferBindings) void;
extern fn mtl_draw(base_element: c_int, element_count: c_int, instance_count: c_int) void;
