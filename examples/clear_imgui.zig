const std = @import("std");
pub const aya = @import("aya");
const gfx = aya.gfx;
usingnamespace @import("imgui");

pub const imgui = true;

var clear_color = gfx.math.Color.aya;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    while (!aya.pollEvents()) {
        const size = aya.getRenderableSize();
        gfx.beginDefaultPass(.{ .color = clear_color.asArray() }, size.w, size.h);

        var color = clear_color.asVec4();
        if (igColorEdit4("Clear Color", &color.x, ImGuiColorEditFlags_NoInputs)) {
            clear_color = gfx.math.Color.fromRgba(color.x, color.y, color.z, color.w);
        }

        gfx.endPass();
        aya.swapWindow();
    }
}
