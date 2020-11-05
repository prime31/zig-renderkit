const std = @import("std");
const sdl = @import("sdl");
pub const gfx = @import("gfx");

pub const renderer: gfx.Renderer = if (@hasDecl(@import("root"), "renderer")) @field(@import("root"), "renderer") else .opengl;

pub var window: *sdl.SDL_Window = undefined;

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

    var gl_ctx = sdl.SDL_GL_CreateContext(window);
    defer sdl.SDL_GL_DeleteContext(gl_ctx);

    gfx.init();
    // gfx.initWithLoader(sdl.SDL_GL_GetProcAddress);

    if (init) |init_fn| {
        try init_fn();
    } else {
        try render();
        return;
    }

    while (!pollEvents()) {
        try render();
        sdl.SDL_GL_SwapWindow(window);
    }
}

pub fn pollEvents() bool {
    var event: sdl.SDL_Event = undefined;
    while (sdl.SDL_PollEvent(&event) != 0) {
        switch (event.type) {
            sdl.SDL_QUIT => return true,
            else => {},
        }
    }

    return false;
}

pub fn swapWindow() void {
    sdl.SDL_GL_SwapWindow(window);
}