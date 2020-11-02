const std = @import("std");
const runner = @import("runner");
const sdl = @import("sdl");
usingnamespace @import("stb");
usingnamespace @import("gl");

var rng = std.rand.DefaultPrng.init(0x12345678);

const total_objects = 5;

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
    texture: Texture,
    pos: Vec2,
    vel: Vec2,
    col: u32,

    pub fn init(texture: Texture) Thing {
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
    try runner.run(null, render);
}

fn render() !void {
    var shader = try ShaderProgram.createFromFile(std.testing.allocator, "assets/shaders/vert.vs", "assets/shaders/frag.fs");
    shader.bind();

    var batcher = Batcher.init(100);
    defer batcher.deinit();

    var texture = loadTexture("assets/textures/bee-8.png");
    var checker_tex = loadCheckerTexture();
    var white_tex = loadWhiteTexture();
    var things = makeThings(total_objects, texture);

    shader.bind();
    shader.setInt("MainTex", 0);
    shader.setMat3x2("TransformMatrix", Mat32.initOrtho(800, 600));
    glViewport(0, 0, 800, 600);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // glPolygonMode(GL_FRONT_AND_BACK, GL_LINE_NV);

    var rt = try RenderTexture.init(300, 200);
    defer rt.deinit();

    // render something to the render texture
    rt.bind();
    glClearColor(0.4, 0.5, 0.3, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    shader.setMat3x2("TransformMatrix", Mat32.initOrthoInverted(300, 200));
    batcher.begin();
    batcher.drawTex(.{ .x = 10 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 50 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 90 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 130 }, 0xFFFFFFFF, texture);
    batcher.end();
    rt.unbind();

    var rt_pos: Vec2 = .{};

    shader.setMat3x2("TransformMatrix", Mat32.initOrtho(800, 600));

    while (!runner.pollEvents()) {
        for (things) |*thing| {
            thing.pos.x += thing.vel.x * 0.016;
            thing.pos.y += thing.vel.y * 0.016;
        }

        glClearColor(0.2, 0.3, 0.3, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);

        // render
        batcher.begin();
        batcher.drawTex(rt_pos, 0xFFFFFFFF, rt.texture);
        rt_pos.x += 0.5;
        rt_pos.y += 0.5;

        for (things) |thing| {
            batcher.drawTex(thing.pos, thing.col, thing.texture);
        }

        // batcher.drawRect(checker_tex, .{ .x = 350, .y = 50 }, .{ .x = 50, .y = 50 });

        batcher.drawPoint(white_tex, .{.x = 400, .y = 300}, 20, 0xFF0099FF);
        batcher.drawRect(checker_tex, .{ .x = 0, .y = 0 }, .{ .x = 50, .y = 50 }); // bl
        batcher.drawRect(checker_tex, .{ .x = 800 - 50, .y = 0 }, .{ .x = 50, .y = 50 }); // br
        batcher.drawRect(checker_tex, .{ .x = 800 - 50, .y = 600 - 50 }, .{ .x = 50, .y = 50 }); // tr
        batcher.drawRect(checker_tex, .{ .x = 0, .y = 600 - 50 }, .{ .x = 50, .y = 50 }); // tl

        batcher.end();

        runner.swapWindow();
    }
}

fn loadTexture(name: []const u8) Texture {
    var width: c_int = undefined;
    var height: c_int = undefined;
    var channels: c_int = undefined;

    var texture = Texture.init();

    var data = stbi_load(name.ptr, &width, &height, &channels, 4);
    defer stbi_image_free(data);
    if (data != null) {
        texture.setData(width, height, data);
    }

    return texture;
}

fn loadWhiteTexture() Texture {
    var pixels = [_]u32{
        0xFFFFFFFF, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFFFFFFFF,
    };

    var texture = Texture.init();
    texture.setColorData(2, 2, &pixels);
    return texture;
}

fn loadCheckerTexture() Texture {
    var pixels = [_]u32{
        0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
        0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
        0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF
        // 0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF,
    };

    var texture = Texture.init();
    texture.setColorData(4, 4, &pixels);
    return texture;
}

fn makeThings(n: usize, texture: Texture) []Thing {
    var things = std.testing.allocator.alloc(Thing, n) catch unreachable;

    for (things) |*thing, i| {
        thing.* = Thing.init(texture);
    }

    return things;
}
