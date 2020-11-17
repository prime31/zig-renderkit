const std = @import("std");
usingnamespace @import("../types.zig");
usingnamespace @import("../descriptions.zig");

const HandledCache = @import("../handles.zig").HandledCache;

var image_cache: HandledCache(*MtlImage) = undefined;
var buffer_cache: HandledCache(*MtlBuffer) = undefined;
var shader_cache: HandledCache(*MtlShader) = undefined;

pub fn setup(desc: RendererDesc) void {
    image_cache = HandledCache(*MtlImage).init(desc.allocator, desc.pool_sizes.texture);
    buffer_cache = HandledCache(*MtlBuffer).init(desc.allocator, desc.pool_sizes.buffers);
    shader_cache = HandledCache(*MtlShader).init(desc.allocator, desc.pool_sizes.shaders);

    metal_setup(desc);
    setRenderState(.{});
}

pub fn shutdown() void {
    metal_shutdown();
}

pub fn setRenderState(state: RenderState) void {
    metal_set_render_state(state);
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    metal_viewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    metal_scissor(x, y, width, height);
}

// images
pub fn createImage(desc: ImageDesc) Image {
    const img = metal_create_image(desc);
    return image_cache.append(img);
}

pub fn destroyImage(image: Image) void {
    var img = image_cache.free(image);
    metal_destroy_image(img.*);
}

pub fn updateImage(comptime T: type, image: Image, content: []const T) void {
    var img = image_cache.free(image);
    @panic("not implemented");
}

pub fn getImageNativeId(image: Image) u32 {
    @panic("not implemented");
    return 0;
}

// passes
pub fn createPass(desc: PassDesc) Pass {
    return 0;
}

pub fn destroyPass(pass: Pass) void {}

pub fn beginDefaultPass(action: ClearCommand, width: c_int, height: c_int) void {
    metal_begin_pass(0, action, width, height);
}

pub fn beginPass(pass: Pass, action: ClearCommand) void {
    metal_begin_pass(pass, action, -1, -1);
}

pub fn endPass() void {
    metal_end_pass();
}

pub fn commitFrame() void {
    metal_commit_frame();
}

// buffers
pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer {
    const buffer = metal_create_buffer(MtlBufferDesc.init(T, desc));
    return buffer_cache.append(buffer);
}

pub fn destroyBuffer(buffer: Buffer) void {
    var buff = buffer_cache.free(buffer);
    metal_destroy_buffer(buff.*);
}

pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {
    var buff = buffer_cache.get(buffer);
    metal_update_buffer(buff.*, verts.ptr, @intCast(u32, verts.len * @sizeOf(T)));
}

// shaders
pub fn createShaderProgram(comptime FragUniformT: type, desc: ShaderDesc) ShaderProgram {
    const shader = metal_create_shader(MtlShaderDesc.init(desc));
    return shader_cache.append(shader);
}

pub fn destroyShaderProgram(shader: ShaderProgram) void {
    var shd = shader_cache.free(shader);
    metal_destroy_shader(shd.*);
}

pub fn useShaderProgram(shader: ShaderProgram) void {
    var shdr = shader_cache.get(shader);
    metal_use_shader(shdr.*);
}

pub fn setShaderProgramUniformBlock(comptime FragUniformT: type, shader: ShaderProgram, stage: ShaderStage, value: FragUniformT) void {
    var shdr = shader_cache.get(shader);
}

pub fn setShaderProgramUniform(comptime T: type, shader: ShaderProgram, name: [:0]const u8, value: T) void {
    var shdr = shader_cache.get(shader);
}

// bindings and drawing
pub fn applyBindings(bindings: BufferBindings) void {
    metal_apply_bindings(MtlBufferBindings.init(bindings));
}

pub fn draw(base_element: c_int, element_count: c_int, instance_count: c_int) void {
    metal_draw(base_element, element_count, instance_count);
}

// C api
// we need these due to the normal descriptors either being generic or not able to be extern
const VertexFormat = extern enum {
    float,
    float2,
    float3,
    float4,
    u_byte_4n,
};

const IndexType = extern enum {
    uint16,
    uint32,
};

const VertexAttribute = extern struct {
    format: VertexFormat = .float,
    offset: c_int = 0,
};

const VertexLayout = extern struct {
    stride: c_int = 0,
    step_func: VertexStep = .per_vertex,
};

const MtlBufferDesc = extern struct {
    size: c_long = 0, // either size (for stream buffers) or content (for static/dynamic) must be set
    type: BufferType = .vertex,
    usage: Usage = .immutable,
    content: ?*const c_void = null,
    index_type: IndexType = .uint16,
    vertex_layout: [4]VertexLayout,
    vertex_attrs: [8]VertexAttribute,

    pub fn init(comptime T: type, buffer_desc: BufferDesc(T)) MtlBufferDesc {
        var vertex_attrs: [8]VertexAttribute = [_]VertexAttribute{.{}} ** 8;

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

                                        vertex_attrs[attr_index].format = std.meta.stringToEnum(VertexFormat, enum_name).?;
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

        var vertex_layout: [4]VertexLayout = [_]VertexLayout{.{}} ** 4;
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

const MtlImage = extern struct {
    tex: u32,
    depth_tex: u32,
    stencil_tex: u32,
    sampler_state: u32,
    width: u32,
    height: u32,
};

const MtlVertexLayout = extern struct {
    stride: c_int,
    step_func: c_int,
};

const MtlBuffer = extern struct {
    buffer: u32,
    vertex_layout: [4]MtlVertexLayout,
    vertex_attrs: [8]VertexAttribute,
};

const MtlShader = extern struct {
    vs_lib: u32,
    vs_func: u32,
    fs_lib: u32,
    fs_func: u32,
};

extern fn metal_setup(arg0: RendererDesc) void;
extern fn metal_shutdown() void;

extern fn metal_set_render_state(arg0: RenderState) void;
extern fn metal_viewport(arg0: c_int, arg1: c_int, w: c_int, h: c_int) void;
extern fn metal_scissor(arg0: c_int, arg1: c_int, w: c_int, h: c_int) void;
extern fn metal_clear(arg0: ClearCommand) void;

extern fn metal_create_image(desc: ImageDesc) *MtlImage;
extern fn metal_destroy_image(image: *MtlImage) void;
extern fn metal_update_image(image: *MtlImage, arg1: ?*const c_void) void;
extern fn metal_bind_image(arg0: u16, arg1: u32) void;

extern fn metal_create_pass(arg0: PassDesc) u16;
extern fn metal_destroy_pass(arg0: u16) void;
extern fn metal_begin_pass(pass: u16, arg0: ClearCommand, w: c_int, h: c_int) void;
extern fn metal_end_pass() void;
extern fn metal_commit_frame() void;

extern fn metal_create_buffer(desc: MtlBufferDesc) *MtlBuffer;
extern fn metal_destroy_buffer(buffer: *MtlBuffer) void;
extern fn metal_update_buffer(buffer: *MtlBuffer, data: ?*const c_void, data_size: u32) void;

extern fn metal_create_shader(desc: MtlShaderDesc) *MtlShader;
extern fn metal_destroy_shader(shader: *MtlShader) void;
extern fn metal_use_shader(shader: *MtlShader) void;
extern fn metal_set_shader_uniform(shader: *MtlShader, arg1: [*c]u8, arg2: ?*const c_void) void;

extern fn metal_apply_bindings(bindings: MtlBufferBindings) void;
extern fn metal_draw(base_element: c_int, element_count: c_int, instance_count: c_int) void;
