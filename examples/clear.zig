const std = @import("std");
const gamekit = @import("gamekit");
const renderkit = @import("renderkit");

pub fn main() !void {
    try gamekit.run(.{
        .init = init,
        .render = render,
    });
}

fn init() !void {}

fn render() !void {
    const size = gamekit.window.drawableSize();
    renderkit.beginDefaultPass(.{}, size.w, size.h);
    renderkit.endPass();
}
