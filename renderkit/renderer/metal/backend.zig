const std = @import("std");
usingnamespace @import("../types.zig");
usingnamespace @import("../descriptions.zig");

const HandledCache = @import("../handles.zig").HandledCache;
const num_in_flight_frames: usize = 1;

var image_cache: HandledCache(*MtlImage) = undefined;
var pass_cache: HandledCache(*MtlPass) = undefined;
var buffer_cache: HandledCache(*MtlBuffer) = undefined;
var shader_cache: HandledCache(*MtlShader) = undefined;

pub fn setup(desc: RendererDesc) void {
    image_cache = HandledCache(*MtlImage).init(desc.allocator, desc.pool_sizes.texture * num_in_flight_frames);
    pass_cache = HandledCache(*MtlPass).init(desc.allocator, desc.pool_sizes.offscreen_pass * num_in_flight_frames);
    buffer_cache = HandledCache(*MtlBuffer).init(desc.allocator, desc.pool_sizes.buffers * num_in_flight_frames);
    shader_cache = HandledCache(*MtlShader).init(desc.allocator, desc.pool_sizes.shaders * num_in_flight_frames);

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

pub fn appendBuffer(comptime T: type, buffer: Buffer, verts: []const T) u32 {
    var buff = buffer_cache.get(buffer);
    return mtl_append_buffer(buff.*, verts.ptr, @intCast(u32, verts.len * @sizeOf(T)));
}

// shaders
pub fn createShaderProgram(comptime VertUniformT: type, comptime FragUniformT: type, desc: ShaderDesc) ShaderProgram {
    const shader = mtl_create_shader(MtlShaderDesc.init(VertUniformT, FragUniformT, desc));
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

pub fn setShaderProgramUniformBlock(comptime UniformT: type, shader: ShaderProgram, stage: ShaderStage, value: *UniformT) void {
    var shdr = shader_cache.get(shader);
    var data = std.mem.asBytes(value);
    mtl_set_shader_uniform_block(shdr.*, stage, data, @intCast(c_int, @sizeOf(UniformT)));
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

const MtlVertexLayout = extern struct {
    stride: c_int = 0,
    step_func: VertexStep = .per_vertex,
};

const MtlBufferDesc = extern struct {
    size: c_long = 0, // either size (for stream buffers) or content (for static/dynamic) must be set
    type: BufferType = .vertex,
    type_id: u8,
    usage: Usage = .immutable,
    content: ?*const c_void = null,
    index_type: MtlIndexType = .uint16,
    vertex_layout: [4]MtlVertexLayout,
    vertex_attrs: [8]MtlVertexAttribute,

    var type_id_counter: u8 = 1;

    /// registered vertex types. this provides a way for us to send a unique id for each vertex type that can be used
    /// on the C side to identify a vertex buffer
    fn typeHandle(comptime T: type) *u8 {
        return &(struct {
            pub var handle: u8 = std.math.maxInt(u8);
        }.handle);
    }

    fn getTypeId(comptime T: type) u8 {
        var handle = typeHandle(T);
        if (handle.* < std.math.maxInt(u8)) {
            return handle.*;
        }
        handle.* = type_id_counter;
        type_id_counter += 1;
        return handle.*;
    }

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
            .type_id = getTypeId(T),
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
    vs_uniform_size: u32,
    fs_uniform_size: u32,

    pub fn init(comptime VertUniformT: type, comptime FragUniformT: type, desc: ShaderDesc) MtlShaderDesc {
        return .{
            .vs = desc.vs,
            .fs = desc.fs,
            .vs_uniform_size = @sizeOf(VertUniformT),
            .fs_uniform_size = @sizeOf(FragUniformT),
        };
    }
};

const MtlBufferBindings = extern struct {
    index_buffer: ?*MtlBuffer,
    vert_buffers: [4]?*MtlBuffer = [_]?*MtlBuffer{null} ** 4,
    index_buffer_offset: u32,
    vertex_buffer_offsets: [4]u32 = [_]u32{0} ** 4,
    images: [8]?*MtlImage = [_]?*MtlImage{null} ** 8,

    pub fn init(bindings: BufferBindings) MtlBufferBindings {
        var mtl_bindings = MtlBufferBindings{
            .index_buffer = buffer_cache.get(bindings.index_buffer).*,
            .index_buffer_offset = bindings.index_buffer_offset,
        };

        for (bindings.vert_buffers) |vb, i| {
            if (vb == 0) break;
            mtl_bindings.vert_buffers[i] = buffer_cache.get(vb).*;
        }

        std.mem.copy(u32, &mtl_bindings.vertex_buffer_offsets, &bindings.vertex_buffer_offsets);

        for (bindings.images) |img, i| {
            if (img == 0) break;
            mtl_bindings.images[i] = image_cache.get(img).*;
        }

        return mtl_bindings;
    }
};

// opaque objects returned by the metal C code
const MtlImage = opaque {};
const MtlBuffer = opaque {};
const MtlPass = opaque {};
const MtlShader = opaque {};

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
extern fn mtl_append_buffer(buffer: *MtlBuffer, data: ?*const c_void, data_size: u32) u32;

extern fn mtl_create_shader(desc: MtlShaderDesc) *MtlShader;
extern fn mtl_destroy_shader(shader: *MtlShader) void;
extern fn mtl_use_shader(shader: *MtlShader) void;
extern fn mtl_set_shader_uniform_block(shader: *MtlShader, stage: ShaderStage, data: ?*const c_void, num_bytes: c_int) void;

extern fn mtl_apply_bindings(bindings: MtlBufferBindings) void;
extern fn mtl_draw(base_element: c_int, element_count: c_int, instance_count: c_int) void;
