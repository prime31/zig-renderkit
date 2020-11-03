const aya = @import("../runner.zig");
const math = @import("../math/math.zig");
usingnamespace @import("backend.zig");

pub const Batcher = @import("batcher.zig").Batcher;
pub const MultiBatcher = @import("batcher.zig").MultiBatcher;

pub const Vertex = extern struct {
    pos: aya.math.Vec2,
    uv: aya.math.Vec2 = .{ .x = 0, .y = 0 },
    col: u32 = 0xFFFFFFFF,
};

pub const MultiVertex = extern struct {
    pos: aya.math.Vec2,
    uv: aya.math.Vec2 = .{ .x = 0, .y = 0 },
    col: u32 = 0xFFFFFFFF,
    tid: f32 = 0,
};


