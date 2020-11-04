const std = @import("std");
const runner = @import("runner");
const sdl = @import("sdl");
usingnamespace @import("gl");
const gfx = runner.gfx;
const math = runner.math;

var shader: gfx.Shader = undefined;
var mesh: runner.gfx.Mesh = undefined;
var tex: gfx.Texture = undefined;

pub fn main() !void {
    try runner.run(init, render);
}

fn init() !void {
    shader = try gfx.Shader.initFromFile(std.testing.allocator, "assets/shaders/vert.vs", "assets/shaders/frag.fs");
    shader.bind();
    shader.setInt("MainTex", 0);
    shader.setMat3x2("TransformMatrix", math.Mat32.initOrtho(800, 600));

    tex = loadCheckerTexture();
    var vertices = [_]runner.gfx.Vertex{
        .{ .pos = .{ .x = 10, .y = 10 }, .uv = .{ .x = 0, .y = 1 } }, // bl
        .{ .pos = .{ .x = 100, .y = 10 }, .uv = .{ .x = 1, .y = 1 } }, // br
        .{ .pos = .{ .x = 100, .y = 100 }, .uv = .{ .x = 1, .y = 0 } }, // tr
        .{ .pos = .{ .x = 10, .y = 100 }, .uv = .{ .x = 0, .y = 0 } }, // tl
    };
    var indices = [_]u32{
        0, 1, 2, 2, 3, 0,
    };

    mesh = runner.gfx.Mesh.init(runner.gfx.Vertex, vertices[0..], indices[0..]);
}

fn render() !void {
    glViewport(0, 0, 800, 600);
    glClearColor(0.4, 0.2, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    shader.bind();
    tex.bind();
    mesh.draw();
}

fn loadCheckerTexture() gfx.Texture {
    var pixels = [_]u32{
        0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
        0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
        0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF
    };

    var texture = gfx.Texture.init();
    texture.setColorData(4, 4, &pixels);
    return texture;
}
