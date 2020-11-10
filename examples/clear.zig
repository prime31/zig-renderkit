const std = @import("std");
pub const aya = @import("aya");
const renderkit = aya.renderkit;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    while (!aya.pollEvents()) {
        const size = aya.getRenderableSize();
        renderkit.beginDefaultPass(.{}, size.w, size.h);
        renderkit.endPass();
        aya.swapWindow();
    }
}

extern fn metal_tick() void;