const std = @import("std");
const runner = @import("runner");
const sdl = @import("sdl");
usingnamespace @import("stb");
usingnamespace @import("gl");

var rng = std.rand.DefaultPrng.init(0x12345678);

const total_textures: usize = 8;
const max_sprites_per_batch: usize = 1000;
const total_objects = 5000;
const draws_per_tex_swap = 20;
const use_multi_texture_batcher = true;

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
                .y = range(f32, 0, 50),
            },
            .vel = .{
                .x = range(f32, -50, 50),
                .y = range(f32, 0, 50),
            },
            .col = randomColor(),
        };
    }
};

const Fps = struct {
    start: i64,
    fps_frames: u32 = 0,
    prev_time: i64 = 0,
    curr_time: i64 = 0,
    fps_last_update: i64 = 0,
    frames_per_seconds: i64 = 0,
    frame_count: u32 = 1,
    now: u64,
    last: u64 = 0,
    dt: f32 = 0,

    pub fn init() Fps {
        return .{
            .start = std.time.milliTimestamp(),
            .now = sdl.SDL_GetPerformanceCounter(),
        };
    }

    pub fn update(self: *Fps) void {
        self.frame_count += 1;
        self.fps_frames += 1;
        self.prev_time = self.curr_time;
        self.curr_time = std.time.milliTimestamp();

        const time_since_last = self.curr_time - self.fps_last_update;
        if (self.curr_time > self.fps_last_update + 1000) {
            self.frames_per_seconds = @divTrunc(@intCast(i64, self.fps_frames) * 1000, time_since_last);
            self.fps_last_update = self.curr_time;
            self.fps_frames = 0;
            std.debug.print("fps: {d}\n", .{self.frames_per_seconds});
        }

        // dt
        self.last = self.now;
        self.now = sdl.SDL_GetPerformanceCounter();
        self.dt = @intToFloat(f32, (self.now - self.last)) / @intToFloat(f32, sdl.SDL_GetPerformanceFrequency());
    }
};

pub fn main() !void {
    try runner.run(null, render);
}

fn render() !void {
    _ = sdl.SDL_GL_SetSwapInterval(0);

    var shader = if (use_multi_texture_batcher) try ShaderProgram.createFromFile(std.testing.allocator, "assets/shaders/vert_multi.vs", "assets/shaders/frag_multi.fs") else try ShaderProgram.createFromFile(std.testing.allocator, "assets/shaders/vert.vs", "assets/shaders/frag.fs");
    shader.bind();

    if (use_multi_texture_batcher) {
        var samplers: [8]c_int = undefined;
        for (samplers) |*val, i| val.* = @intCast(c_int, i);
        shader.setIntArray("Textures", &samplers);
    }

    var batcher = if (use_multi_texture_batcher) MultiBatcher.init(max_sprites_per_batch) else Batcher.init(max_sprites_per_batch);
    defer batcher.deinit();

    var fps = Fps.init();
    var textures = loadTextures();
    var things = makeThings(total_objects, textures);

    shader.bind();
    shader.setInt("MainTex", 0);
    shader.setMat3x2("TransformMatrix", Mat32.initOrtho(800, 600));
    glViewport(0, 0, 800, 600);

    // glEnable(GL_BLEND);
    // glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, 0);
    // glPolygonMode(GL_FRONT_AND_BACK, GL_LINE_NV);

    while (!runner.pollEvents()) {
        fps.update();
        for (things) |*thing| {
            thing.pos.x += thing.vel.x * fps.dt;
            thing.pos.y += thing.vel.y * fps.dt;

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

        glClearColor(0.2, 0.3, 0.3, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);

        // render
        batcher.begin();

        for (things) |thing| {
            batcher.drawTex(thing.pos, thing.col, thing.texture);
        }

        batcher.end();

        runner.swapWindow();
    }
}

fn loadTextures() []Texture {
    var textures = std.testing.allocator.alloc(Texture, total_textures) catch unreachable;

    var width: c_int = undefined;
    var height: c_int = undefined;
    var channels: c_int = undefined;

    var buf: [512]u8 = undefined;
    // stbi_set_flip_vertically_on_load(1);
    for (textures) |tex, i| {
        textures[i] = Texture.init();

        var name = std.fmt.bufPrintZ(&buf, "assets/textures/bee-{}.png", .{i + 1}) catch unreachable;
        var data = stbi_load(name.ptr, &width, &height, &channels, 4);
        defer stbi_image_free(data);
        if (data != null) {
            textures[i].setData(width, height, data);
        }
    }

    return textures;
}

fn makeThings(n: usize, textures: []Texture) []Thing {
    var things = std.testing.allocator.alloc(Thing, n) catch unreachable;

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

    return things;
}
