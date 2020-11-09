const std = @import("std");
const sdl = @import("sdl");
pub const gfx = @import("gfx");

pub var window: *sdl.SDL_Window = undefined;
pub var gl_ctx: sdl.SDL_GLContext = undefined;
var renderer: gfx.Renderer = undefined;

pub fn createWindow(current_renderer: gfx.Renderer) void {
    renderer = current_renderer;
    _ = sdl.SDL_InitSubSystem(sdl.SDL_INIT_VIDEO);

    switch (renderer) {
        .opengl => createOpenGlWindow(),
        .metal => createMetalWindow(),
        else => unreachable,
    }
}

fn createOpenGlWindow() void {
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
        @panic("no window");
    };

    gl_ctx = sdl.SDL_GL_CreateContext(window);
}

fn createMetalWindow() void {
    _ = sdl.SDL_SetHint(sdl.SDL_HINT_RENDER_DRIVER, "metal");
    _ = sdl.SDL_InitSubSystem(sdl.SDL_INIT_VIDEO);

    var flags = @enumToInt(sdl.SDL_WindowFlags.SDL_WINDOW_RESIZABLE) | @enumToInt(sdl.SDL_WindowFlags.SDL_WINDOW_METAL);
    window = sdl.SDL_CreateWindow("zig metal", sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, 800, 600, @bitCast(u32, flags)) orelse {
        sdl.SDL_Log("Unable to create window: %s", sdl.SDL_GetError());
        @panic("no window");
    };
}

pub fn getRenderableSize() struct { w: c_int, h: c_int } {
    var w: c_int = 0;
    var h: c_int = 0;
    switch (renderer) {
        .opengl => sdl.SDL_GL_GetDrawableSize(window, &w, &h),
        .metal => sdl.SDL_Metal_GetDrawableSize(window, &w, &h),
        else => unreachable,
    }

    return .{ .w = w, .h = h };
}

