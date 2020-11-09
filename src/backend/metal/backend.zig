const std = @import("std");
usingnamespace @import("../types.zig");
usingnamespace @import("../descriptions.zig");

// the dummy backend defines the interface that all other backends need to implement for renderer compliance
pub fn init(desc: RendererDesc) void {
    metal_init(desc);
}

pub fn setup(desc: RendererDesc) void {
    metal_setup(desc);
}

pub fn shutdown() void {
    metal_shutdown();
}

pub fn setRenderState(state: RenderState) void {
    metal_setRenderState(state);
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {}
pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {}
pub fn clear(action: ClearCommand) void {}

// images
pub const Image = u16;
pub fn createImage(desc: ImageDesc) Image { return 0; }
pub fn destroyImage(image: Image) void {}
pub fn updateImage(comptime T: type, image: Image, content: []const T) void {}
pub fn bindImage(tid: Image, slot: c_uint) void {}

// passes
pub const OffscreenPass = u16;
pub fn createOffscreenPass(desc: OffscreenPassDesc) OffscreenPass { return 0; }
pub fn destroyOffscreenPass(pass: OffscreenPass) void {}

pub fn beginDefaultPass(action: ClearCommand, width: c_int, height: c_int) void {
    metal_beginPass(0, action, width, height);
}

pub fn beginOffscreenPass(pass: OffscreenPass, action: ClearCommand) void {
    metal_beginPass(pass, action, -1, -1);
}

pub fn endPass() void {
    metal_endPass();
}

pub fn commitFrame() void {
    metal_commit_frame();
}

// buffers
pub const Buffer = u16;
pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer { return 0; }
pub fn destroyBuffer(buffer: Buffer) void {}
pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {}

// buffer bindings
pub const BufferBindings = u16;
pub fn createBufferBindings(index_buffer: Buffer, vert_buffer: Buffer) BufferBindings { return 0; }
pub fn destroyBufferBindings(bindings: BufferBindings) void {}
pub fn drawBufferBindings(bindings: BufferBindings, element_count: c_int) void {}

// shaders
pub const ShaderProgram = u16;
pub fn createShaderProgram(desc: ShaderDesc) ShaderProgram { return 0; }
pub fn destroyShaderProgram(shader: ShaderProgram) void {}
pub fn useShaderProgram(shader: ShaderProgram) void {}
pub fn setShaderProgramUniform(comptime T: type, shader: ShaderProgram, name: [:0]const u8, value: T) void {}


pub extern fn metal_init(arg0: RendererDesc) void;
pub extern fn metal_setup(arg0: RendererDesc) void;
pub extern fn metal_shutdown() void;
pub extern fn metal_setRenderState(arg0: RenderState) void;
pub extern fn metal_viewport(arg0: c_int, arg1: c_int, w: c_int, h: c_int) void;
pub extern fn metal_scissor(arg0: c_int, arg1: c_int, w: c_int, h: c_int) void;
pub extern fn metal_clear(arg0: ClearCommand) void;
pub extern fn metal_createImage(arg0: ImageDesc) u16;
pub extern fn metal_destroyImage(arg0: u16) void;
pub extern fn metal_updateImage(arg0: u16, arg1: ?*c_void) void;
pub extern fn metal_bindImage(arg0: u16, arg1: u32) void;
pub extern fn metal_createOffscreenPass(arg0: OffscreenPassDesc) u16;
pub extern fn metal_destroyOffscreenPass(arg0: u16) void;
pub extern fn metal_beginPass(pass: u16, arg0: ClearCommand, w: c_int, h: c_int) void;
pub extern fn metal_endPass() void;
pub extern fn metal_commit_frame() void;
pub extern fn metal_destroyBuffer(arg0: u16) void;
pub extern fn metal_updateBuffer(arg0: u16, arg1: ?*c_void) void;
pub extern fn metal_createBufferBindings(arg0: u16, arg1: u16) u16;
pub extern fn metal_destroyBufferBindings(arg0: u16) void;
pub extern fn metal_drawBufferBindings(arg0: u16, arg1: c_int) void;
pub extern fn metal_createShaderProgram(arg0: ShaderDesc) u16;
pub extern fn metal_destroyShaderProgram(arg0: u16) void;
pub extern fn metal_useShaderProgram(arg0: u16) void;
pub extern fn metal_setShaderProgramUniform(arg0: u16, arg1: [*c]u8, arg2: ?*c_void) void;