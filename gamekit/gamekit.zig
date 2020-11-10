const std = @import("std");
const sdl = @import("sdl");
const imgui_gl = @import("imgui_gl");
const imgui = @import("imgui");
const gfx = @import("gfx");

const Window = @import("window.zig").Window;
const WindowConfig = @import("window.zig").WindowConfig;

pub const Config = struct {
    init: fn () anyerror!void,
    update: ?fn () anyerror!void = null,
    render: fn () anyerror!void,
    shutdown: ?fn () void = null,
    onFileDropped: ?fn ([]const u8) void = null,

    // gfx: gfx.Config = gfx.Config{},
    window: WindowConfig = WindowConfig{},
};

pub var window: Window = undefined;

pub fn run(config: Config) !void {
    window = try Window.init(.{});

    var metal_setup = gfx.MetalSetup{};
    if (gfx.current_renderer == .metal) {
        var metal_view = sdl.SDL_Metal_CreateView(window.sdl_window);
        metal_setup.ca_layer = sdl.SDL_Metal_GetLayer(metal_view);
    }

    gfx.renderer.setup(.{
        .allocator = std.testing.allocator,
        .gl_loader = sdl.SDL_GL_GetProcAddress,
        .metal = metal_setup,
    });

    try config.init();

    while (!pollEvents()) {
        if (config.update) |update| try update();
        try config.render();
        swapWindow();
    }
}

fn pollEvents() bool {
    var event: sdl.SDL_Event = undefined;
    while (sdl.SDL_PollEvent(&event) != 0) {
        if (gfx.has_imgui and imguiHandleEvent(&event)) continue;

        switch (event.type) {
            sdl.SDL_QUIT => return true,
            else => {},
        }
    }

    if (gfx.has_imgui) imgui_gl.newFrame(window.sdl_window);

    return false;
}

// returns true if the event is handled by imgui and should be ignored by via
fn imguiHandleEvent(evt: *sdl.SDL_Event) bool {
    if (imgui_gl.ImGui_ImplSDL2_ProcessEvent(evt)) {
        return switch (evt.type) {
            sdl.SDL_MOUSEWHEEL, sdl.SDL_MOUSEBUTTONDOWN => return imgui.igGetIO().WantCaptureMouse,
            sdl.SDL_KEYDOWN, sdl.SDL_KEYUP, sdl.SDL_TEXTINPUT => return imgui.igGetIO().WantCaptureKeyboard,
            sdl.SDL_WINDOWEVENT => return true,
            else => return false,
        };
    }
    return false;
}

pub fn swapWindow() void {
    if (gfx.has_imgui) {
        const size = window.drawableSize();
        gfx.viewport(0, 0, size.w, size.h);

        imgui_gl.render();
        _ = sdl.SDL_GL_MakeCurrent(window.sdl_window, window.gl_ctx);
    }

    if (gfx.current_renderer == .opengl) sdl.SDL_GL_SwapWindow(window.sdl_window);
    gfx.commitFrame();
}