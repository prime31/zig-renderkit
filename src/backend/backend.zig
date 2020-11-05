const gfx_types = @import("types.zig");

// this is the entrypoint for all renderer specific types. They are loaded based on the chosen Renderer
// and exposed via this interface.

pub const Renderer = enum {
    dummy,
    opengl,
    metal,
    directx,
    vulkan,
};

// pub const backend = @import(@tagName(aya.renderer) ++ "/backend.zig"); // zls cant auto-complete these
pub const backend = @import("opengl/backend.zig"); // hardcoded for now to zls can auto-complete it

// the backend must provide all of the following types/funcs
pub fn init() void {
    backend.init();
    backend.setRenderState(.{});
}

pub fn initWithLoader(loader: fn ([*c]const u8) callconv(.C) ?*c_void) void {
    backend.initWithLoader(loader);
    backend.setRenderState(.{});
}

pub fn setRenderState(state: gfx_types.RenderState) void {
    backend.setRenderState(state);
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    backend.viewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    backend.scissor(x, y, width, height);
}

pub fn clear(action: gfx_types.ClearCommand) void {
    backend.clear(action);
}

pub const TextureId = backend.TextureId;
pub const Texture = backend.Texture;
pub const RenderTexture = backend.RenderTexture;

pub const BufferBindings = backend.BufferBindings;
pub const VertexBuffer = backend.VertexBuffer;
pub const IndexBuffer = backend.IndexBuffer;

pub const Shader = backend.Shader;
