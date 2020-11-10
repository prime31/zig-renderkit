const std = @import("std");
pub const aya = @import("aya");
const ig = @import("imgui");
const gfx = @import("gfx");
const math = gfx.math;
const gamekit = @import("gamekit");

var rng = std.rand.DefaultPrng.init(0x12345678);

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

    pub fn init(tex: gfx.Texture) Thing {
        return .{
            .texture = tex,
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

var shader: gfx.Shader = undefined;
var batcher: gfx.Batcher = undefined;
var texture: gfx.Texture = undefined;
var checker_tex: gfx.Texture = undefined;
var white_tex: gfx.Texture = undefined;
var things: []Thing = undefined;
var pass: gfx.OffscreenPass = undefined;
var rt_pos: math.Vec2 = .{};

pub fn main() !void {
    try gamekit.run(.{
        .init = init,
        .render = render,
    });
}

fn init() !void {
    shader = try gfx.Shader.initFromFile(std.testing.allocator, "examples/assets/shaders/vert.vs", "examples/assets/shaders/frag.fs");
    shader.bind();

    batcher = gfx.Batcher.init(std.testing.allocator, 100);
    texture = gfx.Texture.initFromFile(std.testing.allocator, "examples/assets/textures/bee-8.png", .nearest) catch unreachable;
    checker_tex = gfx.Texture.initCheckerTexture();
    white_tex = gfx.Texture.initSingleColor(0xFFFFFFFF);
    things = makeThings(12, texture);
    pass = gfx.OffscreenPass.init(300, 200);

    shader.bind();
    shader.setUniformName(i32, "MainTex", 0);
    gfx.viewport(0, 0, 800, 600);

    // render something to the render texture
    pass.bind(.{ .color = math.Color.purple.asArray() });

    shader.setUniformName(math.Mat32, "TransformMatrix", math.Mat32.initOrthoInverted(300, 200));
    batcher.begin();
    batcher.drawTex(.{ .x = 10 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 50 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 90 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 130 }, 0xFFFFFFFF, texture);
    batcher.end();
    pass.unbind();

    gfx.viewport(0, 0, 800, 600);
    shader.setUniformName(math.Mat32, "TransformMatrix", math.Mat32.initOrtho(800, 600));
}

fn render() !void {
    for (things) |*thing| {
        thing.pos.x += thing.vel.x * 0.016;
        thing.pos.y += thing.vel.y * 0.016;
    }

    const size = gamekit.window.drawableSize();
    gfx.beginDefaultPass(.{ .color = (math.Color{ .value = randomColor() }).asArray() }, size.w, size.h);

    // render
    batcher.begin();
    batcher.drawTex(rt_pos, 0xFFFFFFFF, pass.color_texture);
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

    gfx.endPass();
}

fn makeThings(n: usize, tex: gfx.Texture) []Thing {
    var the_things = std.testing.allocator.alloc(Thing, n) catch unreachable;

    for (the_things) |*thing, i| {
        thing.* = Thing.init(tex);
    }

    return the_things;
}
