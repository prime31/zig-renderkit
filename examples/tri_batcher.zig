const std = @import("std");
const gamekit = @import("gamekit");
const renderkit = @import("renderkit");
const math = renderkit.math;
const Color = math.Color;

var shader: renderkit.Shader = undefined;
var tri_batch: renderkit.TriangleBatcher = undefined;

pub fn main() !void {
    try gamekit.run(.{
        .init = init,
        .render = render,
    });
}

fn init() !void {
    shader = try renderkit.Shader.initFromFile(std.testing.allocator, "examples/assets/shaders/vert.vs", "examples/assets/shaders/frag.fs");
    shader.bind();
    shader.setUniformName(i32, "MainTex", 0);
    shader.setUniformName(renderkit.math.Mat32, "TransformMatrix", renderkit.math.Mat32.initOrtho(800, 600));

    tri_batch = try renderkit.TriangleBatcher.init(std.testing.allocator, 100);
}

fn render() !void {
    const size = gamekit.window.drawableSize();
    renderkit.renderer.beginDefaultPass(.{}, size.w, size.h);

    tri_batch.begin();
    tri_batch.drawTriangle(.{ .x = 50, .y = 50 }, .{ .x = 150, .y = 150 }, .{ .x = 0, .y = 150 }, Color.sky_blue);
    tri_batch.drawTriangle(.{ .x = 300, .y = 50 }, .{ .x = 350, .y = 150 }, .{ .x = 200, .y = 150 }, Color.lime);
    tri_batch.end();

    renderkit.renderer.endPass();
}
