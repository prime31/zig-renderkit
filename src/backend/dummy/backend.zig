const std = @import("std");
pub const gfx_types = @import("types.zig");
pub usingnamespace @import("descriptions.zig");

// the dummy backend defines the interface that all other backends need to implement for renderer compliance

pub fn init() void {}
pub fn initWithLoader(loader: fn ([*c]const u8) callconv(.C) ?*c_void) void {}
pub fn setRenderState(state: gfx.RenderState) void {}
pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {}
pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {}
pub fn clear(action: gfx.ClearCommand) void {}
