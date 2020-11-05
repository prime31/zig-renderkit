const std = @import("std");
const aya = @import("../aya.zig");
usingnamespace @import("imgui");

pub const FixedList = @import("fixed_list.zig").FixedList;

pub fn cstr_u8_cmp(a: [*:0]const u8, b: []const u8) i8 {
    var index: usize = 0;
    while (b[index] == a[index] and a[index + 1] != 0) : (index += 1) {}
    if (b[index] > a[index]) {
        return 1;
    } else if (b[index] < a[index]) {
        return -1;
    } else {
        return 0;
    }
}

// ImGui inspector

/// given a desired return type T, struct type P and the name of a tuple decl in the struct, uses that tuple to
/// check for annotations to be used for the min/max values.
fn getMinMax(comptime T: type, comptime P: type, comptime name: []const u8) struct { min: T, max: T, speed: f32 } {
    if (@hasDecl(P, "inspect") and @hasField(@TypeOf(P.inspect), name)) {
        const data = @field(P.inspect, name);
        const min = if (@hasField(@TypeOf(data), "min")) @field(data, "min") else -std.math.f32_max;
        const max = if (@hasField(@TypeOf(data), "max")) @field(data, "max") else std.math.f32_max;
        const speed = std.math.min(1.0, (max - min) / 100.0);
        return .{ .min = min, .max = max, .speed = speed };
    }

    switch (T) {
        f32 => return .{ .min = -std.math.f32_max, .max = std.math.f32_max, .speed = 1 },
        else => unreachable,
    }
}

pub fn inspect(comptime label: []const u8, comptime value: anytype) bool {
    if (!aya.has_imgui) return false;

    const T = comptime @TypeOf(value);
    std.debug.assert(std.meta.trait.isSingleItemPtr(T));

    const C = comptime std.meta.Child(T);
    const child_type_info = @typeInfo(C);
    std.debug.assert(child_type_info == .Struct);

    if (igCollapsingHeaderBoolPtr(@as([*c]const u8, label.ptr), null, ImGuiTreeNodeFlags_DefaultOpen)) {
        const info = child_type_info.Struct;
        igPushIDPtr(value);
        var changed = false;
        inline for (info.fields) |*field_info| {
            const name = field_info.name;
            const FieldType = field_info.field_type;
            if (comptime std.meta.trait.is(.Pointer)(FieldType)) {
                std.debug.print("skipping field " ++ name ++ " of struct " ++ @typeName(C) ++ " because it is of pointer-type " ++ @typeName(FieldType), .{});
                continue;
            }
            if (inspectValue(name, value, &@field(value, name))) changed = true;
        }
        igPopID();
        return changed;
    }
    return false;
}

pub fn inspectValue(comptime label: []const u8, comptime parent: anytype, comptime value: anytype) bool {
    if (!aya.has_imgui) return false;

    const T = comptime @TypeOf(value);
    std.debug.assert(std.meta.trait.isSingleItemPtr(T));

    if (comptime std.meta.trait.isSlice(T) or comptime std.meta.trait.isPtrTo(.Array)(T)) {
        var modified = false;
        for (value) |*v| {
            if (inspectValue(label, value, v))
                modified = true;
        }
        return modified;
    }

    const C = comptime std.meta.Child(T);

    // special cases of aya built-in structs
    switch (C) {
        aya.math.Color => @compileError("not implemented"),
        aya.math.Mat32, aya.math.Mat4 => return false,
        aya.math.Vec2 => {
            var min_max = getMinMax(f32, std.meta.Child(@TypeOf(parent)), label);
            if (igDragFloat2(@as([*c]const u8, label.ptr), @ptrCast([*c]f32, &value.x), min_max.speed, min_max.min, min_max.max, null, 1)) {
                return true;
            }
            return false;
        },
        aya.math.Vec3 => {
            var min_max = getMinMax(f32, std.meta.Child(@TypeOf(parent)), label);
            if (igDragFloat3(@as([*c]const u8, label.ptr), @ptrCast([*c]f32, &value.x), min_max.speed, min_max.min, min_max.max, null, 1)) {
                return true;
            }
            return false;
        },
        aya.math.Vec4 => {
            var min_max = getMinMax(f32, std.meta.Child(@TypeOf(parent)), label);
            // should be able to use @ptrCast([*c]f32, &value.x) but when the Vec4 is padded with align(n) it doesnt work
            if (igDragFloat4(@as([*c]const u8, label.ptr), @ptrCast([*c]f32, &value.x), min_max.speed, min_max.min, min_max.max, null, 1)) {
                return true;
            }
            return false;
        },
        else => {},
    }

    const child_type_info = @typeInfo(C);

    switch (child_type_info) {
        .Bool => return igCheckbox(@as([*c]const u8, label.ptr), value),
        .Int => {
            var min_max = getMinMax(i32, std.meta.Child(@TypeOf(parent)), label);
            var tmp = @alignCast(@alignOf(i32), value);
            if (igDragInt(@as([*c]const u8, label.ptr), tmp, min_max.speed, min_max.min, min_max.max, null, 1)) {
                value.* = tmp.*;
                return true;
            }
        },
        .Float => {
            var min_max = getMinMax(f32, std.meta.Child(@TypeOf(parent)), label);
            var tmp = @alignCast(@alignOf(f32), value);
            if (igDragFloat(@as([*c]const u8, label.ptr), tmp, min_max.speed, min_max.min, min_max.max, null, 1)) {
                value.* = tmp.*;
                return true;
            }
        },
        .Struct => @compileError("unhandled sub-struct type"),
        else => {},
    }
    return false;
}

test "test cstr" {
    // const std = @import("std");
    const slice = try std.cstr.addNullByte(std.testing.allocator, "hello"[0..4]);
    defer std.testing.allocator.free(slice);
    const span = std.mem.spanZ(slice);

    std.testing.expect(cstr_u8_cmp(slice, span) == 0);
    std.testing.expect(cstr_u8_cmp(slice, "hell") == 0);
    std.testing.expect(cstr_u8_cmp(span, "hell") == 0);
}
