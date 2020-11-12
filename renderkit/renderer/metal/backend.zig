const std = @import("std");
usingnamespace @import("../types.zig");
usingnamespace @import("../descriptions.zig");

// the dummy backend defines the interface that all other backends need to implement for renderer compliance
pub fn setup(desc: RendererDesc) void {
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
pub fn createImage(desc: ImageDesc) Image { return 0; }
pub fn destroyImage(image: Image) void {}
pub fn updateImage(comptime T: type, image: Image, content: []const T) void {}
pub fn bindImage(tid: Image, slot: c_uint) void {}

// passes
pub fn createPass(desc: PassDesc) Pass { return 0; }
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
pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer { return 0; }
pub fn destroyBuffer(buffer: Buffer) void {}
pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {}

// buffer bindings
pub fn createBufferBindings(index_buffer: Buffer, vert_buffer: Buffer) BufferBindings { return 0; }
pub fn destroyBufferBindings(bindings: BufferBindings) void {}
pub fn drawBufferBindings(bindings: BufferBindings, base_element: c_int, element_count: c_int, instance_count: c_int) void {}

// shaders
pub fn createShaderProgram(desc: ShaderDesc) ShaderProgram { return 0; }
pub fn destroyShaderProgram(shader: ShaderProgram) void {}
pub fn useShaderProgram(shader: ShaderProgram) void {}
pub fn setShaderProgramUniform(comptime T: type, shader: ShaderProgram, name: [:0]const u8, value: T) void {}


pub extern fn metal_setup(arg0: RendererDesc) void;
pub extern fn metal_shutdown() void;
pub extern fn metal_set_render_state(arg0: RenderState) void;
pub extern fn metal_viewport(arg0: c_int, arg1: c_int, w: c_int, h: c_int) void;
pub extern fn metal_scissor(arg0: c_int, arg1: c_int, w: c_int, h: c_int) void;
pub extern fn metal_clear(arg0: ClearCommand) void;
pub extern fn metal_create_image(arg0: ImageDesc) u16;
pub extern fn metal_destroy_image(arg0: u16) void;
pub extern fn metal_update_image(arg0: u16, arg1: ?*c_void) void;
pub extern fn metal_bind_image(arg0: u16, arg1: u32) void;
pub extern fn metal_create_pass(arg0: PassDesc) u16;
pub extern fn mmetal_destroy_pass(arg0: u16) void;
pub extern fn metal_begin_pass(pass: u16, arg0: ClearCommand, w: c_int, h: c_int) void;
pub extern fn metal_end_pass() void;
pub extern fn metal_commit_frame() void;
pub extern fn metal_destroy_buffer(arg0: u16) void;
pub extern fn metal_update_buffer(arg0: u16, arg1: ?*c_void) void;
pub extern fn metal_create_buffer_bindings(arg0: u16, arg1: u16) u16;
pub extern fn metal_destroy_buffer_bindings(arg0: u16) void;
pub extern fn metal_draw_buffer_bindings(arg0: u16, arg1: c_int) void;
pub extern fn metal_create_shader(arg0: ShaderDesc) u16;
pub extern fn metal_destroy_shader(arg0: u16) void;
pub extern fn metal_use_shader(arg0: u16) void;
pub extern fn metal_set_shader_uniform(arg0: u16, arg1: [*c]u8, arg2: ?*c_void) void;