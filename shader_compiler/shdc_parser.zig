const std = @import("std");

const ParseState = enum {
    none,
    maps,
    types,
    reflection,
    uniform,
    inputs,
    outputs,
    image,
    stage_complete,
};

pub const ShaderProgram = struct {
    name: []const u8,
    vs: []const u8 = undefined,
    fs: []const u8 = undefined,
    vs_snippet: u8 = undefined,
    fs_snippet: u8 = undefined,
    /// flag that indicates if this program uses the default vert shader
    has_default_vert_shader: bool = false,
};

const ShaderStage = enum { vs, fs };

pub const ReflectionData = struct {
    stage: ShaderStage = undefined,
    uniform_block: ?UniformBlock = null,
    images: std.ArrayList(Image),
    inputs: std.ArrayList(ShaderAttribute),
    outputs: std.ArrayList(ShaderAttribute),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) ReflectionData {
        return .{
            .images = std.ArrayList(Image).init(allocator),
            .inputs = std.ArrayList(ShaderAttribute).init(allocator),
            .outputs = std.ArrayList(ShaderAttribute).init(allocator),
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
            .name = try self.allocator.dupe(u8, name),
            .slot = slot,
        });
    }

    pub fn addAttribute(self: *@This(), is_input: bool, line: []const u8) !void {
        // uv_in: slot=1, sem_name=TEXCOORD, sem_index=1
        const name = line[0..std.mem.indexOfScalar(u8, line, ':').?];

        var iter = std.mem.split(u8, line[std.mem.indexOfScalar(u8, line, ':').? + 2 ..], "=");
        _ = iter.next();
        const slot_str = iter.next().?;
        const slot = try std.fmt.parseUnsigned(u32, slot_str[0..std.mem.indexOf(u8, slot_str, ",").?], 10);

        const sem_str = iter.next().?;
        const sem_name = sem_str[0..std.mem.indexOf(u8, sem_str, ",").?];

        const sem_index = try std.fmt.parseUnsigned(u32, iter.next().?, 10);

        var storage = if (is_input) &self.inputs else &self.outputs;
        try storage.append(.{
            .name = try self.allocator.dupe(u8, name),
            .slot = slot,
            .sem_name = try self.allocator.dupe(u8, sem_name),
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
    mat4,

    pub fn fromStr(kind: []const u8) UniformType {
        if (std.mem.eql(u8, kind, "FLOAT")) return .float;
        if (std.mem.eql(u8, kind, "FLOAT2")) return .float2;
        if (std.mem.eql(u8, kind, "FLOAT3")) return .float3;
        if (std.mem.eql(u8, kind, "FLOAT4")) return .float4;
        if (std.mem.eql(u8, kind, "MAT4")) return .mat4;
        std.debug.print("Invalid type: {s}\n", .{kind});
        @panic("unidentified uniform type");
    }

    pub fn size(self: @This(), array_count: u32) usize {
        return switch (self) {
            .float => 4 * array_count,
            .float2 => 8 * array_count,
            .float3 => 12 * array_count,
            .float4 => 16 * array_count,
            .mat4 => 16 * 4 * array_count,
        };
    }

    pub fn zigType(self: @This(), a: std.mem.Allocator, array_count: u32, shdr_compiler: *ShdcParser) []const u8 {
        // helper closure just to make the below code more readable
        const print = struct {
            fn print(alloc: std.mem.Allocator, comptime fmt: []const u8, params: anytype) []const u8 {
                return std.fmt.allocPrint(alloc, fmt, params) catch unreachable;
            }
        }.print;

        return switch (self) {
            .float => {
                if (array_count == 1) return print(a, "f32 = 0", .{});
                return print(a, "[{0}]f32 = [_]f32{{0}} ** {0}", .{array_count});
            },
            .float2 => {
                if (array_count == 1) return print(a, "{s} = .{{}}", .{shdr_compiler.float2_type});
                return print(a, "[{d}]{s}", .{ array_count, shdr_compiler.float2_type });
            },
            .float3 => {
                if (array_count == 1) return print(a, "{s} = .{{}}", .{shdr_compiler.float3_type});
                return print(a, "[{d}]{s}", .{ array_count, shdr_compiler.float3_type });
            },
            .float4 => {
                if (array_count == 1) return print(a, "[4]f32 = [_]f32{{0}} ** 4", .{});
                return print(a, "[{d}]f32 = [_]f32{{0}} ** {d}", .{ array_count * 4, array_count * 4 });
            },
            .mat4 => {
                if (array_count == 1) return print(a, "{s} = .{{}}", .{shdr_compiler.mat4_type});
                return print(a, "[{d}]f32 = [_]f32{{0}} ** {d}", .{ array_count * 4, array_count * 4 });
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

pub const UniformBlock = struct {
    name: []const u8,
    slot: u32,
    size: u32,
    uniforms: std.ArrayList(Uniform),

    pub fn init(allocator: std.mem.Allocator, line: []const u8) !UniformBlock {
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
            .name = try allocator.dupe(u8, name),
            .slot = slot,
            .size = size,
            .uniforms = std.ArrayList(Uniform).init(allocator),
        };
    }

    pub fn addUniform(self: *@This(), alloc: std.mem.Allocator, line: []const u8) !void {
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
            .name = try alloc.dupe(u8, name),
            .type = UniformType.fromStr(kind),
            .array_count = array_count,
            .offset = offset,
        });
    }
};

/// takes the `-d` dump output from sokol_shdc and parses it into maps of data with the shader details. The data can
/// be used to generate any required code for loading the shaders including uniform data and vertex buffer bindings.
pub const ShdcParser = struct {
    /// type maps first provided in init. These can be overriden if @ctype declarations are in the shader
    float2_type: []const u8,
    float3_type: []const u8,
    mat4_type: []const u8,

    /// map of the vert/fragment shader name to the snippet id
    snippet_map: std.StringHashMap(u8),
    /// all of the full program data from the `programs` section. Includes the program/shader names and snippet ids
    shader_programs: std.ArrayList(ShaderProgram),
    /// map of the snippet id to the reflection data block
    snippet_reflection_map: std.AutoHashMap(u8, ReflectionData),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, float2_type: []const u8, float3_type: []const u8, mat4_type: []const u8) ShdcParser {
        return .{
            .float2_type = float2_type,
            .float3_type = float3_type,
            .mat4_type = mat4_type,
            .snippet_map = std.StringHashMap(u8).init(allocator),
            .shader_programs = std.ArrayList(ShaderProgram).init(allocator),
            .snippet_reflection_map = std.AutoHashMap(u8, ReflectionData).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn parse(self: *@This(), data: []const u8) !void {
        var in_stream = std.io.fixedBufferStream(data);
        var reader = in_stream.reader();

        var parse_state: ParseState = .none;
        var shader_stage: ShaderStage = undefined;
        var reflection: ReflectionData = undefined;
        var uni_block: ?UniformBlock = null;
        var snippet_id: u8 = 0;

        // TODO: when DirectX is added we'll need to add inputs/outputs in the metadata. See D3D11_INPUT_ELEMENT_DESC for details.
        // TODO: WebGL needs to know the vertex attribute names
        var line_buffer: [2048]u8 = undefined;
        while (try reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
            const line_trimmed = std.mem.trimRight(u8, line, "\r\n");
            if (parse_state == .none) {
                if (std.mem.indexOf(u8, line_trimmed, "snippet_map:") != null) {
                    parse_state = .maps;
                } else if (std.mem.indexOf(u8, line_trimmed, "types:") != null) {
                    parse_state = .types;
                } else if (std.mem.indexOf(u8, line_trimmed, "reflection for snippet") != null) {
                    parse_state = .reflection;

                    const shader_id = try self.allocator.dupe(u8, line_trimmed[std.mem.indexOf(u8, line_trimmed, "snippet").? + 8 .. std.mem.indexOfScalar(u8, line_trimmed, ':').?]);

                    // save this for later so we can associate a ReflectionData with the snippet id
                    snippet_id = try std.fmt.parseUnsigned(u8, shader_id, 10);
                    reflection = ReflectionData.init(self.allocator);
                } else if (std.mem.indexOf(u8, line_trimmed, "image:") != null) {
                    parse_state = .image;
                }
            } else if (parse_state == .reflection) {
                if (std.mem.indexOf(u8, line_trimmed, "stage:") != null) {
                    const stage = line_trimmed[std.mem.indexOfScalar(u8, line_trimmed, ':').? + 2 ..];
                    shader_stage = if (std.mem.eql(u8, stage, "FS")) .fs else .vs;
                    reflection.stage = shader_stage;
                } else if (std.mem.indexOf(u8, line_trimmed, "uniform block:") != null) {
                    parse_state = .uniform;
                    uni_block = try UniformBlock.init(self.allocator, line_trimmed);
                } else if (std.mem.indexOf(u8, line_trimmed, "image:") != null) {
                    parse_state = .image;
                } else if (std.mem.indexOf(u8, line_trimmed, "inputs:") != null) {
                    parse_state = .inputs;
                } else if (std.mem.indexOf(u8, line_trimmed, "outputs:") != null) {
                    parse_state = .outputs;
                }
            } else if (parse_state == .uniform) {
                if (std.mem.indexOf(u8, line_trimmed, "image:") != null) {
                    parse_state = .image;
                } else if (std.mem.indexOf(u8, line_trimmed, "member:") == null) {
                    parse_state = .stage_complete;
                } else {
                    try uni_block.?.addUniform(self.allocator, line_trimmed);
                }
            } else if (parse_state == .inputs) {
                // if we find outputs or image bounce out of the input state
                if (std.mem.indexOf(u8, line_trimmed, "outputs:") != null) {
                    parse_state = .outputs;
                } else if (std.mem.indexOf(u8, line_trimmed, "image:") != null) {
                    parse_state = .image;
                } else {
                    try reflection.addAttribute(true, std.mem.trim(u8, line_trimmed, " "));
                }
            } else if (parse_state == .outputs) {
                // if we find uniform block or image bounce out of the input state
                if (std.mem.indexOf(u8, line_trimmed, "uniform block:") != null) {
                    parse_state = .uniform;
                    uni_block = try UniformBlock.init(self.allocator, line_trimmed);
                } else if (std.mem.indexOf(u8, line_trimmed, "image:") != null) {
                    parse_state = .image;
                } else {
                    try reflection.addAttribute(false, std.mem.trim(u8, line_trimmed, " "));
                }
            }

            if (parse_state == .maps) {
                var inner_state: enum { snippet_map, programs } = .snippet_map;
                var program: ShaderProgram = undefined;

                // inner loop until we get to `spirv_t`
                var inner_line_buffer: [512]u8 = undefined;
                while (try reader.readUntilDelimiterOrEof(&inner_line_buffer, '\n')) |line2| {
                    const line2_trimmed = std.mem.trimRight(u8, line2, "\r\n");
                    if (std.mem.indexOf(u8, line2_trimmed, "spirv_t:") != null) {
                        parse_state = .none;
                        break;
                    } else if (inner_state == .snippet_map) {
                        if (std.mem.indexOf(u8, line2_trimmed, "programs:") != null) {
                            inner_state = .programs;
                        } else if (std.mem.indexOf(u8, line2_trimmed, " => ") != null) {
                            var iter = std.mem.split(u8, line2_trimmed, "=>");
                            const key = try self.allocator.dupe(u8, std.mem.trim(u8, iter.next().?, " "));
                            var val = try self.allocator.dupe(u8, std.mem.trim(u8, iter.next().?, " "));
                            val = val[std.mem.indexOf(u8, val, " ").? + 1 ..];
                            try self.snippet_map.put(key, try std.fmt.parseUnsigned(u8, val, 10));
                            // std.debug.print("-- snip: {} => {}\n", .{ key, val });
                        }
                    } else if (inner_state == .programs) {
                        // start a new program
                        if (std.mem.indexOf(u8, line2_trimmed, "program ")) |prog_index| {
                            const name = line2_trimmed[prog_index + 8 .. std.mem.indexOf(u8, line2_trimmed, ":").?];
                            program = .{ .name = try self.allocator.dupe(u8, name) };
                        } else if (std.mem.indexOf(u8, line2_trimmed, "line_index") != null) { // end the program
                            try self.shader_programs.append(program);
                        } else if (std.mem.indexOf(u8, line2_trimmed, "vs:")) |vs_index| {
                            const name = line2_trimmed[vs_index + 4 ..];
                            program.vs = try self.allocator.dupe(u8, name);
                            program.vs_snippet = self.snippet_map.get(name).?;
                        } else if (std.mem.indexOf(u8, line2_trimmed, "fs:")) |vs_index| {
                            const name = line2_trimmed[vs_index + 4 ..];
                            program.fs = try self.allocator.dupe(u8, name);
                            program.fs_snippet = self.snippet_map.get(name).?;
                        }
                    }
                }
            }

            if (parse_state == .types) {
                if (std.mem.indexOf(u8, line_trimmed, "snippet") != null) {
                    parse_state = .none;
                } else if (!std.mem.endsWith(u8, line_trimmed, "types:")) { // skip the first one, which doesnt have a type map
                    var colon_index = std.mem.indexOfScalar(u8, line_trimmed, ':').?;
                    const name = std.mem.trim(u8, line_trimmed[0..colon_index], " \n\t");
                    var replacement = line_trimmed[colon_index + 2 ..];

                    if (std.mem.eql(u8, name, "vec2")) {
                        self.float2_type = try self.allocator.dupe(u8, replacement);
                    } else if (std.mem.eql(u8, name, "vec3")) {
                        self.float3_type = try self.allocator.dupe(u8, replacement);
                    } else if (std.mem.eql(u8, name, "mat4")) {
                        self.mat4_type = try self.allocator.dupe(u8, replacement);
                    } else {
                        std.log.warn("unsupported type map found! {s}\n", .{name});
                    }
                }
            }

            if (parse_state == .image) {
                if (std.mem.indexOf(u8, line_trimmed, "image:") == null) {
                    parse_state = .stage_complete;
                } else {
                    try reflection.addImage(line_trimmed);
                }
            }

            if (parse_state == .stage_complete) {
                parse_state = .none;

                if (!self.snippet_reflection_map.contains(snippet_id)) {
                    const stage_name = if (uni_block) |uni| uni.name else null;
                    std.log.warn("snippet id: {}, stage: {}, uniform name: {any}, inputs: {}, outputs: {}, images: {}\n", .{ snippet_id, reflection.stage, stage_name, reflection.inputs.items.len, reflection.outputs.items.len, reflection.images.items.len });
                }

                reflection.uniform_block = uni_block;
                try self.snippet_reflection_map.put(snippet_id, reflection);

                uni_block = null;
            }
        }
    }
};
