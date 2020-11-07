const builtin = @import("builtin");
const std = @import("std");
const Builder = std.build.Builder;

pub fn linkArtifact(b: *Builder, artifact: *std.build.LibExeObjStep, target: std.build.Target) void {
    compileImGui(b, artifact, target);
}

fn compileImGui(b: *Builder, exe: *std.build.LibExeObjStep, target: std.build.Target) void {
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

    // TODO: source doesnt compile in the imgui_impl_opengl3/imgui_impl_sdl files for some reason...
    const use_source = false;
    if (use_source) {
        const cpp_args = [_][]const u8{"-Wno-return-type-c-linkage"};
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/imgui.cpp", &cpp_args);
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/imgui_demo.cpp", &cpp_args);
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/imgui_draw.cpp", &cpp_args);
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/imgui_widgets.cpp", &cpp_args);
        exe.addCSourceFile("src/deps/imgui/cimgui/cimgui.cpp", &cpp_args);
        exe.addCSourceFile("src/deps/imgui/temporary_hacks.cpp", &cpp_args);

        // OpenGL imgui implementation
        const imgui_cpp_args = [_][]const u8{ "-DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=1", "-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1", "-DIMGUI_IMPL_API=", "-Wno-return-type-c-linkage", "-I ../flextgl/thirdparty", "-DIMGUI_IMPL_OPENGL_LOADER_CUSTOM=\"flextGL.h\"" };
        exe.addIncludeDir("src/deps/imgui/flextGL");
        exe.addIncludeDir("/usr/local/include/SDL2");

        exe.addCSourceFile("src/deps/imgui/flextGL/flextGL.c", &imgui_cpp_args);
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/imgui_impl_opengl3.cpp", &imgui_cpp_args);
        exe.addCSourceFile("src/deps/imgui/cimgui/imgui/examples/imgui_impl_sdl.cpp", &imgui_cpp_args);
    } else {
        exe.addIncludeDir("src/deps/imgui/flextGL");
        exe.addCSourceFile("src/deps/imgui/flextGL/flextGL.c", &[_][]const u8{});

        exe.addObjectFile("src/deps/imgui/build/cimgui.a");
        exe.addObjectFile("src/deps/imgui/build/imgui_impl_opengl3.o");
        exe.addObjectFile("src/deps/imgui/build/imgui_impl_sdl.o");
    }
}

// helper function to get SDK path on Mac
fn macosFrameworksDir(b: *Builder) ![]u8 {
    var str = try b.exec(&[_][]const u8{ "xcrun", "--show-sdk-path" });
    const strip_newline = std.mem.lastIndexOf(u8, str, "\n");
    if (strip_newline) |index| {
        str = str[0..index];
    }
    const frameworks_dir = try std.mem.concat(b.allocator, u8, &[_][]const u8{ str, "/System/Library/Frameworks" });
    return frameworks_dir;
}
