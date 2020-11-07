// TODO: instead of exposing all of backing only expose the render state functions (clear, scissor, etc)
pub usingnamespace @import("backend");
pub usingnamespace @import("backend").gfx_types;

pub const math = @import("math/math.zig");
pub const fs = @import("fs.zig");

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