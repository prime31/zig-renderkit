const std = @import("std");
const gamekit = @import("gamekit");
const renderkit = @import("renderkit");
const math = renderkit.math;

var shader: renderkit.Shader = undefined;
var tex: renderkit.Texture = undefined;
var colored_tex: renderkit.Texture = undefined;
var mesh: renderkit.Mesh = undefined;
var dyn_mesh: renderkit.DynamicMesh(renderkit.Vertex, u16) = undefined;

pub fn main() !void {
    try gamekit.run(.{
        .init = init,
        .render = render,
    });
}

fn init() !void {
    shader = try renderkit.Shader.init(@embedFile("assets/shaders/vert.vs"), @embedFile("assets/shaders/frag.fs"));
    shader.bind();
    shader.setUniformName(i32, "MainTex", 0);
    shader.setUniformName(math.Mat32, "TransformMatrix", math.Mat32.initOrtho(800, 600));

    tex = renderkit.Texture.initCheckerTexture();
    colored_tex = renderkit.Texture.initSingleColor(0xFFFF0000);

    var vertices = [_]renderkit.Vertex{
        .{ .pos = .{ .x = 10, .y = 10 }, .uv = .{ .x = 0, .y = 1 } }, // bl
        .{ .pos = .{ .x = 100, .y = 10 }, .uv = .{ .x = 1, .y = 1 } }, // br
        .{ .pos = .{ .x = 100, .y = 100 }, .uv = .{ .x = 1, .y = 0 } }, // tr
        .{ .pos = .{ .x = 10, .y = 100 }, .uv = .{ .x = 0, .y = 0 } }, // tl
    };
    var indices = [_]u16{
        0, 1, 2, 2, 3, 0,
    };

    mesh = renderkit.Mesh.init(renderkit.Vertex, vertices[0..], u16, indices[0..]);

    dyn_mesh = try renderkit.DynamicMesh(renderkit.Vertex, u16).init(std.testing.allocator, vertices.len, &indices);
    for (vertices) |*vert, i| {
        vert.pos.x += 200;
        vert.pos.y += 200;
        dyn_mesh.verts[i] = vert.*;
    }
    dyn_mesh.updateAllVerts();
}

fn render() !void {
    const size = gamekit.window.drawableSize();
    renderkit.beginDefaultPass(.{ .color = math.Color.beige.asArray() }, size.w, size.h);

    renderkit.bindImage(tex.img, 0);
    mesh.draw();

    renderkit.bindImage(colored_tex.img, 0);
    dyn_mesh.drawAllVerts();

    renderkit.endPass();
}
