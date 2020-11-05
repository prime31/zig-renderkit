const std = @import("std");
const fs = @import("../fs.zig");
const gfx = @import("../../gfx.zig");
const stb_image = @import("stb");

// api that isnt renderer specific can be put here then "imported" into the per-renderer types

pub const Texture = struct {

};
