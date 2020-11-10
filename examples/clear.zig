const std = @import("std");
const gamekit = @import("gamekit");
const Color = @import("renderkit").math.Color;

pub fn main() !void {
    try gamekit.run(.{
        .init = init,
        .render = render,
    });
}

fn init() !void {}

fn render() !void {
    gamekit.gfx.beginPass(.{.color = Color.lime });
    gamekit.gfx.endPass();
}
