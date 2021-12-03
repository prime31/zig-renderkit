const std = @import("std");
// export the types and descriptions and also import all of them for use in this file
pub const types = @import("types.zig");
pub usingnamespace types;
pub const descriptions = @import("descriptions.zig");

// this is the entrypoint for all renderer specific types. They are loaded based on the chosen Renderer
// and exposed via this interface.

var cache = struct {
    const Rect = struct {
        x: c_int = 0,
        y: c_int = 0,
        w: c_int = 0,
        h: c_int = 0,

        pub fn changed(self: *@This(), x: c_int, y: c_int, w: c_int, h: c_int) bool {
            if (self.w != w or self.h != h or self.x != x or self.y != y) {
                self.x = x;
                self.y = y;
                self.w = w;
                self.h = h;
                return true;
            }
            return false;
        }
    };

    viewport: Rect = .{},
    scissor: Rect = .{},
    in_pass: bool = false,
}{};

pub const Renderer = enum {
    dummy,
    opengl,
    webgl,
    metal,
    directx,
    vulkan,
};

// import our chosen backend renderer
const renderkit = @import("../renderkit.zig");
const backend = if (renderkit.current_renderer == .opengl) @import("opengl/backend.zig") else @import("metal/backend.zig");

// setup and state
pub fn setup(desc: descriptions.RendererDesc) void {
    if (@import("../renderkit.zig").current_renderer == .metal and std.builtin.os.tag != .macos) @panic("Metal only exists on macOS!");
    backend.setup(desc);
}

pub fn shutdown() void {
    backend.shutdown();
}

pub fn setRenderState(state: types.RenderState) void {
    backend.setRenderState(state);
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    std.debug.assert(cache.in_pass);
    if (cache.viewport.changed(x, y, width, height))
        backend.viewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    std.debug.assert(cache.in_pass);
    if (cache.scissor.changed(x, y, width, height))
        backend.scissor(x, y, width, height);
}

// textures
pub fn createImage(desc: descriptions.ImageDesc) types.Image {
    return backend.createImage(desc);
}

pub fn destroyImage(image: types.Image) void {
    backend.destroyImage(image);
}

pub fn updateImage(comptime T: type, image: types.Image, content: []const T) void {
    std.debug.assert(T == u8 or T == u32);
    backend.updateImage(T, image, content);
}

// passes
pub fn createPass(desc: descriptions.PassDesc) types.Pass {
    return backend.createPass(desc);
}

pub fn destroyPass(pass: types.Pass) void {
    backend.destroyPass(pass);
}

pub fn beginDefaultPass(action: types.ClearCommand, width: c_int, height: c_int) void {
    std.debug.assert(!cache.in_pass);
    cache.in_pass = true;
    backend.beginDefaultPass(action, width, height);
}

pub fn beginPass(pass: types.Pass, action: types.ClearCommand) void {
    std.debug.assert(!cache.in_pass);
    cache.in_pass = true;
    backend.beginPass(pass, action);
}

pub fn endPass() void {
    std.debug.assert(cache.in_pass);
    cache.in_pass = false;
    backend.endPass();
}

pub fn commitFrame() void {
    std.debug.assert(!cache.in_pass);
    backend.commitFrame();
}

// buffers
pub fn createBuffer(comptime T: type, desc: descriptions.BufferDesc(T)) types.Buffer {
    return backend.createBuffer(T, desc);
}

pub fn destroyBuffer(buffer: types.Buffer) void {
    backend.destroyBuffer(buffer);
}

pub fn updateBuffer(comptime T: type, buffer: types.Buffer, data: []const T) void {
    backend.updateBuffer(T, buffer, data);
}

pub fn appendBuffer(comptime T: type, buffer: types.Buffer, data: []const T) u32 {
    return backend.appendBuffer(T, buffer, data);
}

// bindings and drawing
pub fn applyBindings(bindings: types.BufferBindings) void {
    std.debug.assert(cache.in_pass);
    backend.applyBindings(bindings);
}

pub fn draw(base_element: c_int, element_count: c_int, instance_count: c_int) void {
    std.debug.assert(cache.in_pass);
    backend.draw(base_element, element_count, instance_count);
}

// shaders
pub fn createShaderProgram(comptime VertUniformT: type, comptime FragUniformT: type, desc: descriptions.ShaderDesc) types.ShaderProgram {
    return backend.createShaderProgram(VertUniformT, FragUniformT, desc);
}

pub fn destroyShaderProgram(shader: types.ShaderProgram) void {
    return backend.destroyShaderProgram(shader);
}

pub fn useShaderProgram(shader: types.ShaderProgram) void {
    backend.useShaderProgram(shader);
}

pub fn setShaderProgramUniformBlock(comptime UniformT: type, shader: types.ShaderProgram, stage: types.ShaderStage, value: *UniformT) void {
    std.debug.assert(cache.in_pass);
    backend.setShaderProgramUniformBlock(UniformT, shader, stage, value);
}
