const std = @import("std");
const sdl = @import("sdl");
const imgui_gl = @import("imgui_gl");
pub const imgui = @import("imgui");
pub const gfx = @import("gfx");

pub const renderer: gfx.Renderer = if (@hasDecl(@import("root"), "renderer")) @field(@import("root"), "renderer") else .opengl;
pub const has_imgui: bool = if (@hasDecl(@import("root"), "imgui")) @import("root").imgui else false;

pub var window: *sdl.SDL_Window = undefined;
var gl_ctx: sdl.SDL_GLContext = undefined;

// if init is null then render is the only method that will be called. Use while (pollEvents()) to make your game loop.
pub fn run(init: ?fn () anyerror!void, render: fn () anyerror!void) !void {
    if (sdl.SDL_Init(sdl.SDL_INIT_VIDEO) != 0) {
        sdl.SDL_Log("Unable to initialize SDL: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer sdl.SDL_Quit();

    _ = sdl.SDL_GL_SetAttribute(.SDL_GL_CONTEXT_FLAGS, @enumToInt(sdl.SDL_GLcontextFlag.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG));
    _ = sdl.SDL_GL_SetAttribute(.SDL_GL_CONTEXT_PROFILE_MASK, @enumToInt(sdl.SDL_GLprofile.SDL_GL_CONTEXT_PROFILE_CORE));
    _ = sdl.SDL_GL_SetAttribute(.SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    _ = sdl.SDL_GL_SetAttribute(.SDL_GL_CONTEXT_MINOR_VERSION, 3);

    _ = sdl.SDL_GL_SetAttribute(.SDL_GL_DOUBLEBUFFER, 1);
    _ = sdl.SDL_GL_SetAttribute(.SDL_GL_DEPTH_SIZE, 24);
    _ = sdl.SDL_GL_SetAttribute(.SDL_GL_STENCIL_SIZE, 8);

    var flags = @enumToInt(sdl.SDL_WindowFlags.SDL_WINDOW_RESIZABLE) | @enumToInt(sdl.SDL_WindowFlags.SDL_WINDOW_OPENGL);
    window = sdl.SDL_CreateWindow("zig gl", sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, 800, 600, @bitCast(u32, flags)) orelse {
        sdl.SDL_Log("Unable to create window: %s", sdl.SDL_GetError());
        return error.SDLWindowInitializationFailed;
    };
    defer sdl.SDL_DestroyWindow(window);

    gl_ctx = sdl.SDL_GL_CreateContext(window);
    defer sdl.SDL_GL_DeleteContext(gl_ctx);

    gfx.setup(.{ .gl_loader = sdl.SDL_GL_GetProcAddress });

    if (has_imgui) {
        _ = imgui.igCreateContext(null);
        var io = imgui.igGetIO();
        io.ConfigFlags |= imgui.ImGuiConfigFlags_NavEnableKeyboard;
        io.ConfigFlags |= imgui.ImGuiConfigFlags_DockingEnable;
        io.ConfigFlags |= imgui.ImGuiConfigFlags_ViewportsEnable;
        imgui_gl.initForGl(null, window, gl_ctx);
    }

    if (init) |init_fn| {
        try init_fn();
    } else {
        try render();
        if (has_imgui) imgui_gl.shutdown();
        return;
    }

    while (!pollEvents()) {
        try render();
        sdl.SDL_GL_SwapWindow(window);
    }
    if (has_imgui) imgui_gl.shutdown();
}

pub fn pollEvents() bool {
    if (has_imgui) {
        imgui_gl.newFrame(window);
        imgui.igShowDemoWindow(null);
    }

    var event: sdl.SDL_Event = undefined;
    while (sdl.SDL_PollEvent(&event) != 0) {
        if (has_imgui and imguiHandleEvent(&event)) continue;

        switch (event.type) {
            sdl.SDL_QUIT => return true,
            else => {},
        }
    }

    return false;
}

// returns true if the event is handled by imgui and should be ignored by via
fn imguiHandleEvent(evt: *sdl.SDL_Event) bool {
    if (imgui_gl.ImGui_ImplSDL2_ProcessEvent(evt)) {
        switch (evt.type) {
            // .mousewheel, .mousebuttondown => { return imgui.igGetIO().WantCaptureMouse; }
            // .textinput, .keydown, .keyup =>  { return imgui.igGetIO().WantCaptureKeyboard; }
            // .windowevent => { return true; }
            else => {
                return false;
            },
        }
    }
    return false;
}

pub fn swapWindow() void {
    if (has_imgui) {
        var w: c_int = 0;
        var h: c_int = 0;
        sdl.SDL_GetWindowSize(window, &w, &h);
        gfx.backend.viewport(0, 0, w, h);

        imgui_gl.render(window, gl_ctx);
        _ = sdl.SDL_GL_MakeCurrent(window, gl_ctx);
    }

    sdl.SDL_GL_SwapWindow(window);
}
