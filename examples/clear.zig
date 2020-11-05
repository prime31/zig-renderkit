const std = @import("std");
const aya = @import("aya");
const gfx = aya.gfx;

pub fn main() !void {
    try aya.run(null, render);
}

fn render() !void {
    while (!aya.pollEvents()) {
        gfx.clear(.{});
        aya.swapWindow();
    }
}
