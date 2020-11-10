const std = @import("std");
const sdl = @import("sdl");
const imgui_gl = @import("imgui_gl");
const window_impl = @import("window.zig");
pub const imgui = @import("imgui");
pub const gfx = @import("gfx");


// if init is null then render is the only method that will be called. Use while (pollEvents()) to make your game loop.
pub fn run(init: ?fn () anyerror!void, render: fn () anyerror!void) !void {
    if (sdl.SDL_Init(sdl.SDL_INIT_VIDEO) != 0) {
        sdl.SDL_Log("Unable to initialize SDL: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer sdl.SDL_Quit();

    window_impl.createWindow(gfx.current_renderer);

    var metal_setup = gfx.MetalSetup{};
    if (gfx.current_renderer == .metal) {
        var metal_view = sdl.SDL_Metal_CreateView(window_impl.window);
        metal_setup.ca_layer = sdl.SDL_Metal_GetLayer(metal_view);
    }

    gfx.renderer.setup(.{
        .allocator = std.testing.allocator,
        .gl_loader = sdl.SDL_GL_GetProcAddress,
        .metal = metal_setup,
    });

    if (gfx.has_imgui) {
        _ = imgui.igCreateContext(null);
        var io = imgui.igGetIO();
        io.ConfigFlags |= imgui.ImGuiConfigFlags_NavEnableKeyboard;
        io.ConfigFlags |= imgui.ImGuiConfigFlags_DockingEnable;
        io.ConfigFlags |= imgui.ImGuiConfigFlags_ViewportsEnable;
        imgui_gl.initForGl(null, window_impl.window, window_impl.gl_ctx);

        var style = imgui.igGetStyle();
        style.WindowRounding = 0;
    }

    if (init) |init_fn| {
        try init_fn();
    } else {
        try render();
        if (gfx.has_imgui) imgui_gl.shutdown();
        gfx.renderer.shutdown();
        sdl.SDL_DestroyWindow(window_impl.window);
        sdl.SDL_Quit();
        return;
    }

    while (!pollEvents()) {
        try render();
        sdl.SDL_GL_SwapWindow(window_impl.window);
    }
    if (gfx.has_imgui) imgui_gl.shutdown();
    gfx.renderer.shutdown();
    sdl.SDL_DestroyWindow(window_impl.window);
    sdl.SDL_Quit();
}

pub fn pollEvents() bool {
    var event: sdl.SDL_Event = undefined;
    while (sdl.SDL_PollEvent(&event) != 0) {
        if (gfx.has_imgui and imguiHandleEvent(&event)) continue;

        switch (event.type) {
            sdl.SDL_QUIT => return true,
            else => {},
        }
    }

    if (gfx.has_imgui) imgui_gl.newFrame(window_impl.window);

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
        const size = window_impl.getRenderableSize();
        gfx.viewport(0, 0, size.w, size.h);

        imgui_gl.render();
        _ = sdl.SDL_GL_MakeCurrent(window_impl.window, window_impl.gl_ctx);
    }

    if (gfx.current_renderer == .opengl) sdl.SDL_GL_SwapWindow(window_impl.window);
    gfx.commitFrame();
}

pub const getRenderableSize = window_impl.getRenderableSize;
