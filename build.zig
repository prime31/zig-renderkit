const std = @import("std");
const Builder = @import("std").build.Builder;

/// rel_path is the path to gfx relative to your build.zig. Must end with a slash.
pub fn addGfxToArtifact(artifact: *LibExeObjStep, rel_path: []const u8) void {
    try @import(rel_path ++ "/build.zig").build(step);
}

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const examples = [_][2][]const u8{
        // [_][]const u8{ "offscreen", "examples/offscreen.zig" },
        // [_][]const u8{ "tri_batcher", "examples/tri_batcher.zig" },
        [_][]const u8{ "batcher", "examples/batcher.zig" },
        // [_][]const u8{ "meshes", "examples/meshes.zig" },
        // [_][]const u8{ "clear", "examples/clear.zig" },
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

        addOpenGlToArtifact(exe, target);
        @import("src/deps/sdl/build.zig").linkArtifact(exe, target);
        @import("src/deps/stb/build.zig").linkArtifact(b, exe, target);
        exe.addPackage(.{
            .name = "gfx",
            .path = "src/gfx.zig",
            .dependencies = exe.packages.items,
        });

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
