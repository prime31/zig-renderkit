const std = @import("std");
const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const examples = [_][2][]const u8{
        [_][]const u8{ "offscreen", "examples/offscreen.zig" },
        [_][]const u8{ "batcher", "examples/batcher.zig" },
        [_][]const u8{ "1_4", "examples/1_4.zig" },
        [_][]const u8{ "1_3", "examples/1_3.zig" },
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

        @import("src/deps/gl/build.zig").linkArtifact(b, exe, target);
        @import("src/deps/sdl/build.zig").linkArtifact(exe, target);
        @import("src/deps/stb/build.zig").linkArtifact(b, exe, target);

        exe.addPackage(.{
            .name = "runner",
            .path = "src/runner.zig",
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
