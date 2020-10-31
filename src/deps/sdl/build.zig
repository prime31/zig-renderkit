const builtin = @import("builtin");
const std = @import("std");
const Builder = std.build.Builder;

pub fn linkArtifact(artifact: *std.build.LibExeObjStep) void {
    artifact.linkSystemLibrary("c");
    artifact.linkSystemLibrary("SDL2");
    artifact.addPackagePath("sdl", "src/deps/sdl/sdl.zig");
}
