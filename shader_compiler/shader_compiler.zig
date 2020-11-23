const std = @import("std");
const path = std.fs.path;
const Builder = std.build.Builder;
const Step = std.build.Step;
const BufMap = std.BufMap;

fn warn(comptime format: []const u8, args: anytype) void {
    std.debug.warn(format ++ "\n", args);
}

/// Utility functionality to help with compiling shaders from build.zig. Invokes sokol-shdc for each shader added via `addShader`.
pub const ShaderCompileStep = struct {
    step: Step,
    builder: *Builder,

    /// The command and optional arguments used to invoke the shader compiler.
    /// // sokol-shdc -i shd.glsl -o ./out/ -l glsl330:metal_macos -f bare -d
    shdc_cmd: []const []const u8,
    shader: []const u8,
    package: ?std.build.Pkg = null,
    package_filename: []const u8,
    shader_out_path: []const u8,
    package_out_path: []const u8,
    default_program_name: []const u8,
    additional_imports: ?[]const []const u8 = null,

    /// map of types that can be added to manually or via Sokol's `@ctype vec2 [2]f32` or set here
    float2_type: []const u8 = "[2]f32",
    float3_type: []const u8 = "[3]f32",

    snippet_map: std.StringHashMap([]const u8),
    shader_programs: std.ArrayList(ShaderProgram),

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
        package_deps: ?[]std.build.Pkg = null,
    };

    /// Create a ShaderCompilerStep for `builder`. When this step is invoked by the build
    /// system, `sokol-shdc` is invoked to compile the shader.
    pub fn init(builder: *Builder, comptime prefix_path: []const u8, comptime options: Options) *ShaderCompileStep {
        const shader_out_path = if (options.shader_output_path) |out_path| out_path ++ "/" else path.join(builder.allocator, &[_][]const u8{
            builder.build_root,
            builder.cache_root,
            "shaders",
            "/",
        }) catch unreachable;

        const package_out_path = if (options.package_output_path) |out_path| out_path ++ "/" else path.join(builder.allocator, &[_][]const u8{
            builder.build_root,
            builder.cache_root,
            "shaders",
            "/",
        }) catch unreachable;

        const package_filename = if (options.package_name) |p_name| p_name ++ ".zig" else "shaders.zig";
        var package: ?std.build.Pkg = null;
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

        const self = builder.allocator.create(ShaderCompileStep) catch unreachable;
        self.* = .{
            .step = Step.init(.Custom, "shader-compile", builder.allocator, make),
            .builder = builder,
            .shdc_cmd = &[_][]const u8{ "./" ++ prefix_path ++ "sokol-shdc", "-d", "-l", "glsl330:metal_macos", "-f", "bare", "-i" },
            .shader = options.shader,
            .package = package,
            .package_filename = package_filename,
            .shader_out_path = shader_out_path,
            .package_out_path = package_out_path,
            .default_program_name = options.default_program_name,
            .additional_imports = options.additional_imports,
            .snippet_map = std.StringHashMap([]const u8).init(self.builder.allocator),
            .shader_programs = std.ArrayList(ShaderProgram).init(self.builder.allocator),
        };
        return self;
    }

    /// Internal build function
    fn make(step: *Step) !void {
        const self = @fieldParentPtr(ShaderCompileStep, "step", step);
        const cwd = std.fs.cwd();
        cwd.makePath(self.shader_out_path) catch unreachable;
        cwd.makePath(self.package_out_path) catch unreachable;

        const cmd = try self.builder.allocator.alloc([]const u8, self.shdc_cmd.len + 3);
        for (self.shdc_cmd) |part, i| cmd[i] = part;

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
                    std.debug.warn("The following command exited with error code {}:\n", .{code});
                    return error.UncleanExit;
                }

                // dump sokol output
                // warn("{}", .{res.stderr});

                const shader_map = try self.parseShaderCompilerOutput(res.stderr);
                try self.cleanUnusedVertPrograms();
                try self.generateShaderPackage(shader_map);
                self.builder.allocator.free(res.stderr);
            },
            else => {
                std.debug.warn("The following command terminated unexpectedly:\n", .{});
                return error.UncleanExit;
            },
        }
    }

    const ParseState = enum {
        none,
        maps,
        types,
        reflection,
        uniform,
        inputs,
        image,
        stage_complete,
    };

    const ShaderProgram = struct {
        name: []const u8,
        vs: []const u8 = undefined,
        fs: []const u8 = undefined,
    };

    const ShaderStage = enum {
        vs, fs
    };

    const Shader = struct {
        vs_block: ?UniformBlock = null,
        fs_block: ?UniformBlock = null,
        images: std.ArrayList(Image),
        attributes: std.ArrayList(ShaderAttribute),
        allocator: *std.mem.Allocator,

        pub fn init(allocator: *std.mem.Allocator) Shader {
            return .{
                .images = std.ArrayList(Image).init(allocator),
                .attributes = std.ArrayList(ShaderAttribute).init(allocator),
                .allocator = allocator,
            };
        }

        pub fn addImage(self: *@This(), line: []const u8) !void {
            var colon_index = std.mem.indexOfScalar(u8, line, ':').? + 2;
            var comma_index = std.mem.indexOfScalarPos(u8, line, colon_index, ',').?;
            const name = line[colon_index..comma_index];

            var str = line[comma_index..];
            colon_index = std.mem.indexOfScalar(u8, str, ':').? + 2;
            comma_index = std.mem.indexOfScalarPos(u8, str, colon_index, ',').?;
            const slot = try std.fmt.parseUnsigned(u32, str[colon_index..comma_index], 10);

            for (self.images.items) |img| {
                if (img.slot == slot) return;
                if (std.mem.eql(u8, img.name, name)) return;
            }

            try self.images.append(.{
                .name = try std.mem.dupe(self.allocator, u8, name),
                .slot = slot,
            });
        }

        pub fn addAttribute(self: *@This(), line: []const u8) !void {
            // uv_in: slot=1, sem_name=TEXCOORD, sem_index=1
            const name = line[0..std.mem.indexOfScalar(u8, line, ':').?];

            var iter = std.mem.split(line[std.mem.indexOfScalar(u8, line, ':').? + 2 ..], "=");
            _ = iter.next();
            const slot_str = iter.next().?;
            const slot = try std.fmt.parseUnsigned(u32, slot_str[0..std.mem.indexOf(u8, slot_str, ",").?], 10);

            const sem_str = iter.next().?;
            const sem_name = sem_str[0..std.mem.indexOf(u8, sem_str, ",").?];

            const sem_index = try std.fmt.parseUnsigned(u32, iter.next().?, 10);

            try self.attributes.append(.{
                .name = try std.mem.dupe(self.allocator, u8, name),
                .slot = slot,
                .sem_name = try std.mem.dupe(self.allocator, u8, sem_name),
                .sem_index = sem_index,
            });
        }
    };

    const ShaderAttribute = struct {
        name: []const u8,
        slot: u32,
        sem_name: []const u8,
        sem_index: u32,
    };

    const UniformType = enum {
        float,
        float2,
        float3,
        float4,

        pub fn fromStr(kind: []const u8) UniformType {
            if (std.mem.eql(u8, kind, "FLOAT")) return .float;
            if (std.mem.eql(u8, kind, "FLOAT2")) return .float2;
            if (std.mem.eql(u8, kind, "FLOAT3")) return .float3;
            if (std.mem.eql(u8, kind, "FLOAT4")) return .float4;
            @panic("unidentified uniform type");
        }

        pub fn size(self: @This(), array_count: u32) usize {
            return switch (self) {
                .float => 4 * array_count,
                .float2 => 8 * array_count,
                .float3 => 12 * array_count,
                .float4 => 16 * array_count,
            };
        }

        pub fn zigType(self: @This(), array_count: u32, aligned: bool, shdr_compiler: *ShaderCompileStep) []const u8 {
            // helper closure just to make the below code more readable
            const print = struct {
                fn print(comptime fmt: []const u8, params: anytype) []const u8 {
                    return std.fmt.allocPrint(std.testing.allocator, fmt, params) catch unreachable;
                }
            }.print;

            const align_str = if (aligned) " align(16)" else "";
            return switch (self) {
                .float => {
                    if (array_count == 1) return print("f32{} = 0", .{align_str});
                    return print("[{}]f32{}", .{ array_count, align_str });
                },
                .float2 => {
                    if (array_count == 1) return print("{}{} = .{{}}", .{ shdr_compiler.float2_type, align_str });
                    return print("[{}]{}{}", .{ array_count, shdr_compiler.float2_type, align_str });
                },
                .float3 => {
                    if (array_count == 1) return print("{}{} = .{{}}", .{ shdr_compiler.float3_type, align_str });
                    return print("[{}]{}{}", .{ array_count, shdr_compiler.float3_type, align_str });
                },
                .float4 => {
                    // TODO: should we detect transform matrix and make a special case for it?
                    if (array_count == 1) return print("[4]f32{} = [_]f32{{0}} ** 4", .{align_str});
                    return print("[{}]f32{} = [_]f32{{0}} ** {}", .{ array_count * 4, align_str, array_count * 4 });
                },
            };
        }
    };

    const Uniform = struct {
        name: []const u8,
        type: UniformType,
        array_count: u32,
        offset: u32,
    };

    const Image = struct {
        name: []const u8,
        slot: u32,
    };

    const UniformBlock = struct {
        name: []const u8,
        slot: u32,
        size: u32,
        uniforms: std.ArrayList(Uniform),

        pub fn init(allocator: *std.mem.Allocator, line: []const u8) !UniformBlock {
            var colon_index = std.mem.indexOfScalar(u8, line, ':').? + 2;
            var comma_index = std.mem.indexOfScalarPos(u8, line, colon_index, ',').?;
            var name = line[colon_index..comma_index];

            var str = line[comma_index..];
            colon_index = std.mem.indexOfScalar(u8, str, ':').? + 2;
            comma_index = std.mem.indexOfScalarPos(u8, str, colon_index, ',').?;
            const slot = try std.fmt.parseUnsigned(u32, str[colon_index..comma_index], 10);

            str = str[comma_index..];
            colon_index = std.mem.indexOfScalar(u8, str, ':').? + 2;
            const size = try std.fmt.parseUnsigned(u32, str[colon_index..], 10);

            return UniformBlock{
                .name = try std.mem.dupe(allocator, u8, name),
                .slot = slot,
                .size = size,
                .uniforms = std.ArrayList(Uniform).init(allocator),
            };
        }

        pub fn addUniform(self: *@This(), line: []const u8) !void {
            var colon_index = std.mem.indexOfScalar(u8, line, ':').? + 2;
            var comma_index = std.mem.indexOfScalarPos(u8, line, colon_index, ',').?;
            const name = line[colon_index..comma_index];

            var str = line[comma_index..];
            colon_index = std.mem.indexOfScalar(u8, str, ':').? + 2;
            comma_index = std.mem.indexOfScalarPos(u8, str, colon_index, ',').?;
            const kind = str[colon_index..comma_index];

            str = str[comma_index..];
            colon_index = std.mem.indexOfScalar(u8, str, ':').? + 2;
            comma_index = std.mem.indexOfScalarPos(u8, str, colon_index, ',').?;
            const array_count = try std.fmt.parseUnsigned(u32, str[colon_index..comma_index], 10);

            str = str[comma_index..];
            colon_index = std.mem.indexOfScalar(u8, str, ':').? + 2;
            const offset = try std.fmt.parseUnsigned(u32, str[colon_index..], 10);

            try self.uniforms.append(.{
                .name = try std.mem.dupe(std.testing.allocator, u8, name),
                .type = UniformType.fromStr(kind),
                .array_count = array_count,
                .offset = offset,
            });
        }
    };

    fn parseShaderCompilerOutput(self: *ShaderCompileStep, data: []const u8) !std.StringHashMap(Shader) {
        var in_stream = std.io.fixedBufferStream(data);
        var reader = in_stream.reader();

        var shader_hash = std.StringHashMap(Shader).init(self.builder.allocator);
        var parse_state: ParseState = .none;
        var shader_stage: ShaderStage = undefined;
        var shader: ?*Shader = null;
        var uni_block: ?UniformBlock = null;

        // TODO: when DirectX is added we'll need to add inputs to Shader to get at the `sem_name`. See D3D11_INPUT_ELEMENT_DESC.
        // TODO: WebGL needs to know the vertex attribute names
        var line_buffer: [512]u8 = undefined;
        while (try reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
            if (parse_state == .none) {
                if (std.mem.indexOf(u8, line, "snippet_map:") != null) {
                    parse_state = .maps;
                } else if (std.mem.indexOf(u8, line, "types:") != null) {
                    parse_state = .types;
                } else if (std.mem.indexOf(u8, line, "reflection for snippet") != null) {
                    parse_state = .reflection;
                    const shader_id = try std.mem.dupe(self.builder.allocator, u8, line[std.mem.indexOf(u8, line, "snippet").? + 8 .. std.mem.indexOfScalar(u8, line, ':').?]);
                    try shader_hash.ensureCapacity(shader_hash.count() + 1);
                    const get_or_put = shader_hash.getOrPutAssumeCapacity(shader_id);
                    if (!get_or_put.found_existing) get_or_put.entry.value = Shader.init(self.builder.allocator);
                    shader = &get_or_put.entry.value;
                } else if (std.mem.indexOf(u8, line, "image:") != null) {
                    parse_state = .image;
                }
            } else if (parse_state == .reflection) {
                if (std.mem.indexOf(u8, line, "stage:") != null) {
                    const stage = line[std.mem.indexOfScalar(u8, line, ':').? + 2 ..];
                    shader_stage = if (std.mem.eql(u8, stage, "FS")) .fs else .vs;
                } else if (std.mem.indexOf(u8, line, "uniform block:") != null) {
                    parse_state = .uniform;
                    uni_block = try UniformBlock.init(self.builder.allocator, line);
                } else if (std.mem.indexOf(u8, line, "image:") != null) {
                    parse_state = .image;
                } else if (std.mem.indexOf(u8, line, "inputs:") != null) {
                    parse_state = .inputs;
                }
            } else if (parse_state == .uniform) {
                if (std.mem.indexOf(u8, line, "image:") != null) {
                    parse_state = .image;
                } else if (std.mem.indexOf(u8, line, "member:") == null) {
                    parse_state = .stage_complete;
                } else {
                    try uni_block.?.addUniform(line);
                }
            } else if (parse_state == .inputs) {
                // if we find outputs or image bounce out of the input state
                if (std.mem.indexOf(u8, line, "outputs:") != null) {
                    parse_state = .reflection;
                } else if (std.mem.indexOf(u8, line, "image:") != null) {
                    parse_state = .image;
                } else {
                    try shader.?.addAttribute(std.mem.trim(u8, line, " "));
                }
            }

            if (parse_state == .maps) {
                var inner_state: enum { snippet_map, programs } = .snippet_map;
                var program: ShaderProgram = undefined;

                // inner loop until we get to `spirv_t`
                var inner_line_buffer: [512]u8 = undefined;
                while (try reader.readUntilDelimiterOrEof(&inner_line_buffer, '\n')) |line2| {
                    if (std.mem.indexOf(u8, line2, "spirv_t:") != null) {
                        parse_state = .none;
                        break;
                    } else if (inner_state == .snippet_map) {
                        if (std.mem.indexOf(u8, line2, "programs:") != null) {
                            inner_state = .programs;
                        } else if (std.mem.indexOf(u8, line2, " => ") != null) {
                            var iter = std.mem.split(line2, "=>");
                            const key = try std.mem.dupe(self.builder.allocator, u8, std.mem.trim(u8, iter.next().?, " "));
                            const val = try std.mem.dupe(self.builder.allocator, u8, std.mem.trim(u8, iter.next().?, " "));
                            try self.snippet_map.put(key, val);
                            // warn("-- snip: {} => {}", .{ key, val });
                        }
                    } else if (inner_state == .programs) {
                        // start a new program
                        if (std.mem.indexOf(u8, line2, "program ")) |prog_index| {
                            const name = line2[prog_index + 8 .. std.mem.indexOf(u8, line2, ":").?];
                            program = .{ .name = try std.mem.dupe(self.builder.allocator, u8, name) };
                        } else if (std.mem.indexOf(u8, line2, "line_index") != null) { // end the program
                            try self.shader_programs.append(program);
                        } else if (std.mem.indexOf(u8, line2, "vs:")) |vs_index| {
                            const name = line2[vs_index + 4 ..];
                            program.vs = try std.mem.dupe(self.builder.allocator, u8, name);
                        } else if (std.mem.indexOf(u8, line2, "fs:")) |vs_index| {
                            const name = line2[vs_index + 4 ..];
                            program.fs = try std.mem.dupe(self.builder.allocator, u8, name);
                        }
                    }
                }
            }

            if (parse_state == .types) {
                if (std.mem.indexOf(u8, line, "snippet") != null) {
                    parse_state = .none;
                } else if (!std.mem.endsWith(u8, line, "types:")) { // skip the first one, which doesnt have a type map
                    var colon_index = std.mem.indexOfScalar(u8, line, ':').?;
                    const name = std.mem.trim(u8, line[0..colon_index], " \n\t");
                    var replacement = line[colon_index + 2 ..];

                    if (std.mem.eql(u8, name, "vec2")) {
                        self.float2_type = try std.mem.dupe(self.builder.allocator, u8, replacement);
                    } else if (std.mem.eql(u8, name, "vec3")) {
                        self.float3_type = try std.mem.dupe(self.builder.allocator, u8, replacement);
                    } else {
                        warn("unsupported type map found! {}", .{name});
                    }
                }
            }

            if (parse_state == .image) {
                if (std.mem.indexOf(u8, line, "image:") == null) {
                    parse_state = .stage_complete;
                } else {
                    try shader.?.addImage(line);
                }
            }

            if (parse_state == .stage_complete) {
                parse_state = .none;
                if (shader_stage == .vs and uni_block != null) shader.?.vs_block = uni_block.?;
                if (shader_stage == .fs and uni_block != null) shader.?.fs_block = uni_block.?;
                uni_block = null;
            }
        }

        return shader_hash;
    }

    fn generateShaderPackage(self: *ShaderCompileStep, shader_map: std.StringHashMap(Shader)) !void {
        const out_path = try path.join(self.builder.allocator, &[_][]const u8{ self.package_out_path, self.package_filename });

        var array_list = std.ArrayList(u8).init(self.builder.allocator);
        var writer = array_list.writer();
        try writer.writeAll("const std = @import(\"std\");\n");

        if (self.additional_imports) |imports| {
            for (imports) |import| try writer.print("{}\n", .{import});
        }
        try writer.writeAll("\n");

        var iter = shader_map.iterator();
        while (iter.next()) |entry| {
            const shader = entry.value;
            if (shader.vs_block) |block| try self.generateUniformBlockStruct(shader, .vs, block, writer);
            if (shader.fs_block) |block| try self.generateUniformBlockStruct(shader, .fs, block, writer);
        }

        try std.fs.cwd().writeFile(out_path, array_list.items);
    }

    /// searches for `default_program_name` in the generated shaders. If it is found, it's vert shader is considered the
    /// default vertex shader. Any other program that uses that vert shader will have it's vert shader deleted because it
    /// is just a duplicate.
    fn cleanUnusedVertPrograms(self: *ShaderCompileStep) !void {
        // find the name of the vert progam in the default shader program
        const vs_name = for (self.shader_programs.items) |p| {
            if (std.mem.eql(u8, p.name, self.default_program_name)) break p.vs;
        } else {
            return;
        };

        var walker = try std.fs.walkPath(self.builder.allocator, self.shader_out_path[0 .. self.shader_out_path.len - 1]);
        defer walker.deinit();

        while (try walker.next()) |entry| {
            if (entry.kind != .File) continue;
            if (std.mem.indexOf(u8, entry.basename, "_vs")) |vs_index| {
                // if this shader isnt a unique vert program delete it
                const shader_stage_name = entry.basename[0..std.mem.lastIndexOf(u8, entry.basename, ".").?];
                const shader_name = shader_stage_name[0 .. shader_stage_name.len - 3];

                // check the actual shader to see if it is using "vs_name". Do NOT return our default shader, we need to keep that one ;)
                const uses_default_vs = for (self.shader_programs.items) |p| {
                    if (!std.mem.eql(u8, p.name, self.default_program_name) and
                        std.mem.eql(u8, p.name, shader_name) and
                        std.mem.eql(u8, p.vs, vs_name))
                    {
                        break true;
                    }
                } else false;

                if (uses_default_vs) try std.fs.deleteFileAbsolute(entry.path);
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
    fn generateUniformBlockStruct(self: *ShaderCompileStep, shader: Shader, stage: ShaderStage, block: UniformBlock, writer: std.ArrayList(u8).Writer) !void {
        const next_align16 = nextHighestAlign16(block.size);
        // warn("{}, size: {}, aligned size: {}", .{ block.name, block.size, next_align16 });

        try writer.print("pub const {} = extern struct {{\n", .{block.name});

        // struct metadata
        try writer.writeAll("    pub const metadata = .{\n");

        // images (currently only for frag shader)
        if (stage == .fs) {
            try writer.writeAll("        .images = .{ ");
            for (shader.images.items) |img, i| {
                if (i > 0) try writer.writeAll(", ");
                try writer.print("\"{}\"", .{img.name});
            }
            try writer.writeAll(" },\n");
        }

        // uniforms, always float4 so not much to do here
        try writer.print("        .uniforms = .{{ .{} = .{{ .type = .float4, .array_count = {} }} }},\n", .{ block.name, @divExact(next_align16, 16) });

        // end metadata
        try writer.writeAll("    };\n\n");

        var running_size: usize = 0;
        for (block.uniforms.items) |uni, i| {
            const potential_pad = uni.offset - running_size;

            running_size += uni.type.size(uni.array_count);
            try writer.print("    {}: {},\n", .{ uni.name, uni.type.zigType(uni.array_count, potential_pad != 0, self) });

            // generates the uniform block struct. Care is taken here to align all the struct fields to match the graphics
            // specs and also pad them out correctly. Only floats are suported for struct members because of this.
            if (block.uniforms.items.len - 1 == i and running_size == block.size and @mod(running_size, 16) != 0) {
                const pad_amt = next_align16 - @mod(running_size, next_align16);
                try writer.print("    _pad{}_: [{}]u8 = [_]u8{{0}} ** {},\n", .{ @mod(running_size, next_align16), pad_amt, pad_amt });
            }
        }
        try writer.writeAll("};\n\n");
    }

    /// custom exec because the normal one deadlocks due to the output being huge
    fn exec(args: struct {
        allocator: *std.mem.Allocator,
        argv: []const []const u8,
        cwd: ?[]const u8 = null,
        cwd_dir: ?std.fs.Dir = null,
        env_map: ?*const BufMap = null,
        max_output_bytes: usize = 50 * 1024,
        expand_arg0: std.ChildProcess.Arg0Expand = .no_expand,
    }) !std.ChildProcess.ExecResult {
        const child = try std.ChildProcess.init(args.argv, args.allocator);
        defer child.deinit();

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
