const std = @import("std");
const aya = @import("aya");
const sdl = @import("sdl");


pub fn main() !void {
    try aya.run(init, render);
}

fn init() !void {}

fn render() !void {
    aya.gfx.clear(.{});
}
