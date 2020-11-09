const builtin = @import("builtin");
const std = @import("std");
const Builder = std.build.Builder;

pub fn linkArtifact(b: *Builder, exe: *std.build.LibExeObjStep, target: std.build.Target) void {
    const imgui = std.build.Pkg{
        .name = "imgui",
        .path = "src/deps/imgui/imgui.zig",
    };
    const imgui_gl = std.build.Pkg{
        .name = "imgui_gl",
        .path = "src/deps/imgui/imgui_gl.zig",
        .dependencies = &[_]std.build.Pkg{imgui},
    };
    exe.addPackage(imgui);
    exe.addPackage(imgui_gl);

    exe.linkLibC();
    if (target.isWindows()) {
        exe.linkSystemLibrary("user32");
        exe.linkSystemLibrary("gdi32");
    } else if (target.isDarwin()) {
        const frameworks_dir = macosFrameworksDir(b) catch unreachable;
        exe.addFrameworkDir(frameworks_dir);
        exe.linkFramework("Foundation");
        exe.linkFramework("Cocoa");
        exe.linkFramework("Quartz");
        exe.linkFramework("QuartzCore");
        exe.linkFramework("Metal");
        exe.linkFramework("MetalKit");
        exe.linkFramework("OpenGL");
        exe.linkFramework("Audiotoolbox");
        exe.linkFramework("CoreAudio");
        exe.linkSystemLibrary("c++");
    } else {
        exe.linkSystemLibrary("c++");
        exe.linkSystemLibrary("X11");
    }

    exe.addIncludeDir("src/deps/imgui/cimgui");
    exe.addIncludeDir("src/deps/imgui/cimgui/imgui");
    exe.addIncludeDir("src/deps/imgui/cimgui/imgui/examples");

    const cpp_args = [_][]const u8{ "-Wno-return-type-c-linkage", "-DIMGUI_IMPL_API=extern \"C\"", "-DIMGUI_IMPL_OPENGL_LOADER_GL3W" };
    exe.addCSourceFile("src/deps/imgui/cimgui/imgui/imgui.cpp", &cpp_args);
    exe.addCSourceFile("src/deps/imgui/cimgui/imgui/imgui_demo.cpp", &cpp_args);
    exe.addCSourceFile("src/deps/imgui/cimgui/imgui/imgui_draw.cpp", &cpp_args);
    exe.addCSourceFile("src/deps/imgui/cimgui/imgui/imgui_widgets.cpp", &cpp_args);
    exe.addCSourceFile("src/deps/imgui/cimgui/cimgui.cpp", &cpp_args);
    exe.addCSourceFile("src/deps/imgui/temporary_hacks.cpp", &cpp_args);

    // OpenGL/SDL imgui implementation
    // TODO: why doesnt gl3w/imgui_impl_opengl3 compile correctly?
    const build_impl_type: enum { exe, static_lib, object_files } = .static_lib;
    if (build_impl_type == .static_lib) {
        const lib = b.addStaticLibrary("gl3w", null);
        lib.setBuildMode(b.standardReleaseOptions());
        lib.setTarget(target);

        if (target.isDarwin()) {
            const frameworks_dir = macosFrameworksDir(b) catch unreachable;
            lib.addFrameworkDir(frameworks_dir);
        }
        lib.addIncludeDir("src/deps/imgui/cimgui/imgui");
        lib.addIncludeDir("src/deps/imgui/cimgui/imgui/examples/libs/gl3w");
        lib.addIncludeDir("/usr/local/include/SDL2");

        lib.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/libs/gl3w/GL/gl3w.c", &cpp_args);
        lib.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/imgui_impl_opengl3.cpp", &cpp_args);
        lib.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/imgui_impl_sdl.cpp", &cpp_args);
        lib.install();
        exe.linkLibrary(lib);
    } else if (build_impl_type == .object_files) {
        // use make to build the object files then include them
        _ = b.exec(&[_][]const u8{ "make", "-C", "src/deps/imgui" }) catch unreachable;
        exe.addObjectFile("src/deps/imgui/build/gl3w.o");
        exe.addObjectFile("src/deps/imgui/build/imgui_impl_opengl3.o");
        exe.addObjectFile("src/deps/imgui/build/imgui_impl_sdl.o");
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/imgui_impl_sdl.cpp", &cpp_args);
    } else if (build_impl_type == .exe) {
        exe.addIncludeDir("src/deps/imgui/cimgui/imgui/examples/libs/gl3w");
        exe.addIncludeDir("/usr/local/include/SDL2");

        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/libs/gl3w/GL/gl3w.c", &cpp_args);
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/imgui_impl_opengl3.cpp", &cpp_args);
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/imgui_impl_sdl.cpp", &cpp_args);
    }
}

// helper function to get SDK path on Mac
pub fn macosFrameworksDir(b: *Builder) ![]u8 {
    var str = try b.exec(&[_][]const u8{ "xcrun", "--show-sdk-path" });
    const strip_newline = std.mem.lastIndexOf(u8, str, "\n");
    if (strip_newline) |index| {
        str = str[0..index];
    }
    return try std.mem.concat(b.allocator, u8, &[_][]const u8{ str, "/System/Library/Frameworks" });
}
