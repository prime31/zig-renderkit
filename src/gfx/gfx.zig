const aya = @import("../aya.zig");
const math = @import("../math/math.zig");
pub usingnamespace @import("backend.zig");

pub const Mesh = @import("mesh.zig").Mesh;
pub const DynamicMesh = @import("mesh.zig").DynamicMesh;

pub const Batcher = @import("batcher.zig").Batcher;
pub const MultiBatcher = @import("multi_batcher.zig").MultiBatcher;

pub const Vertex = extern struct {
    pos: aya.math.Vec2,
    uv: aya.math.Vec2 = .{ .x = 0, .y = 0 },
    col: u32 = 0xFFFFFFFF,
};



