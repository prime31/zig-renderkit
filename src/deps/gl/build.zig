const builtin = @import("builtin");
const std = @import("std");
const Builder = std.build.Builder;

pub fn linkArtifact(b: *Builder, artifact: *std.build.LibExeObjStep, target: std.build.Target) void {
    artifact.linkFramework("OpenGL");
    artifact.addPackagePath("gl", "src/deps/gl/gl.zig");
}
