const std = @import("std");
usingnamespace @import("../types.zig");
usingnamespace @import("../descriptions.zig");

// the dummy backend defines the interface that all other backends need to implement for renderer compliance
pub fn setup(desc: RendererDesc) void {}
pub fn shutdown() void {}
pub fn setRenderState(state: RenderState) void {}
pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {}
pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {}

// images
pub fn createImage(desc: ImageDesc) Image { return 0; }
pub fn destroyImage(image: Image) void {}
pub fn updateImage(comptime T: type, image: Image, content: []const T) void {}
pub fn getImageNativeId(image: Image) u32 { return 0; }

// passes
pub fn createPass(desc: PassDesc) Pass { return 0; }
pub fn destroyPass(pass: Pass) void {}
pub fn beginDefaultPass(action: ClearCommand, width: c_int, height: c_int) void {}
pub fn beginPass(pass: Pass, action: ClearCommand) void {}
pub fn endPass() void {}
pub fn commitFrame() void {}

// buffers
pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer { return 0; }
pub fn destroyBuffer(buffer: Buffer) void {}
pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {}
pub fn appendBuffer(comptime T: type, buffer: Buffer, verts: []const T) int {}

// buffer bindings
pub fn createBufferBindings(index_buffer: Buffer, vert_buffers: []Buffer) BufferBindings { return 0; }
pub fn destroyBufferBindings(bindings: BufferBindings) void {}
pub fn bindImageToBufferBindings(buffer_bindings: BufferBindings, image: Image, slot: c_uint) void {}
pub fn drawBufferBindings(bindings: BufferBindings, base_element: c_int, element_count: c_int, instance_count: c_int) void {}

// shaders
pub fn createShaderProgram(desc: ShaderDesc) ShaderProgram { return 0; }
pub fn destroyShaderProgram(shader: ShaderProgram) void {}
pub fn useShaderProgram(shader: ShaderProgram) void {}
pub fn setShaderProgramUniformBlock(comptime FragUniformT: type, shader: ShaderProgram, stage: ShaderStage, value: FragUniformT) void {}
