const std = @import("std");
pub const aya = @import("aya");
const gfx = aya.gfx;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    while (!aya.pollEvents()) {
        const size = aya.getRenderableSize();
        gfx.beginDefaultPass(.{}, size.w, size.h);
        gfx.endPass();
        aya.swapWindow();
    }
}

extern fn metal_tick() void;