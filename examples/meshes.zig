const std = @import("std");
const aya = @import("aya");
const gfx = @import("gfx");
const math = gfx.math;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    const backend = @import("backend");
    var s = backend.createShaderProgram(.{
        .vs = @embedFile("assets/shaders/vert.vs"),
        .fs = @embedFile("assets/shaders/frag.fs"),
        .images = &[_][:0]const u8 {"MainTex"},
    });
    backend.useShaderProgram(s);
    backend.setUniform(math.Mat32, s, "TransformMatrix", math.Mat32.initOrtho(800, 600));
    backend.setUniform(math.Vec2, s, "t", math.Vec2{});
    defer backend.destroyShaderProgram(s);

    // var shader = try gfx.Shader.init(@embedFile("assets/shaders/vert.vs"), @embedFile("assets/shaders/frag.fs"));
    // shader.bind();
    // shader.setInt("MainTex", 0);
    // shader.setMat3x2("TransformMatrix", math.Mat32.initOrtho(800, 600));
    // defer shader.deinit();

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
        gfx.clear(.{});

        // shader.bind();
        mesh.bindings.bindTexture(tex.img.tid, 0);
        mesh.draw();

        mesh.bindings.bindTexture(red_tex.img.tid, 0);
        dyn_mesh.drawAllVerts();

        aya.swapWindow();
    }
}
