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
    const size = gamekit.window.drawableSize();
    renderkit.beginDefaultPass(.{ .color = clear_color.asArray() }, size.w, size.h);

    var color = clear_color.asVec4();
    if (igColorEdit4("Clear Color", &color.x, ImGuiColorEditFlags_NoInputs)) {
        clear_color = renderkit.math.Color.fromRgba(color.x, color.y, color.z, color.w);
    }

    renderkit.endPass();
}
