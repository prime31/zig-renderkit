pub usingnamespace @import("backend.zig");
pub usingnamespace @import("types.zig");
pub const math = @import("math/math.zig");

pub const Mesh = @import("mesh.zig").Mesh;
pub const DynamicMesh = @import("mesh.zig").DynamicMesh;

pub const Batcher = @import("batcher.zig").Batcher;
pub const MultiBatcher = @import("multi_batcher.zig").MultiBatcher;
pub const TriangleBatcher = @import("triangle_batcher.zig").TriangleBatcher;

pub const Vertex = extern struct {
    pos: math.Vec2,
    uv: math.Vec2 = .{ .x = 0, .y = 0 },
    col: u32 = 0xFFFFFFFF,
};