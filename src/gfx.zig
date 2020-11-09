// export all the types and descriptors for ease of use
pub usingnamespace @import("backend").gfx_types;
pub usingnamespace @import("backend").descriptions;

// export the backend only explicitly (leaving gfx object methods only via backend.METHOD)
// and some select, higher level types and methods
pub const backend = @import("backend");
pub const Renderer = backend.Renderer;
pub const setRenderState = backend.setRenderState;
pub const viewport = backend.viewport;
pub const scissor = backend.scissor;
pub const beginDefaultPass = backend.beginDefaultPass;
pub const beginPass = backend.beginPass;
pub const endPass = backend.endPass;
pub const commitFrame = backend.commitFrame;
pub const bindImage = backend.bindImage;

pub const math = @import("math/math.zig");
pub const fs = @import("fs.zig");

// high level wrapper objects that use the low-level backend api
pub const Texture = @import("gfx/texture.zig").Texture;
pub const RenderTexture = @import("gfx/render_texture.zig").RenderTexture;
pub const Shader = @import("gfx/shader.zig").Shader;

// TODO: hlapi is a dumb folder name. fix that.
pub const Mesh = @import("hlapi/mesh.zig").Mesh;
pub const DynamicMesh = @import("hlapi/mesh.zig").DynamicMesh;

pub const Batcher = @import("hlapi/batcher.zig").Batcher;
pub const MultiBatcher = @import("hlapi/multi_batcher.zig").MultiBatcher;
pub const TriangleBatcher = @import("hlapi/triangle_batcher.zig").TriangleBatcher;

pub const Vertex = extern struct {
    pos: math.Vec2 = .{ .x = 0, .y = 0 },
    uv: math.Vec2 = .{ .x = 0, .y = 0 },
    col: u32 = 0xFFFFFFFF,
};