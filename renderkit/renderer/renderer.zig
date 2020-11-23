const std = @import("std");
// export the types and descriptions and also import all of them for use in this file
pub const renderkit_types = @import("types.zig");
usingnamespace @import("types.zig");
pub const descriptions = @import("descriptions.zig");
usingnamespace @import("descriptions.zig");

// this is the entrypoint for all renderer specific types. They are loaded based on the chosen Renderer
// and exposed via this interface.

pub const Renderer = enum {
    dummy,
    opengl,
    webgl,
    metal,
    directx,
    vulkan,
};

// import our chosen backend renderer
const backend = @import(@tagName(@import("../renderkit.zig").current_renderer) ++ "/backend.zig");

// setup and state
pub fn setup(desc: RendererDesc) void {
    if (@import("../renderkit.zig").current_renderer == .metal and std.builtin.os.tag != .macos) @panic("Metal only exists on macOS!");
    backend.setup(desc);
}

pub fn shutdown() void {
    backend.shutdown();
}

pub fn setRenderState(state: RenderState) void {
    backend.setRenderState(state);
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    backend.viewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    backend.scissor(x, y, width, height);
}


// textures
pub fn createImage(desc: ImageDesc) Image {
    return backend.createImage(desc);
}

pub fn destroyImage(image: Image) void {
    backend.destroyImage(image);
}

pub fn updateImage(comptime T: type, image: Image, content: []const T) void {
    std.debug.assert(T == u8 or T == u32);
    backend.updateImage(T, image, content);
}

pub fn getImageNativeId(image: Image) u32 {
    return backend.getImageNativeId(image);
}

// passes
pub fn createPass(desc: PassDesc) Pass {
    return backend.createPass(desc);
}

pub fn destroyPass(pass: Pass) void {
    backend.destroyPass(pass);
}

pub fn beginDefaultPass(action: ClearCommand, width: c_int, height: c_int) void {
    backend.beginDefaultPass(action, width, height);
}

pub fn beginPass(pass: Pass, action: ClearCommand) void {
    backend.beginPass(pass, action);
}

pub fn endPass() void {
    backend.endPass();
}

pub fn commitFrame() void {
    backend.commitFrame();
}

// buffers
pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer {
    return backend.createBuffer(T, desc);
}

pub fn destroyBuffer(buffer: Buffer) void {
    backend.destroyBuffer(buffer);
}

pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {
    backend.updateBuffer(T, buffer, verts);
}

pub fn appendBuffer(comptime T: type, buffer: Buffer, verts: []const T) u32 {
    return backend.appendBuffer(T, buffer, verts);
}

// bindings and drawing
pub fn applyBindings(bindings: BufferBindings) void {
    backend.applyBindings(bindings);
}

pub fn draw(base_element: c_int, element_count: c_int, instance_count: c_int) void {
    backend.draw(base_element, element_count, instance_count);
}

// shaders
pub fn createShaderProgram(comptime VertUniformT: type, comptime FragUniformT: type, desc: ShaderDesc) ShaderProgram {
    return backend.createShaderProgram(VertUniformT, FragUniformT, desc);
}

pub fn destroyShaderProgram(shader: ShaderProgram) void {
    return backend.destroyShaderProgram(shader);
}

pub fn useShaderProgram(shader: ShaderProgram) void {
    backend.useShaderProgram(shader);
}

pub fn setShaderProgramUniformBlock(comptime UniformT: type, shader: ShaderProgram, stage: ShaderStage, value: *UniformT) void {
    backend.setShaderProgramUniformBlock(UniformT, shader, stage, value);
}
