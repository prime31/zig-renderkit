const std = @import("std");
const path = std.fs.path;
const Step = std.build.Step;
const BufMap = std.BufMap;

const ShdcParser = @import("shdc_parser.zig").ShdcParser;
const ShaderProgram = @import("shdc_parser.zig").ShaderProgram;
const ReflectionData = @import("shdc_parser.zig").ReflectionData;
const UniformBlock = @import("shdc_parser.zig").UniformBlock;

fn warn(comptime format: []const u8, args: anytype) void {
    std.log.warn(format ++ "\n", args);
}

/// Utility functionality to help with compiling shaders from build.zig. Invokes sokol-shdc for each shader added via `addShader`.
pub const ShaderCompileStep = struct {
    step: Step,
    builder: *std.Build,

    /// The command and optional arguments used to invoke the shader compiler.
    /// sokol-shdc -i shd.glsl -o ./out/ -l glsl330:metal_macos -f bare -d
    shdc_cmd: []const []const u8,
    shader: []const u8,
    package: ?std.build.Module = null,
    package_filename: []const u8,
    shader_out_path: []const u8,
    package_out_path: []const u8,
    default_program_name: []const u8,
    additional_imports: ?[]const []const u8 = null,

    /// map of types that can be added to manually here or via Sokol's `@ctype vec2 [2]f32`
    float2_type: []const u8 = "[2]f32",
    float3_type: []const u8 = "[3]f32",
    mat4_type: []const u8 = "[16]f32",

    pub const Options = struct {
        /// the source glsl shader file
        shader: []const u8,

        /// additional imports to add to the generated shader uniform file. Must contain at least an import
        /// for standard math types, for GameKit: `usingnamespace @import("gamekit").math;`
        additional_imports: ?[]const []const u8 = null,

        /// output path relative to build_root for compiled shaders. If null, it will be `zig-cache/shaders`
        shader_output_path: ?[]const u8 = null,

        /// output path relative to build_root for the generated zig file. If null, it will be `zig-cache/shaders`
        package_output_path: ?[]const u8 = null,

        /// if set and multiple shaders are generated with the exact same vert shader (common for 2D) all the duplicated
        /// vert shaders will be removed. The default value will keep the vert shader for the "sprite" program and delete
        /// all the vert programs from any other shader that uses the "sprite" program's vert shader.
        default_program_name: []const u8 = "sprite",

        /// name of the package that will include the generated shader uniform file. If null, `package` will be null.
        /// Defaults to "shaders". Will also be used as the filename of the generated file, which will always be generated
        /// whether `package_name` is null or not.
        package_name: ?[]const u8 = null,

        /// dependencies to add to the package. For GameKit the `gamekit` package would be needed for the math imports.
        package_deps: ?[]std.build.Module = null,
    };

    /// Create a ShaderCompilerStep for `builder`. When this step is invoked by the build
    /// system, `sokol-shdc` is invoked to compile the shader.
    pub fn init(builder: *std.Build, comptime prefix_path: []const u8, comptime options: Options) *ShaderCompileStep {
        if (prefix_path.len > 0 and !std.mem.endsWith(u8, prefix_path, "/")) @panic("prefix-path must end with '/' if it is not empty");
        const shader_out_path = if (options.shader_output_path) |out_path| out_path ++ path.sep_str else path.join(builder.allocator, &[_][]const u8{
            builder.build_root,
            builder.cache_root,
            "shaders",
            path.sep_str,
        }) catch unreachable;

        const package_out_path = if (options.package_output_path) |out_path| out_path ++ path.sep_str else path.join(builder.allocator, &[_][]const u8{
            builder.build_root,
            builder.cache_root,
            "shaders",
            path.sep_str,
        }) catch unreachable;

        const package_filename = if (options.package_name) |p_name| p_name ++ ".zig" else "shaders.zig";
        var package: ?std.build.Module = null;
        if (options.package_name) |package_name| {
            const pkg_path = path.join(builder.allocator, &[_][]const u8{
                package_out_path,
                package_filename,
            }) catch unreachable;

            package = .{
                .name = package_name,
                .path = pkg_path,
                .dependencies = options.package_deps,
            };
        }
        const shdc_binary = switch (@import("builtin").os.tag) {
            .macos => "sokol-shdc",
            .linux => "sokol-shdc-linux",
            .windows => "sokol-shdc.exe",
            else => @panic("unsupported platform"),
        };

        const self = builder.allocator.create(ShaderCompileStep) catch unreachable;
        self.* = .{
            .step = Step.init(.{
                .id = Step.Id.custom,
                .name = "shader-compile",
                .owner = builder,
                .makeFn = make,
            }),
            .builder = builder,
            .shdc_cmd = &[_][]const u8{ "." ++ path.sep_str ++ prefix_path ++ "bin" ++ path.sep_str ++ shdc_binary, "-d", "-l", "glsl330", "-f", "bare", "-i" },
            .shader = options.shader,
            .package = package,
            .package_filename = package_filename,
            .shader_out_path = shader_out_path,
            .package_out_path = package_out_path,
            .default_program_name = options.default_program_name,
            .additional_imports = options.additional_imports,
        };
        return self;
    }

    /// Internal build function
    fn make(step: *Step, _: *std.Progress.Node) !void {
        const self = @fieldParentPtr(ShaderCompileStep, "step", step);
        const cwd = std.fs.cwd();
        cwd.makePath(self.shader_out_path) catch unreachable;
        cwd.makePath(self.package_out_path) catch unreachable;

        const cmd = try self.builder.allocator.alloc([]const u8, self.shdc_cmd.len + 3);
        for (self.shdc_cmd, 0..) |part, i| cmd[i] = part;

        cmd[cmd.len - 2] = "-o";
        cmd[cmd.len - 3] = self.shader;
        cmd[cmd.len - 1] = self.shader_out_path;

        const res = try exec(.{
            .allocator = self.builder.allocator,
            .argv = cmd,
            .env_map = self.builder.env_map,
            .max_output_bytes = 1024 * 1024 * 1024,
        });

        switch (res.term) {
            .Exited => |code| {
                if (code != 0) {
                    std.log.warn("The following command exited with error code {}:\n", .{code});
                    return error.UncleanExit;
                }

                // dump sokol output
                // warn("{}", .{res.stderr});

                var parsed = ShdcParser.init(self.builder.allocator, self.float2_type, self.float3_type, self.mat4_type);
                try parsed.parse(res.stderr);

                try self.cleanUnusedVertPrograms(parsed.shader_programs.items);
                try self.generateShaderPackage(&parsed);
                self.builder.allocator.free(res.stderr);
            },
            else => {
                std.log.warn("The following command terminated unexpectedly:\n", .{});
                return error.UncleanExit;
            },
        }
    }

    fn generateShaderPackage(self: *ShaderCompileStep, parsed: *ShdcParser) !void {
        const out_path = try path.join(self.builder.allocator, &[_][]const u8{ self.package_out_path, self.package_filename });

        var array_list = std.ArrayList(u8).init(self.builder.allocator);
        var writer = array_list.writer();
        try writer.writeAll("const std = @import(\"std\");\n");

        // second writer used to write the creation functions so they can be after the declarations
        var fn_array_list = std.ArrayList(u8).init(self.builder.allocator);
        var fn_writer = fn_array_list.writer();

        if (self.additional_imports) |imports| {
            for (imports) |import| try writer.print("{s}\n", .{import});
        }
        try writer.writeAll("\n");

        // if we have some shaders that use the default vert shader, setup a ShaderState and Shader creation method for them
        var relative_path_from_package_to_shaders = try std.fs.path.relative(self.builder.allocator, self.package_out_path, self.shader_out_path);

        // ensure if we have a non-empty path that it ends in a '/'
        const rel_path_len = relative_path_from_package_to_shaders.len;
        if (rel_path_len > 0 and relative_path_from_package_to_shaders[rel_path_len - 1] != path.sep) {
            const with_sep = try self.builder.allocator.alloc(u8, rel_path_len + 1);
            std.mem.copy(u8, with_sep, relative_path_from_package_to_shaders);
            with_sep[rel_path_len] = '/';
            relative_path_from_package_to_shaders = with_sep;
        }

        for (parsed.shader_programs.items) |program| {
            if (std.mem.eql(u8, self.default_program_name, program.name)) continue;
            var name = try self.builder.allocator.dupe(u8, program.name);
            name[0] = std.ascii.toUpper(name[0]);

            // cleanup underscores in names by removing them and capitilizing the next letter
            if (std.mem.indexOfScalar(u8, name, '_')) |underscore_index| {
                const to_replace = name[underscore_index .. underscore_index + 2];
                var replace_with = try self.builder.allocator.dupe(u8, to_replace);
                replace_with[replace_with.len - 1] = std.ascii.toUpper(replace_with[replace_with.len - 1]);
                replace_with = replace_with[1..];

                var buffer = try self.builder.allocator.alloc(u8, std.mem.replacementSize(u8, name, to_replace, replace_with));
                _ = std.mem.replace(u8, name, to_replace, replace_with, buffer);
                name = buffer;
            }

            const fs_reflection: ReflectionData = parsed.snippet_reflection_map.get(program.fs_snippet).?;

            // TODO: support generating ShaderState for custom vert + custom frag shader setups
            // only make a ShaderState for shaders with a frag uniform and the default vert shader
            if (program.has_default_vert_shader and fs_reflection.uniform_block != null) {
                const uni_block = fs_reflection.uniform_block.?;
                try writer.print("pub const {s}Shader = gfx.ShaderState({s});\n", .{ name, uni_block.name });

                // write out creation helper functions
                try fn_writer.print("pub fn create{s}Shader() {s}Shader {{\n", .{ name, name });
                try fn_writer.print("    const frag = @embedFile(\"{0s}{1s}.glsl\");\n", .{
                    relative_path_from_package_to_shaders,
                    program.fs,
                });
                try fn_writer.print("    return {0s}Shader.init(.{{ .frag = frag, .onPostBind = {0s}Shader.onPostBind }});\n", .{name});
                try fn_writer.writeAll("}\n\n");
            } else {
                // we have a non-default vert shader is all we know here, frag could have a uniform or not
                const vs_reflection: ReflectionData = parsed.snippet_reflection_map.get(program.vs_snippet).?;

                const vs_uni_type = vs_reflection.uniform_block.?.name;
                const fs_uni_type = if (fs_reflection.uniform_block) |uni_block| uni_block.name else blk: {
                    // check for edge case: no frag uniform but more than one image. We need the `images` metadata so we use an anonymous struct
                    if (fs_reflection.images.items.len > 0) {
                        var img_array_list = std.ArrayList(u8).init(self.builder.allocator);
                        var img_writer = img_array_list.writer();

                        try img_writer.writeAll("struct { pub const metadata = .{ .images = .{ ");
                        for (fs_reflection.images.items, 0..) |img, i| {
                            try img_writer.print("\"{s}\"", .{img.name});
                            if (fs_reflection.images.items.len - 1 > i) try img_writer.writeAll(", ");
                        }
                        try img_writer.writeAll(" } }; }");
                        break :blk img_array_list.items;
                    }
                    break :blk "struct {}";
                };

                try fn_writer.print("pub fn create{s}Shader() !gfx.Shader {{\n", .{name});
                try fn_writer.print("    const vert = @embedFile(\"{0s}{1s}.glsl\");\n", .{ relative_path_from_package_to_shaders, program.vs });
                try fn_writer.print("    const frag = @embedFile(\"{0s}{1s}.glsl\");\n", .{ relative_path_from_package_to_shaders, program.fs });
                try fn_writer.print("    return try gfx.Shader.initWithVertFrag({s}, {s}, .{{ .frag = frag, .vert = vert }});\n", .{ vs_uni_type, fs_uni_type });
                try fn_writer.writeAll("}\n\n");
            }
        }

        try writer.writeAll("\n");
        try writer.writeAll(fn_array_list.items);
        try writer.writeAll("\n");

        var iter = parsed.snippet_reflection_map.iterator();
        while (iter.next()) |entry| {
            const reflection: ReflectionData = entry.value_ptr.*;
            if (reflection.uniform_block) |uniform| {
                try self.generateUniformBlockStruct(reflection, uniform, parsed, writer);
            }
        }

        try std.fs.cwd().writeFile(out_path, array_list.items);
    }

    /// searches for `default_program_name` in the generated shaders. If it is found, it's vert shader is considered the
    /// default vertex shader. Any other program that uses that vert shader will have it's vert shader deleted because it
    /// is just a duplicate.
    fn cleanUnusedVertPrograms(self: *ShaderCompileStep, shader_programs: []ShaderProgram) !void {
        // find the name of the vert progam in the default shader program
        const vs_name = for (shader_programs) |p| {
            if (std.mem.eql(u8, p.name, self.default_program_name)) break p.vs;
        } else {
            return;
        };

        var dir_obj = try std.fs.cwd().openIterableDir(self.shader_out_path[0 .. self.shader_out_path.len - 1], .{ .access_sub_paths = true });
        defer dir_obj.close();
        var walker = try dir_obj.walk(self.builder.allocator);
        defer walker.deinit();

        while (try walker.next()) |entry| {
            if (entry.kind != .file) continue;
            if (std.mem.indexOf(u8, entry.basename, "_vs")) |vs_index| {
                _ = vs_index;
                // if this shader isnt a unique vert program delete it
                const shader_stage_name = entry.basename[0..std.mem.lastIndexOf(u8, entry.basename, ".").?];
                const shader_name = shader_stage_name[0 .. shader_stage_name.len - 3];

                // check the actual shader to see if it is using "vs_name". Do NOT return our default shader, we need to keep that one ;)
                const uses_default_vs = for (shader_programs) |*p| {
                    if (!std.mem.eql(u8, p.name, self.default_program_name) and
                        std.mem.eql(u8, p.name, shader_name) and
                        std.mem.eql(u8, p.vs, vs_name))
                    {
                        p.has_default_vert_shader = true;
                        break true;
                    }
                } else false;

                if (uses_default_vs) {
                    // we may have a relative path if the Options were given a relative output path for the shader or package
                    if (std.fs.path.isAbsolute(entry.path)) try std.fs.deleteFileAbsolute(entry.path) else try dir_obj.dir.deleteFile(entry.path);
                }
            }
        }
    }

    fn nextHighestAlign16(val: u32) u32 {
        var ret: u32 = 16;
        while (ret < val) : (ret += 16) {}
        return ret;
    }

    /// generates the uniform block struct. Care is taken here to align all the struct fields to match the graphics
    /// specs and also pad them out correctly. Only floats are suported for struct members because of this.
    fn generateUniformBlockStruct(self: *ShaderCompileStep, reflection: ReflectionData, block: UniformBlock, parsed: *ShdcParser, writer: std.ArrayList(u8).Writer) !void {
        const next_align16 = nextHighestAlign16(block.size);
        // warn("{}, size: {}, aligned size: {}", .{ block.name, block.size, next_align16 });

        try writer.print("pub const {s} = extern struct {{\n", .{block.name});

        // struct metadata
        try writer.writeAll("    pub const metadata = .{\n");

        // images (currently only for frag shader)
        if (reflection.stage == .fs) {
            try writer.writeAll("        .images = .{ ");
            for (reflection.images.items, 0..) |img, i| {
                if (i > 0) try writer.writeAll(", ");
                try writer.print("\"{s}\"", .{img.name});
            }
            try writer.writeAll(" },\n");
        }

        // uniforms, always float4 so not much to do here
        try writer.print("        .uniforms = .{{ .{s} = .{{ .type = .float4, .array_count = {} }} }},\n", .{ block.name, @divExact(next_align16, 16) });

        // end metadata
        try writer.writeAll("    };\n\n");

        var pad_cnt: u8 = 0;
        var running_size: usize = 0;
        for (block.uniforms.items, 0..) |uni, i| {
            const potential_pad = uni.offset - running_size;

            running_size += uni.type.size(uni.array_count);
            if (potential_pad > 0) {
                try writer.print("    _pad{}_{}_: [{}]u8 = [_]u8{{0}} ** {},\n", .{ @mod(potential_pad, next_align16), pad_cnt, potential_pad, potential_pad });
                pad_cnt += 1;
            }
            try writer.print("    {s}: {s},\n", .{ uni.name, uni.type.zigType(self.builder.allocator, uni.array_count, parsed) });

            // generates the uniform block struct. Care is taken here to align all the struct fields to match the graphics
            // specs and also pad them out correctly. Only floats are suported for struct members because of this.
            if (block.uniforms.items.len - 1 == i and running_size == block.size and @mod(running_size, 16) != 0) {
                const pad_amt = next_align16 - @mod(running_size, next_align16);
                try writer.print("    _pad{}_{}_: [{}]u8 = [_]u8{{0}} ** {},\n", .{ @mod(running_size, next_align16), pad_cnt, pad_amt, pad_amt });
            }
        }
        try writer.writeAll("};\n\n");
    }

    /// custom exec because the normal one deadlocks due to the output being huge
    fn exec(
        args: struct {
            allocator: std.mem.Allocator,
            argv: []const []const u8,
            cwd: ?[]const u8 = null,
            cwd_dir: ?std.fs.Dir = null,
            env_map: ?*const std.process.EnvMap = null,
            max_output_bytes: usize = 50 * 1024,
            expand_arg0: std.ChildProcess.Arg0Expand = .no_expand,
        },
    ) !std.ChildProcess.ExecResult {
        var child = std.ChildProcess.init(args.argv, args.allocator);

        child.stdin_behavior = .Ignore;
        // child.stdout_behavior = .Pipe;
        child.stderr_behavior = .Pipe;
        child.cwd = args.cwd;
        child.cwd_dir = args.cwd_dir;
        child.env_map = args.env_map;
        child.expand_arg0 = args.expand_arg0;

        try child.spawn();

        const stderr_in = child.stderr.?.reader();

        const stderr = try stderr_in.readAllAlloc(args.allocator, args.max_output_bytes);
        errdefer args.allocator.free(stderr);

        return std.ChildProcess.ExecResult{
            .term = try child.wait(),
            .stdout = undefined,
            .stderr = stderr,
        };
    }
};
