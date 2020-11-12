const std = @import("std");
const sdl = @import("sdl");
const renderkit = @import("renderkit");

pub const utils = @import("utils/utils.zig");
pub const math = @import("math/math.zig");

const Gfx = @import("gfx.zig").Gfx;
const Window = @import("window.zig").Window;
const WindowConfig = @import("window.zig").WindowConfig;
const Input = @import("input.zig").Input;
const Time = @import("time.zig").Time;

pub const Config = struct {
    init: fn () anyerror!void,
    update: ?fn () anyerror!void = null,
    render: fn () anyerror!void,
    shutdown: ?fn () anyerror!void = null,

    window: WindowConfig = WindowConfig{},

    update_rate: f64 = 60, // desired fps
};

pub const gfx = @import("gfx.zig");
pub var window: Window = undefined;
pub var time: Time = undefined;
pub var input: Input = undefined;

pub fn run(config: Config) !void {
    window = try Window.init(config.window);

    var metal_setup = renderkit.MetalSetup{};
    if (renderkit.current_renderer == .metal) {
        var metal_view = sdl.SDL_Metal_CreateView(window.sdl_window);
        metal_setup.ca_layer = sdl.SDL_Metal_GetLayer(metal_view);
    }

    renderkit.renderer.setup(.{
        .allocator = std.testing.allocator,
        .gl_loader = sdl.SDL_GL_GetProcAddress,
        .metal = metal_setup,
    });

    gfx.init();
    time = Time.init(config.update_rate);
    input = Input.init(window.scale());

    try config.init();

    while (!pollEvents()) {
        time.tick();
        if (config.update) |update| try update();
        try config.render();

        if (renderkit.current_renderer == .opengl) sdl.SDL_GL_SwapWindow(window.sdl_window);
        gfx.commitFrame();
        input.newFrame();
    }

    gfx.deinit();
    renderkit.renderer.shutdown();
    window.deinit();
    sdl.SDL_Quit();
}

fn pollEvents() bool {
    var event: sdl.SDL_Event = undefined;
    while (sdl.SDL_PollEvent(&event) != 0) {
        switch (event.type) {
            sdl.SDL_QUIT => return true,
            sdl.SDL_WINDOWEVENT => {
                if (event.window.windowID == window.id) {
                    if (event.window.event == sdl.SDL_WINDOWEVENT_CLOSE) return true;
                    window.handleEvent(&event.window);
                }
            },
            else => input.handleEvent(&event),
        }
    }

    return false;
}
