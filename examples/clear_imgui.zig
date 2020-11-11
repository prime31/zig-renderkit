const std = @import("std");
const gamekit = @import("gamekit");
const renderkit = @import("renderkit");
usingnamespace @import("imgui");

pub const enable_imgui = true;

var clear_color = renderkit.math.Color.aya;
var camera: gamekit.utils.Camera = undefined;
var tex: renderkit.Texture = undefined;

pub fn main() !void {
    try gamekit.run(.{
        .init = init,
        .update = update,
        .render = render,
    });
}

fn init() !void {
    camera = gamekit.utils.Camera.init();
    tex = renderkit.Texture.initSingleColor(0xFFFF00FF);
}

fn update() !void {
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
    gamekit.gfx.beginPass(.{ .color = clear_color, .trans_mat = camera.transMat() });

    igText("WASD moves camera");

    var color = clear_color.asArray();
    if (igColorEdit4("Clear Color", &color[0], ImGuiColorEditFlags_NoInputs)) {
        clear_color = renderkit.math.Color.fromRgba(color[0], color[1], color[2], color[3]);
    }

    var buf: [255]u8 = undefined;
    var str = try std.fmt.bufPrintZ(&buf, "Camera Pos: {d:.2}, {d:.2}", .{camera.pos.x, camera.pos.y});
    igText(str);

    var mouse = gamekit.input.mousePosVec();
    var world = camera.screenToWorld(mouse);

    str = try std.fmt.bufPrintZ(&buf, "Mouse Pos: {d:.2}, {d:.2}", .{ mouse.x, mouse.y });
    igText(str);

    str = try std.fmt.bufPrintZ(&buf, "World Pos: {d:.2}, {d:.2}", .{ world.x, world.y });
    igText(str);

    if (ogButton("Camera Pos to 0,0")) camera.pos = .{};
    if (ogButton("Camera Pos to screen center")) {
        const size = gamekit.window.size();
        camera.pos = .{ .x = @intToFloat(f32, size.w) * 0.5, .y = @intToFloat(f32, size.h) * 0.5 };
    }

    gamekit.gfx.batcher.drawPoint(tex, .{}, 40, 0xFFFFFFFF);

    gamekit.gfx.endPass();
}
