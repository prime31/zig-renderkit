// export all the types and descriptors for ease of use
pub const renderer = @import("renderer/renderer.zig");
pub usingnamespace renderer.types;
pub usingnamespace renderer.descriptions;

// export the backend only explicitly (leaving gfx object methods only accessible via renderer.METHOD)
// and some select, higher level types and methods
pub const setRenderState = renderer.setRenderState;
pub const viewport = renderer.viewport;
pub const scissor = renderer.scissor;
