const std = @import("std");
const gamekit = @import("gamekit");
const renderkit = @import("renderkit");
const math = renderkit.math;

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
    texture: renderkit.Texture,
    pos: math.Vec2,
    vel: math.Vec2,
    col: u32,

    pub fn init(tex: renderkit.Texture) Thing {
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

var batcher: renderkit.Batcher = undefined;
var texture: renderkit.Texture = undefined;
var checker_tex: renderkit.Texture = undefined;
var white_tex: renderkit.Texture = undefined;
var things: []Thing = undefined;
var pass: renderkit.OffscreenPass = undefined;
var rt_pos: math.Vec2 = .{};
var camera: gamekit.utils.Camera = undefined;

pub fn main() !void {
    rng.seed(@intCast(u64, std.time.milliTimestamp()));
    try gamekit.run(.{
        .init = init,
        .update = update,
        .render = render,
    });
}

fn init() !void {
    camera = gamekit.utils.Camera.init();
    const size = gamekit.window.size();
    camera.pos = .{ .x = @intToFloat(f32, size.w) * 0.5, .y = @intToFloat(f32, size.h) * 0.5 };

    batcher = renderkit.Batcher.init(std.testing.allocator, 100);
    texture = renderkit.Texture.initFromFile(std.testing.allocator, "examples/assets/textures/bee-8.png", .nearest) catch unreachable;
    checker_tex = renderkit.Texture.initCheckerTexture();
    white_tex = renderkit.Texture.initSingleColor(0xFFFFFFFF);
    things = makeThings(12, texture);
    pass = renderkit.OffscreenPass.init(300, 200);
}

fn update() !void {
    for (things) |*thing| {
        thing.pos.x += thing.vel.x * gamekit.time.dt();
        thing.pos.y += thing.vel.y * gamekit.time.dt();
    }

    rt_pos.x += 0.5;
    rt_pos.y += 0.5;

    var did_move = false;
    if (gamekit.input.keyDown(.SDL_SCANCODE_A)) {
        camera.pos.x += 100 * gamekit.time.dt();
    } else if (gamekit.input.keyDown(.SDL_SCANCODE_D)) {
        camera.pos.x -= 100 * gamekit.time.dt();
    }
    if (gamekit.input.keyDown(.SDL_SCANCODE_W)) {
        camera.pos.y -= 100 * gamekit.time.dt();
    } else if (gamekit.input.keyDown(.SDL_SCANCODE_S)) {
        camera.pos.y += 100 * gamekit.time.dt();
    }
}

fn render() !void {
    // offscreen rendering
    gamekit.gfx.beginPass(.{ .color = math.Color.purple, .pass = pass });
    gamekit.gfx.drawTexture(texture, .{ .x = 10 + range(f32, -5, 5) });
    gamekit.gfx.drawTexture(texture, .{ .x = 50 + range(f32, -5, 5) });
    gamekit.gfx.drawTexture(texture, .{ .x = 90 + range(f32, -5, 5) });
    gamekit.gfx.drawTexture(texture, .{ .x = 130 + range(f32, -5, 5) });
    gamekit.gfx.endPass();

    // backbuffer rendering
    gamekit.gfx.beginPass(.{
        .color = math.Color{ .value = randomColor() },
        .trans_mat = camera.transMat(),
    });

    // render the offscreen texture to the backbuffer
    gamekit.gfx.drawTexture(pass.color_texture, rt_pos);

    for (things) |thing| {
        // batcher.drawTex(thing.pos, thing.col, thing.texture);
        gamekit.gfx.drawTexture(thing.texture, thing.pos);
    }

    gamekit.gfx.batcher.drawRect(checker_tex, .{ .x = 350, .y = 50 }, .{ .x = 50, .y = 50 });

    gamekit.gfx.batcher.drawPoint(white_tex, .{ .x = 400, .y = 300 }, 20, 0xFF0099FF);
    gamekit.gfx.batcher.drawRect(checker_tex, .{ .x = 0, .y = 0 }, .{ .x = 50, .y = 50 }); // bl
    gamekit.gfx.batcher.drawRect(checker_tex, .{ .x = 800 - 50, .y = 0 }, .{ .x = 50, .y = 50 }); // br
    gamekit.gfx.batcher.drawRect(checker_tex, .{ .x = 800 - 50, .y = 600 - 50 }, .{ .x = 50, .y = 50 }); // tr
    gamekit.gfx.batcher.drawRect(checker_tex, .{ .x = 0, .y = 600 - 50 }, .{ .x = 50, .y = 50 }); // tl

    gamekit.gfx.endPass();
}

fn makeThings(n: usize, tex: renderkit.Texture) []Thing {
    var the_things = std.testing.allocator.alloc(Thing, n) catch unreachable;

    for (the_things) |*thing, i| {
        thing.* = Thing.init(tex);
    }

    return the_things;
}
