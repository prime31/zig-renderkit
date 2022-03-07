const std = @import("std");
const Pkg = std.build.Pkg;
const Builder = @import("std").build.Builder;
pub const ShaderCompileStep = @import("shader_compiler/shader_compiler.zig").ShaderCompileStep;

pub fn getRenderKitPackage(comptime prefix_path: []const u8) Pkg {
    return .{
        .name = "renderkit",
        .path = .{ .path = prefix_path ++ "renderkit/renderkit.zig" },
    };
}

/// prefix_path is the path to the gfx build.zig file relative to your build.zig.
/// prefix_path is used to add package paths. It should be the the same path used to include this build file.
pub fn addRenderKitToArtifact(_: *Builder, exe: *std.build.LibExeObjStep, target: std.zig.CrossTarget, comptime prefix_path: []const u8) void {
    if (prefix_path.len > 0 and !std.mem.endsWith(u8, prefix_path, "/")) @panic("prefix-path must end with '/' if it is not empty");
    addOpenGlToArtifact(exe, target);
    exe.addPackage(getRenderKitPackage(prefix_path));
}

fn addOpenGlToArtifact(artifact: *std.build.LibExeObjStep, target: std.zig.CrossTarget) void {
    if (target.isDarwin()) {
        artifact.linkFramework("OpenGL");
    } else if (target.isWindows()) {
        artifact.linkSystemLibrary("kernel32");
        artifact.linkSystemLibrary("user32");
        artifact.linkSystemLibrary("shell32");
        artifact.linkSystemLibrary("gdi32");
    } else if (target.isLinux()) {
        artifact.linkSystemLibrary("GL");
    }
}
