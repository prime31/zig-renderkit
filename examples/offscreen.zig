const std = @import("std");
const aya = @import("aya");
const ig = @import("imgui");
const gfx = @import("gfx");
const math = gfx.math;

var rng = std.rand.DefaultPrng.init(0x12345678);
pub const imgui = true;

pub fn range(comptime T: type, at_least: T, less_than: T) T {
    if (@typeInfo(T) == .Int) {
        return rng.random.intRangeLessThanBiased(T, at_least, less_than);
    } else if (@typeInfo(T) == .Float) {
        return at_least + rng.random.float(T) * (less_than - at_least);
    }
    unreachable;
}

pub fn randomColor() u32 {
    const r = 200 + range(u8, 0, 55);
    const g = 200 + range(u8, 0, 55);
    const b = 200 + range(u8, 0, 55);
    return (r) | (@as(u32, g) << 8) | (@as(u32, b) << 16) | (@as(u32, 255) << 24);
}

const Thing = struct {
    texture: gfx.Texture,
    pos: math.Vec2,
    vel: math.Vec2,
    col: u32,

    pub fn init(texture: gfx.Texture) Thing {
        return .{
            .texture = texture,
            .pos = .{
                .x = range(f32, 0, 750),
                .y = range(f32, 0, 50),
            },
            .vel = .{
                .x = range(f32, 0, 0),
                .y = range(f32, 0, 50),
            },
            .col = randomColor(),
        };
    }
};

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    var shader = try gfx.Shader.initFromFile(std.testing.allocator, "examples/assets/shaders/vert.vs", "examples/assets/shaders/frag.fs");
    defer shader.deinit();
    shader.bind();

    var batcher = gfx.Batcher.init(std.testing.allocator, 100);
    defer batcher.deinit();

    var texture = gfx.Texture.initFromFile(std.testing.allocator, "examples/assets/textures/bee-8.png", .nearest) catch unreachable;
    defer texture.deinit();

    var checker_tex = gfx.Texture.initCheckerTexture();
    defer checker_tex.deinit();

    var white_tex = gfx.Texture.initSingleColor(0xFFFFFFFF);
    defer white_tex.deinit();

    var things = makeThings(12, texture);
    defer std.testing.allocator.free(things);

    shader.bind();
    shader.setUniformName(i32, "MainTex", 0);
    shader.setUniformName(math.Mat32, "TransformMatrix", math.Mat32.initOrtho(800, 600));
    gfx.viewport(0, 0, 800, 600);

    var rt = gfx.RenderTexture.init(300, 200);
    defer rt.deinit();

    // render something to the render texture
    rt.bind();
    gfx.clear(.{ .color = (math.Color{ .value = randomColor() }).asArray() });

    shader.setUniformName(math.Mat32, "TransformMatrix", math.Mat32.initOrthoInverted(300, 200));
    batcher.begin();
    batcher.drawTex(.{ .x = 10 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 50 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 90 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 130 }, 0xFFFFFFFF, texture);
    batcher.end();
    rt.unbind();

    gfx.viewport(0, 0, 800, 600);
    var rt_pos: math.Vec2 = .{};

    shader.setUniformName(math.Mat32, "TransformMatrix", math.Mat32.initOrtho(800, 600));

    while (!aya.pollEvents()) {
        for (things) |*thing| {
            thing.pos.x += thing.vel.x * 0.016;
            thing.pos.y += thing.vel.y * 0.016;
        }

        gfx.clear(.{ .color = (math.Color{ .value = randomColor() }).asArray() });

        // render
        batcher.begin();
        batcher.drawTex(rt_pos, 0xFFFFFFFF, rt.color_texture);
        rt_pos.x += 0.5;
        rt_pos.y += 0.5;

        for (things) |thing| {
            batcher.drawTex(thing.pos, thing.col, thing.texture);
        }

        batcher.drawRect(checker_tex, .{ .x = 350, .y = 50 }, .{ .x = 50, .y = 50 });

        batcher.drawPoint(white_tex, .{ .x = 400, .y = 300 }, 20, 0xFF0099FF);
        batcher.drawRect(checker_tex, .{ .x = 0, .y = 0 }, .{ .x = 50, .y = 50 }); // bl
        batcher.drawRect(checker_tex, .{ .x = 800 - 50, .y = 0 }, .{ .x = 50, .y = 50 }); // br
        batcher.drawRect(checker_tex, .{ .x = 800 - 50, .y = 600 - 50 }, .{ .x = 50, .y = 50 }); // tr
        batcher.drawRect(checker_tex, .{ .x = 0, .y = 600 - 50 }, .{ .x = 50, .y = 50 }); // tl

        batcher.end();

        aya.swapWindow();
    }
}

fn makeThings(n: usize, texture: gfx.Texture) []Thing {
    var things = std.testing.allocator.alloc(Thing, n) catch unreachable;

    for (things) |*thing, i| {
        thing.* = Thing.init(texture);
    }

    return things;
}
