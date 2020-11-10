const std = @import("std");
pub const aya = @import("aya");
const renderkit = aya.renderkit;
const Color = renderkit.math.Color;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    var shader = try renderkit.Shader.initFromFile(std.testing.allocator, "examples/assets/shaders/vert.vs", "examples/assets/shaders/frag.fs");
    defer shader.deinit();
    shader.bind();
    shader.setUniformName(i32, "MainTex", 0);
    shader.setUniformName(renderkit.math.Mat32, "TransformMatrix", renderkit.math.Mat32.initOrtho(800, 600));
    renderkit.viewport(0, 0, 800, 600);

    var tri_batch = try renderkit.TriangleBatcher.init(std.testing.allocator, 100);

    while (!aya.pollEvents()) {
        const size = aya.getRenderableSize();
        renderkit.beginDefaultPass(.{}, size.w, size.h);

        tri_batch.begin();
        tri_batch.drawTriangle(.{ .x = 50, .y = 50 }, .{ .x = 150, .y = 150 }, .{ .x = 0, .y = 150 }, Color.sky_blue);
        tri_batch.drawTriangle(.{ .x = 300, .y = 50 }, .{ .x = 350, .y = 150 }, .{ .x = 200, .y = 150 }, Color.lime);
        tri_batch.end();

        renderkit.endPass();
        aya.swapWindow();
    }
}
