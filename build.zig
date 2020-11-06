const std = @import("std");
const Builder = @import("std").build.Builder;
const Renderer = @import("src/backend/backend.zig").Renderer;

/// rel_path is the path to the gfx build.zig file relative to your build.zig.
/// rel_path is used to add package paths. It should be the the same path used to include this build file
pub fn linkArtifact(b: *Builder, artifact: *std.build.LibExeObjStep, target: std.build.Target, comptime rel_path: []const u8) void {
    artifact.addPackagePath("gfx", rel_path ++ "src/gfx.zig");
}

pub fn build(b: *Builder) void {
    const renderer = b.option(Renderer, "renderer", "dummy, opengl, metal, directx or vulkan") orelse Renderer.opengl;

    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const examples = [_][2][]const u8{
        // [_][]const u8{ "offscreen", "examples/offscreen.zig" },
        // [_][]const u8{ "tri_batcher", "examples/tri_batcher.zig" },
        // [_][]const u8{ "batcher", "examples/batcher.zig" },
        [_][]const u8{ "meshes", "examples/meshes.zig" },
        [_][]const u8{ "clear", "examples/clear.zig" },
    };

    const examples_step = b.step("examples", "build all examples");
    b.default_step.dependOn(examples_step);

    for (examples) |example, i| {
        const name = example[0];
        const source = example[1];

        var exe = b.addExecutable(name, source);
        exe.setBuildMode(b.standardReleaseOptions());
        exe.setOutputDir("zig-cache/bin");
        examples_step.dependOn(&exe.step);

        if (b.standardReleaseOptions() == std.builtin.Mode.ReleaseSmall) exe.strip = true;

        // TODO: why dont we need to link OpenGL?
        // if (renderer == .opengl) addOpenGlToArtifact(exe, target);

        // stb package
        @import("src/deps/stb/build.zig").linkArtifact(b, exe, target);

        // backend package. this can probably just go straight to the actual opengl/backend.zig file
        exe.addPackage(.{
            .name = "backend",
            .path = "src/backend/backend.zig",
            .dependencies = exe.packages.items, // includes just stb
        });

        // gfx gets access to stb and backend
        exe.addPackage(.{
            .name = "gfx",
            .path = "src/gfx.zig",
            .dependencies = exe.packages.items,
        });

        // sdl package
        @import("src/deps/sdl/build.zig").linkArtifact(exe, target);

        // aya gets access to everything
        exe.addPackage(.{
            .name = "aya",
            .path = "examples/core/aya.zig",
            .dependencies = exe.packages.items,
        });

        const run_cmd = exe.run();
        const exe_step = b.step(name, b.fmt("run {}.zig", .{name}));
        exe_step.dependOn(&run_cmd.step);

        // first element in the list is added as "run" so "zig build run" works
        if (i == 0) {
            const run_exe_step = b.step("run", b.fmt("run {}.zig", .{name}));
            run_exe_step.dependOn(&run_cmd.step);
        }
    }
}

fn addOpenGlToArtifact(artifact: *std.build.LibExeObjStep, target: std.build.Target) void {
    std.debug.print("------ linking opengl ----------\n", .{});
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
