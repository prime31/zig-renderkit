const std = @import("std");
pub const aya = @import("aya");
const gfx = @import("gfx");
const math = gfx.math;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    var shader = try gfx.Shader.init(@embedFile("assets/shaders/vert.vs"), @embedFile("assets/shaders/frag.fs"));
    shader.bind();
    shader.setUniformName(i32, "MainTex", 0);
    shader.setUniformName(math.Mat32, "TransformMatrix", math.Mat32.initOrtho(800, 600));
    defer shader.deinit();

    var tex = gfx.Texture.initCheckerTexture();
    defer tex.deinit();
    var red_tex = gfx.Texture.initSingleColor(0xFFFF0000);
    defer red_tex.deinit();

    var vertices = [_]gfx.Vertex{
        .{ .pos = .{ .x = 10, .y = 10 }, .uv = .{ .x = 0, .y = 1 } }, // bl
        .{ .pos = .{ .x = 100, .y = 10 }, .uv = .{ .x = 1, .y = 1 } }, // br
        .{ .pos = .{ .x = 100, .y = 100 }, .uv = .{ .x = 1, .y = 0 } }, // tr
        .{ .pos = .{ .x = 10, .y = 100 }, .uv = .{ .x = 0, .y = 0 } }, // tl
    };
    var indices = [_]u16{
        0, 1, 2, 2, 3, 0,
    };

    var mesh = gfx.Mesh.init(gfx.Vertex, vertices[0..], u16, indices[0..]);

    var dyn_mesh = try gfx.DynamicMesh(gfx.Vertex, u16).init(std.testing.allocator, vertices.len, &indices);
    for (vertices) |*vert, i| {
        vert.pos.x += 200;
        vert.pos.y += 200;
        dyn_mesh.verts[i] = vert.*;
    }
    dyn_mesh.updateAllVerts();

    gfx.viewport(0, 0, 800, 600);

    while (!aya.pollEvents()) {
        const size = aya.getRenderableSize();
        gfx.beginDefaultPass(.{ .color = math.Color.beige.asArray() }, size.w, size.h);

        gfx.bindImage(tex.img, 0);
        mesh.draw();

        gfx.bindImage(red_tex.img, 0);
        dyn_mesh.drawAllVerts();

        gfx.endPass();
        aya.swapWindow();
    }
}
