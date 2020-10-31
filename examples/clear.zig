const std = @import("std");
const runner = @import("runner");
const sdl = @import("sdl");
usingnamespace @import("gl");

pub fn main() !void {
    try runner.run(init, render);
}

fn init() !void {}

fn render() !void {
    glClearColor(0.2, 0.3, 0.3, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}
