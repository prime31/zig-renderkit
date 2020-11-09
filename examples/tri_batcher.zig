const std = @import("std");
pub const aya = @import("aya");
const gfx = aya.gfx;
const Color = gfx.math.Color;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    var shader = try gfx.Shader.initFromFile(std.testing.allocator, "examples/assets/shaders/vert.vs", "examples/assets/shaders/frag.fs");
    defer shader.deinit();
    shader.bind();
    shader.setUniformName(i32, "MainTex", 0);
    shader.setUniformName(gfx.math.Mat32, "TransformMatrix", gfx.math.Mat32.initOrtho(800, 600));
    gfx.viewport(0, 0, 800, 600);

    var tri_batch = try gfx.TriangleBatcher.init(std.testing.allocator, 100);

    while (!aya.pollEvents()) {
        gfx.clear(.{});

        tri_batch.begin();
        tri_batch.drawTriangle(.{ .x = 50, .y = 50 }, .{ .x = 150, .y = 150 }, .{ .x = 0, .y = 150 }, Color.sky_blue);
        tri_batch.drawTriangle(.{ .x = 300, .y = 50 }, .{ .x = 350, .y = 150 }, .{ .x = 200, .y = 150 }, Color.lime);
        tri_batch.end();

        aya.swapWindow();
    }
}
