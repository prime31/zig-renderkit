const std = @import("std");
usingnamespace @import("../types.zig");
usingnamespace @import("../descriptions.zig");

const HandledCache = @import("../handles.zig").HandledCache;

var image_cache: HandledCache(*MtlImage) = undefined;

// the dummy backend defines the interface that all other backends need to implement for renderer compliance
pub fn setup(desc: RendererDesc) void {
    image_cache = HandledCache(*MtlImage).init(desc.allocator, desc.pool_sizes.texture);
    metal_setup(desc);
}

pub fn shutdown() void {
    metal_shutdown();
}

pub fn setRenderState(state: RenderState) void {
    metal_set_render_state(state);
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {}
pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {}

// images
pub fn createImage(desc: ImageDesc) Image {
    const img = metal_create_image(desc);
    return image_cache.append(img);
}

pub fn destroyImage(image: Image) void {
    var img = image_cache.free(image);
    metal_destroy_image(img.*);
}

pub fn updateImage(comptime T: type, image: Image, content: []const T) void {}

pub fn getImageNativeId(image: Image) u32 {
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
    return 0;
}
pub fn destroyBuffer(buffer: Buffer) void {}
pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {}

// buffer bindings
pub fn createBufferBindings(index_buffer: Buffer, vert_buffers: []Buffer) BufferBindings {
    return 0;
}
pub fn destroyBufferBindings(bindings: BufferBindings) void {}
pub fn bindImageToBufferBindings(buffer_bindings: BufferBindings, image: Image, slot: c_uint) void {}
pub fn drawBufferBindings(bindings: BufferBindings, base_element: c_int, element_count: c_int, instance_count: c_int) void {}

// shaders
pub fn createShaderProgram(comptime FragUniformT: type, desc: ShaderDesc) ShaderProgram {
    return 0;
}
pub fn destroyShaderProgram(shader: ShaderProgram) void {}
pub fn useShaderProgram(shader: ShaderProgram) void {}
pub fn setShaderProgramUniformBlock(comptime FragUniformT: type, shader: ShaderProgram, stage: ShaderStage, value: FragUniformT) void {}
pub fn setShaderProgramUniform(comptime T: type, shader: ShaderProgram, name: [:0]const u8, value: T) void {}

// C api
const MtlImage = extern struct {
    tex: u32,
    depth_tex: u32,
    stencil_tex: u32,
    sampler_state: u32,
};

extern fn metal_setup(arg0: RendererDesc) void;
extern fn metal_shutdown() void;

extern fn metal_set_render_state(arg0: RenderState) void;
extern fn metal_viewport(arg0: c_int, arg1: c_int, w: c_int, h: c_int) void;
extern fn metal_scissor(arg0: c_int, arg1: c_int, w: c_int, h: c_int) void;
extern fn metal_clear(arg0: ClearCommand) void;

extern fn metal_create_image(desc: ImageDesc) *MtlImage;
extern fn metal_destroy_image(image: *MtlImage) void;
extern fn metal_update_image(image: *MtlImage, arg1: ?*c_void) void;
extern fn metal_bind_image(arg0: u16, arg1: u32) void;

extern fn metal_create_pass(arg0: PassDesc) u16;
extern fn metal_destroy_pass(arg0: u16) void;
extern fn metal_begin_pass(pass: u16, arg0: ClearCommand, w: c_int, h: c_int) void;
extern fn metal_end_pass() void;
extern fn metal_commit_frame() void;

extern fn metal_destroy_buffer(arg0: u16) void;
extern fn metal_update_buffer(arg0: u16, arg1: ?*c_void) void;
extern fn metal_create_buffer_bindings(arg0: u16, arg1: u16) u16;
extern fn metal_destroy_buffer_bindings(arg0: u16) void;
extern fn metal_draw_buffer_bindings(arg0: u16, arg1: c_int) void;
extern fn metal_create_shader(arg0: ShaderDesc) u16;
extern fn metal_destroy_shader(arg0: u16) void;
extern fn metal_use_shader(arg0: u16) void;
extern fn metal_set_shader_uniform(arg0: u16, arg1: [*c]u8, arg2: ?*c_void) void;
