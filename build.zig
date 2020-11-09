const std = @import("std");
const Builder = @import("std").build.Builder;
const Renderer = @import("src/backend/backend.zig").Renderer;

pub fn build(b: *Builder) !void {
    const prefix_path = "";
    const renderer = b.option(Renderer, "renderer", "dummy, opengl, metal, directx or vulkan") orelse Renderer.opengl;

    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const examples = [_][2][]const u8{
        [_][]const u8{ "offscreen", "examples/offscreen.zig" },
        [_][]const u8{ "tri_batcher", "examples/tri_batcher.zig" },
        [_][]const u8{ "batcher", "examples/batcher.zig" },
        [_][]const u8{ "meshes", "examples/meshes.zig" },
        [_][]const u8{ "clear_imgui", "examples/clear_imgui.zig" },
        [_][]const u8{ "clear", "examples/clear.zig" },
    };

    const examples_step = b.step("examples", "build all examples");
    b.default_step.dependOn(examples_step);

    for (examples) |example, i| {
        const name = example[0];
        const source = example[1];

        var exe = createExe(b, target, name, source, prefix_path);
        examples_step.dependOn(&exe.step);

        // first element in the list is added as "run" so "zig build run" works
        if (i == 0) {
            _ = createExe(b, target, "run", source, prefix_path);
        }
    }
}

fn createExe(b: *Builder, target: std.build.Target, name: []const u8, source: []const u8, comptime prefix_path: []const u8) *std.build.LibExeObjStep {
    var exe = b.addExecutable(name, source);
    exe.setBuildMode(b.standardReleaseOptions());
    exe.setOutputDir("zig-cache/bin");

    if (b.standardReleaseOptions() == std.builtin.Mode.ReleaseSmall) exe.strip = true;

    // TODO: why dont we need to link OpenGL?
    linkArtifact(b, exe, target, prefix_path);

    // renderer specific linkage
    addOpenGlToArtifact(exe, target);

    // sdl package
    @import("src/deps/sdl/build.zig").linkArtifact(exe, target);

    // imgui
    @import("src/deps/imgui/build.zig").linkArtifact(b, exe, target);

    // aya gets access to everything
    exe.addPackage(.{
        .name = "aya",
        .path = "examples/core/aya.zig",
        .dependencies = exe.packages.items,
    });

    const run_cmd = exe.run();
    const exe_step = b.step(name, b.fmt("run {}.zig", .{name}));
    exe_step.dependOn(&run_cmd.step);

    return exe;
}

/// prefix_path is the path to the gfx build.zig file relative to your build.zig.
/// prefix_path is used to add package paths. It should be the the same path used to include this build file and end with a slash.
pub fn linkArtifact(b: *Builder, exe: *std.build.LibExeObjStep, target: std.build.Target, comptime prefix_path: []const u8) void {
    if (target.isDarwin()) addMetalToArtifact(b, exe, target);

    // stb
    @import("src/deps/stb/build.zig").linkArtifact(b, exe, target, prefix_path);
    const stb_pkg = @import("src/deps/stb/build.zig").getPackage(prefix_path);

    // backend package, LLAPI
    const backend_pkg = std.build.Pkg{
        .name = "backend",
        .path = prefix_path ++ "src/backend/backend.zig",
        .dependencies = &[_]std.build.Pkg{stb_pkg},
    };
    exe.addPackage(backend_pkg);

    // gfx package, HLAPI. gets access to stb and backend
    exe.addPackage(.{
        .name = "gfx",
        .path = prefix_path ++ "src/gfx.zig",
        .dependencies = &[_]std.build.Pkg{ stb_pkg, backend_pkg },
    });
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

fn addMetalToArtifact(b: *Builder, exe: *std.build.LibExeObjStep, target: std.build.Target) void {
    const frameworks_dir = @import("src/deps/imgui/build.zig").macosFrameworksDir(b) catch unreachable;
    exe.addFrameworkDir(frameworks_dir);
    exe.linkFramework("Foundation");
    exe.linkFramework("Cocoa");
    exe.linkFramework("Quartz");
    exe.linkFramework("QuartzCore");
    exe.linkFramework("Metal");
    exe.linkFramework("MetalKit");

    const cflags = [_][]const u8{ "-std=c99", "-ObjC", "-fobjc-arc" };
    exe.addIncludeDir("src/backend/metal/native");
    exe.addCSourceFile("src/backend/metal/native/metal.c", &cflags);
}
