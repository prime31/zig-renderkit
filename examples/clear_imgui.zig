const std = @import("std");
pub const aya = @import("aya");
const renderkit = aya.renderkit;
usingnamespace @import("imgui");

pub const enable_imgui = true;

var clear_color = renderkit.math.Color.aya;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    while (!aya.pollEvents()) {
        const size = aya.getRenderableSize();
        renderkit.beginDefaultPass(.{ .color = clear_color.asArray() }, size.w, size.h);

        var color = clear_color.asVec4();
        if (igColorEdit4("Clear Color", &color.x, ImGuiColorEditFlags_NoInputs)) {
            clear_color = renderkit.math.Color.fromRgba(color.x, color.y, color.z, color.w);
        }

        renderkit.endPass();
        aya.swapWindow();
    }
}
