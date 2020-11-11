const std = @import("std");
const gamekit = @import("gamekit");
const renderkit = @import("renderkit");

const Texture = renderkit.Texture;
const Color = renderkit.math.Color;

const Block = struct {
    tex: Texture,
    pos: renderkit.math.Vec2,
    scale: f32,
    dist: f32,
};

const Camera = struct {
    sw: f32,
    sh: f32,
    x: f32 = 0,
    y: f32 = 0,
    r: f32 = 0,
    z: f32 = 32,
    f: f32 = 1,
    o: f32 = 1,
    x1: f32 = 0,
    y1: f32 = 0,
    x2: f32 = 0,
    y2: f32 = 0,
    sprites: std.ArrayList(Block) = undefined,

    pub fn init(sw: f32, sh: f32) Camera {
        var new_cam = Camera{ .sw = sw, .sh = sh, .sprites = std.ArrayList(Block).init(std.testing.allocator) };
        new_cam.setRotation(0);
        return new_cam;
    }

    pub fn deinit(self: Camera) void {
        self.sprites.deinit();
    }

    pub fn setRotation(self: *Camera, rot: f32) void {
        self.r = rot;
        self.x1 = std.math.sin(rot);
        self.y1 = std.math.cos(rot);
        self.x2 = -std.math.cos(rot);
        self.y2 = std.math.sin(rot);
    }

    pub fn toWorld(self: Camera, position: renderkit.math.Vec2) renderkit.math.Vec2 {
        var pos = renderkit.math.Vec2{ .x = position.x, .y = self.sh - position.y };
        const sx = (self.sw / 2 - pos.x) * self.z / (self.sw / self.sh);
        const sy = (self.o * self.sh - pos.y) * (self.z / self.f);

        const rot_x = sx * self.x1 + sy * self.y1;
        const rot_y = sx * self.x2 + sy * self.y2;

        return .{ .x = rot_x / pos.y + self.x, .y = rot_y / pos.y + self.y };
    }

    pub fn toScreen(self: Camera, pos: renderkit.math.Vec2) struct { x: f32, y: f32, size: f32 } {
        const obj_x = -(self.x - pos.x) / self.z;
        const obj_y = (self.y - pos.y) / self.z;

        const space_x = (-obj_x * self.x1 - obj_y * self.y1);
        const space_y = (obj_x * self.x2 + obj_y * self.y2) * self.f;

        const distance = 1 - space_y;
        const screen_x = (space_x / distance) * self.o * self.sw + self.sw / 2;
        const screen_y = ((space_y + self.o - 1) / distance) * self.sh + self.sh;

        // Should be approximately one pixel on the plane
        const size = ((1 / distance) / self.z * self.o) * self.sw;

        return .{ .x = screen_x, .y = screen_y, .size = size };
    }

    pub fn placeSprite(self: *Camera, tex: Texture, pos: renderkit.math.Vec2, scale: f32) void {
        const dim = self.toScreen(pos);
        const sx2 = (dim.size * scale) / tex.width;

        if (sx2 < 0) return;

        _ = self.sprites.append(.{
            .tex = tex,
            .pos = .{ .x = dim.x, .y = dim.y },
            .scale = sx2,
            .dist = dim.size,
        }) catch unreachable;
    }

    pub fn renderSprites(self: *Camera) void {
        if (self.sprites.items.len > 0) {
            std.sort.sort(Block, self.sprites.items, {}, sort);
        }

        for (self.sprites.items) |sprite| {
            gamekit.gfx.drawTexScaleOrigin(sprite.tex, sprite.pos.x, sprite.pos.y, sprite.scale, sprite.tex.width / 2, sprite.tex.height);
        }
        self.sprites.items.len = 0;
    }

    fn sort(ctx: void, a: Block, b: Block) bool {
        return a.dist < b.dist;
    }
};

var rt: Texture = undefined;
var map: Texture = undefined;
var block: Texture = undefined;
var mode7_shader: renderkit.Shader = undefined;
var camera: Camera = undefined;
var blocks: std.ArrayList(renderkit.math.Vec2) = undefined;
var cam: gamekit.utils.Camera = undefined;

pub fn main() !void {
    try gamekit.run(.{
        .init = init,
        .update = update,
        .render = render,
        .shutdown = shutdown,
    });
}

fn init() !void {
    camera = Camera.init(@intToFloat(f32, gamekit.window.width()), @intToFloat(f32, gamekit.window.height()));

    cam = gamekit.utils.Camera.init();
    const size = gamekit.window.size();
    cam.pos = .{ .x = @intToFloat(f32, size.w) * 0.5, .y = @intToFloat(f32, size.h) * 0.5 };

    rt = Texture.init(800, 600);
    map = Texture.initFromFile(std.testing.allocator, "examples/assets/mario_kart.png", .nearest) catch unreachable;
    block = Texture.initFromFile(std.testing.allocator, "examples/assets/block.png", .nearest) catch unreachable;
    mode7_shader = try renderkit.Shader.init(@embedFile("assets/shaders/vert.vs"), @embedFile("assets/shaders/mode7.fs"));
    mode7_shader.bind();
    mode7_shader.setUniformName(i32, "MainTex", 0);
    mode7_shader.setUniformName(i32, "map_tex", 1);

    blocks = std.ArrayList(renderkit.math.Vec2).init(std.testing.allocator);
    _ = blocks.append(.{ .x = 0, .y = 0 }) catch unreachable;

    // uncomment for sorting stress test
    // var x: usize = 4;
    // while (x < 512) : (x += 12) {
    //     var y: usize = 4;
    //     while (y < 512) : (y += 12) {
    //         _ = blocks.append(.{ .x = @intToFloat(f32, x), .y = @intToFloat(f32, y) }) catch unreachable;
    //     }
    // }
}

