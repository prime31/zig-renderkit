const std = @import("std");
const Pkg = std.build.Pkg;
const Builder = @import("std").build.Builder;
const Renderer = @import("renderkit/renderer/renderer.zig").Renderer;
pub const ShaderCompileStep = @import("shader_compiler/shader_compiler.zig").ShaderCompileStep;

/// cached directory so we dont have to query Xcode multiple times
var framework_dir: ?[]u8 = null;
var renderer: ?Renderer = null;

pub fn getRenderKitPackage(comptime prefix_path: []const u8) Pkg {
    return .{
        .name = "renderkit",
        .path = .{ .path = prefix_path ++ "renderkit/renderkit.zig" },
    };
}

/// prefix_path is the path to the gfx build.zig file relative to your build.zig.
/// prefix_path is used to add package paths. It should be the the same path used to include this build file.
pub fn addRenderKitToArtifact(b: *Builder, exe: *std.build.LibExeObjStep, target: std.zig.CrossTarget, comptime prefix_path: []const u8) void {
    if (prefix_path.len > 0 and !std.mem.endsWith(u8, prefix_path, "/")) @panic("prefix-path must end with '/' if it is not empty");

    // build options. For now they can be overridden in root directly as well
    if (renderer == null)
        renderer = b.option(Renderer, "renderer", "dummy, opengl, webgl, metal, directx or vulkan") orelse Renderer.opengl;
    const exe_options = b.addOptions();
    exe.addOptions("renderkit_build_options", exe_options);
    exe_options.addOption(Renderer, "renderer", renderer.?);

    // renderer specific linkage
    if (target.isDarwin()) addMetalToArtifact(b, exe, target, prefix_path);
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

fn addMetalToArtifact(b: *Builder, exe: *std.build.LibExeObjStep, target: std.zig.CrossTarget, comptime prefix_path: []const u8) void {
    _ = target;
    const frameworks_dir = macosFrameworksDir(b) catch unreachable;
    exe.addFrameworkDir(frameworks_dir);
    exe.linkFramework("Foundation");
    exe.linkFramework("Cocoa");
    exe.linkFramework("Quartz");
    exe.linkFramework("QuartzCore");
    exe.linkFramework("Metal");
    exe.linkFramework("MetalKit");

    const cflags = [_][]const u8{ "-std=c99", "-ObjC", "-fobjc-arc" };
    exe.addIncludeDir(prefix_path ++ "renderkit/renderer/metal/native");
    exe.addCSourceFile(prefix_path ++ "renderkit/renderer/metal/native/metal.c", &cflags);
}

/// helper function to get SDK path on Mac
fn macosFrameworksDir(b: *Builder) ![]u8 {
    if (framework_dir) |dir| return dir;

    var str = try b.exec(&[_][]const u8{ "xcrun", "--show-sdk-path" });
    const strip_newline = std.mem.lastIndexOf(u8, str, "\n");
    if (strip_newline) |index| {
        str = str[0..index];
    }
    framework_dir = try std.mem.concat(b.allocator, u8, &[_][]const u8{ str, "/System/Library/Frameworks" });
    return framework_dir.?;
}
