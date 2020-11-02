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
    const r = range(u8, 0, 255);
    const g = range(u8, 0, 255);
    const b = range(u8, 0, 255);
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
                .y = range(f32, 0, 550),
            },
            .vel = .{
                .x = range(f32, -50, 50),
                .y = range(f32, -50, 50),
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
    batcher.drawTex(.{ .x = 10, .y = 10 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 50, .y = 50 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 90, .y = 90 }, 0xFFFFFFFF, texture);
    batcher.drawTex(.{ .x = 130, .y = 130 }, 0xFFFFFFFF, texture);
    batcher.end();
    rt.unbind();

    shader.setMat3x2("TransformMatrix", Mat32.initOrtho(800, 600));

    while (!runner.pollEvents()) {
        glClearColor(0.2, 0.3, 0.3, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);

        // render
        batcher.begin();
        batcher.drawTex(.{ .x = 0, .y = 0 }, 0xFFFFFFFF, rt.texture);

        for (things) |thing| {
            batcher.drawTex(thing.pos, thing.col, thing.texture);
        }

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

fn makeThings(n: usize, texture: Texture) []Thing {
    var things = std.testing.allocator.alloc(Thing, n) catch unreachable;

    for (things) |*thing, i| {
        thing.* = Thing.init(texture);
    }

    return things;
}