fn shutdown() !void {
    map.deinit();
    block.deinit();
    mode7_shader.deinit();
    blocks.deinit();
    camera.deinit();
}

fn update() !void {
    const move_speed = 140.0;
    if (gamekit.input.keyDown(.SDL_SCANCODE_W)) {
        camera.x += std.math.cos(camera.r) * move_speed * gamekit.time.dt();
        camera.y += std.math.sin(camera.r) * move_speed * gamekit.time.dt();
    } else if (gamekit.input.keyDown(.SDL_SCANCODE_S)) {
        camera.x = camera.x - std.math.cos(camera.r) * move_speed * gamekit.time.dt();
        camera.y = camera.y - std.math.sin(camera.r) * move_speed * gamekit.time.dt();
    }

    if (gamekit.input.keyDown(.SDL_SCANCODE_A)) {
        camera.x += std.math.cos(camera.r - std.math.pi / 2.0) * move_speed * gamekit.time.dt();
        camera.y += std.math.sin(camera.r - std.math.pi / 2.0) * move_speed * gamekit.time.dt();
    } else if (gamekit.input.keyDown(.SDL_SCANCODE_D)) {
        camera.x += std.math.cos(camera.r + std.math.pi / 2.0) * move_speed * gamekit.time.dt();
        camera.y += std.math.sin(camera.r + std.math.pi / 2.0) * move_speed * gamekit.time.dt();
    }

    if (gamekit.input.keyDown(.SDL_SCANCODE_I)) {
        camera.f += gamekit.time.dt();
    } else if (gamekit.input.keyDown(.SDL_SCANCODE_O)) {
        camera.f -= gamekit.time.dt();
    }

    if (gamekit.input.keyDown(.SDL_SCANCODE_K)) {
        camera.o += gamekit.time.dt();
    } else if (gamekit.input.keyDown(.SDL_SCANCODE_L)) {
        camera.o -= gamekit.time.dt();
    }

    if (gamekit.input.keyDown(.SDL_SCANCODE_MINUS)) {
        camera.z += gamekit.time.dt() * 10;
    } else if (gamekit.input.keyDown(.SDL_SCANCODE_EQUALS)) {
        camera.z -= gamekit.time.dt() * 10;
    }

    if (gamekit.input.keyDown(.SDL_SCANCODE_Q)) {
        camera.setRotation(@mod(camera.r, std.math.tau) - gamekit.time.dt());
    } else if (gamekit.input.keyDown(.SDL_SCANCODE_E)) {
        camera.setRotation(@mod(camera.r, std.math.tau) + gamekit.time.dt());
    }

    if (gamekit.input.mousePressed(.left)) {
        var pos = camera.toWorld(gamekit.input.mousePosVec());
        _ = blocks.append(pos) catch unreachable;
    }
}

fn render() !void {
    gamekit.gfx.beginPass(.{});
    drawPlane();

    var pos = camera.toScreen(camera.toWorld(gamekit.input.mousePosVec()));
    gamekit.gfx.drawTexScaleOrigin(block, pos.x, pos.y, pos.size, block.width / 2, block.height);

    for (blocks.items) |b| {
        camera.placeSprite(block, b, 8);
    }
    camera.renderSprites();

    gamekit.gfx.endPass();
}

fn drawPlane() void {
    gamekit.gfx.setShader(mode7_shader);

    mode7_shader.setUniformName(f32, "mapw", map.width);
    mode7_shader.setUniformName(f32, "maph", map.height);

    mode7_shader.setUniformName(f32, "x", camera.x);
    mode7_shader.setUniformName(f32, "y", camera.y);
    mode7_shader.setUniformName(f32, "zoom", camera.z);
    mode7_shader.setUniformName(f32, "fov", camera.f);
    mode7_shader.setUniformName(f32, "offset", camera.o);
    mode7_shader.setUniformName(f32, "wrap", 0);

    mode7_shader.setUniformName(f32, "x1", camera.x1);
    mode7_shader.setUniformName(f32, "y1", camera.y1);
    mode7_shader.setUniformName(f32, "x2", camera.x2);
    mode7_shader.setUniformName(f32, "y2", camera.y2);

    gamekit.gfx.batcher.mesh.bindImage(map.img, 1);
    gamekit.gfx.drawTexture(rt, .{});
    gamekit.gfx.setShader(null);
    gamekit.gfx.batcher.mesh.bindImage(0, 1);
}
