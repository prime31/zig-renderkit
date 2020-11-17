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
    var buffer = buffer_cache.free(image);
    metal_destroy_buffer(buffer.*);
}

pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {
    var buff = buffer_cache.get(buffer);
    metal_update_buffer(buff.*, verts.ptr, @intCast(u32, verts.len));
}

// buffer bindings
pub fn createBufferBindings(index_buffer: Buffer, vert_buffers: []Buffer) BufferBindings {
    return 0;
}
pub fn destroyBufferBindings(bindings: BufferBindings) void {}
pub fn bindImageToBufferBindings(buffer_bindings: BufferBindings, image: Image, slot: c_uint) void {}
pub fn drawBufferBindings(bindings: BufferBindings, base_element: c_int, element_count: c_int, instance_count: c_int) void {}

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

// C api
// we need this due to the normal descriptor being generic which cant be sent to C: BufferDesc(T)
const MtlBufferDesc = extern struct {
    size: c_long = 0, // either size (for stream buffers) or content (for static/dynamic) must be set
    type: BufferType = .vertex,
    usage: Usage = .immutable,
    content: ?*const c_void = null,
    step_func: VertexStep = .per_vertex, // step function used for instanced drawing

    pub fn init(comptime T: type, buffer_desc: anytype) MtlBufferDesc {
        return .{
            .size = buffer_desc.getSize(),
            .type = buffer_desc.type,
            .usage = buffer_desc.usage,
            .content = if (buffer_desc.content) |content| content.ptr else null,
            .step_func = buffer_desc.step_func,
        };
    }
};

pub const MtlShaderDesc = extern struct {
    vs: [*c]const u8,
    fs: [*c]const u8,
    images: [4][*c]const u8 = &[_][*c]const u8{},

    pub fn init(desc: ShaderDesc) MtlShaderDesc {
        var images: [4][*c]const u8 = undefined;
        for (desc.images) |img, i| images[i] = img;

        return .{
            .vs = desc.vs,
            .fs = desc.fs,
            .images = images,
        };
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

const MtlBuffer = extern struct {
    buffer: u32,
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

extern fn metal_create_buffer_bindings(arg0: u16, arg1: u16) u16;
extern fn metal_destroy_buffer_bindings(arg0: u16) void;
extern fn metal_draw_buffer_bindings(arg0: u16, arg1: c_int) void;

extern fn metal_create_shader(desc: MtlShaderDesc) *MtlShader;
extern fn metal_destroy_shader(shader: *MtlShader) void;
extern fn metal_use_shader(shader: *MtlShader) void;
extern fn metal_set_shader_uniform(shader: *MtlShader, arg1: [*c]u8, arg2: ?*const c_void) void;
