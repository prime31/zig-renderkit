const builtin = @import("builtin");
const std = @import("std");
const Builder = std.build.Builder;

pub fn linkArtifact(artifact: *std.build.LibExeObjStep, target: std.build.Target) void {
    artifact.linkSystemLibrary("c");
    artifact.linkSystemLibrary("SDL2");

    if (target.isWindows()) {
        // Windows include dirs for SDL2. This requires downloading SDL2 dev and extracting to c:\SDL2 then renaming
        // the "include" folder to "SDL2". SDL2.dll and SDL2.lib need to be copied to the zig-cache/bin folder
        artifact.addLibPath("c:\\SDL2\\lib\\x64");
    }

    artifact.addPackage(getPackage(""));
}

pub fn getPackage(comptime prefix_path: []const u8) std.build.Pkg {
    return .{
        .name = "sdl",
        .path = prefix_path ++ "gamekit/deps/sdl/sdl.zig",
    };
}