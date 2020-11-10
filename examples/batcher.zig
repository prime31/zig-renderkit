const std = @import("std");
const sdl = @import("sdl");
const gamekit = @import("gamekit");
const renderkit = @import("renderkit");
const math = renderkit.math;

var rng = std.rand.DefaultPrng.init(0x12345678);

const total_textures: usize = 8;
const max_sprites_per_batch: usize = 5000;
const total_objects = 10000;
const draws_per_tex_swap = 250;
const use_multi_texture_batcher = false;

pub fn range(comptime T: type, at_least: T, less_than: T) T {
    if (@typeInfo(T) == .Int) {
        return rng.random.intRangeLessThanBiased(T, at_least, less_than);
    } else if (@typeInfo(T) == .Float) {
        return at_least + rng.random.float(T) * (less_than - at_least);
    }
    unreachable;
}

pub fn randomColor() u32 {
    const r = range(u8, 0, 255);
    const g = range(u8, 0, 255);
    const b = range(u8, 0, 255);
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
                .x = range(f32, -150, 150),
                .y = range(f32, 0, 250),
            },
            .col = randomColor(),
        };
    }
};

var shader: renderkit.Shader = undefined;
var batcher: if (use_multi_texture_batcher) renderkit.MultiBatcher else renderkit.Batcher = undefined;
var textures: []renderkit.Texture = undefined;
var things: []Thing = undefined;

pub fn main() !void {
    rng.seed(@intCast(u64, std.time.milliTimestamp()));
    try gamekit.run(.{
        .init = init,
        .update = update,
        .render = render,
        .shutdown = shutdown,
    });
}

fn init() !void {
    _ = sdl.SDL_GL_SetSwapInterval(0);

    shader = if (use_multi_texture_batcher) try renderkit.Shader.initFromFile(std.testing.allocator, "examples/assets/shaders/vert_multi.vs", "examples/assets/shaders/frag_multi.fs") else try renderkit.Shader.initFromFile(std.testing.allocator, "examples/assets/shaders/vert.vs", "examples/assets/shaders/frag.fs");
    shader.bind();
    shader.setUniformName(i32, "MainTex", 0);
    shader.setUniformName(math.Mat32, "TransformMatrix", math.Mat32.initOrtho(800, 600));

    if (use_multi_texture_batcher) {
        var samplers: [8]c_int = undefined;
        for (samplers) |*val, i| val.* = @intCast(c_int, i);
        shader.setUniformName([]c_int, "Textures", &samplers);
    }

    batcher = if (use_multi_texture_batcher) renderkit.MultiBatcher.init(std.testing.allocator, max_sprites_per_batch) else renderkit.Batcher.init(std.testing.allocator, max_sprites_per_batch);

    loadTextures();
    makeThings(total_objects);
}

fn shutdown() !void {
    std.testing.allocator.free(things);
    defer {
        for (textures) |tex| tex.deinit();
        std.testing.allocator.free(textures);
    }
}

fn update() !void {
    if (@mod(gamekit.time.frames(), 500) == 0) std.debug.print("fps: {d}\n", .{gamekit.time.fps()});

    for (things) |*thing| {
        thing.pos.x += thing.vel.x * gamekit.time.rawDeltaTime();
        thing.pos.y += thing.vel.y * gamekit.time.rawDeltaTime();

        if (thing.pos.x > 780) {
            thing.vel.x *= -1;
            thing.pos.x = 780;
        }
        if (thing.pos.x < 0) {
            thing.vel.x *= -1;
            thing.pos.x = 0;
        }
        if (thing.pos.y > 580) {
            thing.vel.y *= -1;
            thing.pos.y = 580;
        }
        if (thing.pos.y < 0) {
            thing.vel.y *= -1;
            thing.pos.y = 0;
        }
    }
}

fn render() !void {
    const size = gamekit.window.drawableSize();
    renderkit.beginDefaultPass(.{ .color = math.Color.beige.asArray() }, size.w, size.h);

    // render
    batcher.begin();

    for (things) |thing| {
        batcher.drawTex(thing.pos, thing.col, thing.texture);
    }

    batcher.end();
    renderkit.endPass();
}

fn loadTextures() void {
    textures = std.testing.allocator.alloc(renderkit.Texture, total_textures) catch unreachable;

    var width: c_int = undefined;
    var height: c_int = undefined;
    var channels: c_int = undefined;

    var buf: [512]u8 = undefined;
    for (textures) |tex, i| {
        var name = std.fmt.bufPrintZ(&buf, "examples/assets/textures/bee-{}.png", .{i + 1}) catch unreachable;
        textures[i] = renderkit.Texture.initFromFile(std.testing.allocator, name, .nearest) catch unreachable;
    }
}

fn makeThings(n: usize) void {
    things = std.testing.allocator.alloc(Thing, n) catch unreachable;

    var count: usize = 0;
    var tid = range(usize, 0, total_textures);

    for (things) |*thing, i| {
        count += 1;
        if (@mod(count, draws_per_tex_swap) == 0) {
            count = 0;
            tid = range(usize, 0, total_textures);
        }

        if (use_multi_texture_batcher) tid = range(usize, 0, total_textures);

        thing.* = Thing.init(textures[tid]);
    }
}
