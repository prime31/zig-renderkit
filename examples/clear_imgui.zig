const std = @import("std");
const gamekit = @import("gamekit");
const renderkit = @import("renderkit");
usingnamespace @import("imgui");

pub const enable_imgui = true;

var clear_color = renderkit.math.Color.aya;

pub fn main() !void {
    try gamekit.run(.{
        .init = init,
        .render = render,
    });
}

fn init() !void {}

fn render() !void {
    gamekit.gfx.beginPass(.{ .color = clear_color });

    var color = clear_color.asArray();
    if (igColorEdit4("Clear Color", &color[0], ImGuiColorEditFlags_NoInputs)) {
        clear_color = renderkit.math.Color.fromRgba(color[0], color[1], color[2], color[3]);
    }

    gamekit.gfx.endPass();
}
