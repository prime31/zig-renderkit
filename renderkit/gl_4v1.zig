﻿// hijacked from https://github.com/MasterQ32/zig-opengl
const std = @import("std");
const builtin = @import("builtin");
const log = std.log.scoped(.OpenGL);

pub const GLenum = c_uint;
pub const GLboolean = u8;
pub const GLbitfield = c_uint;
pub const GLbyte = i8;
pub const GLubyte = u8;
pub const GLshort = i16;
pub const GLushort = u16;
pub const GLint = c_int;
pub const GLuint = c_uint;
pub const GLclampx = i32;
pub const GLsizei = c_int;
pub const GLfloat = f32;
pub const GLclampf = f32;
pub const GLdouble = f64;
pub const GLclampd = f64;
pub const GLeglClientBufferEXT = void;
pub const GLeglImageOES = void;
pub const GLchar = u8;
pub const GLcharARB = u8;

pub const GLhandleARB = if (builtin.os.tag == .macos) *anyopaque else c_uint;

pub const GLhalf = u16;
pub const GLhalfARB = u16;
pub const GLfixed = i32;
pub const GLintptr = usize;
pub const GLintptrARB = usize;
pub const GLsizeiptr = isize;
pub const GLsizeiptrARB = isize;
pub const GLint64 = i64;
pub const GLint64EXT = i64;
pub const GLuint64 = u64;
pub const GLuint64EXT = u64;

pub const GLsync = *opaque {};

pub const _cl_context = opaque {};
pub const _cl_event = opaque {};

pub const GLDEBUGPROC = fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;
pub const GLDEBUGPROCARB = fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;
pub const GLDEBUGPROCKHR = fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;

pub const GLDEBUGPROCAMD = fn (id: GLuint, category: GLenum, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;

pub const GLhalfNV = u16;
pub const GLvdpauSurfaceNV = GLintptr;
pub const GLVULKANPROCNV = fn () callconv(.C) void;

pub const DEPTH_BUFFER_BIT = 0x00000100;
pub const STENCIL_BUFFER_BIT = 0x00000400;
pub const COLOR_BUFFER_BIT = 0x00004000;
pub const FALSE = 0;
pub const TRUE = 1;
pub const POINTS = 0x0000;
pub const LINES = 0x0001;
pub const LINE_LOOP = 0x0002;
pub const LINE_STRIP = 0x0003;
pub const TRIANGLES = 0x0004;
pub const TRIANGLE_STRIP = 0x0005;
pub const TRIANGLE_FAN = 0x0006;
pub const NEVER = 0x0200;
pub const LESS = 0x0201;
pub const EQUAL = 0x0202;
pub const LEQUAL = 0x0203;
pub const GREATER = 0x0204;
pub const NOTEQUAL = 0x0205;
pub const GEQUAL = 0x0206;
pub const ALWAYS = 0x0207;
pub const ZERO = 0;
pub const ONE = 1;
pub const SRC_COLOR = 0x0300;
pub const ONE_MINUS_SRC_COLOR = 0x0301;
pub const SRC_ALPHA = 0x0302;
pub const ONE_MINUS_SRC_ALPHA = 0x0303;
pub const DST_ALPHA = 0x0304;
pub const ONE_MINUS_DST_ALPHA = 0x0305;
pub const DST_COLOR = 0x0306;
pub const ONE_MINUS_DST_COLOR = 0x0307;
pub const SRC_ALPHA_SATURATE = 0x0308;
pub const NONE = 0;
pub const FRONT_LEFT = 0x0400;
pub const FRONT_RIGHT = 0x0401;
pub const BACK_LEFT = 0x0402;
pub const BACK_RIGHT = 0x0403;
pub const FRONT = 0x0404;
pub const BACK = 0x0405;
pub const LEFT = 0x0406;
pub const RIGHT = 0x0407;
pub const FRONT_AND_BACK = 0x0408;
pub const NO_ERROR = 0;
pub const INVALID_ENUM = 0x0500;
pub const INVALID_VALUE = 0x0501;
pub const INVALID_OPERATION = 0x0502;
pub const OUT_OF_MEMORY = 0x0505;
pub const CW = 0x0900;
pub const CCW = 0x0901;
pub const POINT_SIZE = 0x0B11;
pub const POINT_SIZE_RANGE = 0x0B12;
pub const POINT_SIZE_GRANULARITY = 0x0B13;
pub const LINE_SMOOTH = 0x0B20;
pub const LINE_WIDTH = 0x0B21;
pub const LINE_WIDTH_RANGE = 0x0B22;
pub const LINE_WIDTH_GRANULARITY = 0x0B23;
pub const POLYGON_MODE = 0x0B40;
pub const POLYGON_SMOOTH = 0x0B41;
pub const CULL_FACE = 0x0B44;
pub const CULL_FACE_MODE = 0x0B45;
pub const FRONT_FACE = 0x0B46;
pub const DEPTH_RANGE = 0x0B70;
pub const DEPTH_TEST = 0x0B71;
pub const DEPTH_WRITEMASK = 0x0B72;
pub const DEPTH_CLEAR_VALUE = 0x0B73;
pub const DEPTH_FUNC = 0x0B74;
pub const STENCIL_TEST = 0x0B90;
pub const STENCIL_CLEAR_VALUE = 0x0B91;
pub const STENCIL_FUNC = 0x0B92;
pub const STENCIL_VALUE_MASK = 0x0B93;
pub const STENCIL_FAIL = 0x0B94;
pub const STENCIL_PASS_DEPTH_FAIL = 0x0B95;
pub const STENCIL_PASS_DEPTH_PASS = 0x0B96;
pub const STENCIL_REF = 0x0B97;
pub const STENCIL_WRITEMASK = 0x0B98;
pub const VIEWPORT = 0x0BA2;
pub const DITHER = 0x0BD0;
pub const BLEND_DST = 0x0BE0;
pub const BLEND_SRC = 0x0BE1;
pub const BLEND = 0x0BE2;
pub const LOGIC_OP_MODE = 0x0BF0;
pub const DRAW_BUFFER = 0x0C01;
pub const READ_BUFFER = 0x0C02;
pub const SCISSOR_BOX = 0x0C10;
pub const SCISSOR_TEST = 0x0C11;
pub const COLOR_CLEAR_VALUE = 0x0C22;
pub const COLOR_WRITEMASK = 0x0C23;
pub const DOUBLEBUFFER = 0x0C32;
pub const STEREO = 0x0C33;
pub const LINE_SMOOTH_HINT = 0x0C52;
pub const POLYGON_SMOOTH_HINT = 0x0C53;
pub const UNPACK_SWAP_BYTES = 0x0CF0;
pub const UNPACK_LSB_FIRST = 0x0CF1;
pub const UNPACK_ROW_LENGTH = 0x0CF2;
pub const UNPACK_SKIP_ROWS = 0x0CF3;
pub const UNPACK_SKIP_PIXELS = 0x0CF4;
pub const UNPACK_ALIGNMENT = 0x0CF5;
pub const PACK_SWAP_BYTES = 0x0D00;
pub const PACK_LSB_FIRST = 0x0D01;
pub const PACK_ROW_LENGTH = 0x0D02;
pub const PACK_SKIP_ROWS = 0x0D03;
pub const PACK_SKIP_PIXELS = 0x0D04;
pub const PACK_ALIGNMENT = 0x0D05;
pub const MAX_TEXTURE_SIZE = 0x0D33;
pub const MAX_VIEWPORT_DIMS = 0x0D3A;
pub const SUBPIXEL_BITS = 0x0D50;
pub const TEXTURE_1D = 0x0DE0;
pub const TEXTURE_2D = 0x0DE1;
pub const TEXTURE_WIDTH = 0x1000;
pub const TEXTURE_HEIGHT = 0x1001;
pub const TEXTURE_BORDER_COLOR = 0x1004;
pub const DONT_CARE = 0x1100;
pub const FASTEST = 0x1101;
pub const NICEST = 0x1102;
pub const BYTE = 0x1400;
pub const UNSIGNED_BYTE = 0x1401;
pub const SHORT = 0x1402;
pub const UNSIGNED_SHORT = 0x1403;
pub const INT = 0x1404;
pub const UNSIGNED_INT = 0x1405;
pub const FLOAT = 0x1406;
pub const CLEAR = 0x1500;
pub const AND = 0x1501;
pub const AND_REVERSE = 0x1502;
pub const COPY = 0x1503;
pub const AND_INVERTED = 0x1504;
pub const NOOP = 0x1505;
pub const XOR = 0x1506;
pub const OR = 0x1507;
pub const NOR = 0x1508;
pub const EQUIV = 0x1509;
pub const INVERT = 0x150A;
pub const OR_REVERSE = 0x150B;
pub const COPY_INVERTED = 0x150C;
pub const OR_INVERTED = 0x150D;
pub const NAND = 0x150E;
pub const SET = 0x150F;
pub const TEXTURE = 0x1702;
pub const COLOR = 0x1800;
pub const DEPTH = 0x1801;
pub const STENCIL = 0x1802;
pub const STENCIL_INDEX = 0x1901;
pub const DEPTH_COMPONENT = 0x1902;
pub const RED = 0x1903;
pub const GREEN = 0x1904;
pub const BLUE = 0x1905;
pub const ALPHA = 0x1906;
pub const RGB = 0x1907;
pub const RGBA = 0x1908;
pub const POINT = 0x1B00;
pub const LINE = 0x1B01;
pub const FILL = 0x1B02;
pub const KEEP = 0x1E00;
pub const REPLACE = 0x1E01;
pub const INCR = 0x1E02;
pub const DECR = 0x1E03;
pub const VENDOR = 0x1F00;
pub const RENDERER = 0x1F01;
pub const VERSION = 0x1F02;
pub const EXTENSIONS = 0x1F03;
pub const NEAREST = 0x2600;
pub const LINEAR = 0x2601;
pub const NEAREST_MIPMAP_NEAREST = 0x2700;
pub const LINEAR_MIPMAP_NEAREST = 0x2701;
pub const NEAREST_MIPMAP_LINEAR = 0x2702;
pub const LINEAR_MIPMAP_LINEAR = 0x2703;
pub const TEXTURE_MAG_FILTER = 0x2800;
pub const TEXTURE_MIN_FILTER = 0x2801;
pub const TEXTURE_WRAP_S = 0x2802;
pub const TEXTURE_WRAP_T = 0x2803;
pub const REPEAT = 0x2901;
pub const UNDEFINED_VERTEX = 0x8260;
pub const VIEWPORT_INDEX_PROVOKING_VERTEX = 0x825F;
pub const LAYER_PROVOKING_VERTEX = 0x825E;
pub const VIEWPORT_BOUNDS_RANGE = 0x825D;
pub const VIEWPORT_SUBPIXEL_BITS = 0x825C;
pub const MAX_VIEWPORTS = 0x825B;
pub const PROGRAM_PIPELINE_BINDING = 0x825A;
pub const ACTIVE_PROGRAM = 0x8259;
pub const PROGRAM_SEPARABLE = 0x8258;
pub const ALL_SHADER_BITS = 0xFFFFFFFF;
pub const TESS_EVALUATION_SHADER_BIT = 0x00000010;
pub const TESS_CONTROL_SHADER_BIT = 0x00000008;
pub const GEOMETRY_SHADER_BIT = 0x00000004;
pub const FRAGMENT_SHADER_BIT = 0x00000002;
pub const VERTEX_SHADER_BIT = 0x00000001;
pub const PROGRAM_BINARY_FORMATS = 0x87FF;
pub const NUM_PROGRAM_BINARY_FORMATS = 0x87FE;
pub const PROGRAM_BINARY_LENGTH = 0x8741;
pub const PROGRAM_BINARY_RETRIEVABLE_HINT = 0x8257;
pub const RGB565 = 0x8D62;
pub const MAX_FRAGMENT_UNIFORM_VECTORS = 0x8DFD;
pub const MAX_VARYING_VECTORS = 0x8DFC;
pub const MAX_VERTEX_UNIFORM_VECTORS = 0x8DFB;
pub const NUM_SHADER_BINARY_FORMATS = 0x8DF9;
pub const SHADER_BINARY_FORMATS = 0x8DF8;
pub const SHADER_COMPILER = 0x8DFA;
pub const HIGH_INT = 0x8DF5;
pub const MEDIUM_INT = 0x8DF4;
pub const LOW_INT = 0x8DF3;
pub const HIGH_FLOAT = 0x8DF2;
pub const MEDIUM_FLOAT = 0x8DF1;
pub const LOW_FLOAT = 0x8DF0;
pub const IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B;
pub const IMPLEMENTATION_COLOR_READ_TYPE = 0x8B9A;
pub const FIXED = 0x140C;
pub const MAX_TRANSFORM_FEEDBACK_BUFFERS = 0x8E70;
pub const ISOLINES = 0x8E7A;
pub const TESS_GEN_POINT_MODE = 0x8E79;
pub const TESS_GEN_VERTEX_ORDER = 0x8E78;
pub const TESS_GEN_SPACING = 0x8E77;
pub const TESS_GEN_MODE = 0x8E76;
pub const TESS_CONTROL_OUTPUT_VERTICES = 0x8E75;
pub const PATCH_DEFAULT_OUTER_LEVEL = 0x8E74;
pub const PATCH_DEFAULT_INNER_LEVEL = 0x8E73;
pub const PATCH_VERTICES = 0x8E72;
pub const PATCHES = 0x000E;
pub const COLOR_LOGIC_OP = 0x0BF2;
pub const POLYGON_OFFSET_UNITS = 0x2A00;
pub const POLYGON_OFFSET_POINT = 0x2A01;
pub const POLYGON_OFFSET_LINE = 0x2A02;
pub const POLYGON_OFFSET_FILL = 0x8037;
pub const POLYGON_OFFSET_FACTOR = 0x8038;
pub const TEXTURE_BINDING_1D = 0x8068;
pub const TEXTURE_BINDING_2D = 0x8069;
pub const TEXTURE_INTERNAL_FORMAT = 0x1003;
pub const TEXTURE_RED_SIZE = 0x805C;
pub const TEXTURE_GREEN_SIZE = 0x805D;
pub const TEXTURE_BLUE_SIZE = 0x805E;
pub const TEXTURE_ALPHA_SIZE = 0x805F;
pub const DOUBLE = 0x140A;
pub const PROXY_TEXTURE_1D = 0x8063;
pub const PROXY_TEXTURE_2D = 0x8064;
pub const R3_G3_B2 = 0x2A10;
pub const RGB4 = 0x804F;
pub const RGB5 = 0x8050;
pub const RGB8 = 0x8051;
pub const RGB10 = 0x8052;
pub const RGB12 = 0x8053;
pub const RGB16 = 0x8054;
pub const RGBA2 = 0x8055;
pub const RGBA4 = 0x8056;
pub const RGB5_A1 = 0x8057;
pub const RGBA8 = 0x8058;
pub const RGB10_A2 = 0x8059;
pub const RGBA12 = 0x805A;
pub const RGBA16 = 0x805B;
pub const TRANSFORM_FEEDBACK_BINDING = 0x8E25;
pub const TRANSFORM_FEEDBACK_BUFFER_ACTIVE = 0x8E24;
pub const TRANSFORM_FEEDBACK_BUFFER_PAUSED = 0x8E23;
pub const TRANSFORM_FEEDBACK = 0x8E22;
pub const TESS_CONTROL_SHADER = 0x8E88;
pub const TESS_EVALUATION_SHADER = 0x8E87;
pub const UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER = 0x84F1;
pub const UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER = 0x84F0;
pub const MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS = 0x8E1F;
pub const MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS = 0x8E1E;
pub const MAX_TESS_EVALUATION_INPUT_COMPONENTS = 0x886D;
pub const MAX_TESS_CONTROL_INPUT_COMPONENTS = 0x886C;
pub const MAX_TESS_EVALUATION_UNIFORM_BLOCKS = 0x8E8A;
pub const MAX_TESS_CONTROL_UNIFORM_BLOCKS = 0x8E89;
pub const MAX_TESS_EVALUATION_OUTPUT_COMPONENTS = 0x8E86;
pub const MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS = 0x8E85;
pub const MAX_TESS_PATCH_COMPONENTS = 0x8E84;
pub const MAX_TESS_CONTROL_OUTPUT_COMPONENTS = 0x8E83;
pub const MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS = 0x8E82;
pub const MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS = 0x8E81;
pub const MAX_TESS_EVALUATION_UNIFORM_COMPONENTS = 0x8E80;
pub const MAX_TESS_CONTROL_UNIFORM_COMPONENTS = 0x8E7F;
pub const MAX_TESS_GEN_LEVEL = 0x8E7E;
pub const MAX_PATCH_VERTICES = 0x8E7D;
pub const FRACTIONAL_EVEN = 0x8E7C;
pub const FRACTIONAL_ODD = 0x8E7B;
pub const QUADS = 0x0007;
pub const MAX_SUBROUTINE_UNIFORM_LOCATIONS = 0x8DE8;
pub const COMPATIBLE_SUBROUTINES = 0x8E4B;
pub const NUM_COMPATIBLE_SUBROUTINES = 0x8E4A;
pub const MAX_SUBROUTINES = 0x8DE7;
pub const ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH = 0x8E49;
pub const ACTIVE_SUBROUTINE_MAX_LENGTH = 0x8E48;
pub const ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS = 0x8E47;
pub const ACTIVE_SUBROUTINE_UNIFORMS = 0x8DE6;
pub const ACTIVE_SUBROUTINES = 0x8DE5;
pub const UNSIGNED_BYTE_3_3_2 = 0x8032;
pub const UNSIGNED_SHORT_4_4_4_4 = 0x8033;
pub const UNSIGNED_SHORT_5_5_5_1 = 0x8034;
pub const UNSIGNED_INT_8_8_8_8 = 0x8035;
pub const UNSIGNED_INT_10_10_10_2 = 0x8036;
pub const TEXTURE_BINDING_3D = 0x806A;
pub const PACK_SKIP_IMAGES = 0x806B;
pub const PACK_IMAGE_HEIGHT = 0x806C;
pub const UNPACK_SKIP_IMAGES = 0x806D;
pub const UNPACK_IMAGE_HEIGHT = 0x806E;
pub const TEXTURE_3D = 0x806F;
pub const PROXY_TEXTURE_3D = 0x8070;
pub const TEXTURE_DEPTH = 0x8071;
pub const TEXTURE_WRAP_R = 0x8072;
pub const MAX_3D_TEXTURE_SIZE = 0x8073;
pub const UNSIGNED_BYTE_2_3_3_REV = 0x8362;
pub const UNSIGNED_SHORT_5_6_5 = 0x8363;
pub const UNSIGNED_SHORT_5_6_5_REV = 0x8364;
pub const UNSIGNED_SHORT_4_4_4_4_REV = 0x8365;
pub const UNSIGNED_SHORT_1_5_5_5_REV = 0x8366;
pub const UNSIGNED_INT_8_8_8_8_REV = 0x8367;
pub const UNSIGNED_INT_2_10_10_10_REV = 0x8368;
pub const BGR = 0x80E0;
pub const BGRA = 0x80E1;
pub const MAX_ELEMENTS_VERTICES = 0x80E8;
pub const MAX_ELEMENTS_INDICES = 0x80E9;
pub const CLAMP_TO_EDGE = 0x812F;
pub const TEXTURE_MIN_LOD = 0x813A;
pub const TEXTURE_MAX_LOD = 0x813B;
pub const TEXTURE_BASE_LEVEL = 0x813C;
pub const TEXTURE_MAX_LEVEL = 0x813D;
pub const SMOOTH_POINT_SIZE_RANGE = 0x0B12;
pub const SMOOTH_POINT_SIZE_GRANULARITY = 0x0B13;
pub const SMOOTH_LINE_WIDTH_RANGE = 0x0B22;
pub const SMOOTH_LINE_WIDTH_GRANULARITY = 0x0B23;
pub const ALIASED_LINE_WIDTH_RANGE = 0x846E;
pub const TEXTURE0 = 0x84C0;
pub const TEXTURE1 = 0x84C1;
pub const TEXTURE2 = 0x84C2;
pub const TEXTURE3 = 0x84C3;
pub const TEXTURE4 = 0x84C4;
pub const TEXTURE5 = 0x84C5;
pub const TEXTURE6 = 0x84C6;
pub const TEXTURE7 = 0x84C7;
pub const TEXTURE8 = 0x84C8;
pub const TEXTURE9 = 0x84C9;
pub const TEXTURE10 = 0x84CA;
pub const TEXTURE11 = 0x84CB;
pub const TEXTURE12 = 0x84CC;
pub const TEXTURE13 = 0x84CD;
pub const TEXTURE14 = 0x84CE;
pub const TEXTURE15 = 0x84CF;
pub const TEXTURE16 = 0x84D0;
pub const TEXTURE17 = 0x84D1;
pub const TEXTURE18 = 0x84D2;
pub const TEXTURE19 = 0x84D3;
pub const TEXTURE20 = 0x84D4;
pub const TEXTURE21 = 0x84D5;
pub const TEXTURE22 = 0x84D6;
pub const TEXTURE23 = 0x84D7;
pub const TEXTURE24 = 0x84D8;
pub const TEXTURE25 = 0x84D9;
pub const TEXTURE26 = 0x84DA;
pub const TEXTURE27 = 0x84DB;
pub const TEXTURE28 = 0x84DC;
pub const TEXTURE29 = 0x84DD;
pub const TEXTURE30 = 0x84DE;
pub const TEXTURE31 = 0x84DF;
pub const ACTIVE_TEXTURE = 0x84E0;
pub const MULTISAMPLE = 0x809D;
pub const SAMPLE_ALPHA_TO_COVERAGE = 0x809E;
pub const SAMPLE_ALPHA_TO_ONE = 0x809F;
pub const SAMPLE_COVERAGE = 0x80A0;
pub const SAMPLE_BUFFERS = 0x80A8;
pub const SAMPLES = 0x80A9;
pub const SAMPLE_COVERAGE_VALUE = 0x80AA;
pub const SAMPLE_COVERAGE_INVERT = 0x80AB;
pub const TEXTURE_CUBE_MAP = 0x8513;
pub const TEXTURE_BINDING_CUBE_MAP = 0x8514;
pub const TEXTURE_CUBE_MAP_POSITIVE_X = 0x8515;
pub const TEXTURE_CUBE_MAP_NEGATIVE_X = 0x8516;
pub const TEXTURE_CUBE_MAP_POSITIVE_Y = 0x8517;
pub const TEXTURE_CUBE_MAP_NEGATIVE_Y = 0x8518;
pub const TEXTURE_CUBE_MAP_POSITIVE_Z = 0x8519;
pub const TEXTURE_CUBE_MAP_NEGATIVE_Z = 0x851A;
pub const PROXY_TEXTURE_CUBE_MAP = 0x851B;
pub const MAX_CUBE_MAP_TEXTURE_SIZE = 0x851C;
pub const COMPRESSED_RGB = 0x84ED;
pub const COMPRESSED_RGBA = 0x84EE;
pub const TEXTURE_COMPRESSION_HINT = 0x84EF;
pub const TEXTURE_COMPRESSED_IMAGE_SIZE = 0x86A0;
pub const TEXTURE_COMPRESSED = 0x86A1;
pub const NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
pub const COMPRESSED_TEXTURE_FORMATS = 0x86A3;
pub const CLAMP_TO_BORDER = 0x812D;
pub const DOUBLE_MAT4x3 = 0x8F4E;
pub const DOUBLE_MAT4x2 = 0x8F4D;
pub const DOUBLE_MAT3x4 = 0x8F4C;
pub const DOUBLE_MAT3x2 = 0x8F4B;
pub const DOUBLE_MAT2x4 = 0x8F4A;
pub const DOUBLE_MAT2x3 = 0x8F49;
pub const DOUBLE_MAT4 = 0x8F48;
pub const DOUBLE_MAT3 = 0x8F47;
pub const DOUBLE_MAT2 = 0x8F46;
pub const DOUBLE_VEC4 = 0x8FFE;
pub const DOUBLE_VEC3 = 0x8FFD;
pub const DOUBLE_VEC2 = 0x8FFC;
pub const MAX_VERTEX_STREAMS = 0x8E71;
pub const FRAGMENT_INTERPOLATION_OFFSET_BITS = 0x8E5D;
pub const MAX_FRAGMENT_INTERPOLATION_OFFSET = 0x8E5C;
pub const MIN_FRAGMENT_INTERPOLATION_OFFSET = 0x8E5B;
pub const MAX_GEOMETRY_SHADER_INVOCATIONS = 0x8E5A;
pub const GEOMETRY_SHADER_INVOCATIONS = 0x887F;
pub const DRAW_INDIRECT_BUFFER_BINDING = 0x8F43;
pub const DRAW_INDIRECT_BUFFER = 0x8F3F;
pub const UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY = 0x900F;
pub const INT_SAMPLER_CUBE_MAP_ARRAY = 0x900E;
pub const SAMPLER_CUBE_MAP_ARRAY_SHADOW = 0x900D;
pub const SAMPLER_CUBE_MAP_ARRAY = 0x900C;
pub const PROXY_TEXTURE_CUBE_MAP_ARRAY = 0x900B;
pub const TEXTURE_BINDING_CUBE_MAP_ARRAY = 0x900A;
pub const TEXTURE_CUBE_MAP_ARRAY = 0x9009;
pub const MAX_PROGRAM_TEXTURE_GATHER_OFFSET = 0x8E5F;
pub const MIN_PROGRAM_TEXTURE_GATHER_OFFSET = 0x8E5E;
pub const MIN_SAMPLE_SHADING_VALUE = 0x8C37;
pub const SAMPLE_SHADING = 0x8C36;
pub const INT_2_10_10_10_REV = 0x8D9F;
pub const TIMESTAMP = 0x8E28;
pub const TIME_ELAPSED = 0x88BF;
pub const TEXTURE_SWIZZLE_RGBA = 0x8E46;
pub const TEXTURE_SWIZZLE_A = 0x8E45;
pub const TEXTURE_SWIZZLE_B = 0x8E44;
pub const TEXTURE_SWIZZLE_G = 0x8E43;
pub const TEXTURE_SWIZZLE_R = 0x8E42;
pub const RGB10_A2UI = 0x906F;
pub const BLEND_DST_RGB = 0x80C8;
pub const BLEND_SRC_RGB = 0x80C9;
pub const BLEND_DST_ALPHA = 0x80CA;
pub const BLEND_SRC_ALPHA = 0x80CB;
pub const POINT_FADE_THRESHOLD_SIZE = 0x8128;
pub const DEPTH_COMPONENT16 = 0x81A5;
pub const DEPTH_COMPONENT24 = 0x81A6;
pub const DEPTH_COMPONENT32 = 0x81A7;
pub const MIRRORED_REPEAT = 0x8370;
pub const MAX_TEXTURE_LOD_BIAS = 0x84FD;
pub const TEXTURE_LOD_BIAS = 0x8501;
pub const INCR_WRAP = 0x8507;
pub const DECR_WRAP = 0x8508;
pub const TEXTURE_DEPTH_SIZE = 0x884A;
pub const TEXTURE_COMPARE_MODE = 0x884C;
pub const TEXTURE_COMPARE_FUNC = 0x884D;
pub const SAMPLER_BINDING = 0x8919;
pub const ANY_SAMPLES_PASSED = 0x8C2F;
pub const MAX_DUAL_SOURCE_DRAW_BUFFERS = 0x88FC;
pub const ONE_MINUS_SRC1_ALPHA = 0x88FB;
pub const ONE_MINUS_SRC1_COLOR = 0x88FA;
pub const SRC1_COLOR = 0x88F9;
pub const VERTEX_ATTRIB_ARRAY_DIVISOR = 0x88FE;
pub const MAX_INTEGER_SAMPLES = 0x9110;
pub const MAX_DEPTH_TEXTURE_SAMPLES = 0x910F;
pub const MAX_COLOR_TEXTURE_SAMPLES = 0x910E;
pub const UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910D;
pub const INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910C;
pub const SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910B;
pub const UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE = 0x910A;
pub const INT_SAMPLER_2D_MULTISAMPLE = 0x9109;
pub const SAMPLER_2D_MULTISAMPLE = 0x9108;
pub const TEXTURE_FIXED_SAMPLE_LOCATIONS = 0x9107;
pub const TEXTURE_SAMPLES = 0x9106;
pub const TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = 0x9105;
pub const TEXTURE_BINDING_2D_MULTISAMPLE = 0x9104;
pub const PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9103;
pub const TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9102;
pub const PROXY_TEXTURE_2D_MULTISAMPLE = 0x9101;
pub const TEXTURE_2D_MULTISAMPLE = 0x9100;
pub const MAX_SAMPLE_MASK_WORDS = 0x8E59;
pub const SAMPLE_MASK_VALUE = 0x8E52;
pub const SAMPLE_MASK = 0x8E51;
pub const SAMPLE_POSITION = 0x8E50;
pub const SYNC_FLUSH_COMMANDS_BIT = 0x00000001;
pub const TIMEOUT_IGNORED = 0xFFFFFFFFFFFFFFFF;
pub const WAIT_FAILED = 0x911D;
pub const CONDITION_SATISFIED = 0x911C;
pub const TIMEOUT_EXPIRED = 0x911B;
pub const ALREADY_SIGNALED = 0x911A;
pub const SIGNALED = 0x9119;
pub const UNSIGNALED = 0x9118;
pub const SYNC_GPU_COMMANDS_COMPLETE = 0x9117;
pub const BLEND_COLOR = 0x8005;
pub const BLEND_EQUATION = 0x8009;
pub const CONSTANT_COLOR = 0x8001;
pub const ONE_MINUS_CONSTANT_COLOR = 0x8002;
pub const CONSTANT_ALPHA = 0x8003;
pub const ONE_MINUS_CONSTANT_ALPHA = 0x8004;
pub const FUNC_ADD = 0x8006;
pub const FUNC_REVERSE_SUBTRACT = 0x800B;
pub const FUNC_SUBTRACT = 0x800A;
pub const MIN = 0x8007;
pub const MAX = 0x8008;
pub const BUFFER_SIZE = 0x8764;
pub const BUFFER_USAGE = 0x8765;
pub const QUERY_COUNTER_BITS = 0x8864;
pub const CURRENT_QUERY = 0x8865;
pub const QUERY_RESULT = 0x8866;
pub const QUERY_RESULT_AVAILABLE = 0x8867;
pub const ARRAY_BUFFER = 0x8892;
pub const ELEMENT_ARRAY_BUFFER = 0x8893;
pub const ARRAY_BUFFER_BINDING = 0x8894;
pub const ELEMENT_ARRAY_BUFFER_BINDING = 0x8895;
pub const VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;
pub const READ_ONLY = 0x88B8;
pub const WRITE_ONLY = 0x88B9;
pub const READ_WRITE = 0x88BA;
pub const BUFFER_ACCESS = 0x88BB;
pub const BUFFER_MAPPED = 0x88BC;
pub const BUFFER_MAP_POINTER = 0x88BD;
pub const STREAM_DRAW = 0x88E0;
pub const STREAM_READ = 0x88E1;
pub const STREAM_COPY = 0x88E2;
pub const STATIC_DRAW = 0x88E4;
pub const STATIC_READ = 0x88E5;
pub const STATIC_COPY = 0x88E6;
pub const DYNAMIC_DRAW = 0x88E8;
pub const DYNAMIC_READ = 0x88E9;
pub const DYNAMIC_COPY = 0x88EA;
pub const SAMPLES_PASSED = 0x8914;
pub const SRC1_ALPHA = 0x8589;
pub const SYNC_FENCE = 0x9116;
pub const SYNC_FLAGS = 0x9115;
pub const SYNC_STATUS = 0x9114;
pub const SYNC_CONDITION = 0x9113;
pub const OBJECT_TYPE = 0x9112;
pub const MAX_SERVER_WAIT_TIMEOUT = 0x9111;
pub const TEXTURE_CUBE_MAP_SEAMLESS = 0x884F;
pub const PROVOKING_VERTEX = 0x8E4F;
pub const LAST_VERTEX_CONVENTION = 0x8E4E;
pub const FIRST_VERTEX_CONVENTION = 0x8E4D;
pub const QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = 0x8E4C;
pub const DEPTH_CLAMP = 0x864F;
pub const CONTEXT_PROFILE_MASK = 0x9126;
pub const MAX_FRAGMENT_INPUT_COMPONENTS = 0x9125;
pub const MAX_GEOMETRY_OUTPUT_COMPONENTS = 0x9124;
pub const MAX_GEOMETRY_INPUT_COMPONENTS = 0x9123;
pub const MAX_VERTEX_OUTPUT_COMPONENTS = 0x9122;
pub const BLEND_EQUATION_RGB = 0x8009;
pub const VERTEX_ATTRIB_ARRAY_ENABLED = 0x8622;
pub const VERTEX_ATTRIB_ARRAY_SIZE = 0x8623;
pub const VERTEX_ATTRIB_ARRAY_STRIDE = 0x8624;
pub const VERTEX_ATTRIB_ARRAY_TYPE = 0x8625;
pub const CURRENT_VERTEX_ATTRIB = 0x8626;
pub const VERTEX_PROGRAM_POINT_SIZE = 0x8642;
pub const VERTEX_ATTRIB_ARRAY_POINTER = 0x8645;
pub const STENCIL_BACK_FUNC = 0x8800;
pub const STENCIL_BACK_FAIL = 0x8801;
pub const STENCIL_BACK_PASS_DEPTH_FAIL = 0x8802;
pub const STENCIL_BACK_PASS_DEPTH_PASS = 0x8803;
pub const MAX_DRAW_BUFFERS = 0x8824;
pub const DRAW_BUFFER0 = 0x8825;
pub const DRAW_BUFFER1 = 0x8826;
pub const DRAW_BUFFER2 = 0x8827;
pub const DRAW_BUFFER3 = 0x8828;
pub const DRAW_BUFFER4 = 0x8829;
pub const DRAW_BUFFER5 = 0x882A;
pub const DRAW_BUFFER6 = 0x882B;
pub const DRAW_BUFFER7 = 0x882C;
pub const DRAW_BUFFER8 = 0x882D;
pub const DRAW_BUFFER9 = 0x882E;
pub const DRAW_BUFFER10 = 0x882F;
pub const DRAW_BUFFER11 = 0x8830;
pub const DRAW_BUFFER12 = 0x8831;
pub const DRAW_BUFFER13 = 0x8832;
pub const DRAW_BUFFER14 = 0x8833;
pub const DRAW_BUFFER15 = 0x8834;
pub const BLEND_EQUATION_ALPHA = 0x883D;
pub const MAX_VERTEX_ATTRIBS = 0x8869;
pub const VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A;
pub const MAX_TEXTURE_IMAGE_UNITS = 0x8872;
pub const FRAGMENT_SHADER = 0x8B30;
pub const VERTEX_SHADER = 0x8B31;
pub const MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49;
pub const MAX_VERTEX_UNIFORM_COMPONENTS = 0x8B4A;
pub const MAX_VARYING_FLOATS = 0x8B4B;
pub const MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C;
pub const MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
pub const SHADER_TYPE = 0x8B4F;
pub const FLOAT_VEC2 = 0x8B50;
pub const FLOAT_VEC3 = 0x8B51;
pub const FLOAT_VEC4 = 0x8B52;
pub const INT_VEC2 = 0x8B53;
pub const INT_VEC3 = 0x8B54;
pub const INT_VEC4 = 0x8B55;
pub const BOOL = 0x8B56;
pub const BOOL_VEC2 = 0x8B57;
pub const BOOL_VEC3 = 0x8B58;
pub const BOOL_VEC4 = 0x8B59;
pub const FLOAT_MAT2 = 0x8B5A;
pub const FLOAT_MAT3 = 0x8B5B;
pub const FLOAT_MAT4 = 0x8B5C;
pub const SAMPLER_1D = 0x8B5D;
pub const SAMPLER_2D = 0x8B5E;
pub const SAMPLER_3D = 0x8B5F;
pub const SAMPLER_CUBE = 0x8B60;
pub const SAMPLER_1D_SHADOW = 0x8B61;
pub const SAMPLER_2D_SHADOW = 0x8B62;
pub const DELETE_STATUS = 0x8B80;
pub const COMPILE_STATUS = 0x8B81;
pub const LINK_STATUS = 0x8B82;
pub const VALIDATE_STATUS = 0x8B83;
pub const INFO_LOG_LENGTH = 0x8B84;
pub const ATTACHED_SHADERS = 0x8B85;
pub const ACTIVE_UNIFORMS = 0x8B86;
pub const ACTIVE_UNIFORM_MAX_LENGTH = 0x8B87;
pub const SHADER_SOURCE_LENGTH = 0x8B88;
pub const ACTIVE_ATTRIBUTES = 0x8B89;
pub const ACTIVE_ATTRIBUTE_MAX_LENGTH = 0x8B8A;
pub const FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B;
pub const SHADING_LANGUAGE_VERSION = 0x8B8C;
pub const CURRENT_PROGRAM = 0x8B8D;
pub const POINT_SPRITE_COORD_ORIGIN = 0x8CA0;
pub const LOWER_LEFT = 0x8CA1;
pub const UPPER_LEFT = 0x8CA2;
pub const STENCIL_BACK_REF = 0x8CA3;
pub const STENCIL_BACK_VALUE_MASK = 0x8CA4;
pub const STENCIL_BACK_WRITEMASK = 0x8CA5;
pub const MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = 0x8DE1;
pub const MAX_GEOMETRY_OUTPUT_VERTICES = 0x8DE0;
pub const MAX_GEOMETRY_UNIFORM_COMPONENTS = 0x8DDF;
pub const GEOMETRY_OUTPUT_TYPE = 0x8918;
pub const PIXEL_PACK_BUFFER = 0x88EB;
pub const PIXEL_UNPACK_BUFFER = 0x88EC;
pub const PIXEL_PACK_BUFFER_BINDING = 0x88ED;
pub const PIXEL_UNPACK_BUFFER_BINDING = 0x88EF;
pub const FLOAT_MAT2x3 = 0x8B65;
pub const FLOAT_MAT2x4 = 0x8B66;
pub const FLOAT_MAT3x2 = 0x8B67;
pub const FLOAT_MAT3x4 = 0x8B68;
pub const FLOAT_MAT4x2 = 0x8B69;
pub const FLOAT_MAT4x3 = 0x8B6A;
pub const SRGB = 0x8C40;
pub const SRGB8 = 0x8C41;
pub const SRGB_ALPHA = 0x8C42;
pub const SRGB8_ALPHA8 = 0x8C43;
pub const COMPRESSED_SRGB = 0x8C48;
pub const COMPRESSED_SRGB_ALPHA = 0x8C49;
pub const GEOMETRY_INPUT_TYPE = 0x8917;
pub const GEOMETRY_VERTICES_OUT = 0x8916;
pub const GEOMETRY_SHADER = 0x8DD9;
pub const FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = 0x8DA8;
pub const FRAMEBUFFER_ATTACHMENT_LAYERED = 0x8DA7;
pub const MAX_GEOMETRY_TEXTURE_IMAGE_UNITS = 0x8C29;
pub const PROGRAM_POINT_SIZE = 0x8642;
pub const COMPARE_REF_TO_TEXTURE = 0x884E;
pub const CLIP_DISTANCE0 = 0x3000;
pub const CLIP_DISTANCE1 = 0x3001;
pub const CLIP_DISTANCE2 = 0x3002;
pub const CLIP_DISTANCE3 = 0x3003;
pub const CLIP_DISTANCE4 = 0x3004;
pub const CLIP_DISTANCE5 = 0x3005;
pub const CLIP_DISTANCE6 = 0x3006;
pub const CLIP_DISTANCE7 = 0x3007;
pub const MAX_CLIP_DISTANCES = 0x0D32;
pub const MAJOR_VERSION = 0x821B;
pub const MINOR_VERSION = 0x821C;
pub const NUM_EXTENSIONS = 0x821D;
pub const CONTEXT_FLAGS = 0x821E;
pub const COMPRESSED_RED = 0x8225;
pub const COMPRESSED_RG = 0x8226;
pub const CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT = 0x00000001;
pub const RGBA32F = 0x8814;
pub const RGB32F = 0x8815;
pub const RGBA16F = 0x881A;
pub const RGB16F = 0x881B;
pub const VERTEX_ATTRIB_ARRAY_INTEGER = 0x88FD;
pub const MAX_ARRAY_TEXTURE_LAYERS = 0x88FF;
pub const MIN_PROGRAM_TEXEL_OFFSET = 0x8904;
pub const MAX_PROGRAM_TEXEL_OFFSET = 0x8905;
pub const CLAMP_READ_COLOR = 0x891C;
pub const FIXED_ONLY = 0x891D;
pub const MAX_VARYING_COMPONENTS = 0x8B4B;
pub const TEXTURE_1D_ARRAY = 0x8C18;
pub const PROXY_TEXTURE_1D_ARRAY = 0x8C19;
pub const TEXTURE_2D_ARRAY = 0x8C1A;
pub const PROXY_TEXTURE_2D_ARRAY = 0x8C1B;
pub const TEXTURE_BINDING_1D_ARRAY = 0x8C1C;
pub const TEXTURE_BINDING_2D_ARRAY = 0x8C1D;
pub const R11F_G11F_B10F = 0x8C3A;
pub const UNSIGNED_INT_10F_11F_11F_REV = 0x8C3B;
pub const RGB9_E5 = 0x8C3D;
pub const UNSIGNED_INT_5_9_9_9_REV = 0x8C3E;
pub const TEXTURE_SHARED_SIZE = 0x8C3F;
pub const TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = 0x8C76;
pub const TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7F;
pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80;
pub const TRANSFORM_FEEDBACK_VARYINGS = 0x8C83;
pub const TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84;
pub const TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85;
pub const PRIMITIVES_GENERATED = 0x8C87;
pub const TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88;
pub const RASTERIZER_DISCARD = 0x8C89;
pub const MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A;
pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8B;
pub const INTERLEAVED_ATTRIBS = 0x8C8C;
pub const SEPARATE_ATTRIBS = 0x8C8D;
pub const TRANSFORM_FEEDBACK_BUFFER = 0x8C8E;
pub const TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8F;
pub const RGBA32UI = 0x8D70;
pub const RGB32UI = 0x8D71;
pub const RGBA16UI = 0x8D76;
pub const RGB16UI = 0x8D77;
pub const RGBA8UI = 0x8D7C;
pub const RGB8UI = 0x8D7D;
pub const RGBA32I = 0x8D82;
pub const RGB32I = 0x8D83;
pub const RGBA16I = 0x8D88;
pub const RGB16I = 0x8D89;
pub const RGBA8I = 0x8D8E;
pub const RGB8I = 0x8D8F;
pub const RED_INTEGER = 0x8D94;
pub const GREEN_INTEGER = 0x8D95;
pub const BLUE_INTEGER = 0x8D96;
pub const RGB_INTEGER = 0x8D98;
pub const RGBA_INTEGER = 0x8D99;
pub const BGR_INTEGER = 0x8D9A;
pub const BGRA_INTEGER = 0x8D9B;
pub const SAMPLER_1D_ARRAY = 0x8DC0;
pub const SAMPLER_2D_ARRAY = 0x8DC1;
pub const SAMPLER_1D_ARRAY_SHADOW = 0x8DC3;
pub const SAMPLER_2D_ARRAY_SHADOW = 0x8DC4;
pub const SAMPLER_CUBE_SHADOW = 0x8DC5;
pub const UNSIGNED_INT_VEC2 = 0x8DC6;
pub const UNSIGNED_INT_VEC3 = 0x8DC7;
pub const UNSIGNED_INT_VEC4 = 0x8DC8;
pub const INT_SAMPLER_1D = 0x8DC9;
pub const INT_SAMPLER_2D = 0x8DCA;
pub const INT_SAMPLER_3D = 0x8DCB;
pub const INT_SAMPLER_CUBE = 0x8DCC;
pub const INT_SAMPLER_1D_ARRAY = 0x8DCE;
pub const INT_SAMPLER_2D_ARRAY = 0x8DCF;
pub const UNSIGNED_INT_SAMPLER_1D = 0x8DD1;
pub const UNSIGNED_INT_SAMPLER_2D = 0x8DD2;
pub const UNSIGNED_INT_SAMPLER_3D = 0x8DD3;
pub const UNSIGNED_INT_SAMPLER_CUBE = 0x8DD4;
pub const UNSIGNED_INT_SAMPLER_1D_ARRAY = 0x8DD6;
pub const UNSIGNED_INT_SAMPLER_2D_ARRAY = 0x8DD7;
pub const QUERY_WAIT = 0x8E13;
pub const QUERY_NO_WAIT = 0x8E14;
pub const QUERY_BY_REGION_WAIT = 0x8E15;
pub const QUERY_BY_REGION_NO_WAIT = 0x8E16;
pub const BUFFER_ACCESS_FLAGS = 0x911F;
pub const BUFFER_MAP_LENGTH = 0x9120;
pub const BUFFER_MAP_OFFSET = 0x9121;
pub const DEPTH_COMPONENT32F = 0x8CAC;
pub const DEPTH32F_STENCIL8 = 0x8CAD;
pub const FLOAT_32_UNSIGNED_INT_24_8_REV = 0x8DAD;
pub const INVALID_FRAMEBUFFER_OPERATION = 0x0506;
pub const FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210;
pub const FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211;
pub const FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212;
pub const FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213;
pub const FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214;
pub const FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215;
pub const FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216;
pub const FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217;
pub const FRAMEBUFFER_DEFAULT = 0x8218;
pub const FRAMEBUFFER_UNDEFINED = 0x8219;
pub const DEPTH_STENCIL_ATTACHMENT = 0x821A;
pub const MAX_RENDERBUFFER_SIZE = 0x84E8;
pub const DEPTH_STENCIL = 0x84F9;
pub const UNSIGNED_INT_24_8 = 0x84FA;
pub const DEPTH24_STENCIL8 = 0x88F0;
pub const TEXTURE_STENCIL_SIZE = 0x88F1;
pub const TEXTURE_RED_TYPE = 0x8C10;
pub const TEXTURE_GREEN_TYPE = 0x8C11;
pub const TEXTURE_BLUE_TYPE = 0x8C12;
pub const TEXTURE_ALPHA_TYPE = 0x8C13;
pub const TEXTURE_DEPTH_TYPE = 0x8C16;
pub const UNSIGNED_NORMALIZED = 0x8C17;
pub const FRAMEBUFFER_BINDING = 0x8CA6;
pub const DRAW_FRAMEBUFFER_BINDING = 0x8CA6;
pub const RENDERBUFFER_BINDING = 0x8CA7;
pub const READ_FRAMEBUFFER = 0x8CA8;
pub const DRAW_FRAMEBUFFER = 0x8CA9;
pub const READ_FRAMEBUFFER_BINDING = 0x8CAA;
pub const RENDERBUFFER_SAMPLES = 0x8CAB;
pub const FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0;
pub const FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4;
pub const FRAMEBUFFER_COMPLETE = 0x8CD5;
pub const FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6;
pub const FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
pub const FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER = 0x8CDB;
pub const FRAMEBUFFER_INCOMPLETE_READ_BUFFER = 0x8CDC;
pub const FRAMEBUFFER_UNSUPPORTED = 0x8CDD;
pub const MAX_COLOR_ATTACHMENTS = 0x8CDF;
pub const COLOR_ATTACHMENT0 = 0x8CE0;
pub const COLOR_ATTACHMENT1 = 0x8CE1;
pub const COLOR_ATTACHMENT2 = 0x8CE2;
pub const COLOR_ATTACHMENT3 = 0x8CE3;
pub const COLOR_ATTACHMENT4 = 0x8CE4;
pub const COLOR_ATTACHMENT5 = 0x8CE5;
pub const COLOR_ATTACHMENT6 = 0x8CE6;
pub const COLOR_ATTACHMENT7 = 0x8CE7;
pub const COLOR_ATTACHMENT8 = 0x8CE8;
pub const COLOR_ATTACHMENT9 = 0x8CE9;
pub const COLOR_ATTACHMENT10 = 0x8CEA;
pub const COLOR_ATTACHMENT11 = 0x8CEB;
pub const COLOR_ATTACHMENT12 = 0x8CEC;
pub const COLOR_ATTACHMENT13 = 0x8CED;
pub const COLOR_ATTACHMENT14 = 0x8CEE;
pub const COLOR_ATTACHMENT15 = 0x8CEF;
pub const COLOR_ATTACHMENT16 = 0x8CF0;
pub const COLOR_ATTACHMENT17 = 0x8CF1;
pub const COLOR_ATTACHMENT18 = 0x8CF2;
pub const COLOR_ATTACHMENT19 = 0x8CF3;
pub const COLOR_ATTACHMENT20 = 0x8CF4;
pub const COLOR_ATTACHMENT21 = 0x8CF5;
pub const COLOR_ATTACHMENT22 = 0x8CF6;
pub const COLOR_ATTACHMENT23 = 0x8CF7;
pub const COLOR_ATTACHMENT24 = 0x8CF8;
pub const COLOR_ATTACHMENT25 = 0x8CF9;
pub const COLOR_ATTACHMENT26 = 0x8CFA;
pub const COLOR_ATTACHMENT27 = 0x8CFB;
pub const COLOR_ATTACHMENT28 = 0x8CFC;
pub const COLOR_ATTACHMENT29 = 0x8CFD;
pub const COLOR_ATTACHMENT30 = 0x8CFE;
pub const COLOR_ATTACHMENT31 = 0x8CFF;
pub const DEPTH_ATTACHMENT = 0x8D00;
pub const STENCIL_ATTACHMENT = 0x8D20;
pub const FRAMEBUFFER = 0x8D40;
pub const RENDERBUFFER = 0x8D41;
pub const RENDERBUFFER_WIDTH = 0x8D42;
pub const RENDERBUFFER_HEIGHT = 0x8D43;
pub const RENDERBUFFER_INTERNAL_FORMAT = 0x8D44;
pub const STENCIL_INDEX1 = 0x8D46;
pub const STENCIL_INDEX4 = 0x8D47;
pub const STENCIL_INDEX8 = 0x8D48;
pub const STENCIL_INDEX16 = 0x8D49;
pub const RENDERBUFFER_RED_SIZE = 0x8D50;
pub const RENDERBUFFER_GREEN_SIZE = 0x8D51;
pub const RENDERBUFFER_BLUE_SIZE = 0x8D52;
pub const RENDERBUFFER_ALPHA_SIZE = 0x8D53;
pub const RENDERBUFFER_DEPTH_SIZE = 0x8D54;
pub const RENDERBUFFER_STENCIL_SIZE = 0x8D55;
pub const FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56;
pub const MAX_SAMPLES = 0x8D57;
pub const LINES_ADJACENCY = 0x000A;
pub const CONTEXT_COMPATIBILITY_PROFILE_BIT = 0x00000002;
pub const CONTEXT_CORE_PROFILE_BIT = 0x00000001;
pub const FRAMEBUFFER_SRGB = 0x8DB9;
pub const HALF_FLOAT = 0x140B;
pub const MAP_READ_BIT = 0x0001;
pub const MAP_WRITE_BIT = 0x0002;
pub const MAP_INVALIDATE_RANGE_BIT = 0x0004;
pub const MAP_INVALIDATE_BUFFER_BIT = 0x0008;
pub const MAP_FLUSH_EXPLICIT_BIT = 0x0010;
pub const MAP_UNSYNCHRONIZED_BIT = 0x0020;
pub const COMPRESSED_RED_RGTC1 = 0x8DBB;
pub const COMPRESSED_SIGNED_RED_RGTC1 = 0x8DBC;
pub const COMPRESSED_RG_RGTC2 = 0x8DBD;
pub const COMPRESSED_SIGNED_RG_RGTC2 = 0x8DBE;
pub const RG = 0x8227;
pub const RG_INTEGER = 0x8228;
pub const R8 = 0x8229;
pub const R16 = 0x822A;
pub const RG8 = 0x822B;
pub const RG16 = 0x822C;
pub const R16F = 0x822D;
pub const R32F = 0x822E;
pub const RG16F = 0x822F;
pub const RG32F = 0x8230;
pub const R8I = 0x8231;
pub const R8UI = 0x8232;
pub const R16I = 0x8233;
pub const R16UI = 0x8234;
pub const R32I = 0x8235;
pub const R32UI = 0x8236;
pub const RG8I = 0x8237;
pub const RG8UI = 0x8238;
pub const RG16I = 0x8239;
pub const RG16UI = 0x823A;
pub const RG32I = 0x823B;
pub const RG32UI = 0x823C;
pub const VERTEX_ARRAY_BINDING = 0x85B5;
pub const TRIANGLE_STRIP_ADJACENCY = 0x000D;
pub const TRIANGLES_ADJACENCY = 0x000C;
pub const LINE_STRIP_ADJACENCY = 0x000B;
pub const SAMPLER_2D_RECT = 0x8B63;
pub const SAMPLER_2D_RECT_SHADOW = 0x8B64;
pub const SAMPLER_BUFFER = 0x8DC2;
pub const INT_SAMPLER_2D_RECT = 0x8DCD;
pub const INT_SAMPLER_BUFFER = 0x8DD0;
pub const UNSIGNED_INT_SAMPLER_2D_RECT = 0x8DD5;
pub const UNSIGNED_INT_SAMPLER_BUFFER = 0x8DD8;
pub const TEXTURE_BUFFER = 0x8C2A;
pub const MAX_TEXTURE_BUFFER_SIZE = 0x8C2B;
pub const TEXTURE_BINDING_BUFFER = 0x8C2C;
pub const TEXTURE_BUFFER_DATA_STORE_BINDING = 0x8C2D;
pub const TEXTURE_RECTANGLE = 0x84F5;
pub const TEXTURE_BINDING_RECTANGLE = 0x84F6;
pub const PROXY_TEXTURE_RECTANGLE = 0x84F7;
pub const MAX_RECTANGLE_TEXTURE_SIZE = 0x84F8;
pub const R8_SNORM = 0x8F94;
pub const RG8_SNORM = 0x8F95;
pub const RGB8_SNORM = 0x8F96;
pub const RGBA8_SNORM = 0x8F97;
pub const R16_SNORM = 0x8F98;
pub const RG16_SNORM = 0x8F99;
pub const RGB16_SNORM = 0x8F9A;
pub const RGBA16_SNORM = 0x8F9B;
pub const SIGNED_NORMALIZED = 0x8F9C;
pub const PRIMITIVE_RESTART = 0x8F9D;
pub const PRIMITIVE_RESTART_INDEX = 0x8F9E;
pub const COPY_READ_BUFFER = 0x8F36;
pub const COPY_WRITE_BUFFER = 0x8F37;
pub const UNIFORM_BUFFER = 0x8A11;
pub const UNIFORM_BUFFER_BINDING = 0x8A28;
pub const UNIFORM_BUFFER_START = 0x8A29;
pub const UNIFORM_BUFFER_SIZE = 0x8A2A;
pub const MAX_VERTEX_UNIFORM_BLOCKS = 0x8A2B;
pub const MAX_GEOMETRY_UNIFORM_BLOCKS = 0x8A2C;
pub const MAX_FRAGMENT_UNIFORM_BLOCKS = 0x8A2D;
pub const MAX_COMBINED_UNIFORM_BLOCKS = 0x8A2E;
pub const MAX_UNIFORM_BUFFER_BINDINGS = 0x8A2F;
pub const MAX_UNIFORM_BLOCK_SIZE = 0x8A30;
pub const MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31;
pub const MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS = 0x8A32;
pub const MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33;
pub const UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34;
pub const ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = 0x8A35;
pub const ACTIVE_UNIFORM_BLOCKS = 0x8A36;
pub const UNIFORM_TYPE = 0x8A37;
pub const UNIFORM_SIZE = 0x8A38;
pub const UNIFORM_NAME_LENGTH = 0x8A39;
pub const UNIFORM_BLOCK_INDEX = 0x8A3A;
pub const UNIFORM_OFFSET = 0x8A3B;
pub const UNIFORM_ARRAY_STRIDE = 0x8A3C;
pub const UNIFORM_MATRIX_STRIDE = 0x8A3D;
pub const UNIFORM_IS_ROW_MAJOR = 0x8A3E;
pub const UNIFORM_BLOCK_BINDING = 0x8A3F;
pub const UNIFORM_BLOCK_DATA_SIZE = 0x8A40;
pub const UNIFORM_BLOCK_NAME_LENGTH = 0x8A41;
pub const UNIFORM_BLOCK_ACTIVE_UNIFORMS = 0x8A42;
pub const UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43;
pub const UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44;
pub const UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = 0x8A45;
pub const UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46;
pub const INVALID_INDEX = 0xFFFFFFFF;


pub fn getDoublei_v(_target: GLenum, _index: GLuint, _data: [*c]GLdouble) void {
    return (function_pointers.glGetDoublei_v orelse @panic("glGetDoublei_v was not bound."))(_target, _index, _data);
}

pub fn getFloati_v(_target: GLenum, _index: GLuint, _data: [*c]GLfloat) void {
    return (function_pointers.glGetFloati_v orelse @panic("glGetFloati_v was not bound."))(_target, _index, _data);
}

pub fn depthRangeIndexed(_index: GLuint, _n: GLdouble, _f: GLdouble) void {
    return (function_pointers.glDepthRangeIndexed orelse @panic("glDepthRangeIndexed was not bound."))(_index, _n, _f);
}

pub fn depthRangeArrayv(_first: GLuint, _count: GLsizei, _v: [*c]const GLdouble) void {
    return (function_pointers.glDepthRangeArrayv orelse @panic("glDepthRangeArrayv was not bound."))(_first, _count, _v);
}

pub fn scissorIndexedv(_index: GLuint, _v: [*c]const GLint) void {
    return (function_pointers.glScissorIndexedv orelse @panic("glScissorIndexedv was not bound."))(_index, _v);
}

pub fn scissorIndexed(_index: GLuint, _left: GLint, _bottom: GLint, _width: GLsizei, _height: GLsizei) void {
    return (function_pointers.glScissorIndexed orelse @panic("glScissorIndexed was not bound."))(_index, _left, _bottom, _width, _height);
}

pub fn scissorArrayv(_first: GLuint, _count: GLsizei, _v: [*c]const GLint) void {
    return (function_pointers.glScissorArrayv orelse @panic("glScissorArrayv was not bound."))(_first, _count, _v);
}

pub fn viewportIndexedfv(_index: GLuint, _v: [*c]const GLfloat) void {
    return (function_pointers.glViewportIndexedfv orelse @panic("glViewportIndexedfv was not bound."))(_index, _v);
}

pub fn viewportIndexedf(_index: GLuint, _x: GLfloat, _y: GLfloat, _w: GLfloat, _h: GLfloat) void {
    return (function_pointers.glViewportIndexedf orelse @panic("glViewportIndexedf was not bound."))(_index, _x, _y, _w, _h);
}

pub fn viewportArrayv(_first: GLuint, _count: GLsizei, _v: [*c]const GLfloat) void {
    return (function_pointers.glViewportArrayv orelse @panic("glViewportArrayv was not bound."))(_first, _count, _v);
}

pub fn getVertexAttribLdv(_index: GLuint, _pname: GLenum, _params: [*c]GLdouble) void {
    return (function_pointers.glGetVertexAttribLdv orelse @panic("glGetVertexAttribLdv was not bound."))(_index, _pname, _params);
}

pub fn vertexAttribLPointer(_index: GLuint, _size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    return (function_pointers.glVertexAttribLPointer orelse @panic("glVertexAttribLPointer was not bound."))(_index, _size, _type, _stride, _pointer);
}

pub fn vertexAttribL4dv(_index: GLuint, _v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttribL4dv orelse @panic("glVertexAttribL4dv was not bound."))(_index, _v);
}

pub fn vertexAttribL3dv(_index: GLuint, _v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttribL3dv orelse @panic("glVertexAttribL3dv was not bound."))(_index, _v);
}

pub fn vertexAttribL2dv(_index: GLuint, _v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttribL2dv orelse @panic("glVertexAttribL2dv was not bound."))(_index, _v);
}

pub fn vertexAttribL1dv(_index: GLuint, _v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttribL1dv orelse @panic("glVertexAttribL1dv was not bound."))(_index, _v);
}

pub fn vertexAttribL4d(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) void {
    return (function_pointers.glVertexAttribL4d orelse @panic("glVertexAttribL4d was not bound."))(_index, _x, _y, _z, _w);
}

pub fn vertexAttribL3d(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble) void {
    return (function_pointers.glVertexAttribL3d orelse @panic("glVertexAttribL3d was not bound."))(_index, _x, _y, _z);
}

pub fn vertexAttribL2d(_index: GLuint, _x: GLdouble, _y: GLdouble) void {
    return (function_pointers.glVertexAttribL2d orelse @panic("glVertexAttribL2d was not bound."))(_index, _x, _y);
}

pub fn vertexAttribL1d(_index: GLuint, _x: GLdouble) void {
    return (function_pointers.glVertexAttribL1d orelse @panic("glVertexAttribL1d was not bound."))(_index, _x);
}

pub fn validateProgramPipeline(_pipeline: GLuint) void {
    return (function_pointers.glValidateProgramPipeline orelse @panic("glValidateProgramPipeline was not bound."))(_pipeline);
}

pub fn programUniformMatrix4x3dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix4x3dv orelse @panic("glProgramUniformMatrix4x3dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix3x4dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix3x4dv orelse @panic("glProgramUniformMatrix3x4dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix4x2dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix4x2dv orelse @panic("glProgramUniformMatrix4x2dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix2x4dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix2x4dv orelse @panic("glProgramUniformMatrix2x4dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix3x2dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix3x2dv orelse @panic("glProgramUniformMatrix3x2dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix2x3dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix2x3dv orelse @panic("glProgramUniformMatrix2x3dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix4x3fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix4x3fv orelse @panic("glProgramUniformMatrix4x3fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix3x4fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix3x4fv orelse @panic("glProgramUniformMatrix3x4fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix4x2fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix4x2fv orelse @panic("glProgramUniformMatrix4x2fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix2x4fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix2x4fv orelse @panic("glProgramUniformMatrix2x4fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix3x2fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix3x2fv orelse @panic("glProgramUniformMatrix3x2fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix2x3fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix2x3fv orelse @panic("glProgramUniformMatrix2x3fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix4dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix4dv orelse @panic("glProgramUniformMatrix4dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix3dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix3dv orelse @panic("glProgramUniformMatrix3dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix2dv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniformMatrix2dv orelse @panic("glProgramUniformMatrix2dv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix4fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix4fv orelse @panic("glProgramUniformMatrix4fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix3fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix3fv orelse @panic("glProgramUniformMatrix3fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniformMatrix2fv(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniformMatrix2fv orelse @panic("glProgramUniformMatrix2fv was not bound."))(_program, _location, _count, _transpose, _value);
}

pub fn programUniform4uiv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLuint) void {
    return (function_pointers.glProgramUniform4uiv orelse @panic("glProgramUniform4uiv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform4ui(_program: GLuint, _location: GLint, _v0: GLuint, _v1: GLuint, _v2: GLuint, _v3: GLuint) void {
    return (function_pointers.glProgramUniform4ui orelse @panic("glProgramUniform4ui was not bound."))(_program, _location, _v0, _v1, _v2, _v3);
}

pub fn programUniform4dv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniform4dv orelse @panic("glProgramUniform4dv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform4d(_program: GLuint, _location: GLint, _v0: GLdouble, _v1: GLdouble, _v2: GLdouble, _v3: GLdouble) void {
    return (function_pointers.glProgramUniform4d orelse @panic("glProgramUniform4d was not bound."))(_program, _location, _v0, _v1, _v2, _v3);
}

pub fn programUniform4fv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniform4fv orelse @panic("glProgramUniform4fv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform4f(_program: GLuint, _location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat, _v3: GLfloat) void {
    return (function_pointers.glProgramUniform4f orelse @panic("glProgramUniform4f was not bound."))(_program, _location, _v0, _v1, _v2, _v3);
}

pub fn programUniform4iv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLint) void {
    return (function_pointers.glProgramUniform4iv orelse @panic("glProgramUniform4iv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform4i(_program: GLuint, _location: GLint, _v0: GLint, _v1: GLint, _v2: GLint, _v3: GLint) void {
    return (function_pointers.glProgramUniform4i orelse @panic("glProgramUniform4i was not bound."))(_program, _location, _v0, _v1, _v2, _v3);
}

pub fn programUniform3uiv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLuint) void {
    return (function_pointers.glProgramUniform3uiv orelse @panic("glProgramUniform3uiv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform3ui(_program: GLuint, _location: GLint, _v0: GLuint, _v1: GLuint, _v2: GLuint) void {
    return (function_pointers.glProgramUniform3ui orelse @panic("glProgramUniform3ui was not bound."))(_program, _location, _v0, _v1, _v2);
}

pub fn programUniform3dv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniform3dv orelse @panic("glProgramUniform3dv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform3d(_program: GLuint, _location: GLint, _v0: GLdouble, _v1: GLdouble, _v2: GLdouble) void {
    return (function_pointers.glProgramUniform3d orelse @panic("glProgramUniform3d was not bound."))(_program, _location, _v0, _v1, _v2);
}

pub fn programUniform3fv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniform3fv orelse @panic("glProgramUniform3fv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform3f(_program: GLuint, _location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat) void {
    return (function_pointers.glProgramUniform3f orelse @panic("glProgramUniform3f was not bound."))(_program, _location, _v0, _v1, _v2);
}

pub fn programUniform3iv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLint) void {
    return (function_pointers.glProgramUniform3iv orelse @panic("glProgramUniform3iv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform3i(_program: GLuint, _location: GLint, _v0: GLint, _v1: GLint, _v2: GLint) void {
    return (function_pointers.glProgramUniform3i orelse @panic("glProgramUniform3i was not bound."))(_program, _location, _v0, _v1, _v2);
}

pub fn useProgramStages(_pipeline: GLuint, _stages: GLbitfield, _program: GLuint) void {
    return (function_pointers.glUseProgramStages orelse @panic("glUseProgramStages was not bound."))(_pipeline, _stages, _program);
}

pub fn programParameteri(_program: GLuint, _pname: GLenum, _value: GLint) void {
    return (function_pointers.glProgramParameteri orelse @panic("glProgramParameteri was not bound."))(_program, _pname, _value);
}

pub fn getShaderPrecisionFormat(_shadertype: GLenum, _precisiontype: GLenum, _range: [*c]GLint, _precision: [*c]GLint) void {
    return (function_pointers.glGetShaderPrecisionFormat orelse @panic("glGetShaderPrecisionFormat was not bound."))(_shadertype, _precisiontype, _range, _precision);
}

pub fn shaderBinary(_count: GLsizei, _shaders: [*c]const GLuint, _binaryFormat: GLenum, _binary: ?*const anyopaque, _length: GLsizei) void {
    return (function_pointers.glShaderBinary orelse @panic("glShaderBinary was not bound."))(_count, _shaders, _binaryFormat, _binary, _length);
}

pub fn releaseShaderCompiler() void {
    return (function_pointers.glReleaseShaderCompiler orelse @panic("glReleaseShaderCompiler was not bound."))();
}

pub fn getQueryIndexediv(_target: GLenum, _index: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetQueryIndexediv orelse @panic("glGetQueryIndexediv was not bound."))(_target, _index, _pname, _params);
}

pub fn endQueryIndexed(_target: GLenum, _index: GLuint) void {
    return (function_pointers.glEndQueryIndexed orelse @panic("glEndQueryIndexed was not bound."))(_target, _index);
}

pub fn beginQueryIndexed(_target: GLenum, _index: GLuint, _id: GLuint) void {
    return (function_pointers.glBeginQueryIndexed orelse @panic("glBeginQueryIndexed was not bound."))(_target, _index, _id);
}

pub fn drawTransformFeedbackStream(_mode: GLenum, _id: GLuint, _stream: GLuint) void {
    return (function_pointers.glDrawTransformFeedbackStream orelse @panic("glDrawTransformFeedbackStream was not bound."))(_mode, _id, _stream);
}

pub fn drawTransformFeedback(_mode: GLenum, _id: GLuint) void {
    return (function_pointers.glDrawTransformFeedback orelse @panic("glDrawTransformFeedback was not bound."))(_mode, _id);
}

pub fn resumeTransformFeedback() void {
    return (function_pointers.glResumeTransformFeedback orelse @panic("glResumeTransformFeedback was not bound."))();
}

pub fn pauseTransformFeedback() void {
    return (function_pointers.glPauseTransformFeedback orelse @panic("glPauseTransformFeedback was not bound."))();
}

pub fn getProgramStageiv(_program: GLuint, _shadertype: GLenum, _pname: GLenum, _values: [*c]GLint) void {
    return (function_pointers.glGetProgramStageiv orelse @panic("glGetProgramStageiv was not bound."))(_program, _shadertype, _pname, _values);
}

pub fn getUniformSubroutineuiv(_shadertype: GLenum, _location: GLint, _params: [*c]GLuint) void {
    return (function_pointers.glGetUniformSubroutineuiv orelse @panic("glGetUniformSubroutineuiv was not bound."))(_shadertype, _location, _params);
}

pub fn uniformSubroutinesuiv(_shadertype: GLenum, _count: GLsizei, _indices: [*c]const GLuint) void {
    return (function_pointers.glUniformSubroutinesuiv orelse @panic("glUniformSubroutinesuiv was not bound."))(_shadertype, _count, _indices);
}

pub fn getActiveSubroutineName(_program: GLuint, _shadertype: GLenum, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _name: [*c]GLchar) void {
    return (function_pointers.glGetActiveSubroutineName orelse @panic("glGetActiveSubroutineName was not bound."))(_program, _shadertype, _index, _bufSize, _length, _name);
}

pub fn cullFace(_mode: GLenum) void {
    return (function_pointers.glCullFace orelse @panic("glCullFace was not bound."))(_mode);
}

pub fn frontFace(_mode: GLenum) void {
    return (function_pointers.glFrontFace orelse @panic("glFrontFace was not bound."))(_mode);
}

pub fn hint(_target: GLenum, _mode: GLenum) void {
    return (function_pointers.glHint orelse @panic("glHint was not bound."))(_target, _mode);
}

pub fn lineWidth(_width: GLfloat) void {
    return (function_pointers.glLineWidth orelse @panic("glLineWidth was not bound."))(_width);
}

pub fn pointSize(_size: GLfloat) void {
    return (function_pointers.glPointSize orelse @panic("glPointSize was not bound."))(_size);
}

pub fn polygonMode(_face: GLenum, _mode: GLenum) void {
    return (function_pointers.glPolygonMode orelse @panic("glPolygonMode was not bound."))(_face, _mode);
}

pub fn scissor(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void {
    return (function_pointers.glScissor orelse @panic("glScissor was not bound."))(_x, _y, _width, _height);
}

pub fn texParameterf(_target: GLenum, _pname: GLenum, _param: GLfloat) void {
    return (function_pointers.glTexParameterf orelse @panic("glTexParameterf was not bound."))(_target, _pname, _param);
}

pub fn texParameterfv(_target: GLenum, _pname: GLenum, _params: [*c]const GLfloat) void {
    return (function_pointers.glTexParameterfv orelse @panic("glTexParameterfv was not bound."))(_target, _pname, _params);
}

pub fn texParameteri(_target: GLenum, _pname: GLenum, _param: GLint) void {
    return (function_pointers.glTexParameteri orelse @panic("glTexParameteri was not bound."))(_target, _pname, _param);
}

pub fn texParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]const GLint) void {
    return (function_pointers.glTexParameteriv orelse @panic("glTexParameteriv was not bound."))(_target, _pname, _params);
}

pub fn texImage1D(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    return (function_pointers.glTexImage1D orelse @panic("glTexImage1D was not bound."))(_target, _level, _internalformat, _width, _border, _format, _type, _pixels);
}

pub fn texImage2D(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    return (function_pointers.glTexImage2D orelse @panic("glTexImage2D was not bound."))(_target, _level, _internalformat, _width, _height, _border, _format, _type, _pixels);
}

pub fn drawBuffer(_buf: GLenum) void {
    return (function_pointers.glDrawBuffer orelse @panic("glDrawBuffer was not bound."))(_buf);
}

pub fn clear(_mask: GLbitfield) void {
    return (function_pointers.glClear orelse @panic("glClear was not bound."))(_mask);
}

pub fn clearColor(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) void {
    return (function_pointers.glClearColor orelse @panic("glClearColor was not bound."))(_red, _green, _blue, _alpha);
}

pub fn clearStencil(_s: GLint) void {
    return (function_pointers.glClearStencil orelse @panic("glClearStencil was not bound."))(_s);
}

pub fn clearDepth(_depth: GLdouble) void {
    return (function_pointers.glClearDepth orelse @panic("glClearDepth was not bound."))(_depth);
}

pub fn stencilMask(_mask: GLuint) void {
    return (function_pointers.glStencilMask orelse @panic("glStencilMask was not bound."))(_mask);
}

pub fn colorMask(_red: GLboolean, _green: GLboolean, _blue: GLboolean, _alpha: GLboolean) void {
    return (function_pointers.glColorMask orelse @panic("glColorMask was not bound."))(_red, _green, _blue, _alpha);
}

pub fn depthMask(_flag: GLboolean) void {
    return (function_pointers.glDepthMask orelse @panic("glDepthMask was not bound."))(_flag);
}

pub fn disable(_cap: GLenum) void {
    return (function_pointers.glDisable orelse @panic("glDisable was not bound."))(_cap);
}

pub fn enable(_cap: GLenum) void {
    return (function_pointers.glEnable orelse @panic("glEnable was not bound."))(_cap);
}

pub fn finish() void {
    return (function_pointers.glFinish orelse @panic("glFinish was not bound."))();
}

pub fn flush() void {
    return (function_pointers.glFlush orelse @panic("glFlush was not bound."))();
}

pub fn blendFunc(_sfactor: GLenum, _dfactor: GLenum) void {
    return (function_pointers.glBlendFunc orelse @panic("glBlendFunc was not bound."))(_sfactor, _dfactor);
}

pub fn logicOp(_opcode: GLenum) void {
    return (function_pointers.glLogicOp orelse @panic("glLogicOp was not bound."))(_opcode);
}

pub fn stencilFunc(_func: GLenum, _ref: GLint, _mask: GLuint) void {
    return (function_pointers.glStencilFunc orelse @panic("glStencilFunc was not bound."))(_func, _ref, _mask);
}

pub fn stencilOp(_fail: GLenum, _zfail: GLenum, _zpass: GLenum) void {
    return (function_pointers.glStencilOp orelse @panic("glStencilOp was not bound."))(_fail, _zfail, _zpass);
}

pub fn depthFunc(_func: GLenum) void {
    return (function_pointers.glDepthFunc orelse @panic("glDepthFunc was not bound."))(_func);
}

pub fn pixelStoref(_pname: GLenum, _param: GLfloat) void {
    return (function_pointers.glPixelStoref orelse @panic("glPixelStoref was not bound."))(_pname, _param);
}

pub fn pixelStorei(_pname: GLenum, _param: GLint) void {
    return (function_pointers.glPixelStorei orelse @panic("glPixelStorei was not bound."))(_pname, _param);
}

pub fn readBuffer(_src: GLenum) void {
    return (function_pointers.glReadBuffer orelse @panic("glReadBuffer was not bound."))(_src);
}

pub fn readPixels(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) void {
    return (function_pointers.glReadPixels orelse @panic("glReadPixels was not bound."))(_x, _y, _width, _height, _format, _type, _pixels);
}

pub fn getBooleanv(_pname: GLenum, _data: [*c]GLboolean) void {
    return (function_pointers.glGetBooleanv orelse @panic("glGetBooleanv was not bound."))(_pname, _data);
}

pub fn getDoublev(_pname: GLenum, _data: [*c]GLdouble) void {
    return (function_pointers.glGetDoublev orelse @panic("glGetDoublev was not bound."))(_pname, _data);
}

pub fn getError() GLenum {
    return (function_pointers.glGetError orelse @panic("glGetError was not bound."))();
}

pub fn getFloatv(_pname: GLenum, _data: [*c]GLfloat) void {
    return (function_pointers.glGetFloatv orelse @panic("glGetFloatv was not bound."))(_pname, _data);
}

pub fn getIntegerv(_pname: GLenum, _data: [*c]GLint) void {
    return (function_pointers.glGetIntegerv orelse @panic("glGetIntegerv was not bound."))(_pname, _data);
}

pub fn getString(_name: GLenum) ?[*:0]const GLubyte {
    return (function_pointers.glGetString orelse @panic("glGetString was not bound."))(_name);
}

pub fn getTexImage(_target: GLenum, _level: GLint, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) void {
    return (function_pointers.glGetTexImage orelse @panic("glGetTexImage was not bound."))(_target, _level, _format, _type, _pixels);
}

pub fn getTexParameterfv(_target: GLenum, _pname: GLenum, _params: [*c]GLfloat) void {
    return (function_pointers.glGetTexParameterfv orelse @panic("glGetTexParameterfv was not bound."))(_target, _pname, _params);
}

pub fn getTexParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetTexParameteriv orelse @panic("glGetTexParameteriv was not bound."))(_target, _pname, _params);
}

pub fn getTexLevelParameterfv(_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLfloat) void {
    return (function_pointers.glGetTexLevelParameterfv orelse @panic("glGetTexLevelParameterfv was not bound."))(_target, _level, _pname, _params);
}

pub fn getTexLevelParameteriv(_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetTexLevelParameteriv orelse @panic("glGetTexLevelParameteriv was not bound."))(_target, _level, _pname, _params);
}

pub fn isEnabled(_cap: GLenum) GLboolean {
    return (function_pointers.glIsEnabled orelse @panic("glIsEnabled was not bound."))(_cap);
}

pub fn depthRange(_n: GLdouble, _f: GLdouble) void {
    return (function_pointers.glDepthRange orelse @panic("glDepthRange was not bound."))(_n, _f);
}

pub fn viewport(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void {
    return (function_pointers.glViewport orelse @panic("glViewport was not bound."))(_x, _y, _width, _height);
}

pub fn getProgramPipelineInfoLog(_pipeline: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) void {
    return (function_pointers.glGetProgramPipelineInfoLog orelse @panic("glGetProgramPipelineInfoLog was not bound."))(_pipeline, _bufSize, _length, _infoLog);
}

pub fn programUniform2uiv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLuint) void {
    return (function_pointers.glProgramUniform2uiv orelse @panic("glProgramUniform2uiv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform2ui(_program: GLuint, _location: GLint, _v0: GLuint, _v1: GLuint) void {
    return (function_pointers.glProgramUniform2ui orelse @panic("glProgramUniform2ui was not bound."))(_program, _location, _v0, _v1);
}

pub fn programUniform2dv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniform2dv orelse @panic("glProgramUniform2dv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform2d(_program: GLuint, _location: GLint, _v0: GLdouble, _v1: GLdouble) void {
    return (function_pointers.glProgramUniform2d orelse @panic("glProgramUniform2d was not bound."))(_program, _location, _v0, _v1);
}

pub fn programUniform2fv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniform2fv orelse @panic("glProgramUniform2fv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform2f(_program: GLuint, _location: GLint, _v0: GLfloat, _v1: GLfloat) void {
    return (function_pointers.glProgramUniform2f orelse @panic("glProgramUniform2f was not bound."))(_program, _location, _v0, _v1);
}

pub fn programUniform2iv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLint) void {
    return (function_pointers.glProgramUniform2iv orelse @panic("glProgramUniform2iv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform2i(_program: GLuint, _location: GLint, _v0: GLint, _v1: GLint) void {
    return (function_pointers.glProgramUniform2i orelse @panic("glProgramUniform2i was not bound."))(_program, _location, _v0, _v1);
}

pub fn programUniform1uiv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLuint) void {
    return (function_pointers.glProgramUniform1uiv orelse @panic("glProgramUniform1uiv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform1ui(_program: GLuint, _location: GLint, _v0: GLuint) void {
    return (function_pointers.glProgramUniform1ui orelse @panic("glProgramUniform1ui was not bound."))(_program, _location, _v0);
}

pub fn programUniform1dv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void {
    return (function_pointers.glProgramUniform1dv orelse @panic("glProgramUniform1dv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform1d(_program: GLuint, _location: GLint, _v0: GLdouble) void {
    return (function_pointers.glProgramUniform1d orelse @panic("glProgramUniform1d was not bound."))(_program, _location, _v0);
}

pub fn programUniform1fv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void {
    return (function_pointers.glProgramUniform1fv orelse @panic("glProgramUniform1fv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform1f(_program: GLuint, _location: GLint, _v0: GLfloat) void {
    return (function_pointers.glProgramUniform1f orelse @panic("glProgramUniform1f was not bound."))(_program, _location, _v0);
}

pub fn programUniform1iv(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLint) void {
    return (function_pointers.glProgramUniform1iv orelse @panic("glProgramUniform1iv was not bound."))(_program, _location, _count, _value);
}

pub fn programUniform1i(_program: GLuint, _location: GLint, _v0: GLint) void {
    return (function_pointers.glProgramUniform1i orelse @panic("glProgramUniform1i was not bound."))(_program, _location, _v0);
}

pub fn getProgramPipelineiv(_pipeline: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetProgramPipelineiv orelse @panic("glGetProgramPipelineiv was not bound."))(_pipeline, _pname, _params);
}

pub fn isProgramPipeline(_pipeline: GLuint) GLboolean {
    return (function_pointers.glIsProgramPipeline orelse @panic("glIsProgramPipeline was not bound."))(_pipeline);
}

pub fn genProgramPipelines(_n: GLsizei, _pipelines: [*c]GLuint) void {
    return (function_pointers.glGenProgramPipelines orelse @panic("glGenProgramPipelines was not bound."))(_n, _pipelines);
}

pub fn deleteProgramPipelines(_n: GLsizei, _pipelines: [*c]const GLuint) void {
    return (function_pointers.glDeleteProgramPipelines orelse @panic("glDeleteProgramPipelines was not bound."))(_n, _pipelines);
}

pub fn bindProgramPipeline(_pipeline: GLuint) void {
    return (function_pointers.glBindProgramPipeline orelse @panic("glBindProgramPipeline was not bound."))(_pipeline);
}

pub fn createShaderProgramv(_type: GLenum, _count: GLsizei, _strings: *[:0]const GLchar) GLuint {
    return (function_pointers.glCreateShaderProgramv orelse @panic("glCreateShaderProgramv was not bound."))(_type, _count, _strings);
}

pub fn activeShaderProgram(_pipeline: GLuint, _program: GLuint) void {
    return (function_pointers.glActiveShaderProgram orelse @panic("glActiveShaderProgram was not bound."))(_pipeline, _program);
}

pub fn programBinary(_program: GLuint, _binaryFormat: GLenum, _binary: ?*const anyopaque, _length: GLsizei) void {
    return (function_pointers.glProgramBinary orelse @panic("glProgramBinary was not bound."))(_program, _binaryFormat, _binary, _length);
}

pub fn getProgramBinary(_program: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _binaryFormat: [*c]GLenum, _binary: ?*anyopaque) void {
    return (function_pointers.glGetProgramBinary orelse @panic("glGetProgramBinary was not bound."))(_program, _bufSize, _length, _binaryFormat, _binary);
}

pub fn clearDepthf(_d: GLfloat) void {
    return (function_pointers.glClearDepthf orelse @panic("glClearDepthf was not bound."))(_d);
}

pub fn depthRangef(_n: GLfloat, _f: GLfloat) void {
    return (function_pointers.glDepthRangef orelse @panic("glDepthRangef was not bound."))(_n, _f);
}

pub fn isTransformFeedback(_id: GLuint) GLboolean {
    return (function_pointers.glIsTransformFeedback orelse @panic("glIsTransformFeedback was not bound."))(_id);
}

pub fn genTransformFeedbacks(_n: GLsizei, _ids: [*c]GLuint) void {
    return (function_pointers.glGenTransformFeedbacks orelse @panic("glGenTransformFeedbacks was not bound."))(_n, _ids);
}

pub fn deleteTransformFeedbacks(_n: GLsizei, _ids: [*c]const GLuint) void {
    return (function_pointers.glDeleteTransformFeedbacks orelse @panic("glDeleteTransformFeedbacks was not bound."))(_n, _ids);
}

pub fn bindTransformFeedback(_target: GLenum, _id: GLuint) void {
    return (function_pointers.glBindTransformFeedback orelse @panic("glBindTransformFeedback was not bound."))(_target, _id);
}

pub fn patchParameterfv(_pname: GLenum, _values: [*c]const GLfloat) void {
    return (function_pointers.glPatchParameterfv orelse @panic("glPatchParameterfv was not bound."))(_pname, _values);
}

pub fn patchParameteri(_pname: GLenum, _value: GLint) void {
    return (function_pointers.glPatchParameteri orelse @panic("glPatchParameteri was not bound."))(_pname, _value);
}

pub fn drawArrays(_mode: GLenum, _first: GLint, _count: GLsizei) void {
    return (function_pointers.glDrawArrays orelse @panic("glDrawArrays was not bound."))(_mode, _first, _count);
}

pub fn drawElements(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) void {
    return (function_pointers.glDrawElements orelse @panic("glDrawElements was not bound."))(_mode, _count, _type, _indices);
}

pub fn polygonOffset(_factor: GLfloat, _units: GLfloat) void {
    return (function_pointers.glPolygonOffset orelse @panic("glPolygonOffset was not bound."))(_factor, _units);
}

pub fn copyTexImage1D(_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _border: GLint) void {
    return (function_pointers.glCopyTexImage1D orelse @panic("glCopyTexImage1D was not bound."))(_target, _level, _internalformat, _x, _y, _width, _border);
}

pub fn copyTexImage2D(_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _border: GLint) void {
    return (function_pointers.glCopyTexImage2D orelse @panic("glCopyTexImage2D was not bound."))(_target, _level, _internalformat, _x, _y, _width, _height, _border);
}

pub fn copyTexSubImage1D(_target: GLenum, _level: GLint, _xoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei) void {
    return (function_pointers.glCopyTexSubImage1D orelse @panic("glCopyTexSubImage1D was not bound."))(_target, _level, _xoffset, _x, _y, _width);
}

pub fn copyTexSubImage2D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void {
    return (function_pointers.glCopyTexSubImage2D orelse @panic("glCopyTexSubImage2D was not bound."))(_target, _level, _xoffset, _yoffset, _x, _y, _width, _height);
}

pub fn texSubImage1D(_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    return (function_pointers.glTexSubImage1D orelse @panic("glTexSubImage1D was not bound."))(_target, _level, _xoffset, _width, _format, _type, _pixels);
}

pub fn texSubImage2D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    return (function_pointers.glTexSubImage2D orelse @panic("glTexSubImage2D was not bound."))(_target, _level, _xoffset, _yoffset, _width, _height, _format, _type, _pixels);
}

pub fn bindTexture(_target: GLenum, _texture: GLuint) void {
    return (function_pointers.glBindTexture orelse @panic("glBindTexture was not bound."))(_target, _texture);
}

pub fn deleteTextures(_n: GLsizei, _textures: [*c]const GLuint) void {
    return (function_pointers.glDeleteTextures orelse @panic("glDeleteTextures was not bound."))(_n, _textures);
}

pub fn genTextures(_n: GLsizei, _textures: [*c]GLuint) void {
    return (function_pointers.glGenTextures orelse @panic("glGenTextures was not bound."))(_n, _textures);
}

pub fn isTexture(_texture: GLuint) GLboolean {
    return (function_pointers.glIsTexture orelse @panic("glIsTexture was not bound."))(_texture);
}

pub fn getActiveSubroutineUniformName(_program: GLuint, _shadertype: GLenum, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _name: [*c]GLchar) void {
    return (function_pointers.glGetActiveSubroutineUniformName orelse @panic("glGetActiveSubroutineUniformName was not bound."))(_program, _shadertype, _index, _bufSize, _length, _name);
}

pub fn getActiveSubroutineUniformiv(_program: GLuint, _shadertype: GLenum, _index: GLuint, _pname: GLenum, _values: [*c]GLint) void {
    return (function_pointers.glGetActiveSubroutineUniformiv orelse @panic("glGetActiveSubroutineUniformiv was not bound."))(_program, _shadertype, _index, _pname, _values);
}

pub fn getSubroutineIndex(_program: GLuint, _shadertype: GLenum, _name: [*c]const GLchar) GLuint {
    return (function_pointers.glGetSubroutineIndex orelse @panic("glGetSubroutineIndex was not bound."))(_program, _shadertype, _name);
}

pub fn getSubroutineUniformLocation(_program: GLuint, _shadertype: GLenum, _name: [*c]const GLchar) GLint {
    return (function_pointers.glGetSubroutineUniformLocation orelse @panic("glGetSubroutineUniformLocation was not bound."))(_program, _shadertype, _name);
}

pub fn getUniformdv(_program: GLuint, _location: GLint, _params: [*c]GLdouble) void {
    return (function_pointers.glGetUniformdv orelse @panic("glGetUniformdv was not bound."))(_program, _location, _params);
}

pub fn uniformMatrix4x3dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix4x3dv orelse @panic("glUniformMatrix4x3dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix4x2dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix4x2dv orelse @panic("glUniformMatrix4x2dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix3x4dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix3x4dv orelse @panic("glUniformMatrix3x4dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix3x2dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix3x2dv orelse @panic("glUniformMatrix3x2dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix2x4dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix2x4dv orelse @panic("glUniformMatrix2x4dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix2x3dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix2x3dv orelse @panic("glUniformMatrix2x3dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix4dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix4dv orelse @panic("glUniformMatrix4dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix3dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix3dv orelse @panic("glUniformMatrix3dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn drawRangeElements(_mode: GLenum, _start: GLuint, _end: GLuint, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) void {
    return (function_pointers.glDrawRangeElements orelse @panic("glDrawRangeElements was not bound."))(_mode, _start, _end, _count, _type, _indices);
}

pub fn texImage3D(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    return (function_pointers.glTexImage3D orelse @panic("glTexImage3D was not bound."))(_target, _level, _internalformat, _width, _height, _depth, _border, _format, _type, _pixels);
}

pub fn texSubImage3D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void {
    return (function_pointers.glTexSubImage3D orelse @panic("glTexSubImage3D was not bound."))(_target, _level, _xoffset, _yoffset, _zoffset, _width, _height, _depth, _format, _type, _pixels);
}

pub fn copyTexSubImage3D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void {
    return (function_pointers.glCopyTexSubImage3D orelse @panic("glCopyTexSubImage3D was not bound."))(_target, _level, _xoffset, _yoffset, _zoffset, _x, _y, _width, _height);
}

pub fn uniformMatrix2dv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniformMatrix2dv orelse @panic("glUniformMatrix2dv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniform4dv(_location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniform4dv orelse @panic("glUniform4dv was not bound."))(_location, _count, _value);
}

pub fn uniform3dv(_location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniform3dv orelse @panic("glUniform3dv was not bound."))(_location, _count, _value);
}

pub fn uniform2dv(_location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniform2dv orelse @panic("glUniform2dv was not bound."))(_location, _count, _value);
}

pub fn uniform1dv(_location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void {
    return (function_pointers.glUniform1dv orelse @panic("glUniform1dv was not bound."))(_location, _count, _value);
}

pub fn uniform4d(_location: GLint, _x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) void {
    return (function_pointers.glUniform4d orelse @panic("glUniform4d was not bound."))(_location, _x, _y, _z, _w);
}

pub fn uniform3d(_location: GLint, _x: GLdouble, _y: GLdouble, _z: GLdouble) void {
    return (function_pointers.glUniform3d orelse @panic("glUniform3d was not bound."))(_location, _x, _y, _z);
}

pub fn uniform2d(_location: GLint, _x: GLdouble, _y: GLdouble) void {
    return (function_pointers.glUniform2d orelse @panic("glUniform2d was not bound."))(_location, _x, _y);
}

pub fn uniform1d(_location: GLint, _x: GLdouble) void {
    return (function_pointers.glUniform1d orelse @panic("glUniform1d was not bound."))(_location, _x);
}

pub fn drawElementsIndirect(_mode: GLenum, _type: GLenum, _indirect: ?*const anyopaque) void {
    return (function_pointers.glDrawElementsIndirect orelse @panic("glDrawElementsIndirect was not bound."))(_mode, _type, _indirect);
}

pub fn drawArraysIndirect(_mode: GLenum, _indirect: ?*const anyopaque) void {
    return (function_pointers.glDrawArraysIndirect orelse @panic("glDrawArraysIndirect was not bound."))(_mode, _indirect);
}

pub fn blendFuncSeparatei(_buf: GLuint, _srcRGB: GLenum, _dstRGB: GLenum, _srcAlpha: GLenum, _dstAlpha: GLenum) void {
    return (function_pointers.glBlendFuncSeparatei orelse @panic("glBlendFuncSeparatei was not bound."))(_buf, _srcRGB, _dstRGB, _srcAlpha, _dstAlpha);
}

pub fn blendFunci(_buf: GLuint, _src: GLenum, _dst: GLenum) void {
    return (function_pointers.glBlendFunci orelse @panic("glBlendFunci was not bound."))(_buf, _src, _dst);
}

pub fn blendEquationSeparatei(_buf: GLuint, _modeRGB: GLenum, _modeAlpha: GLenum) void {
    return (function_pointers.glBlendEquationSeparatei orelse @panic("glBlendEquationSeparatei was not bound."))(_buf, _modeRGB, _modeAlpha);
}

pub fn blendEquationi(_buf: GLuint, _mode: GLenum) void {
    return (function_pointers.glBlendEquationi orelse @panic("glBlendEquationi was not bound."))(_buf, _mode);
}

pub fn minSampleShading(_value: GLfloat) void {
    return (function_pointers.glMinSampleShading orelse @panic("glMinSampleShading was not bound."))(_value);
}

pub fn activeTexture(_texture: GLenum) void {
    return (function_pointers.glActiveTexture orelse @panic("glActiveTexture was not bound."))(_texture);
}

pub fn sampleCoverage(_value: GLfloat, _invert: GLboolean) void {
    return (function_pointers.glSampleCoverage orelse @panic("glSampleCoverage was not bound."))(_value, _invert);
}

pub fn compressedTexImage3D(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) void {
    return (function_pointers.glCompressedTexImage3D orelse @panic("glCompressedTexImage3D was not bound."))(_target, _level, _internalformat, _width, _height, _depth, _border, _imageSize, _data);
}

pub fn compressedTexImage2D(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) void {
    return (function_pointers.glCompressedTexImage2D orelse @panic("glCompressedTexImage2D was not bound."))(_target, _level, _internalformat, _width, _height, _border, _imageSize, _data);
}

pub fn compressedTexImage1D(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) void {
    return (function_pointers.glCompressedTexImage1D orelse @panic("glCompressedTexImage1D was not bound."))(_target, _level, _internalformat, _width, _border, _imageSize, _data);
}

pub fn compressedTexSubImage3D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) void {
    return (function_pointers.glCompressedTexSubImage3D orelse @panic("glCompressedTexSubImage3D was not bound."))(_target, _level, _xoffset, _yoffset, _zoffset, _width, _height, _depth, _format, _imageSize, _data);
}

pub fn compressedTexSubImage2D(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) void {
    return (function_pointers.glCompressedTexSubImage2D orelse @panic("glCompressedTexSubImage2D was not bound."))(_target, _level, _xoffset, _yoffset, _width, _height, _format, _imageSize, _data);
}

pub fn compressedTexSubImage1D(_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) void {
    return (function_pointers.glCompressedTexSubImage1D orelse @panic("glCompressedTexSubImage1D was not bound."))(_target, _level, _xoffset, _width, _format, _imageSize, _data);
}

pub fn getCompressedTexImage(_target: GLenum, _level: GLint, _img: ?*anyopaque) void {
    return (function_pointers.glGetCompressedTexImage orelse @panic("glGetCompressedTexImage was not bound."))(_target, _level, _img);
}

pub fn vertexAttribP4uiv(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribP4uiv orelse @panic("glVertexAttribP4uiv was not bound."))(_index, _type, _normalized, _value);
}

pub fn vertexAttribP4ui(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: GLuint) void {
    return (function_pointers.glVertexAttribP4ui orelse @panic("glVertexAttribP4ui was not bound."))(_index, _type, _normalized, _value);
}

pub fn vertexAttribP3uiv(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribP3uiv orelse @panic("glVertexAttribP3uiv was not bound."))(_index, _type, _normalized, _value);
}

pub fn vertexAttribP3ui(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: GLuint) void {
    return (function_pointers.glVertexAttribP3ui orelse @panic("glVertexAttribP3ui was not bound."))(_index, _type, _normalized, _value);
}

pub fn vertexAttribP2uiv(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribP2uiv orelse @panic("glVertexAttribP2uiv was not bound."))(_index, _type, _normalized, _value);
}

pub fn vertexAttribP2ui(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: GLuint) void {
    return (function_pointers.glVertexAttribP2ui orelse @panic("glVertexAttribP2ui was not bound."))(_index, _type, _normalized, _value);
}

pub fn vertexAttribP1uiv(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribP1uiv orelse @panic("glVertexAttribP1uiv was not bound."))(_index, _type, _normalized, _value);
}

pub fn vertexAttribP1ui(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: GLuint) void {
    return (function_pointers.glVertexAttribP1ui orelse @panic("glVertexAttribP1ui was not bound."))(_index, _type, _normalized, _value);
}

pub fn vertexAttribDivisor(_index: GLuint, _divisor: GLuint) void {
    return (function_pointers.glVertexAttribDivisor orelse @panic("glVertexAttribDivisor was not bound."))(_index, _divisor);
}

pub fn getQueryObjectui64v(_id: GLuint, _pname: GLenum, _params: [*c]GLuint64) void {
    return (function_pointers.glGetQueryObjectui64v orelse @panic("glGetQueryObjectui64v was not bound."))(_id, _pname, _params);
}

pub fn getQueryObjecti64v(_id: GLuint, _pname: GLenum, _params: [*c]GLint64) void {
    return (function_pointers.glGetQueryObjecti64v orelse @panic("glGetQueryObjecti64v was not bound."))(_id, _pname, _params);
}

pub fn queryCounter(_id: GLuint, _target: GLenum) void {
    return (function_pointers.glQueryCounter orelse @panic("glQueryCounter was not bound."))(_id, _target);
}

pub fn getSamplerParameterIuiv(_sampler: GLuint, _pname: GLenum, _params: [*c]GLuint) void {
    return (function_pointers.glGetSamplerParameterIuiv orelse @panic("glGetSamplerParameterIuiv was not bound."))(_sampler, _pname, _params);
}

pub fn getSamplerParameterfv(_sampler: GLuint, _pname: GLenum, _params: [*c]GLfloat) void {
    return (function_pointers.glGetSamplerParameterfv orelse @panic("glGetSamplerParameterfv was not bound."))(_sampler, _pname, _params);
}

pub fn getSamplerParameterIiv(_sampler: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetSamplerParameterIiv orelse @panic("glGetSamplerParameterIiv was not bound."))(_sampler, _pname, _params);
}

pub fn getSamplerParameteriv(_sampler: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetSamplerParameteriv orelse @panic("glGetSamplerParameteriv was not bound."))(_sampler, _pname, _params);
}

pub fn samplerParameterIuiv(_sampler: GLuint, _pname: GLenum, _param: [*c]const GLuint) void {
    return (function_pointers.glSamplerParameterIuiv orelse @panic("glSamplerParameterIuiv was not bound."))(_sampler, _pname, _param);
}

pub fn samplerParameterIiv(_sampler: GLuint, _pname: GLenum, _param: [*c]const GLint) void {
    return (function_pointers.glSamplerParameterIiv orelse @panic("glSamplerParameterIiv was not bound."))(_sampler, _pname, _param);
}

pub fn samplerParameterfv(_sampler: GLuint, _pname: GLenum, _param: [*c]const GLfloat) void {
    return (function_pointers.glSamplerParameterfv orelse @panic("glSamplerParameterfv was not bound."))(_sampler, _pname, _param);
}

pub fn samplerParameterf(_sampler: GLuint, _pname: GLenum, _param: GLfloat) void {
    return (function_pointers.glSamplerParameterf orelse @panic("glSamplerParameterf was not bound."))(_sampler, _pname, _param);
}

pub fn samplerParameteriv(_sampler: GLuint, _pname: GLenum, _param: [*c]const GLint) void {
    return (function_pointers.glSamplerParameteriv orelse @panic("glSamplerParameteriv was not bound."))(_sampler, _pname, _param);
}

pub fn samplerParameteri(_sampler: GLuint, _pname: GLenum, _param: GLint) void {
    return (function_pointers.glSamplerParameteri orelse @panic("glSamplerParameteri was not bound."))(_sampler, _pname, _param);
}

pub fn bindSampler(_unit: GLuint, _sampler: GLuint) void {
    return (function_pointers.glBindSampler orelse @panic("glBindSampler was not bound."))(_unit, _sampler);
}

pub fn isSampler(_sampler: GLuint) GLboolean {
    return (function_pointers.glIsSampler orelse @panic("glIsSampler was not bound."))(_sampler);
}

pub fn deleteSamplers(_count: GLsizei, _samplers: [*c]const GLuint) void {
    return (function_pointers.glDeleteSamplers orelse @panic("glDeleteSamplers was not bound."))(_count, _samplers);
}

pub fn genSamplers(_count: GLsizei, _samplers: [*c]GLuint) void {
    return (function_pointers.glGenSamplers orelse @panic("glGenSamplers was not bound."))(_count, _samplers);
}

pub fn getFragDataIndex(_program: GLuint, _name: [*c]const GLchar) GLint {
    return (function_pointers.glGetFragDataIndex orelse @panic("glGetFragDataIndex was not bound."))(_program, _name);
}

pub fn bindFragDataLocationIndexed(_program: GLuint, _colorNumber: GLuint, _index: GLuint, _name: [*c]const GLchar) void {
    return (function_pointers.glBindFragDataLocationIndexed orelse @panic("glBindFragDataLocationIndexed was not bound."))(_program, _colorNumber, _index, _name);
}

pub fn sampleMaski(_maskNumber: GLuint, _mask: GLbitfield) void {
    return (function_pointers.glSampleMaski orelse @panic("glSampleMaski was not bound."))(_maskNumber, _mask);
}

pub fn getMultisamplefv(_pname: GLenum, _index: GLuint, _val: [*c]GLfloat) void {
    return (function_pointers.glGetMultisamplefv orelse @panic("glGetMultisamplefv was not bound."))(_pname, _index, _val);
}

pub fn texImage3DMultisample(_target: GLenum, _samples: GLsizei, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _fixedsamplelocations: GLboolean) void {
    return (function_pointers.glTexImage3DMultisample orelse @panic("glTexImage3DMultisample was not bound."))(_target, _samples, _internalformat, _width, _height, _depth, _fixedsamplelocations);
}

pub fn texImage2DMultisample(_target: GLenum, _samples: GLsizei, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _fixedsamplelocations: GLboolean) void {
    return (function_pointers.glTexImage2DMultisample orelse @panic("glTexImage2DMultisample was not bound."))(_target, _samples, _internalformat, _width, _height, _fixedsamplelocations);
}

pub fn framebufferTexture(_target: GLenum, _attachment: GLenum, _texture: GLuint, _level: GLint) void {
    return (function_pointers.glFramebufferTexture orelse @panic("glFramebufferTexture was not bound."))(_target, _attachment, _texture, _level);
}

pub fn getBufferParameteri64v(_target: GLenum, _pname: GLenum, _params: [*c]GLint64) void {
    return (function_pointers.glGetBufferParameteri64v orelse @panic("glGetBufferParameteri64v was not bound."))(_target, _pname, _params);
}

pub fn blendFuncSeparate(_sfactorRGB: GLenum, _dfactorRGB: GLenum, _sfactorAlpha: GLenum, _dfactorAlpha: GLenum) void {
    return (function_pointers.glBlendFuncSeparate orelse @panic("glBlendFuncSeparate was not bound."))(_sfactorRGB, _dfactorRGB, _sfactorAlpha, _dfactorAlpha);
}

pub fn multiDrawArrays(_mode: GLenum, _first: [*c]const GLint, _count: [*c]const GLsizei, _drawcount: GLsizei) void {
    return (function_pointers.glMultiDrawArrays orelse @panic("glMultiDrawArrays was not bound."))(_mode, _first, _count, _drawcount);
}

pub fn multiDrawElements(_mode: GLenum, _count: [*c]const GLsizei, _type: GLenum, _indices: [*c]const ?*const anyopaque, _drawcount: GLsizei) void {
    return (function_pointers.glMultiDrawElements orelse @panic("glMultiDrawElements was not bound."))(_mode, _count, _type, _indices, _drawcount);
}

pub fn pointParameterf(_pname: GLenum, _param: GLfloat) void {
    return (function_pointers.glPointParameterf orelse @panic("glPointParameterf was not bound."))(_pname, _param);
}

pub fn pointParameterfv(_pname: GLenum, _params: [*c]const GLfloat) void {
    return (function_pointers.glPointParameterfv orelse @panic("glPointParameterfv was not bound."))(_pname, _params);
}

pub fn pointParameteri(_pname: GLenum, _param: GLint) void {
    return (function_pointers.glPointParameteri orelse @panic("glPointParameteri was not bound."))(_pname, _param);
}

pub fn pointParameteriv(_pname: GLenum, _params: [*c]const GLint) void {
    return (function_pointers.glPointParameteriv orelse @panic("glPointParameteriv was not bound."))(_pname, _params);
}

pub fn getInteger64i_v(_target: GLenum, _index: GLuint, _data: [*c]GLint64) void {
    return (function_pointers.glGetInteger64i_v orelse @panic("glGetInteger64i_v was not bound."))(_target, _index, _data);
}

pub fn getSynciv(_sync: GLsync, _pname: GLenum, _count: GLsizei, _length: [*c]GLsizei, _values: [*c]GLint) void {
    return (function_pointers.glGetSynciv orelse @panic("glGetSynciv was not bound."))(_sync, _pname, _count, _length, _values);
}

pub fn getInteger64v(_pname: GLenum, _data: [*c]GLint64) void {
    return (function_pointers.glGetInteger64v orelse @panic("glGetInteger64v was not bound."))(_pname, _data);
}

pub fn waitSync(_sync: GLsync, _flags: GLbitfield, _timeout: GLuint64) void {
    return (function_pointers.glWaitSync orelse @panic("glWaitSync was not bound."))(_sync, _flags, _timeout);
}

pub fn clientWaitSync(_sync: GLsync, _flags: GLbitfield, _timeout: GLuint64) GLenum {
    return (function_pointers.glClientWaitSync orelse @panic("glClientWaitSync was not bound."))(_sync, _flags, _timeout);
}

pub fn deleteSync(_sync: GLsync) void {
    return (function_pointers.glDeleteSync orelse @panic("glDeleteSync was not bound."))(_sync);
}

pub fn isSync(_sync: GLsync) GLboolean {
    return (function_pointers.glIsSync orelse @panic("glIsSync was not bound."))(_sync);
}

pub fn fenceSync(_condition: GLenum, _flags: GLbitfield) GLsync {
    return (function_pointers.glFenceSync orelse @panic("glFenceSync was not bound."))(_condition, _flags);
}

pub fn blendColor(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) void {
    return (function_pointers.glBlendColor orelse @panic("glBlendColor was not bound."))(_red, _green, _blue, _alpha);
}

pub fn blendEquation(_mode: GLenum) void {
    return (function_pointers.glBlendEquation orelse @panic("glBlendEquation was not bound."))(_mode);
}

pub fn provokingVertex(_mode: GLenum) void {
    return (function_pointers.glProvokingVertex orelse @panic("glProvokingVertex was not bound."))(_mode);
}

pub fn multiDrawElementsBaseVertex(_mode: GLenum, _count: [*c]const GLsizei, _type: GLenum, _indices: [*c]const ?*const anyopaque, _drawcount: GLsizei, _basevertex: [*c]const GLint) void {
    return (function_pointers.glMultiDrawElementsBaseVertex orelse @panic("glMultiDrawElementsBaseVertex was not bound."))(_mode, _count, _type, _indices, _drawcount, _basevertex);
}

pub fn drawElementsInstancedBaseVertex(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque, _instancecount: GLsizei, _basevertex: GLint) void {
    return (function_pointers.glDrawElementsInstancedBaseVertex orelse @panic("glDrawElementsInstancedBaseVertex was not bound."))(_mode, _count, _type, _indices, _instancecount, _basevertex);
}

pub fn drawRangeElementsBaseVertex(_mode: GLenum, _start: GLuint, _end: GLuint, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque, _basevertex: GLint) void {
    return (function_pointers.glDrawRangeElementsBaseVertex orelse @panic("glDrawRangeElementsBaseVertex was not bound."))(_mode, _start, _end, _count, _type, _indices, _basevertex);
}

pub fn drawElementsBaseVertex(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque, _basevertex: GLint) void {
    return (function_pointers.glDrawElementsBaseVertex orelse @panic("glDrawElementsBaseVertex was not bound."))(_mode, _count, _type, _indices, _basevertex);
}

pub fn genQueries(_n: GLsizei, _ids: [*c]GLuint) void {
    return (function_pointers.glGenQueries orelse @panic("glGenQueries was not bound."))(_n, _ids);
}

pub fn deleteQueries(_n: GLsizei, _ids: [*c]const GLuint) void {
    return (function_pointers.glDeleteQueries orelse @panic("glDeleteQueries was not bound."))(_n, _ids);
}

pub fn isQuery(_id: GLuint) GLboolean {
    return (function_pointers.glIsQuery orelse @panic("glIsQuery was not bound."))(_id);
}

pub fn beginQuery(_target: GLenum, _id: GLuint) void {
    return (function_pointers.glBeginQuery orelse @panic("glBeginQuery was not bound."))(_target, _id);
}

pub fn endQuery(_target: GLenum) void {
    return (function_pointers.glEndQuery orelse @panic("glEndQuery was not bound."))(_target);
}

pub fn getQueryiv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetQueryiv orelse @panic("glGetQueryiv was not bound."))(_target, _pname, _params);
}

pub fn getQueryObjectiv(_id: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetQueryObjectiv orelse @panic("glGetQueryObjectiv was not bound."))(_id, _pname, _params);
}

pub fn getQueryObjectuiv(_id: GLuint, _pname: GLenum, _params: [*c]GLuint) void {
    return (function_pointers.glGetQueryObjectuiv orelse @panic("glGetQueryObjectuiv was not bound."))(_id, _pname, _params);
}

pub fn bindBuffer(_target: GLenum, _buffer: GLuint) void {
    return (function_pointers.glBindBuffer orelse @panic("glBindBuffer was not bound."))(_target, _buffer);
}

pub fn deleteBuffers(_n: GLsizei, _buffers: [*c]const GLuint) void {
    return (function_pointers.glDeleteBuffers orelse @panic("glDeleteBuffers was not bound."))(_n, _buffers);
}

pub fn genBuffers(_n: GLsizei, _buffers: [*c]GLuint) void {
    return (function_pointers.glGenBuffers orelse @panic("glGenBuffers was not bound."))(_n, _buffers);
}

pub fn isBuffer(_buffer: GLuint) GLboolean {
    return (function_pointers.glIsBuffer orelse @panic("glIsBuffer was not bound."))(_buffer);
}

pub fn bufferData(_target: GLenum, _size: GLsizeiptr, _data: ?*const anyopaque, _usage: GLenum) void {
    return (function_pointers.glBufferData orelse @panic("glBufferData was not bound."))(_target, _size, _data, _usage);
}

pub fn bufferSubData(_target: GLenum, _offset: GLintptr, _size: GLsizeiptr, _data: ?*const anyopaque) void {
    return (function_pointers.glBufferSubData orelse @panic("glBufferSubData was not bound."))(_target, _offset, _size, _data);
}

pub fn getBufferSubData(_target: GLenum, _offset: GLintptr, _size: GLsizeiptr, _data: ?*anyopaque) void {
    return (function_pointers.glGetBufferSubData orelse @panic("glGetBufferSubData was not bound."))(_target, _offset, _size, _data);
}

pub fn mapBuffer(_target: GLenum, _access: GLenum) ?*anyopaque {
    return (function_pointers.glMapBuffer orelse @panic("glMapBuffer was not bound."))(_target, _access);
}

pub fn unmapBuffer(_target: GLenum) GLboolean {
    return (function_pointers.glUnmapBuffer orelse @panic("glUnmapBuffer was not bound."))(_target);
}

pub fn getBufferParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetBufferParameteriv orelse @panic("glGetBufferParameteriv was not bound."))(_target, _pname, _params);
}

pub fn getBufferPointerv(_target: GLenum, _pname: GLenum, _params: ?*?*anyopaque) void {
    return (function_pointers.glGetBufferPointerv orelse @panic("glGetBufferPointerv was not bound."))(_target, _pname, _params);
}

pub fn blendEquationSeparate(_modeRGB: GLenum, _modeAlpha: GLenum) void {
    return (function_pointers.glBlendEquationSeparate orelse @panic("glBlendEquationSeparate was not bound."))(_modeRGB, _modeAlpha);
}

pub fn drawBuffers(_n: GLsizei, _bufs: [*c]const GLenum) void {
    return (function_pointers.glDrawBuffers orelse @panic("glDrawBuffers was not bound."))(_n, _bufs);
}

pub fn stencilOpSeparate(_face: GLenum, _sfail: GLenum, _dpfail: GLenum, _dppass: GLenum) void {
    return (function_pointers.glStencilOpSeparate orelse @panic("glStencilOpSeparate was not bound."))(_face, _sfail, _dpfail, _dppass);
}

pub fn stencilFuncSeparate(_face: GLenum, _func: GLenum, _ref: GLint, _mask: GLuint) void {
    return (function_pointers.glStencilFuncSeparate orelse @panic("glStencilFuncSeparate was not bound."))(_face, _func, _ref, _mask);
}

pub fn stencilMaskSeparate(_face: GLenum, _mask: GLuint) void {
    return (function_pointers.glStencilMaskSeparate orelse @panic("glStencilMaskSeparate was not bound."))(_face, _mask);
}

pub fn attachShader(_program: GLuint, _shader: GLuint) void {
    return (function_pointers.glAttachShader orelse @panic("glAttachShader was not bound."))(_program, _shader);
}

pub fn bindAttribLocation(_program: GLuint, _index: GLuint, _name: [*c]const GLchar) void {
    return (function_pointers.glBindAttribLocation orelse @panic("glBindAttribLocation was not bound."))(_program, _index, _name);
}

pub fn compileShader(_shader: GLuint) void {
    return (function_pointers.glCompileShader orelse @panic("glCompileShader was not bound."))(_shader);
}

pub fn createProgram() GLuint {
    return (function_pointers.glCreateProgram orelse @panic("glCreateProgram was not bound."))();
}

pub fn createShader(_type: GLenum) GLuint {
    return (function_pointers.glCreateShader orelse @panic("glCreateShader was not bound."))(_type);
}

pub fn deleteProgram(_program: GLuint) void {
    return (function_pointers.glDeleteProgram orelse @panic("glDeleteProgram was not bound."))(_program);
}

pub fn deleteShader(_shader: GLuint) void {
    return (function_pointers.glDeleteShader orelse @panic("glDeleteShader was not bound."))(_shader);
}

pub fn detachShader(_program: GLuint, _shader: GLuint) void {
    return (function_pointers.glDetachShader orelse @panic("glDetachShader was not bound."))(_program, _shader);
}

pub fn disableVertexAttribArray(_index: GLuint) void {
    return (function_pointers.glDisableVertexAttribArray orelse @panic("glDisableVertexAttribArray was not bound."))(_index);
}

pub fn enableVertexAttribArray(_index: GLuint) void {
    return (function_pointers.glEnableVertexAttribArray orelse @panic("glEnableVertexAttribArray was not bound."))(_index);
}

pub fn getActiveAttrib(_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLint, _type: [*c]GLenum, _name: [*c]GLchar) void {
    return (function_pointers.glGetActiveAttrib orelse @panic("glGetActiveAttrib was not bound."))(_program, _index, _bufSize, _length, _size, _type, _name);
}

pub fn getActiveUniform(_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLint, _type: [*c]GLenum, _name: [*c]GLchar) void {
    return (function_pointers.glGetActiveUniform orelse @panic("glGetActiveUniform was not bound."))(_program, _index, _bufSize, _length, _size, _type, _name);
}

pub fn getAttachedShaders(_program: GLuint, _maxCount: GLsizei, _count: [*c]GLsizei, _shaders: [*c]GLuint) void {
    return (function_pointers.glGetAttachedShaders orelse @panic("glGetAttachedShaders was not bound."))(_program, _maxCount, _count, _shaders);
}

pub fn getAttribLocation(_program: GLuint, _name: [*c]const GLchar) GLint {
    return (function_pointers.glGetAttribLocation orelse @panic("glGetAttribLocation was not bound."))(_program, _name);
}

pub fn getProgramiv(_program: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetProgramiv orelse @panic("glGetProgramiv was not bound."))(_program, _pname, _params);
}

pub fn getProgramInfoLog(_program: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) void {
    return (function_pointers.glGetProgramInfoLog orelse @panic("glGetProgramInfoLog was not bound."))(_program, _bufSize, _length, _infoLog);
}

pub fn getShaderiv(_shader: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetShaderiv orelse @panic("glGetShaderiv was not bound."))(_shader, _pname, _params);
}

pub fn getShaderInfoLog(_shader: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) void {
    return (function_pointers.glGetShaderInfoLog orelse @panic("glGetShaderInfoLog was not bound."))(_shader, _bufSize, _length, _infoLog);
}

pub fn getShaderSource(_shader: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _source: [*c]GLchar) void {
    return (function_pointers.glGetShaderSource orelse @panic("glGetShaderSource was not bound."))(_shader, _bufSize, _length, _source);
}

pub fn getUniformLocation(_program: GLuint, _name: [*c]const GLchar) GLint {
    return (function_pointers.glGetUniformLocation orelse @panic("glGetUniformLocation was not bound."))(_program, _name);
}

pub fn getUniformfv(_program: GLuint, _location: GLint, _params: [*c]GLfloat) void {
    return (function_pointers.glGetUniformfv orelse @panic("glGetUniformfv was not bound."))(_program, _location, _params);
}

pub fn getUniformiv(_program: GLuint, _location: GLint, _params: [*c]GLint) void {
    return (function_pointers.glGetUniformiv orelse @panic("glGetUniformiv was not bound."))(_program, _location, _params);
}

pub fn getVertexAttribdv(_index: GLuint, _pname: GLenum, _params: [*c]GLdouble) void {
    return (function_pointers.glGetVertexAttribdv orelse @panic("glGetVertexAttribdv was not bound."))(_index, _pname, _params);
}

pub fn getVertexAttribfv(_index: GLuint, _pname: GLenum, _params: [*c]GLfloat) void {
    return (function_pointers.glGetVertexAttribfv orelse @panic("glGetVertexAttribfv was not bound."))(_index, _pname, _params);
}

pub fn getVertexAttribiv(_index: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetVertexAttribiv orelse @panic("glGetVertexAttribiv was not bound."))(_index, _pname, _params);
}

pub fn getVertexAttribPointerv(_index: GLuint, _pname: GLenum, _pointer: ?*?*anyopaque) void {
    return (function_pointers.glGetVertexAttribPointerv orelse @panic("glGetVertexAttribPointerv was not bound."))(_index, _pname, _pointer);
}

pub fn isProgram(_program: GLuint) GLboolean {
    return (function_pointers.glIsProgram orelse @panic("glIsProgram was not bound."))(_program);
}

pub fn isShader(_shader: GLuint) GLboolean {
    return (function_pointers.glIsShader orelse @panic("glIsShader was not bound."))(_shader);
}

pub fn linkProgram(_program: GLuint) void {
    return (function_pointers.glLinkProgram orelse @panic("glLinkProgram was not bound."))(_program);
}

pub fn shaderSource(_shader: GLuint, _count: GLsizei, _string: *[:0]const GLchar, _length: [*c]const GLint) void {
    return (function_pointers.glShaderSource orelse @panic("glShaderSource was not bound."))(_shader, _count, _string, _length);
}

pub fn useProgram(_program: GLuint) void {
    return (function_pointers.glUseProgram orelse @panic("glUseProgram was not bound."))(_program);
}

pub fn uniform1f(_location: GLint, _v0: GLfloat) void {
    return (function_pointers.glUniform1f orelse @panic("glUniform1f was not bound."))(_location, _v0);
}

pub fn uniform2f(_location: GLint, _v0: GLfloat, _v1: GLfloat) void {
    return (function_pointers.glUniform2f orelse @panic("glUniform2f was not bound."))(_location, _v0, _v1);
}

pub fn uniform3f(_location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat) void {
    return (function_pointers.glUniform3f orelse @panic("glUniform3f was not bound."))(_location, _v0, _v1, _v2);
}

pub fn uniform4f(_location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat, _v3: GLfloat) void {
    return (function_pointers.glUniform4f orelse @panic("glUniform4f was not bound."))(_location, _v0, _v1, _v2, _v3);
}

pub fn uniform1i(_location: GLint, _v0: GLint) void {
    return (function_pointers.glUniform1i orelse @panic("glUniform1i was not bound."))(_location, _v0);
}

pub fn uniform2i(_location: GLint, _v0: GLint, _v1: GLint) void {
    return (function_pointers.glUniform2i orelse @panic("glUniform2i was not bound."))(_location, _v0, _v1);
}

pub fn uniform3i(_location: GLint, _v0: GLint, _v1: GLint, _v2: GLint) void {
    return (function_pointers.glUniform3i orelse @panic("glUniform3i was not bound."))(_location, _v0, _v1, _v2);
}

pub fn uniform4i(_location: GLint, _v0: GLint, _v1: GLint, _v2: GLint, _v3: GLint) void {
    return (function_pointers.glUniform4i orelse @panic("glUniform4i was not bound."))(_location, _v0, _v1, _v2, _v3);
}

pub fn uniform1fv(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniform1fv orelse @panic("glUniform1fv was not bound."))(_location, _count, _value);
}

pub fn uniform2fv(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniform2fv orelse @panic("glUniform2fv was not bound."))(_location, _count, _value);
}

pub fn uniform3fv(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniform3fv orelse @panic("glUniform3fv was not bound."))(_location, _count, _value);
}

pub fn uniform4fv(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniform4fv orelse @panic("glUniform4fv was not bound."))(_location, _count, _value);
}

pub fn uniform1iv(_location: GLint, _count: GLsizei, _value: [*c]const GLint) void {
    return (function_pointers.glUniform1iv orelse @panic("glUniform1iv was not bound."))(_location, _count, _value);
}

pub fn uniform2iv(_location: GLint, _count: GLsizei, _value: [*c]const GLint) void {
    return (function_pointers.glUniform2iv orelse @panic("glUniform2iv was not bound."))(_location, _count, _value);
}

pub fn uniform3iv(_location: GLint, _count: GLsizei, _value: [*c]const GLint) void {
    return (function_pointers.glUniform3iv orelse @panic("glUniform3iv was not bound."))(_location, _count, _value);
}

pub fn uniform4iv(_location: GLint, _count: GLsizei, _value: [*c]const GLint) void {
    return (function_pointers.glUniform4iv orelse @panic("glUniform4iv was not bound."))(_location, _count, _value);
}

pub fn uniformMatrix2fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix2fv orelse @panic("glUniformMatrix2fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix3fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix3fv orelse @panic("glUniformMatrix3fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix4fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix4fv orelse @panic("glUniformMatrix4fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn validateProgram(_program: GLuint) void {
    return (function_pointers.glValidateProgram orelse @panic("glValidateProgram was not bound."))(_program);
}

pub fn vertexAttrib1d(_index: GLuint, _x: GLdouble) void {
    return (function_pointers.glVertexAttrib1d orelse @panic("glVertexAttrib1d was not bound."))(_index, _x);
}

pub fn vertexAttrib1dv(_index: GLuint, _v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttrib1dv orelse @panic("glVertexAttrib1dv was not bound."))(_index, _v);
}

pub fn vertexAttrib1f(_index: GLuint, _x: GLfloat) void {
    return (function_pointers.glVertexAttrib1f orelse @panic("glVertexAttrib1f was not bound."))(_index, _x);
}

pub fn vertexAttrib1fv(_index: GLuint, _v: [*c]const GLfloat) void {
    return (function_pointers.glVertexAttrib1fv orelse @panic("glVertexAttrib1fv was not bound."))(_index, _v);
}

pub fn vertexAttrib1s(_index: GLuint, _x: GLshort) void {
    return (function_pointers.glVertexAttrib1s orelse @panic("glVertexAttrib1s was not bound."))(_index, _x);
}

pub fn vertexAttrib1sv(_index: GLuint, _v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib1sv orelse @panic("glVertexAttrib1sv was not bound."))(_index, _v);
}

pub fn vertexAttrib2d(_index: GLuint, _x: GLdouble, _y: GLdouble) void {
    return (function_pointers.glVertexAttrib2d orelse @panic("glVertexAttrib2d was not bound."))(_index, _x, _y);
}

pub fn vertexAttrib2dv(_index: GLuint, _v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttrib2dv orelse @panic("glVertexAttrib2dv was not bound."))(_index, _v);
}

pub fn vertexAttrib2f(_index: GLuint, _x: GLfloat, _y: GLfloat) void {
    return (function_pointers.glVertexAttrib2f orelse @panic("glVertexAttrib2f was not bound."))(_index, _x, _y);
}

pub fn vertexAttrib2fv(_index: GLuint, _v: [*c]const GLfloat) void {
    return (function_pointers.glVertexAttrib2fv orelse @panic("glVertexAttrib2fv was not bound."))(_index, _v);
}

pub fn vertexAttrib2s(_index: GLuint, _x: GLshort, _y: GLshort) void {
    return (function_pointers.glVertexAttrib2s orelse @panic("glVertexAttrib2s was not bound."))(_index, _x, _y);
}

pub fn vertexAttrib2sv(_index: GLuint, _v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib2sv orelse @panic("glVertexAttrib2sv was not bound."))(_index, _v);
}

pub fn vertexAttrib3d(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble) void {
    return (function_pointers.glVertexAttrib3d orelse @panic("glVertexAttrib3d was not bound."))(_index, _x, _y, _z);
}

pub fn vertexAttrib3dv(_index: GLuint, _v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttrib3dv orelse @panic("glVertexAttrib3dv was not bound."))(_index, _v);
}

pub fn vertexAttrib3f(_index: GLuint, _x: GLfloat, _y: GLfloat, _z: GLfloat) void {
    return (function_pointers.glVertexAttrib3f orelse @panic("glVertexAttrib3f was not bound."))(_index, _x, _y, _z);
}

pub fn vertexAttrib3fv(_index: GLuint, _v: [*c]const GLfloat) void {
    return (function_pointers.glVertexAttrib3fv orelse @panic("glVertexAttrib3fv was not bound."))(_index, _v);
}

pub fn vertexAttrib3s(_index: GLuint, _x: GLshort, _y: GLshort, _z: GLshort) void {
    return (function_pointers.glVertexAttrib3s orelse @panic("glVertexAttrib3s was not bound."))(_index, _x, _y, _z);
}

pub fn vertexAttrib3sv(_index: GLuint, _v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib3sv orelse @panic("glVertexAttrib3sv was not bound."))(_index, _v);
}

pub fn vertexAttrib4Nbv(_index: GLuint, _v: [*c]const GLbyte) void {
    return (function_pointers.glVertexAttrib4Nbv orelse @panic("glVertexAttrib4Nbv was not bound."))(_index, _v);
}

pub fn vertexAttrib4Niv(_index: GLuint, _v: [*c]const GLint) void {
    return (function_pointers.glVertexAttrib4Niv orelse @panic("glVertexAttrib4Niv was not bound."))(_index, _v);
}

pub fn vertexAttrib4Nsv(_index: GLuint, _v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib4Nsv orelse @panic("glVertexAttrib4Nsv was not bound."))(_index, _v);
}

pub fn vertexAttrib4Nub(_index: GLuint, _x: GLubyte, _y: GLubyte, _z: GLubyte, _w: GLubyte) void {
    return (function_pointers.glVertexAttrib4Nub orelse @panic("glVertexAttrib4Nub was not bound."))(_index, _x, _y, _z, _w);
}

pub fn vertexAttrib4Nubv(_index: GLuint, _v: ?[*:0]const GLubyte) void {
    return (function_pointers.glVertexAttrib4Nubv orelse @panic("glVertexAttrib4Nubv was not bound."))(_index, _v);
}

pub fn vertexAttrib4Nuiv(_index: GLuint, _v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttrib4Nuiv orelse @panic("glVertexAttrib4Nuiv was not bound."))(_index, _v);
}

pub fn vertexAttrib4Nusv(_index: GLuint, _v: [*c]const GLushort) void {
    return (function_pointers.glVertexAttrib4Nusv orelse @panic("glVertexAttrib4Nusv was not bound."))(_index, _v);
}

pub fn vertexAttrib4bv(_index: GLuint, _v: [*c]const GLbyte) void {
    return (function_pointers.glVertexAttrib4bv orelse @panic("glVertexAttrib4bv was not bound."))(_index, _v);
}

pub fn vertexAttrib4d(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) void {
    return (function_pointers.glVertexAttrib4d orelse @panic("glVertexAttrib4d was not bound."))(_index, _x, _y, _z, _w);
}

pub fn vertexAttrib4dv(_index: GLuint, _v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttrib4dv orelse @panic("glVertexAttrib4dv was not bound."))(_index, _v);
}

pub fn vertexAttrib4f(_index: GLuint, _x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) void {
    return (function_pointers.glVertexAttrib4f orelse @panic("glVertexAttrib4f was not bound."))(_index, _x, _y, _z, _w);
}

pub fn vertexAttrib4fv(_index: GLuint, _v: [*c]const GLfloat) void {
    return (function_pointers.glVertexAttrib4fv orelse @panic("glVertexAttrib4fv was not bound."))(_index, _v);
}

pub fn vertexAttrib4iv(_index: GLuint, _v: [*c]const GLint) void {
    return (function_pointers.glVertexAttrib4iv orelse @panic("glVertexAttrib4iv was not bound."))(_index, _v);
}

pub fn vertexAttrib4s(_index: GLuint, _x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) void {
    return (function_pointers.glVertexAttrib4s orelse @panic("glVertexAttrib4s was not bound."))(_index, _x, _y, _z, _w);
}

pub fn vertexAttrib4sv(_index: GLuint, _v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib4sv orelse @panic("glVertexAttrib4sv was not bound."))(_index, _v);
}

pub fn vertexAttrib4ubv(_index: GLuint, _v: ?[*:0]const GLubyte) void {
    return (function_pointers.glVertexAttrib4ubv orelse @panic("glVertexAttrib4ubv was not bound."))(_index, _v);
}

pub fn vertexAttrib4uiv(_index: GLuint, _v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttrib4uiv orelse @panic("glVertexAttrib4uiv was not bound."))(_index, _v);
}

pub fn vertexAttrib4usv(_index: GLuint, _v: [*c]const GLushort) void {
    return (function_pointers.glVertexAttrib4usv orelse @panic("glVertexAttrib4usv was not bound."))(_index, _v);
}

pub fn vertexAttribPointer(_index: GLuint, _size: GLint, _type: GLenum, _normalized: GLboolean, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    return (function_pointers.glVertexAttribPointer orelse @panic("glVertexAttribPointer was not bound."))(_index, _size, _type, _normalized, _stride, _pointer);
}

pub fn uniformMatrix2x3fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix2x3fv orelse @panic("glUniformMatrix2x3fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix3x2fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix3x2fv orelse @panic("glUniformMatrix3x2fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix2x4fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix2x4fv orelse @panic("glUniformMatrix2x4fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix4x2fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix4x2fv orelse @panic("glUniformMatrix4x2fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix3x4fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix3x4fv orelse @panic("glUniformMatrix3x4fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn uniformMatrix4x3fv(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix4x3fv orelse @panic("glUniformMatrix4x3fv was not bound."))(_location, _count, _transpose, _value);
}

pub fn colorMaski(_index: GLuint, _r: GLboolean, _g: GLboolean, _b: GLboolean, _a: GLboolean) void {
    return (function_pointers.glColorMaski orelse @panic("glColorMaski was not bound."))(_index, _r, _g, _b, _a);
}

pub fn getBooleani_v(_target: GLenum, _index: GLuint, _data: [*c]GLboolean) void {
    return (function_pointers.glGetBooleani_v orelse @panic("glGetBooleani_v was not bound."))(_target, _index, _data);
}

pub fn getIntegeri_v(_target: GLenum, _index: GLuint, _data: [*c]GLint) void {
    return (function_pointers.glGetIntegeri_v orelse @panic("glGetIntegeri_v was not bound."))(_target, _index, _data);
}

pub fn enablei(_target: GLenum, _index: GLuint) void {
    return (function_pointers.glEnablei orelse @panic("glEnablei was not bound."))(_target, _index);
}

pub fn disablei(_target: GLenum, _index: GLuint) void {
    return (function_pointers.glDisablei orelse @panic("glDisablei was not bound."))(_target, _index);
}

pub fn isEnabledi(_target: GLenum, _index: GLuint) GLboolean {
    return (function_pointers.glIsEnabledi orelse @panic("glIsEnabledi was not bound."))(_target, _index);
}

pub fn beginTransformFeedback(_primitiveMode: GLenum) void {
    return (function_pointers.glBeginTransformFeedback orelse @panic("glBeginTransformFeedback was not bound."))(_primitiveMode);
}

pub fn endTransformFeedback() void {
    return (function_pointers.glEndTransformFeedback orelse @panic("glEndTransformFeedback was not bound."))();
}

pub fn bindBufferRange(_target: GLenum, _index: GLuint, _buffer: GLuint, _offset: GLintptr, _size: GLsizeiptr) void {
    return (function_pointers.glBindBufferRange orelse @panic("glBindBufferRange was not bound."))(_target, _index, _buffer, _offset, _size);
}

pub fn bindBufferBase(_target: GLenum, _index: GLuint, _buffer: GLuint) void {
    return (function_pointers.glBindBufferBase orelse @panic("glBindBufferBase was not bound."))(_target, _index, _buffer);
}

pub fn transformFeedbackVaryings(_program: GLuint, _count: GLsizei, _varyings: *[:0]const GLchar, _bufferMode: GLenum) void {
    return (function_pointers.glTransformFeedbackVaryings orelse @panic("glTransformFeedbackVaryings was not bound."))(_program, _count, _varyings, _bufferMode);
}

pub fn getTransformFeedbackVarying(_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLsizei, _type: [*c]GLenum, _name: [*c]GLchar) void {
    return (function_pointers.glGetTransformFeedbackVarying orelse @panic("glGetTransformFeedbackVarying was not bound."))(_program, _index, _bufSize, _length, _size, _type, _name);
}

pub fn clampColor(_target: GLenum, _clamp: GLenum) void {
    return (function_pointers.glClampColor orelse @panic("glClampColor was not bound."))(_target, _clamp);
}

pub fn beginConditionalRender(_id: GLuint, _mode: GLenum) void {
    return (function_pointers.glBeginConditionalRender orelse @panic("glBeginConditionalRender was not bound."))(_id, _mode);
}

pub fn endConditionalRender() void {
    return (function_pointers.glEndConditionalRender orelse @panic("glEndConditionalRender was not bound."))();
}

pub fn vertexAttribIPointer(_index: GLuint, _size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void {
    return (function_pointers.glVertexAttribIPointer orelse @panic("glVertexAttribIPointer was not bound."))(_index, _size, _type, _stride, _pointer);
}

pub fn getVertexAttribIiv(_index: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetVertexAttribIiv orelse @panic("glGetVertexAttribIiv was not bound."))(_index, _pname, _params);
}

pub fn getVertexAttribIuiv(_index: GLuint, _pname: GLenum, _params: [*c]GLuint) void {
    return (function_pointers.glGetVertexAttribIuiv orelse @panic("glGetVertexAttribIuiv was not bound."))(_index, _pname, _params);
}

pub fn vertexAttribI1i(_index: GLuint, _x: GLint) void {
    return (function_pointers.glVertexAttribI1i orelse @panic("glVertexAttribI1i was not bound."))(_index, _x);
}

pub fn vertexAttribI2i(_index: GLuint, _x: GLint, _y: GLint) void {
    return (function_pointers.glVertexAttribI2i orelse @panic("glVertexAttribI2i was not bound."))(_index, _x, _y);
}

pub fn vertexAttribI3i(_index: GLuint, _x: GLint, _y: GLint, _z: GLint) void {
    return (function_pointers.glVertexAttribI3i orelse @panic("glVertexAttribI3i was not bound."))(_index, _x, _y, _z);
}

pub fn vertexAttribI4i(_index: GLuint, _x: GLint, _y: GLint, _z: GLint, _w: GLint) void {
    return (function_pointers.glVertexAttribI4i orelse @panic("glVertexAttribI4i was not bound."))(_index, _x, _y, _z, _w);
}

pub fn vertexAttribI1ui(_index: GLuint, _x: GLuint) void {
    return (function_pointers.glVertexAttribI1ui orelse @panic("glVertexAttribI1ui was not bound."))(_index, _x);
}

pub fn vertexAttribI2ui(_index: GLuint, _x: GLuint, _y: GLuint) void {
    return (function_pointers.glVertexAttribI2ui orelse @panic("glVertexAttribI2ui was not bound."))(_index, _x, _y);
}

pub fn vertexAttribI3ui(_index: GLuint, _x: GLuint, _y: GLuint, _z: GLuint) void {
    return (function_pointers.glVertexAttribI3ui orelse @panic("glVertexAttribI3ui was not bound."))(_index, _x, _y, _z);
}

pub fn vertexAttribI4ui(_index: GLuint, _x: GLuint, _y: GLuint, _z: GLuint, _w: GLuint) void {
    return (function_pointers.glVertexAttribI4ui orelse @panic("glVertexAttribI4ui was not bound."))(_index, _x, _y, _z, _w);
}

pub fn vertexAttribI1iv(_index: GLuint, _v: [*c]const GLint) void {
    return (function_pointers.glVertexAttribI1iv orelse @panic("glVertexAttribI1iv was not bound."))(_index, _v);
}

pub fn vertexAttribI2iv(_index: GLuint, _v: [*c]const GLint) void {
    return (function_pointers.glVertexAttribI2iv orelse @panic("glVertexAttribI2iv was not bound."))(_index, _v);
}

pub fn vertexAttribI3iv(_index: GLuint, _v: [*c]const GLint) void {
    return (function_pointers.glVertexAttribI3iv orelse @panic("glVertexAttribI3iv was not bound."))(_index, _v);
}

pub fn vertexAttribI4iv(_index: GLuint, _v: [*c]const GLint) void {
    return (function_pointers.glVertexAttribI4iv orelse @panic("glVertexAttribI4iv was not bound."))(_index, _v);
}

pub fn vertexAttribI1uiv(_index: GLuint, _v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribI1uiv orelse @panic("glVertexAttribI1uiv was not bound."))(_index, _v);
}

pub fn vertexAttribI2uiv(_index: GLuint, _v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribI2uiv orelse @panic("glVertexAttribI2uiv was not bound."))(_index, _v);
}

pub fn vertexAttribI3uiv(_index: GLuint, _v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribI3uiv orelse @panic("glVertexAttribI3uiv was not bound."))(_index, _v);
}

pub fn vertexAttribI4uiv(_index: GLuint, _v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribI4uiv orelse @panic("glVertexAttribI4uiv was not bound."))(_index, _v);
}

pub fn vertexAttribI4bv(_index: GLuint, _v: [*c]const GLbyte) void {
    return (function_pointers.glVertexAttribI4bv orelse @panic("glVertexAttribI4bv was not bound."))(_index, _v);
}

pub fn vertexAttribI4sv(_index: GLuint, _v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttribI4sv orelse @panic("glVertexAttribI4sv was not bound."))(_index, _v);
}

pub fn vertexAttribI4ubv(_index: GLuint, _v: ?[*:0]const GLubyte) void {
    return (function_pointers.glVertexAttribI4ubv orelse @panic("glVertexAttribI4ubv was not bound."))(_index, _v);
}

pub fn vertexAttribI4usv(_index: GLuint, _v: [*c]const GLushort) void {
    return (function_pointers.glVertexAttribI4usv orelse @panic("glVertexAttribI4usv was not bound."))(_index, _v);
}

pub fn getUniformuiv(_program: GLuint, _location: GLint, _params: [*c]GLuint) void {
    return (function_pointers.glGetUniformuiv orelse @panic("glGetUniformuiv was not bound."))(_program, _location, _params);
}

pub fn bindFragDataLocation(_program: GLuint, _color: GLuint, _name: [*c]const GLchar) void {
    return (function_pointers.glBindFragDataLocation orelse @panic("glBindFragDataLocation was not bound."))(_program, _color, _name);
}

pub fn getFragDataLocation(_program: GLuint, _name: [*c]const GLchar) GLint {
    return (function_pointers.glGetFragDataLocation orelse @panic("glGetFragDataLocation was not bound."))(_program, _name);
}

pub fn uniform1ui(_location: GLint, _v0: GLuint) void {
    return (function_pointers.glUniform1ui orelse @panic("glUniform1ui was not bound."))(_location, _v0);
}

pub fn uniform2ui(_location: GLint, _v0: GLuint, _v1: GLuint) void {
    return (function_pointers.glUniform2ui orelse @panic("glUniform2ui was not bound."))(_location, _v0, _v1);
}

pub fn uniform3ui(_location: GLint, _v0: GLuint, _v1: GLuint, _v2: GLuint) void {
    return (function_pointers.glUniform3ui orelse @panic("glUniform3ui was not bound."))(_location, _v0, _v1, _v2);
}

pub fn uniform4ui(_location: GLint, _v0: GLuint, _v1: GLuint, _v2: GLuint, _v3: GLuint) void {
    return (function_pointers.glUniform4ui orelse @panic("glUniform4ui was not bound."))(_location, _v0, _v1, _v2, _v3);
}

pub fn uniform1uiv(_location: GLint, _count: GLsizei, _value: [*c]const GLuint) void {
    return (function_pointers.glUniform1uiv orelse @panic("glUniform1uiv was not bound."))(_location, _count, _value);
}

pub fn uniform2uiv(_location: GLint, _count: GLsizei, _value: [*c]const GLuint) void {
    return (function_pointers.glUniform2uiv orelse @panic("glUniform2uiv was not bound."))(_location, _count, _value);
}

pub fn uniform3uiv(_location: GLint, _count: GLsizei, _value: [*c]const GLuint) void {
    return (function_pointers.glUniform3uiv orelse @panic("glUniform3uiv was not bound."))(_location, _count, _value);
}

pub fn uniform4uiv(_location: GLint, _count: GLsizei, _value: [*c]const GLuint) void {
    return (function_pointers.glUniform4uiv orelse @panic("glUniform4uiv was not bound."))(_location, _count, _value);
}

pub fn texParameterIiv(_target: GLenum, _pname: GLenum, _params: [*c]const GLint) void {
    return (function_pointers.glTexParameterIiv orelse @panic("glTexParameterIiv was not bound."))(_target, _pname, _params);
}

pub fn texParameterIuiv(_target: GLenum, _pname: GLenum, _params: [*c]const GLuint) void {
    return (function_pointers.glTexParameterIuiv orelse @panic("glTexParameterIuiv was not bound."))(_target, _pname, _params);
}

pub fn getTexParameterIiv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetTexParameterIiv orelse @panic("glGetTexParameterIiv was not bound."))(_target, _pname, _params);
}

pub fn getTexParameterIuiv(_target: GLenum, _pname: GLenum, _params: [*c]GLuint) void {
    return (function_pointers.glGetTexParameterIuiv orelse @panic("glGetTexParameterIuiv was not bound."))(_target, _pname, _params);
}

pub fn clearBufferiv(_buffer: GLenum, _drawbuffer: GLint, _value: [*c]const GLint) void {
    return (function_pointers.glClearBufferiv orelse @panic("glClearBufferiv was not bound."))(_buffer, _drawbuffer, _value);
}

pub fn clearBufferuiv(_buffer: GLenum, _drawbuffer: GLint, _value: [*c]const GLuint) void {
    return (function_pointers.glClearBufferuiv orelse @panic("glClearBufferuiv was not bound."))(_buffer, _drawbuffer, _value);
}

pub fn clearBufferfv(_buffer: GLenum, _drawbuffer: GLint, _value: [*c]const GLfloat) void {
    return (function_pointers.glClearBufferfv orelse @panic("glClearBufferfv was not bound."))(_buffer, _drawbuffer, _value);
}

pub fn clearBufferfi(_buffer: GLenum, _drawbuffer: GLint, _depth: GLfloat, _stencil: GLint) void {
    return (function_pointers.glClearBufferfi orelse @panic("glClearBufferfi was not bound."))(_buffer, _drawbuffer, _depth, _stencil);
}

pub fn getStringi(_name: GLenum, _index: GLuint) ?[*:0]const GLubyte {
    return (function_pointers.glGetStringi orelse @panic("glGetStringi was not bound."))(_name, _index);
}

pub fn isRenderbuffer(_renderbuffer: GLuint) GLboolean {
    return (function_pointers.glIsRenderbuffer orelse @panic("glIsRenderbuffer was not bound."))(_renderbuffer);
}

pub fn bindRenderbuffer(_target: GLenum, _renderbuffer: GLuint) void {
    return (function_pointers.glBindRenderbuffer orelse @panic("glBindRenderbuffer was not bound."))(_target, _renderbuffer);
}

pub fn deleteRenderbuffers(_n: GLsizei, _renderbuffers: [*c]const GLuint) void {
    return (function_pointers.glDeleteRenderbuffers orelse @panic("glDeleteRenderbuffers was not bound."))(_n, _renderbuffers);
}

pub fn genRenderbuffers(_n: GLsizei, _renderbuffers: [*c]GLuint) void {
    return (function_pointers.glGenRenderbuffers orelse @panic("glGenRenderbuffers was not bound."))(_n, _renderbuffers);
}

pub fn renderbufferStorage(_target: GLenum, _internalformat: GLenum, _width: GLsizei, _height: GLsizei) void {
    return (function_pointers.glRenderbufferStorage orelse @panic("glRenderbufferStorage was not bound."))(_target, _internalformat, _width, _height);
}

pub fn getRenderbufferParameteriv(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetRenderbufferParameteriv orelse @panic("glGetRenderbufferParameteriv was not bound."))(_target, _pname, _params);
}

pub fn isFramebuffer(_framebuffer: GLuint) GLboolean {
    return (function_pointers.glIsFramebuffer orelse @panic("glIsFramebuffer was not bound."))(_framebuffer);
}

pub fn bindFramebuffer(_target: GLenum, _framebuffer: GLuint) void {
    return (function_pointers.glBindFramebuffer orelse @panic("glBindFramebuffer was not bound."))(_target, _framebuffer);
}

pub fn deleteFramebuffers(_n: GLsizei, _framebuffers: [*c]const GLuint) void {
    return (function_pointers.glDeleteFramebuffers orelse @panic("glDeleteFramebuffers was not bound."))(_n, _framebuffers);
}

pub fn genFramebuffers(_n: GLsizei, _framebuffers: [*c]GLuint) void {
    return (function_pointers.glGenFramebuffers orelse @panic("glGenFramebuffers was not bound."))(_n, _framebuffers);
}

pub fn checkFramebufferStatus(_target: GLenum) GLenum {
    return (function_pointers.glCheckFramebufferStatus orelse @panic("glCheckFramebufferStatus was not bound."))(_target);
}

pub fn framebufferTexture1D(_target: GLenum, _attachment: GLenum, _textarget: GLenum, _texture: GLuint, _level: GLint) void {
    return (function_pointers.glFramebufferTexture1D orelse @panic("glFramebufferTexture1D was not bound."))(_target, _attachment, _textarget, _texture, _level);
}

pub fn framebufferTexture2D(_target: GLenum, _attachment: GLenum, _textarget: GLenum, _texture: GLuint, _level: GLint) void {
    return (function_pointers.glFramebufferTexture2D orelse @panic("glFramebufferTexture2D was not bound."))(_target, _attachment, _textarget, _texture, _level);
}

pub fn framebufferTexture3D(_target: GLenum, _attachment: GLenum, _textarget: GLenum, _texture: GLuint, _level: GLint, _zoffset: GLint) void {
    return (function_pointers.glFramebufferTexture3D orelse @panic("glFramebufferTexture3D was not bound."))(_target, _attachment, _textarget, _texture, _level, _zoffset);
}

pub fn framebufferRenderbuffer(_target: GLenum, _attachment: GLenum, _renderbuffertarget: GLenum, _renderbuffer: GLuint) void {
    return (function_pointers.glFramebufferRenderbuffer orelse @panic("glFramebufferRenderbuffer was not bound."))(_target, _attachment, _renderbuffertarget, _renderbuffer);
}

pub fn getFramebufferAttachmentParameteriv(_target: GLenum, _attachment: GLenum, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetFramebufferAttachmentParameteriv orelse @panic("glGetFramebufferAttachmentParameteriv was not bound."))(_target, _attachment, _pname, _params);
}

pub fn generateMipmap(_target: GLenum) void {
    return (function_pointers.glGenerateMipmap orelse @panic("glGenerateMipmap was not bound."))(_target);
}

pub fn blitFramebuffer(_srcX0: GLint, _srcY0: GLint, _srcX1: GLint, _srcY1: GLint, _dstX0: GLint, _dstY0: GLint, _dstX1: GLint, _dstY1: GLint, _mask: GLbitfield, _filter: GLenum) void {
    return (function_pointers.glBlitFramebuffer orelse @panic("glBlitFramebuffer was not bound."))(_srcX0, _srcY0, _srcX1, _srcY1, _dstX0, _dstY0, _dstX1, _dstY1, _mask, _filter);
}

pub fn renderbufferStorageMultisample(_target: GLenum, _samples: GLsizei, _internalformat: GLenum, _width: GLsizei, _height: GLsizei) void {
    return (function_pointers.glRenderbufferStorageMultisample orelse @panic("glRenderbufferStorageMultisample was not bound."))(_target, _samples, _internalformat, _width, _height);
}

pub fn framebufferTextureLayer(_target: GLenum, _attachment: GLenum, _texture: GLuint, _level: GLint, _layer: GLint) void {
    return (function_pointers.glFramebufferTextureLayer orelse @panic("glFramebufferTextureLayer was not bound."))(_target, _attachment, _texture, _level, _layer);
}

pub fn mapBufferRange(_target: GLenum, _offset: GLintptr, _length: GLsizeiptr, _access: GLbitfield) ?*anyopaque {
    return (function_pointers.glMapBufferRange orelse @panic("glMapBufferRange was not bound."))(_target, _offset, _length, _access);
}

pub fn flushMappedBufferRange(_target: GLenum, _offset: GLintptr, _length: GLsizeiptr) void {
    return (function_pointers.glFlushMappedBufferRange orelse @panic("glFlushMappedBufferRange was not bound."))(_target, _offset, _length);
}

pub fn bindVertexArray(_array: GLuint) void {
    return (function_pointers.glBindVertexArray orelse @panic("glBindVertexArray was not bound."))(_array);
}

pub fn deleteVertexArrays(_n: GLsizei, _arrays: [*c]const GLuint) void {
    return (function_pointers.glDeleteVertexArrays orelse @panic("glDeleteVertexArrays was not bound."))(_n, _arrays);
}

pub fn genVertexArrays(_n: GLsizei, _arrays: [*c]GLuint) void {
    return (function_pointers.glGenVertexArrays orelse @panic("glGenVertexArrays was not bound."))(_n, _arrays);
}

pub fn isVertexArray(_array: GLuint) GLboolean {
    return (function_pointers.glIsVertexArray orelse @panic("glIsVertexArray was not bound."))(_array);
}

pub fn drawArraysInstanced(_mode: GLenum, _first: GLint, _count: GLsizei, _instancecount: GLsizei) void {
    return (function_pointers.glDrawArraysInstanced orelse @panic("glDrawArraysInstanced was not bound."))(_mode, _first, _count, _instancecount);
}

pub fn drawElementsInstanced(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque, _instancecount: GLsizei) void {
    return (function_pointers.glDrawElementsInstanced orelse @panic("glDrawElementsInstanced was not bound."))(_mode, _count, _type, _indices, _instancecount);
}

pub fn texBuffer(_target: GLenum, _internalformat: GLenum, _buffer: GLuint) void {
    return (function_pointers.glTexBuffer orelse @panic("glTexBuffer was not bound."))(_target, _internalformat, _buffer);
}

pub fn primitiveRestartIndex(_index: GLuint) void {
    return (function_pointers.glPrimitiveRestartIndex orelse @panic("glPrimitiveRestartIndex was not bound."))(_index);
}

pub fn copyBufferSubData(_readTarget: GLenum, _writeTarget: GLenum, _readOffset: GLintptr, _writeOffset: GLintptr, _size: GLsizeiptr) void {
    return (function_pointers.glCopyBufferSubData orelse @panic("glCopyBufferSubData was not bound."))(_readTarget, _writeTarget, _readOffset, _writeOffset, _size);
}

pub fn getUniformIndices(_program: GLuint, _uniformCount: GLsizei, _uniformNames: *[:0]const GLchar, _uniformIndices: [*c]GLuint) void {
    return (function_pointers.glGetUniformIndices orelse @panic("glGetUniformIndices was not bound."))(_program, _uniformCount, _uniformNames, _uniformIndices);
}

pub fn getActiveUniformsiv(_program: GLuint, _uniformCount: GLsizei, _uniformIndices: [*c]const GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetActiveUniformsiv orelse @panic("glGetActiveUniformsiv was not bound."))(_program, _uniformCount, _uniformIndices, _pname, _params);
}

pub fn getActiveUniformName(_program: GLuint, _uniformIndex: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _uniformName: [*c]GLchar) void {
    return (function_pointers.glGetActiveUniformName orelse @panic("glGetActiveUniformName was not bound."))(_program, _uniformIndex, _bufSize, _length, _uniformName);
}

pub fn getUniformBlockIndex(_program: GLuint, _uniformBlockName: [*c]const GLchar) GLuint {
    return (function_pointers.glGetUniformBlockIndex orelse @panic("glGetUniformBlockIndex was not bound."))(_program, _uniformBlockName);
}

pub fn getActiveUniformBlockiv(_program: GLuint, _uniformBlockIndex: GLuint, _pname: GLenum, _params: [*c]GLint) void {
    return (function_pointers.glGetActiveUniformBlockiv orelse @panic("glGetActiveUniformBlockiv was not bound."))(_program, _uniformBlockIndex, _pname, _params);
}

pub fn getActiveUniformBlockName(_program: GLuint, _uniformBlockIndex: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _uniformBlockName: [*c]GLchar) void {
    return (function_pointers.glGetActiveUniformBlockName orelse @panic("glGetActiveUniformBlockName was not bound."))(_program, _uniformBlockIndex, _bufSize, _length, _uniformBlockName);
}

pub fn uniformBlockBinding(_program: GLuint, _uniformBlockIndex: GLuint, _uniformBlockBinding: GLuint) void {
    return (function_pointers.glUniformBlockBinding orelse @panic("glUniformBlockBinding was not bound."))(_program, _uniformBlockIndex, _uniformBlockBinding);
}
// Extensions:

// Loader API:
pub fn load(get_proc_address: fn ([*c]const u8) callconv(.C) ?*anyopaque) !void {
    var success = true;
    if(get_proc_address("glGetDoublei_v")) |proc| {
        function_pointers.glGetDoublei_v = @ptrCast(?function_signatures.glGetDoublei_v,  proc);
    } else {
        log.err("entry point glGetDoublei_v not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetFloati_v")) |proc| {
        function_pointers.glGetFloati_v = @ptrCast(?function_signatures.glGetFloati_v,  proc);
    } else {
        log.err("entry point glGetFloati_v not found!", .{});
        success = false;
    }
    if(get_proc_address("glDepthRangeIndexed")) |proc| {
        function_pointers.glDepthRangeIndexed = @ptrCast(?function_signatures.glDepthRangeIndexed,  proc);
    } else {
        log.err("entry point glDepthRangeIndexed not found!", .{});
        success = false;
    }
    if(get_proc_address("glDepthRangeArrayv")) |proc| {
        function_pointers.glDepthRangeArrayv = @ptrCast(?function_signatures.glDepthRangeArrayv,  proc);
    } else {
        log.err("entry point glDepthRangeArrayv not found!", .{});
        success = false;
    }
    if(get_proc_address("glScissorIndexedv")) |proc| {
        function_pointers.glScissorIndexedv = @ptrCast(?function_signatures.glScissorIndexedv,  proc);
    } else {
        log.err("entry point glScissorIndexedv not found!", .{});
        success = false;
    }
    if(get_proc_address("glScissorIndexed")) |proc| {
        function_pointers.glScissorIndexed = @ptrCast(?function_signatures.glScissorIndexed,  proc);
    } else {
        log.err("entry point glScissorIndexed not found!", .{});
        success = false;
    }
    if(get_proc_address("glScissorArrayv")) |proc| {
        function_pointers.glScissorArrayv = @ptrCast(?function_signatures.glScissorArrayv,  proc);
    } else {
        log.err("entry point glScissorArrayv not found!", .{});
        success = false;
    }
    if(get_proc_address("glViewportIndexedfv")) |proc| {
        function_pointers.glViewportIndexedfv = @ptrCast(?function_signatures.glViewportIndexedfv,  proc);
    } else {
        log.err("entry point glViewportIndexedfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glViewportIndexedf")) |proc| {
        function_pointers.glViewportIndexedf = @ptrCast(?function_signatures.glViewportIndexedf,  proc);
    } else {
        log.err("entry point glViewportIndexedf not found!", .{});
        success = false;
    }
    if(get_proc_address("glViewportArrayv")) |proc| {
        function_pointers.glViewportArrayv = @ptrCast(?function_signatures.glViewportArrayv,  proc);
    } else {
        log.err("entry point glViewportArrayv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetVertexAttribLdv")) |proc| {
        function_pointers.glGetVertexAttribLdv = @ptrCast(?function_signatures.glGetVertexAttribLdv,  proc);
    } else {
        log.err("entry point glGetVertexAttribLdv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribLPointer")) |proc| {
        function_pointers.glVertexAttribLPointer = @ptrCast(?function_signatures.glVertexAttribLPointer,  proc);
    } else {
        log.err("entry point glVertexAttribLPointer not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribL4dv")) |proc| {
        function_pointers.glVertexAttribL4dv = @ptrCast(?function_signatures.glVertexAttribL4dv,  proc);
    } else {
        log.err("entry point glVertexAttribL4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribL3dv")) |proc| {
        function_pointers.glVertexAttribL3dv = @ptrCast(?function_signatures.glVertexAttribL3dv,  proc);
    } else {
        log.err("entry point glVertexAttribL3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribL2dv")) |proc| {
        function_pointers.glVertexAttribL2dv = @ptrCast(?function_signatures.glVertexAttribL2dv,  proc);
    } else {
        log.err("entry point glVertexAttribL2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribL1dv")) |proc| {
        function_pointers.glVertexAttribL1dv = @ptrCast(?function_signatures.glVertexAttribL1dv,  proc);
    } else {
        log.err("entry point glVertexAttribL1dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribL4d")) |proc| {
        function_pointers.glVertexAttribL4d = @ptrCast(?function_signatures.glVertexAttribL4d,  proc);
    } else {
        log.err("entry point glVertexAttribL4d not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribL3d")) |proc| {
        function_pointers.glVertexAttribL3d = @ptrCast(?function_signatures.glVertexAttribL3d,  proc);
    } else {
        log.err("entry point glVertexAttribL3d not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribL2d")) |proc| {
        function_pointers.glVertexAttribL2d = @ptrCast(?function_signatures.glVertexAttribL2d,  proc);
    } else {
        log.err("entry point glVertexAttribL2d not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribL1d")) |proc| {
        function_pointers.glVertexAttribL1d = @ptrCast(?function_signatures.glVertexAttribL1d,  proc);
    } else {
        log.err("entry point glVertexAttribL1d not found!", .{});
        success = false;
    }
    if(get_proc_address("glValidateProgramPipeline")) |proc| {
        function_pointers.glValidateProgramPipeline = @ptrCast(?function_signatures.glValidateProgramPipeline,  proc);
    } else {
        log.err("entry point glValidateProgramPipeline not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix4x3dv")) |proc| {
        function_pointers.glProgramUniformMatrix4x3dv = @ptrCast(?function_signatures.glProgramUniformMatrix4x3dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix4x3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix3x4dv")) |proc| {
        function_pointers.glProgramUniformMatrix3x4dv = @ptrCast(?function_signatures.glProgramUniformMatrix3x4dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix3x4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix4x2dv")) |proc| {
        function_pointers.glProgramUniformMatrix4x2dv = @ptrCast(?function_signatures.glProgramUniformMatrix4x2dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix4x2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix2x4dv")) |proc| {
        function_pointers.glProgramUniformMatrix2x4dv = @ptrCast(?function_signatures.glProgramUniformMatrix2x4dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix2x4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix3x2dv")) |proc| {
        function_pointers.glProgramUniformMatrix3x2dv = @ptrCast(?function_signatures.glProgramUniformMatrix3x2dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix3x2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix2x3dv")) |proc| {
        function_pointers.glProgramUniformMatrix2x3dv = @ptrCast(?function_signatures.glProgramUniformMatrix2x3dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix2x3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix4x3fv")) |proc| {
        function_pointers.glProgramUniformMatrix4x3fv = @ptrCast(?function_signatures.glProgramUniformMatrix4x3fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix4x3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix3x4fv")) |proc| {
        function_pointers.glProgramUniformMatrix3x4fv = @ptrCast(?function_signatures.glProgramUniformMatrix3x4fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix3x4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix4x2fv")) |proc| {
        function_pointers.glProgramUniformMatrix4x2fv = @ptrCast(?function_signatures.glProgramUniformMatrix4x2fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix4x2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix2x4fv")) |proc| {
        function_pointers.glProgramUniformMatrix2x4fv = @ptrCast(?function_signatures.glProgramUniformMatrix2x4fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix2x4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix3x2fv")) |proc| {
        function_pointers.glProgramUniformMatrix3x2fv = @ptrCast(?function_signatures.glProgramUniformMatrix3x2fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix3x2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix2x3fv")) |proc| {
        function_pointers.glProgramUniformMatrix2x3fv = @ptrCast(?function_signatures.glProgramUniformMatrix2x3fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix2x3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix4dv")) |proc| {
        function_pointers.glProgramUniformMatrix4dv = @ptrCast(?function_signatures.glProgramUniformMatrix4dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix3dv")) |proc| {
        function_pointers.glProgramUniformMatrix3dv = @ptrCast(?function_signatures.glProgramUniformMatrix3dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix2dv")) |proc| {
        function_pointers.glProgramUniformMatrix2dv = @ptrCast(?function_signatures.glProgramUniformMatrix2dv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix4fv")) |proc| {
        function_pointers.glProgramUniformMatrix4fv = @ptrCast(?function_signatures.glProgramUniformMatrix4fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix3fv")) |proc| {
        function_pointers.glProgramUniformMatrix3fv = @ptrCast(?function_signatures.glProgramUniformMatrix3fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniformMatrix2fv")) |proc| {
        function_pointers.glProgramUniformMatrix2fv = @ptrCast(?function_signatures.glProgramUniformMatrix2fv,  proc);
    } else {
        log.err("entry point glProgramUniformMatrix2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform4uiv")) |proc| {
        function_pointers.glProgramUniform4uiv = @ptrCast(?function_signatures.glProgramUniform4uiv,  proc);
    } else {
        log.err("entry point glProgramUniform4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform4ui")) |proc| {
        function_pointers.glProgramUniform4ui = @ptrCast(?function_signatures.glProgramUniform4ui,  proc);
    } else {
        log.err("entry point glProgramUniform4ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform4dv")) |proc| {
        function_pointers.glProgramUniform4dv = @ptrCast(?function_signatures.glProgramUniform4dv,  proc);
    } else {
        log.err("entry point glProgramUniform4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform4d")) |proc| {
        function_pointers.glProgramUniform4d = @ptrCast(?function_signatures.glProgramUniform4d,  proc);
    } else {
        log.err("entry point glProgramUniform4d not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform4fv")) |proc| {
        function_pointers.glProgramUniform4fv = @ptrCast(?function_signatures.glProgramUniform4fv,  proc);
    } else {
        log.err("entry point glProgramUniform4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform4f")) |proc| {
        function_pointers.glProgramUniform4f = @ptrCast(?function_signatures.glProgramUniform4f,  proc);
    } else {
        log.err("entry point glProgramUniform4f not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform4iv")) |proc| {
        function_pointers.glProgramUniform4iv = @ptrCast(?function_signatures.glProgramUniform4iv,  proc);
    } else {
        log.err("entry point glProgramUniform4iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform4i")) |proc| {
        function_pointers.glProgramUniform4i = @ptrCast(?function_signatures.glProgramUniform4i,  proc);
    } else {
        log.err("entry point glProgramUniform4i not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform3uiv")) |proc| {
        function_pointers.glProgramUniform3uiv = @ptrCast(?function_signatures.glProgramUniform3uiv,  proc);
    } else {
        log.err("entry point glProgramUniform3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform3ui")) |proc| {
        function_pointers.glProgramUniform3ui = @ptrCast(?function_signatures.glProgramUniform3ui,  proc);
    } else {
        log.err("entry point glProgramUniform3ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform3dv")) |proc| {
        function_pointers.glProgramUniform3dv = @ptrCast(?function_signatures.glProgramUniform3dv,  proc);
    } else {
        log.err("entry point glProgramUniform3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform3d")) |proc| {
        function_pointers.glProgramUniform3d = @ptrCast(?function_signatures.glProgramUniform3d,  proc);
    } else {
        log.err("entry point glProgramUniform3d not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform3fv")) |proc| {
        function_pointers.glProgramUniform3fv = @ptrCast(?function_signatures.glProgramUniform3fv,  proc);
    } else {
        log.err("entry point glProgramUniform3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform3f")) |proc| {
        function_pointers.glProgramUniform3f = @ptrCast(?function_signatures.glProgramUniform3f,  proc);
    } else {
        log.err("entry point glProgramUniform3f not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform3iv")) |proc| {
        function_pointers.glProgramUniform3iv = @ptrCast(?function_signatures.glProgramUniform3iv,  proc);
    } else {
        log.err("entry point glProgramUniform3iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform3i")) |proc| {
        function_pointers.glProgramUniform3i = @ptrCast(?function_signatures.glProgramUniform3i,  proc);
    } else {
        log.err("entry point glProgramUniform3i not found!", .{});
        success = false;
    }
    if(get_proc_address("glUseProgramStages")) |proc| {
        function_pointers.glUseProgramStages = @ptrCast(?function_signatures.glUseProgramStages,  proc);
    } else {
        log.err("entry point glUseProgramStages not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramParameteri")) |proc| {
        function_pointers.glProgramParameteri = @ptrCast(?function_signatures.glProgramParameteri,  proc);
    } else {
        log.err("entry point glProgramParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetShaderPrecisionFormat")) |proc| {
        function_pointers.glGetShaderPrecisionFormat = @ptrCast(?function_signatures.glGetShaderPrecisionFormat,  proc);
    } else {
        log.err("entry point glGetShaderPrecisionFormat not found!", .{});
        success = false;
    }
    if(get_proc_address("glShaderBinary")) |proc| {
        function_pointers.glShaderBinary = @ptrCast(?function_signatures.glShaderBinary,  proc);
    } else {
        log.err("entry point glShaderBinary not found!", .{});
        success = false;
    }
    if(get_proc_address("glReleaseShaderCompiler")) |proc| {
        function_pointers.glReleaseShaderCompiler = @ptrCast(?function_signatures.glReleaseShaderCompiler,  proc);
    } else {
        log.err("entry point glReleaseShaderCompiler not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetQueryIndexediv")) |proc| {
        function_pointers.glGetQueryIndexediv = @ptrCast(?function_signatures.glGetQueryIndexediv,  proc);
    } else {
        log.err("entry point glGetQueryIndexediv not found!", .{});
        success = false;
    }
    if(get_proc_address("glEndQueryIndexed")) |proc| {
        function_pointers.glEndQueryIndexed = @ptrCast(?function_signatures.glEndQueryIndexed,  proc);
    } else {
        log.err("entry point glEndQueryIndexed not found!", .{});
        success = false;
    }
    if(get_proc_address("glBeginQueryIndexed")) |proc| {
        function_pointers.glBeginQueryIndexed = @ptrCast(?function_signatures.glBeginQueryIndexed,  proc);
    } else {
        log.err("entry point glBeginQueryIndexed not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawTransformFeedbackStream")) |proc| {
        function_pointers.glDrawTransformFeedbackStream = @ptrCast(?function_signatures.glDrawTransformFeedbackStream,  proc);
    } else {
        log.err("entry point glDrawTransformFeedbackStream not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawTransformFeedback")) |proc| {
        function_pointers.glDrawTransformFeedback = @ptrCast(?function_signatures.glDrawTransformFeedback,  proc);
    } else {
        log.err("entry point glDrawTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address("glResumeTransformFeedback")) |proc| {
        function_pointers.glResumeTransformFeedback = @ptrCast(?function_signatures.glResumeTransformFeedback,  proc);
    } else {
        log.err("entry point glResumeTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address("glPauseTransformFeedback")) |proc| {
        function_pointers.glPauseTransformFeedback = @ptrCast(?function_signatures.glPauseTransformFeedback,  proc);
    } else {
        log.err("entry point glPauseTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetProgramStageiv")) |proc| {
        function_pointers.glGetProgramStageiv = @ptrCast(?function_signatures.glGetProgramStageiv,  proc);
    } else {
        log.err("entry point glGetProgramStageiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetUniformSubroutineuiv")) |proc| {
        function_pointers.glGetUniformSubroutineuiv = @ptrCast(?function_signatures.glGetUniformSubroutineuiv,  proc);
    } else {
        log.err("entry point glGetUniformSubroutineuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformSubroutinesuiv")) |proc| {
        function_pointers.glUniformSubroutinesuiv = @ptrCast(?function_signatures.glUniformSubroutinesuiv,  proc);
    } else {
        log.err("entry point glUniformSubroutinesuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveSubroutineName")) |proc| {
        function_pointers.glGetActiveSubroutineName = @ptrCast(?function_signatures.glGetActiveSubroutineName,  proc);
    } else {
        log.err("entry point glGetActiveSubroutineName not found!", .{});
        success = false;
    }
    if(get_proc_address("glCullFace")) |proc| {
        function_pointers.glCullFace = @ptrCast(?function_signatures.glCullFace,  proc);
    } else {
        log.err("entry point glCullFace not found!", .{});
        success = false;
    }
    if(get_proc_address("glFrontFace")) |proc| {
        function_pointers.glFrontFace = @ptrCast(?function_signatures.glFrontFace,  proc);
    } else {
        log.err("entry point glFrontFace not found!", .{});
        success = false;
    }
    if(get_proc_address("glHint")) |proc| {
        function_pointers.glHint = @ptrCast(?function_signatures.glHint,  proc);
    } else {
        log.err("entry point glHint not found!", .{});
        success = false;
    }
    if(get_proc_address("glLineWidth")) |proc| {
        function_pointers.glLineWidth = @ptrCast(?function_signatures.glLineWidth,  proc);
    } else {
        log.err("entry point glLineWidth not found!", .{});
        success = false;
    }
    if(get_proc_address("glPointSize")) |proc| {
        function_pointers.glPointSize = @ptrCast(?function_signatures.glPointSize,  proc);
    } else {
        log.err("entry point glPointSize not found!", .{});
        success = false;
    }
    if(get_proc_address("glPolygonMode")) |proc| {
        function_pointers.glPolygonMode = @ptrCast(?function_signatures.glPolygonMode,  proc);
    } else {
        log.err("entry point glPolygonMode not found!", .{});
        success = false;
    }
    if(get_proc_address("glScissor")) |proc| {
        function_pointers.glScissor = @ptrCast(?function_signatures.glScissor,  proc);
    } else {
        log.err("entry point glScissor not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexParameterf")) |proc| {
        function_pointers.glTexParameterf = @ptrCast(?function_signatures.glTexParameterf,  proc);
    } else {
        log.err("entry point glTexParameterf not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexParameterfv")) |proc| {
        function_pointers.glTexParameterfv = @ptrCast(?function_signatures.glTexParameterfv,  proc);
    } else {
        log.err("entry point glTexParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexParameteri")) |proc| {
        function_pointers.glTexParameteri = @ptrCast(?function_signatures.glTexParameteri,  proc);
    } else {
        log.err("entry point glTexParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexParameteriv")) |proc| {
        function_pointers.glTexParameteriv = @ptrCast(?function_signatures.glTexParameteriv,  proc);
    } else {
        log.err("entry point glTexParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexImage1D")) |proc| {
        function_pointers.glTexImage1D = @ptrCast(?function_signatures.glTexImage1D,  proc);
    } else {
        log.err("entry point glTexImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexImage2D")) |proc| {
        function_pointers.glTexImage2D = @ptrCast(?function_signatures.glTexImage2D,  proc);
    } else {
        log.err("entry point glTexImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawBuffer")) |proc| {
        function_pointers.glDrawBuffer = @ptrCast(?function_signatures.glDrawBuffer,  proc);
    } else {
        log.err("entry point glDrawBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glClear")) |proc| {
        function_pointers.glClear = @ptrCast(?function_signatures.glClear,  proc);
    } else {
        log.err("entry point glClear not found!", .{});
        success = false;
    }
    if(get_proc_address("glClearColor")) |proc| {
        function_pointers.glClearColor = @ptrCast(?function_signatures.glClearColor,  proc);
    } else {
        log.err("entry point glClearColor not found!", .{});
        success = false;
    }
    if(get_proc_address("glClearStencil")) |proc| {
        function_pointers.glClearStencil = @ptrCast(?function_signatures.glClearStencil,  proc);
    } else {
        log.err("entry point glClearStencil not found!", .{});
        success = false;
    }
    if(get_proc_address("glClearDepth")) |proc| {
        function_pointers.glClearDepth = @ptrCast(?function_signatures.glClearDepth,  proc);
    } else {
        log.err("entry point glClearDepth not found!", .{});
        success = false;
    }
    if(get_proc_address("glStencilMask")) |proc| {
        function_pointers.glStencilMask = @ptrCast(?function_signatures.glStencilMask,  proc);
    } else {
        log.err("entry point glStencilMask not found!", .{});
        success = false;
    }
    if(get_proc_address("glColorMask")) |proc| {
        function_pointers.glColorMask = @ptrCast(?function_signatures.glColorMask,  proc);
    } else {
        log.err("entry point glColorMask not found!", .{});
        success = false;
    }
    if(get_proc_address("glDepthMask")) |proc| {
        function_pointers.glDepthMask = @ptrCast(?function_signatures.glDepthMask,  proc);
    } else {
        log.err("entry point glDepthMask not found!", .{});
        success = false;
    }
    if(get_proc_address("glDisable")) |proc| {
        function_pointers.glDisable = @ptrCast(?function_signatures.glDisable,  proc);
    } else {
        log.err("entry point glDisable not found!", .{});
        success = false;
    }
    if(get_proc_address("glEnable")) |proc| {
        function_pointers.glEnable = @ptrCast(?function_signatures.glEnable,  proc);
    } else {
        log.err("entry point glEnable not found!", .{});
        success = false;
    }
    if(get_proc_address("glFinish")) |proc| {
        function_pointers.glFinish = @ptrCast(?function_signatures.glFinish,  proc);
    } else {
        log.err("entry point glFinish not found!", .{});
        success = false;
    }
    if(get_proc_address("glFlush")) |proc| {
        function_pointers.glFlush = @ptrCast(?function_signatures.glFlush,  proc);
    } else {
        log.err("entry point glFlush not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendFunc")) |proc| {
        function_pointers.glBlendFunc = @ptrCast(?function_signatures.glBlendFunc,  proc);
    } else {
        log.err("entry point glBlendFunc not found!", .{});
        success = false;
    }
    if(get_proc_address("glLogicOp")) |proc| {
        function_pointers.glLogicOp = @ptrCast(?function_signatures.glLogicOp,  proc);
    } else {
        log.err("entry point glLogicOp not found!", .{});
        success = false;
    }
    if(get_proc_address("glStencilFunc")) |proc| {
        function_pointers.glStencilFunc = @ptrCast(?function_signatures.glStencilFunc,  proc);
    } else {
        log.err("entry point glStencilFunc not found!", .{});
        success = false;
    }
    if(get_proc_address("glStencilOp")) |proc| {
        function_pointers.glStencilOp = @ptrCast(?function_signatures.glStencilOp,  proc);
    } else {
        log.err("entry point glStencilOp not found!", .{});
        success = false;
    }
    if(get_proc_address("glDepthFunc")) |proc| {
        function_pointers.glDepthFunc = @ptrCast(?function_signatures.glDepthFunc,  proc);
    } else {
        log.err("entry point glDepthFunc not found!", .{});
        success = false;
    }
    if(get_proc_address("glPixelStoref")) |proc| {
        function_pointers.glPixelStoref = @ptrCast(?function_signatures.glPixelStoref,  proc);
    } else {
        log.err("entry point glPixelStoref not found!", .{});
        success = false;
    }
    if(get_proc_address("glPixelStorei")) |proc| {
        function_pointers.glPixelStorei = @ptrCast(?function_signatures.glPixelStorei,  proc);
    } else {
        log.err("entry point glPixelStorei not found!", .{});
        success = false;
    }
    if(get_proc_address("glReadBuffer")) |proc| {
        function_pointers.glReadBuffer = @ptrCast(?function_signatures.glReadBuffer,  proc);
    } else {
        log.err("entry point glReadBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glReadPixels")) |proc| {
        function_pointers.glReadPixels = @ptrCast(?function_signatures.glReadPixels,  proc);
    } else {
        log.err("entry point glReadPixels not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetBooleanv")) |proc| {
        function_pointers.glGetBooleanv = @ptrCast(?function_signatures.glGetBooleanv,  proc);
    } else {
        log.err("entry point glGetBooleanv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetDoublev")) |proc| {
        function_pointers.glGetDoublev = @ptrCast(?function_signatures.glGetDoublev,  proc);
    } else {
        log.err("entry point glGetDoublev not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetError")) |proc| {
        function_pointers.glGetError = @ptrCast(?function_signatures.glGetError,  proc);
    } else {
        log.err("entry point glGetError not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetFloatv")) |proc| {
        function_pointers.glGetFloatv = @ptrCast(?function_signatures.glGetFloatv,  proc);
    } else {
        log.err("entry point glGetFloatv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetIntegerv")) |proc| {
        function_pointers.glGetIntegerv = @ptrCast(?function_signatures.glGetIntegerv,  proc);
    } else {
        log.err("entry point glGetIntegerv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetString")) |proc| {
        function_pointers.glGetString = @ptrCast(?function_signatures.glGetString,  proc);
    } else {
        log.err("entry point glGetString not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetTexImage")) |proc| {
        function_pointers.glGetTexImage = @ptrCast(?function_signatures.glGetTexImage,  proc);
    } else {
        log.err("entry point glGetTexImage not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetTexParameterfv")) |proc| {
        function_pointers.glGetTexParameterfv = @ptrCast(?function_signatures.glGetTexParameterfv,  proc);
    } else {
        log.err("entry point glGetTexParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetTexParameteriv")) |proc| {
        function_pointers.glGetTexParameteriv = @ptrCast(?function_signatures.glGetTexParameteriv,  proc);
    } else {
        log.err("entry point glGetTexParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetTexLevelParameterfv")) |proc| {
        function_pointers.glGetTexLevelParameterfv = @ptrCast(?function_signatures.glGetTexLevelParameterfv,  proc);
    } else {
        log.err("entry point glGetTexLevelParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetTexLevelParameteriv")) |proc| {
        function_pointers.glGetTexLevelParameteriv = @ptrCast(?function_signatures.glGetTexLevelParameteriv,  proc);
    } else {
        log.err("entry point glGetTexLevelParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsEnabled")) |proc| {
        function_pointers.glIsEnabled = @ptrCast(?function_signatures.glIsEnabled,  proc);
    } else {
        log.err("entry point glIsEnabled not found!", .{});
        success = false;
    }
    if(get_proc_address("glDepthRange")) |proc| {
        function_pointers.glDepthRange = @ptrCast(?function_signatures.glDepthRange,  proc);
    } else {
        log.err("entry point glDepthRange not found!", .{});
        success = false;
    }
    if(get_proc_address("glViewport")) |proc| {
        function_pointers.glViewport = @ptrCast(?function_signatures.glViewport,  proc);
    } else {
        log.err("entry point glViewport not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetProgramPipelineInfoLog")) |proc| {
        function_pointers.glGetProgramPipelineInfoLog = @ptrCast(?function_signatures.glGetProgramPipelineInfoLog,  proc);
    } else {
        log.err("entry point glGetProgramPipelineInfoLog not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform2uiv")) |proc| {
        function_pointers.glProgramUniform2uiv = @ptrCast(?function_signatures.glProgramUniform2uiv,  proc);
    } else {
        log.err("entry point glProgramUniform2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform2ui")) |proc| {
        function_pointers.glProgramUniform2ui = @ptrCast(?function_signatures.glProgramUniform2ui,  proc);
    } else {
        log.err("entry point glProgramUniform2ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform2dv")) |proc| {
        function_pointers.glProgramUniform2dv = @ptrCast(?function_signatures.glProgramUniform2dv,  proc);
    } else {
        log.err("entry point glProgramUniform2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform2d")) |proc| {
        function_pointers.glProgramUniform2d = @ptrCast(?function_signatures.glProgramUniform2d,  proc);
    } else {
        log.err("entry point glProgramUniform2d not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform2fv")) |proc| {
        function_pointers.glProgramUniform2fv = @ptrCast(?function_signatures.glProgramUniform2fv,  proc);
    } else {
        log.err("entry point glProgramUniform2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform2f")) |proc| {
        function_pointers.glProgramUniform2f = @ptrCast(?function_signatures.glProgramUniform2f,  proc);
    } else {
        log.err("entry point glProgramUniform2f not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform2iv")) |proc| {
        function_pointers.glProgramUniform2iv = @ptrCast(?function_signatures.glProgramUniform2iv,  proc);
    } else {
        log.err("entry point glProgramUniform2iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform2i")) |proc| {
        function_pointers.glProgramUniform2i = @ptrCast(?function_signatures.glProgramUniform2i,  proc);
    } else {
        log.err("entry point glProgramUniform2i not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform1uiv")) |proc| {
        function_pointers.glProgramUniform1uiv = @ptrCast(?function_signatures.glProgramUniform1uiv,  proc);
    } else {
        log.err("entry point glProgramUniform1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform1ui")) |proc| {
        function_pointers.glProgramUniform1ui = @ptrCast(?function_signatures.glProgramUniform1ui,  proc);
    } else {
        log.err("entry point glProgramUniform1ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform1dv")) |proc| {
        function_pointers.glProgramUniform1dv = @ptrCast(?function_signatures.glProgramUniform1dv,  proc);
    } else {
        log.err("entry point glProgramUniform1dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform1d")) |proc| {
        function_pointers.glProgramUniform1d = @ptrCast(?function_signatures.glProgramUniform1d,  proc);
    } else {
        log.err("entry point glProgramUniform1d not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform1fv")) |proc| {
        function_pointers.glProgramUniform1fv = @ptrCast(?function_signatures.glProgramUniform1fv,  proc);
    } else {
        log.err("entry point glProgramUniform1fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform1f")) |proc| {
        function_pointers.glProgramUniform1f = @ptrCast(?function_signatures.glProgramUniform1f,  proc);
    } else {
        log.err("entry point glProgramUniform1f not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform1iv")) |proc| {
        function_pointers.glProgramUniform1iv = @ptrCast(?function_signatures.glProgramUniform1iv,  proc);
    } else {
        log.err("entry point glProgramUniform1iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramUniform1i")) |proc| {
        function_pointers.glProgramUniform1i = @ptrCast(?function_signatures.glProgramUniform1i,  proc);
    } else {
        log.err("entry point glProgramUniform1i not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetProgramPipelineiv")) |proc| {
        function_pointers.glGetProgramPipelineiv = @ptrCast(?function_signatures.glGetProgramPipelineiv,  proc);
    } else {
        log.err("entry point glGetProgramPipelineiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsProgramPipeline")) |proc| {
        function_pointers.glIsProgramPipeline = @ptrCast(?function_signatures.glIsProgramPipeline,  proc);
    } else {
        log.err("entry point glIsProgramPipeline not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenProgramPipelines")) |proc| {
        function_pointers.glGenProgramPipelines = @ptrCast(?function_signatures.glGenProgramPipelines,  proc);
    } else {
        log.err("entry point glGenProgramPipelines not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteProgramPipelines")) |proc| {
        function_pointers.glDeleteProgramPipelines = @ptrCast(?function_signatures.glDeleteProgramPipelines,  proc);
    } else {
        log.err("entry point glDeleteProgramPipelines not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindProgramPipeline")) |proc| {
        function_pointers.glBindProgramPipeline = @ptrCast(?function_signatures.glBindProgramPipeline,  proc);
    } else {
        log.err("entry point glBindProgramPipeline not found!", .{});
        success = false;
    }
    if(get_proc_address("glCreateShaderProgramv")) |proc| {
        function_pointers.glCreateShaderProgramv = @ptrCast(?function_signatures.glCreateShaderProgramv,  proc);
    } else {
        log.err("entry point glCreateShaderProgramv not found!", .{});
        success = false;
    }
    if(get_proc_address("glActiveShaderProgram")) |proc| {
        function_pointers.glActiveShaderProgram = @ptrCast(?function_signatures.glActiveShaderProgram,  proc);
    } else {
        log.err("entry point glActiveShaderProgram not found!", .{});
        success = false;
    }
    if(get_proc_address("glProgramBinary")) |proc| {
        function_pointers.glProgramBinary = @ptrCast(?function_signatures.glProgramBinary,  proc);
    } else {
        log.err("entry point glProgramBinary not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetProgramBinary")) |proc| {
        function_pointers.glGetProgramBinary = @ptrCast(?function_signatures.glGetProgramBinary,  proc);
    } else {
        log.err("entry point glGetProgramBinary not found!", .{});
        success = false;
    }
    if(get_proc_address("glClearDepthf")) |proc| {
        function_pointers.glClearDepthf = @ptrCast(?function_signatures.glClearDepthf,  proc);
    } else {
        log.err("entry point glClearDepthf not found!", .{});
        success = false;
    }
    if(get_proc_address("glDepthRangef")) |proc| {
        function_pointers.glDepthRangef = @ptrCast(?function_signatures.glDepthRangef,  proc);
    } else {
        log.err("entry point glDepthRangef not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsTransformFeedback")) |proc| {
        function_pointers.glIsTransformFeedback = @ptrCast(?function_signatures.glIsTransformFeedback,  proc);
    } else {
        log.err("entry point glIsTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenTransformFeedbacks")) |proc| {
        function_pointers.glGenTransformFeedbacks = @ptrCast(?function_signatures.glGenTransformFeedbacks,  proc);
    } else {
        log.err("entry point glGenTransformFeedbacks not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteTransformFeedbacks")) |proc| {
        function_pointers.glDeleteTransformFeedbacks = @ptrCast(?function_signatures.glDeleteTransformFeedbacks,  proc);
    } else {
        log.err("entry point glDeleteTransformFeedbacks not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindTransformFeedback")) |proc| {
        function_pointers.glBindTransformFeedback = @ptrCast(?function_signatures.glBindTransformFeedback,  proc);
    } else {
        log.err("entry point glBindTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address("glPatchParameterfv")) |proc| {
        function_pointers.glPatchParameterfv = @ptrCast(?function_signatures.glPatchParameterfv,  proc);
    } else {
        log.err("entry point glPatchParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glPatchParameteri")) |proc| {
        function_pointers.glPatchParameteri = @ptrCast(?function_signatures.glPatchParameteri,  proc);
    } else {
        log.err("entry point glPatchParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawArrays")) |proc| {
        function_pointers.glDrawArrays = @ptrCast(?function_signatures.glDrawArrays,  proc);
    } else {
        log.err("entry point glDrawArrays not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawElements")) |proc| {
        function_pointers.glDrawElements = @ptrCast(?function_signatures.glDrawElements,  proc);
    } else {
        log.err("entry point glDrawElements not found!", .{});
        success = false;
    }
    if(get_proc_address("glPolygonOffset")) |proc| {
        function_pointers.glPolygonOffset = @ptrCast(?function_signatures.glPolygonOffset,  proc);
    } else {
        log.err("entry point glPolygonOffset not found!", .{});
        success = false;
    }
    if(get_proc_address("glCopyTexImage1D")) |proc| {
        function_pointers.glCopyTexImage1D = @ptrCast(?function_signatures.glCopyTexImage1D,  proc);
    } else {
        log.err("entry point glCopyTexImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCopyTexImage2D")) |proc| {
        function_pointers.glCopyTexImage2D = @ptrCast(?function_signatures.glCopyTexImage2D,  proc);
    } else {
        log.err("entry point glCopyTexImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCopyTexSubImage1D")) |proc| {
        function_pointers.glCopyTexSubImage1D = @ptrCast(?function_signatures.glCopyTexSubImage1D,  proc);
    } else {
        log.err("entry point glCopyTexSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCopyTexSubImage2D")) |proc| {
        function_pointers.glCopyTexSubImage2D = @ptrCast(?function_signatures.glCopyTexSubImage2D,  proc);
    } else {
        log.err("entry point glCopyTexSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexSubImage1D")) |proc| {
        function_pointers.glTexSubImage1D = @ptrCast(?function_signatures.glTexSubImage1D,  proc);
    } else {
        log.err("entry point glTexSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexSubImage2D")) |proc| {
        function_pointers.glTexSubImage2D = @ptrCast(?function_signatures.glTexSubImage2D,  proc);
    } else {
        log.err("entry point glTexSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindTexture")) |proc| {
        function_pointers.glBindTexture = @ptrCast(?function_signatures.glBindTexture,  proc);
    } else {
        log.err("entry point glBindTexture not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteTextures")) |proc| {
        function_pointers.glDeleteTextures = @ptrCast(?function_signatures.glDeleteTextures,  proc);
    } else {
        log.err("entry point glDeleteTextures not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenTextures")) |proc| {
        function_pointers.glGenTextures = @ptrCast(?function_signatures.glGenTextures,  proc);
    } else {
        log.err("entry point glGenTextures not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsTexture")) |proc| {
        function_pointers.glIsTexture = @ptrCast(?function_signatures.glIsTexture,  proc);
    } else {
        log.err("entry point glIsTexture not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveSubroutineUniformName")) |proc| {
        function_pointers.glGetActiveSubroutineUniformName = @ptrCast(?function_signatures.glGetActiveSubroutineUniformName,  proc);
    } else {
        log.err("entry point glGetActiveSubroutineUniformName not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveSubroutineUniformiv")) |proc| {
        function_pointers.glGetActiveSubroutineUniformiv = @ptrCast(?function_signatures.glGetActiveSubroutineUniformiv,  proc);
    } else {
        log.err("entry point glGetActiveSubroutineUniformiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetSubroutineIndex")) |proc| {
        function_pointers.glGetSubroutineIndex = @ptrCast(?function_signatures.glGetSubroutineIndex,  proc);
    } else {
        log.err("entry point glGetSubroutineIndex not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetSubroutineUniformLocation")) |proc| {
        function_pointers.glGetSubroutineUniformLocation = @ptrCast(?function_signatures.glGetSubroutineUniformLocation,  proc);
    } else {
        log.err("entry point glGetSubroutineUniformLocation not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetUniformdv")) |proc| {
        function_pointers.glGetUniformdv = @ptrCast(?function_signatures.glGetUniformdv,  proc);
    } else {
        log.err("entry point glGetUniformdv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix4x3dv")) |proc| {
        function_pointers.glUniformMatrix4x3dv = @ptrCast(?function_signatures.glUniformMatrix4x3dv,  proc);
    } else {
        log.err("entry point glUniformMatrix4x3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix4x2dv")) |proc| {
        function_pointers.glUniformMatrix4x2dv = @ptrCast(?function_signatures.glUniformMatrix4x2dv,  proc);
    } else {
        log.err("entry point glUniformMatrix4x2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix3x4dv")) |proc| {
        function_pointers.glUniformMatrix3x4dv = @ptrCast(?function_signatures.glUniformMatrix3x4dv,  proc);
    } else {
        log.err("entry point glUniformMatrix3x4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix3x2dv")) |proc| {
        function_pointers.glUniformMatrix3x2dv = @ptrCast(?function_signatures.glUniformMatrix3x2dv,  proc);
    } else {
        log.err("entry point glUniformMatrix3x2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix2x4dv")) |proc| {
        function_pointers.glUniformMatrix2x4dv = @ptrCast(?function_signatures.glUniformMatrix2x4dv,  proc);
    } else {
        log.err("entry point glUniformMatrix2x4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix2x3dv")) |proc| {
        function_pointers.glUniformMatrix2x3dv = @ptrCast(?function_signatures.glUniformMatrix2x3dv,  proc);
    } else {
        log.err("entry point glUniformMatrix2x3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix4dv")) |proc| {
        function_pointers.glUniformMatrix4dv = @ptrCast(?function_signatures.glUniformMatrix4dv,  proc);
    } else {
        log.err("entry point glUniformMatrix4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix3dv")) |proc| {
        function_pointers.glUniformMatrix3dv = @ptrCast(?function_signatures.glUniformMatrix3dv,  proc);
    } else {
        log.err("entry point glUniformMatrix3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawRangeElements")) |proc| {
        function_pointers.glDrawRangeElements = @ptrCast(?function_signatures.glDrawRangeElements,  proc);
    } else {
        log.err("entry point glDrawRangeElements not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexImage3D")) |proc| {
        function_pointers.glTexImage3D = @ptrCast(?function_signatures.glTexImage3D,  proc);
    } else {
        log.err("entry point glTexImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexSubImage3D")) |proc| {
        function_pointers.glTexSubImage3D = @ptrCast(?function_signatures.glTexSubImage3D,  proc);
    } else {
        log.err("entry point glTexSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCopyTexSubImage3D")) |proc| {
        function_pointers.glCopyTexSubImage3D = @ptrCast(?function_signatures.glCopyTexSubImage3D,  proc);
    } else {
        log.err("entry point glCopyTexSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix2dv")) |proc| {
        function_pointers.glUniformMatrix2dv = @ptrCast(?function_signatures.glUniformMatrix2dv,  proc);
    } else {
        log.err("entry point glUniformMatrix2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform4dv")) |proc| {
        function_pointers.glUniform4dv = @ptrCast(?function_signatures.glUniform4dv,  proc);
    } else {
        log.err("entry point glUniform4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform3dv")) |proc| {
        function_pointers.glUniform3dv = @ptrCast(?function_signatures.glUniform3dv,  proc);
    } else {
        log.err("entry point glUniform3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform2dv")) |proc| {
        function_pointers.glUniform2dv = @ptrCast(?function_signatures.glUniform2dv,  proc);
    } else {
        log.err("entry point glUniform2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform1dv")) |proc| {
        function_pointers.glUniform1dv = @ptrCast(?function_signatures.glUniform1dv,  proc);
    } else {
        log.err("entry point glUniform1dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform4d")) |proc| {
        function_pointers.glUniform4d = @ptrCast(?function_signatures.glUniform4d,  proc);
    } else {
        log.err("entry point glUniform4d not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform3d")) |proc| {
        function_pointers.glUniform3d = @ptrCast(?function_signatures.glUniform3d,  proc);
    } else {
        log.err("entry point glUniform3d not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform2d")) |proc| {
        function_pointers.glUniform2d = @ptrCast(?function_signatures.glUniform2d,  proc);
    } else {
        log.err("entry point glUniform2d not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform1d")) |proc| {
        function_pointers.glUniform1d = @ptrCast(?function_signatures.glUniform1d,  proc);
    } else {
        log.err("entry point glUniform1d not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawElementsIndirect")) |proc| {
        function_pointers.glDrawElementsIndirect = @ptrCast(?function_signatures.glDrawElementsIndirect,  proc);
    } else {
        log.err("entry point glDrawElementsIndirect not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawArraysIndirect")) |proc| {
        function_pointers.glDrawArraysIndirect = @ptrCast(?function_signatures.glDrawArraysIndirect,  proc);
    } else {
        log.err("entry point glDrawArraysIndirect not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendFuncSeparatei")) |proc| {
        function_pointers.glBlendFuncSeparatei = @ptrCast(?function_signatures.glBlendFuncSeparatei,  proc);
    } else {
        log.err("entry point glBlendFuncSeparatei not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendFunci")) |proc| {
        function_pointers.glBlendFunci = @ptrCast(?function_signatures.glBlendFunci,  proc);
    } else {
        log.err("entry point glBlendFunci not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendEquationSeparatei")) |proc| {
        function_pointers.glBlendEquationSeparatei = @ptrCast(?function_signatures.glBlendEquationSeparatei,  proc);
    } else {
        log.err("entry point glBlendEquationSeparatei not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendEquationi")) |proc| {
        function_pointers.glBlendEquationi = @ptrCast(?function_signatures.glBlendEquationi,  proc);
    } else {
        log.err("entry point glBlendEquationi not found!", .{});
        success = false;
    }
    if(get_proc_address("glMinSampleShading")) |proc| {
        function_pointers.glMinSampleShading = @ptrCast(?function_signatures.glMinSampleShading,  proc);
    } else {
        log.err("entry point glMinSampleShading not found!", .{});
        success = false;
    }
    if(get_proc_address("glActiveTexture")) |proc| {
        function_pointers.glActiveTexture = @ptrCast(?function_signatures.glActiveTexture,  proc);
    } else {
        log.err("entry point glActiveTexture not found!", .{});
        success = false;
    }
    if(get_proc_address("glSampleCoverage")) |proc| {
        function_pointers.glSampleCoverage = @ptrCast(?function_signatures.glSampleCoverage,  proc);
    } else {
        log.err("entry point glSampleCoverage not found!", .{});
        success = false;
    }
    if(get_proc_address("glCompressedTexImage3D")) |proc| {
        function_pointers.glCompressedTexImage3D = @ptrCast(?function_signatures.glCompressedTexImage3D,  proc);
    } else {
        log.err("entry point glCompressedTexImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCompressedTexImage2D")) |proc| {
        function_pointers.glCompressedTexImage2D = @ptrCast(?function_signatures.glCompressedTexImage2D,  proc);
    } else {
        log.err("entry point glCompressedTexImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCompressedTexImage1D")) |proc| {
        function_pointers.glCompressedTexImage1D = @ptrCast(?function_signatures.glCompressedTexImage1D,  proc);
    } else {
        log.err("entry point glCompressedTexImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCompressedTexSubImage3D")) |proc| {
        function_pointers.glCompressedTexSubImage3D = @ptrCast(?function_signatures.glCompressedTexSubImage3D,  proc);
    } else {
        log.err("entry point glCompressedTexSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCompressedTexSubImage2D")) |proc| {
        function_pointers.glCompressedTexSubImage2D = @ptrCast(?function_signatures.glCompressedTexSubImage2D,  proc);
    } else {
        log.err("entry point glCompressedTexSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address("glCompressedTexSubImage1D")) |proc| {
        function_pointers.glCompressedTexSubImage1D = @ptrCast(?function_signatures.glCompressedTexSubImage1D,  proc);
    } else {
        log.err("entry point glCompressedTexSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetCompressedTexImage")) |proc| {
        function_pointers.glGetCompressedTexImage = @ptrCast(?function_signatures.glGetCompressedTexImage,  proc);
    } else {
        log.err("entry point glGetCompressedTexImage not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribP4uiv")) |proc| {
        function_pointers.glVertexAttribP4uiv = @ptrCast(?function_signatures.glVertexAttribP4uiv,  proc);
    } else {
        log.err("entry point glVertexAttribP4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribP4ui")) |proc| {
        function_pointers.glVertexAttribP4ui = @ptrCast(?function_signatures.glVertexAttribP4ui,  proc);
    } else {
        log.err("entry point glVertexAttribP4ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribP3uiv")) |proc| {
        function_pointers.glVertexAttribP3uiv = @ptrCast(?function_signatures.glVertexAttribP3uiv,  proc);
    } else {
        log.err("entry point glVertexAttribP3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribP3ui")) |proc| {
        function_pointers.glVertexAttribP3ui = @ptrCast(?function_signatures.glVertexAttribP3ui,  proc);
    } else {
        log.err("entry point glVertexAttribP3ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribP2uiv")) |proc| {
        function_pointers.glVertexAttribP2uiv = @ptrCast(?function_signatures.glVertexAttribP2uiv,  proc);
    } else {
        log.err("entry point glVertexAttribP2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribP2ui")) |proc| {
        function_pointers.glVertexAttribP2ui = @ptrCast(?function_signatures.glVertexAttribP2ui,  proc);
    } else {
        log.err("entry point glVertexAttribP2ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribP1uiv")) |proc| {
        function_pointers.glVertexAttribP1uiv = @ptrCast(?function_signatures.glVertexAttribP1uiv,  proc);
    } else {
        log.err("entry point glVertexAttribP1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribP1ui")) |proc| {
        function_pointers.glVertexAttribP1ui = @ptrCast(?function_signatures.glVertexAttribP1ui,  proc);
    } else {
        log.err("entry point glVertexAttribP1ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribDivisor")) |proc| {
        function_pointers.glVertexAttribDivisor = @ptrCast(?function_signatures.glVertexAttribDivisor,  proc);
    } else {
        log.err("entry point glVertexAttribDivisor not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetQueryObjectui64v")) |proc| {
        function_pointers.glGetQueryObjectui64v = @ptrCast(?function_signatures.glGetQueryObjectui64v,  proc);
    } else {
        log.err("entry point glGetQueryObjectui64v not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetQueryObjecti64v")) |proc| {
        function_pointers.glGetQueryObjecti64v = @ptrCast(?function_signatures.glGetQueryObjecti64v,  proc);
    } else {
        log.err("entry point glGetQueryObjecti64v not found!", .{});
        success = false;
    }
    if(get_proc_address("glQueryCounter")) |proc| {
        function_pointers.glQueryCounter = @ptrCast(?function_signatures.glQueryCounter,  proc);
    } else {
        log.err("entry point glQueryCounter not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetSamplerParameterIuiv")) |proc| {
        function_pointers.glGetSamplerParameterIuiv = @ptrCast(?function_signatures.glGetSamplerParameterIuiv,  proc);
    } else {
        log.err("entry point glGetSamplerParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetSamplerParameterfv")) |proc| {
        function_pointers.glGetSamplerParameterfv = @ptrCast(?function_signatures.glGetSamplerParameterfv,  proc);
    } else {
        log.err("entry point glGetSamplerParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetSamplerParameterIiv")) |proc| {
        function_pointers.glGetSamplerParameterIiv = @ptrCast(?function_signatures.glGetSamplerParameterIiv,  proc);
    } else {
        log.err("entry point glGetSamplerParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetSamplerParameteriv")) |proc| {
        function_pointers.glGetSamplerParameteriv = @ptrCast(?function_signatures.glGetSamplerParameteriv,  proc);
    } else {
        log.err("entry point glGetSamplerParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glSamplerParameterIuiv")) |proc| {
        function_pointers.glSamplerParameterIuiv = @ptrCast(?function_signatures.glSamplerParameterIuiv,  proc);
    } else {
        log.err("entry point glSamplerParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glSamplerParameterIiv")) |proc| {
        function_pointers.glSamplerParameterIiv = @ptrCast(?function_signatures.glSamplerParameterIiv,  proc);
    } else {
        log.err("entry point glSamplerParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glSamplerParameterfv")) |proc| {
        function_pointers.glSamplerParameterfv = @ptrCast(?function_signatures.glSamplerParameterfv,  proc);
    } else {
        log.err("entry point glSamplerParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glSamplerParameterf")) |proc| {
        function_pointers.glSamplerParameterf = @ptrCast(?function_signatures.glSamplerParameterf,  proc);
    } else {
        log.err("entry point glSamplerParameterf not found!", .{});
        success = false;
    }
    if(get_proc_address("glSamplerParameteriv")) |proc| {
        function_pointers.glSamplerParameteriv = @ptrCast(?function_signatures.glSamplerParameteriv,  proc);
    } else {
        log.err("entry point glSamplerParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glSamplerParameteri")) |proc| {
        function_pointers.glSamplerParameteri = @ptrCast(?function_signatures.glSamplerParameteri,  proc);
    } else {
        log.err("entry point glSamplerParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindSampler")) |proc| {
        function_pointers.glBindSampler = @ptrCast(?function_signatures.glBindSampler,  proc);
    } else {
        log.err("entry point glBindSampler not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsSampler")) |proc| {
        function_pointers.glIsSampler = @ptrCast(?function_signatures.glIsSampler,  proc);
    } else {
        log.err("entry point glIsSampler not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteSamplers")) |proc| {
        function_pointers.glDeleteSamplers = @ptrCast(?function_signatures.glDeleteSamplers,  proc);
    } else {
        log.err("entry point glDeleteSamplers not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenSamplers")) |proc| {
        function_pointers.glGenSamplers = @ptrCast(?function_signatures.glGenSamplers,  proc);
    } else {
        log.err("entry point glGenSamplers not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetFragDataIndex")) |proc| {
        function_pointers.glGetFragDataIndex = @ptrCast(?function_signatures.glGetFragDataIndex,  proc);
    } else {
        log.err("entry point glGetFragDataIndex not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindFragDataLocationIndexed")) |proc| {
        function_pointers.glBindFragDataLocationIndexed = @ptrCast(?function_signatures.glBindFragDataLocationIndexed,  proc);
    } else {
        log.err("entry point glBindFragDataLocationIndexed not found!", .{});
        success = false;
    }
    if(get_proc_address("glSampleMaski")) |proc| {
        function_pointers.glSampleMaski = @ptrCast(?function_signatures.glSampleMaski,  proc);
    } else {
        log.err("entry point glSampleMaski not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetMultisamplefv")) |proc| {
        function_pointers.glGetMultisamplefv = @ptrCast(?function_signatures.glGetMultisamplefv,  proc);
    } else {
        log.err("entry point glGetMultisamplefv not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexImage3DMultisample")) |proc| {
        function_pointers.glTexImage3DMultisample = @ptrCast(?function_signatures.glTexImage3DMultisample,  proc);
    } else {
        log.err("entry point glTexImage3DMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexImage2DMultisample")) |proc| {
        function_pointers.glTexImage2DMultisample = @ptrCast(?function_signatures.glTexImage2DMultisample,  proc);
    } else {
        log.err("entry point glTexImage2DMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address("glFramebufferTexture")) |proc| {
        function_pointers.glFramebufferTexture = @ptrCast(?function_signatures.glFramebufferTexture,  proc);
    } else {
        log.err("entry point glFramebufferTexture not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetBufferParameteri64v")) |proc| {
        function_pointers.glGetBufferParameteri64v = @ptrCast(?function_signatures.glGetBufferParameteri64v,  proc);
    } else {
        log.err("entry point glGetBufferParameteri64v not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendFuncSeparate")) |proc| {
        function_pointers.glBlendFuncSeparate = @ptrCast(?function_signatures.glBlendFuncSeparate,  proc);
    } else {
        log.err("entry point glBlendFuncSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address("glMultiDrawArrays")) |proc| {
        function_pointers.glMultiDrawArrays = @ptrCast(?function_signatures.glMultiDrawArrays,  proc);
    } else {
        log.err("entry point glMultiDrawArrays not found!", .{});
        success = false;
    }
    if(get_proc_address("glMultiDrawElements")) |proc| {
        function_pointers.glMultiDrawElements = @ptrCast(?function_signatures.glMultiDrawElements,  proc);
    } else {
        log.err("entry point glMultiDrawElements not found!", .{});
        success = false;
    }
    if(get_proc_address("glPointParameterf")) |proc| {
        function_pointers.glPointParameterf = @ptrCast(?function_signatures.glPointParameterf,  proc);
    } else {
        log.err("entry point glPointParameterf not found!", .{});
        success = false;
    }
    if(get_proc_address("glPointParameterfv")) |proc| {
        function_pointers.glPointParameterfv = @ptrCast(?function_signatures.glPointParameterfv,  proc);
    } else {
        log.err("entry point glPointParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glPointParameteri")) |proc| {
        function_pointers.glPointParameteri = @ptrCast(?function_signatures.glPointParameteri,  proc);
    } else {
        log.err("entry point glPointParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address("glPointParameteriv")) |proc| {
        function_pointers.glPointParameteriv = @ptrCast(?function_signatures.glPointParameteriv,  proc);
    } else {
        log.err("entry point glPointParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetInteger64i_v")) |proc| {
        function_pointers.glGetInteger64i_v = @ptrCast(?function_signatures.glGetInteger64i_v,  proc);
    } else {
        log.err("entry point glGetInteger64i_v not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetSynciv")) |proc| {
        function_pointers.glGetSynciv = @ptrCast(?function_signatures.glGetSynciv,  proc);
    } else {
        log.err("entry point glGetSynciv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetInteger64v")) |proc| {
        function_pointers.glGetInteger64v = @ptrCast(?function_signatures.glGetInteger64v,  proc);
    } else {
        log.err("entry point glGetInteger64v not found!", .{});
        success = false;
    }
    if(get_proc_address("glWaitSync")) |proc| {
        function_pointers.glWaitSync = @ptrCast(?function_signatures.glWaitSync,  proc);
    } else {
        log.err("entry point glWaitSync not found!", .{});
        success = false;
    }
    if(get_proc_address("glClientWaitSync")) |proc| {
        function_pointers.glClientWaitSync = @ptrCast(?function_signatures.glClientWaitSync,  proc);
    } else {
        log.err("entry point glClientWaitSync not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteSync")) |proc| {
        function_pointers.glDeleteSync = @ptrCast(?function_signatures.glDeleteSync,  proc);
    } else {
        log.err("entry point glDeleteSync not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsSync")) |proc| {
        function_pointers.glIsSync = @ptrCast(?function_signatures.glIsSync,  proc);
    } else {
        log.err("entry point glIsSync not found!", .{});
        success = false;
    }
    if(get_proc_address("glFenceSync")) |proc| {
        function_pointers.glFenceSync = @ptrCast(?function_signatures.glFenceSync,  proc);
    } else {
        log.err("entry point glFenceSync not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendColor")) |proc| {
        function_pointers.glBlendColor = @ptrCast(?function_signatures.glBlendColor,  proc);
    } else {
        log.err("entry point glBlendColor not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendEquation")) |proc| {
        function_pointers.glBlendEquation = @ptrCast(?function_signatures.glBlendEquation,  proc);
    } else {
        log.err("entry point glBlendEquation not found!", .{});
        success = false;
    }
    if(get_proc_address("glProvokingVertex")) |proc| {
        function_pointers.glProvokingVertex = @ptrCast(?function_signatures.glProvokingVertex,  proc);
    } else {
        log.err("entry point glProvokingVertex not found!", .{});
        success = false;
    }
    if(get_proc_address("glMultiDrawElementsBaseVertex")) |proc| {
        function_pointers.glMultiDrawElementsBaseVertex = @ptrCast(?function_signatures.glMultiDrawElementsBaseVertex,  proc);
    } else {
        log.err("entry point glMultiDrawElementsBaseVertex not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawElementsInstancedBaseVertex")) |proc| {
        function_pointers.glDrawElementsInstancedBaseVertex = @ptrCast(?function_signatures.glDrawElementsInstancedBaseVertex,  proc);
    } else {
        log.err("entry point glDrawElementsInstancedBaseVertex not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawRangeElementsBaseVertex")) |proc| {
        function_pointers.glDrawRangeElementsBaseVertex = @ptrCast(?function_signatures.glDrawRangeElementsBaseVertex,  proc);
    } else {
        log.err("entry point glDrawRangeElementsBaseVertex not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawElementsBaseVertex")) |proc| {
        function_pointers.glDrawElementsBaseVertex = @ptrCast(?function_signatures.glDrawElementsBaseVertex,  proc);
    } else {
        log.err("entry point glDrawElementsBaseVertex not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenQueries")) |proc| {
        function_pointers.glGenQueries = @ptrCast(?function_signatures.glGenQueries,  proc);
    } else {
        log.err("entry point glGenQueries not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteQueries")) |proc| {
        function_pointers.glDeleteQueries = @ptrCast(?function_signatures.glDeleteQueries,  proc);
    } else {
        log.err("entry point glDeleteQueries not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsQuery")) |proc| {
        function_pointers.glIsQuery = @ptrCast(?function_signatures.glIsQuery,  proc);
    } else {
        log.err("entry point glIsQuery not found!", .{});
        success = false;
    }
    if(get_proc_address("glBeginQuery")) |proc| {
        function_pointers.glBeginQuery = @ptrCast(?function_signatures.glBeginQuery,  proc);
    } else {
        log.err("entry point glBeginQuery not found!", .{});
        success = false;
    }
    if(get_proc_address("glEndQuery")) |proc| {
        function_pointers.glEndQuery = @ptrCast(?function_signatures.glEndQuery,  proc);
    } else {
        log.err("entry point glEndQuery not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetQueryiv")) |proc| {
        function_pointers.glGetQueryiv = @ptrCast(?function_signatures.glGetQueryiv,  proc);
    } else {
        log.err("entry point glGetQueryiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetQueryObjectiv")) |proc| {
        function_pointers.glGetQueryObjectiv = @ptrCast(?function_signatures.glGetQueryObjectiv,  proc);
    } else {
        log.err("entry point glGetQueryObjectiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetQueryObjectuiv")) |proc| {
        function_pointers.glGetQueryObjectuiv = @ptrCast(?function_signatures.glGetQueryObjectuiv,  proc);
    } else {
        log.err("entry point glGetQueryObjectuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindBuffer")) |proc| {
        function_pointers.glBindBuffer = @ptrCast(?function_signatures.glBindBuffer,  proc);
    } else {
        log.err("entry point glBindBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteBuffers")) |proc| {
        function_pointers.glDeleteBuffers = @ptrCast(?function_signatures.glDeleteBuffers,  proc);
    } else {
        log.err("entry point glDeleteBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenBuffers")) |proc| {
        function_pointers.glGenBuffers = @ptrCast(?function_signatures.glGenBuffers,  proc);
    } else {
        log.err("entry point glGenBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsBuffer")) |proc| {
        function_pointers.glIsBuffer = @ptrCast(?function_signatures.glIsBuffer,  proc);
    } else {
        log.err("entry point glIsBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glBufferData")) |proc| {
        function_pointers.glBufferData = @ptrCast(?function_signatures.glBufferData,  proc);
    } else {
        log.err("entry point glBufferData not found!", .{});
        success = false;
    }
    if(get_proc_address("glBufferSubData")) |proc| {
        function_pointers.glBufferSubData = @ptrCast(?function_signatures.glBufferSubData,  proc);
    } else {
        log.err("entry point glBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetBufferSubData")) |proc| {
        function_pointers.glGetBufferSubData = @ptrCast(?function_signatures.glGetBufferSubData,  proc);
    } else {
        log.err("entry point glGetBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address("glMapBuffer")) |proc| {
        function_pointers.glMapBuffer = @ptrCast(?function_signatures.glMapBuffer,  proc);
    } else {
        log.err("entry point glMapBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glUnmapBuffer")) |proc| {
        function_pointers.glUnmapBuffer = @ptrCast(?function_signatures.glUnmapBuffer,  proc);
    } else {
        log.err("entry point glUnmapBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetBufferParameteriv")) |proc| {
        function_pointers.glGetBufferParameteriv = @ptrCast(?function_signatures.glGetBufferParameteriv,  proc);
    } else {
        log.err("entry point glGetBufferParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetBufferPointerv")) |proc| {
        function_pointers.glGetBufferPointerv = @ptrCast(?function_signatures.glGetBufferPointerv,  proc);
    } else {
        log.err("entry point glGetBufferPointerv not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlendEquationSeparate")) |proc| {
        function_pointers.glBlendEquationSeparate = @ptrCast(?function_signatures.glBlendEquationSeparate,  proc);
    } else {
        log.err("entry point glBlendEquationSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawBuffers")) |proc| {
        function_pointers.glDrawBuffers = @ptrCast(?function_signatures.glDrawBuffers,  proc);
    } else {
        log.err("entry point glDrawBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address("glStencilOpSeparate")) |proc| {
        function_pointers.glStencilOpSeparate = @ptrCast(?function_signatures.glStencilOpSeparate,  proc);
    } else {
        log.err("entry point glStencilOpSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address("glStencilFuncSeparate")) |proc| {
        function_pointers.glStencilFuncSeparate = @ptrCast(?function_signatures.glStencilFuncSeparate,  proc);
    } else {
        log.err("entry point glStencilFuncSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address("glStencilMaskSeparate")) |proc| {
        function_pointers.glStencilMaskSeparate = @ptrCast(?function_signatures.glStencilMaskSeparate,  proc);
    } else {
        log.err("entry point glStencilMaskSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address("glAttachShader")) |proc| {
        function_pointers.glAttachShader = @ptrCast(?function_signatures.glAttachShader,  proc);
    } else {
        log.err("entry point glAttachShader not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindAttribLocation")) |proc| {
        function_pointers.glBindAttribLocation = @ptrCast(?function_signatures.glBindAttribLocation,  proc);
    } else {
        log.err("entry point glBindAttribLocation not found!", .{});
        success = false;
    }
    if(get_proc_address("glCompileShader")) |proc| {
        function_pointers.glCompileShader = @ptrCast(?function_signatures.glCompileShader,  proc);
    } else {
        log.err("entry point glCompileShader not found!", .{});
        success = false;
    }
    if(get_proc_address("glCreateProgram")) |proc| {
        function_pointers.glCreateProgram = @ptrCast(?function_signatures.glCreateProgram,  proc);
    } else {
        log.err("entry point glCreateProgram not found!", .{});
        success = false;
    }
    if(get_proc_address("glCreateShader")) |proc| {
        function_pointers.glCreateShader = @ptrCast(?function_signatures.glCreateShader,  proc);
    } else {
        log.err("entry point glCreateShader not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteProgram")) |proc| {
        function_pointers.glDeleteProgram = @ptrCast(?function_signatures.glDeleteProgram,  proc);
    } else {
        log.err("entry point glDeleteProgram not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteShader")) |proc| {
        function_pointers.glDeleteShader = @ptrCast(?function_signatures.glDeleteShader,  proc);
    } else {
        log.err("entry point glDeleteShader not found!", .{});
        success = false;
    }
    if(get_proc_address("glDetachShader")) |proc| {
        function_pointers.glDetachShader = @ptrCast(?function_signatures.glDetachShader,  proc);
    } else {
        log.err("entry point glDetachShader not found!", .{});
        success = false;
    }
    if(get_proc_address("glDisableVertexAttribArray")) |proc| {
        function_pointers.glDisableVertexAttribArray = @ptrCast(?function_signatures.glDisableVertexAttribArray,  proc);
    } else {
        log.err("entry point glDisableVertexAttribArray not found!", .{});
        success = false;
    }
    if(get_proc_address("glEnableVertexAttribArray")) |proc| {
        function_pointers.glEnableVertexAttribArray = @ptrCast(?function_signatures.glEnableVertexAttribArray,  proc);
    } else {
        log.err("entry point glEnableVertexAttribArray not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveAttrib")) |proc| {
        function_pointers.glGetActiveAttrib = @ptrCast(?function_signatures.glGetActiveAttrib,  proc);
    } else {
        log.err("entry point glGetActiveAttrib not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveUniform")) |proc| {
        function_pointers.glGetActiveUniform = @ptrCast(?function_signatures.glGetActiveUniform,  proc);
    } else {
        log.err("entry point glGetActiveUniform not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetAttachedShaders")) |proc| {
        function_pointers.glGetAttachedShaders = @ptrCast(?function_signatures.glGetAttachedShaders,  proc);
    } else {
        log.err("entry point glGetAttachedShaders not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetAttribLocation")) |proc| {
        function_pointers.glGetAttribLocation = @ptrCast(?function_signatures.glGetAttribLocation,  proc);
    } else {
        log.err("entry point glGetAttribLocation not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetProgramiv")) |proc| {
        function_pointers.glGetProgramiv = @ptrCast(?function_signatures.glGetProgramiv,  proc);
    } else {
        log.err("entry point glGetProgramiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetProgramInfoLog")) |proc| {
        function_pointers.glGetProgramInfoLog = @ptrCast(?function_signatures.glGetProgramInfoLog,  proc);
    } else {
        log.err("entry point glGetProgramInfoLog not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetShaderiv")) |proc| {
        function_pointers.glGetShaderiv = @ptrCast(?function_signatures.glGetShaderiv,  proc);
    } else {
        log.err("entry point glGetShaderiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetShaderInfoLog")) |proc| {
        function_pointers.glGetShaderInfoLog = @ptrCast(?function_signatures.glGetShaderInfoLog,  proc);
    } else {
        log.err("entry point glGetShaderInfoLog not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetShaderSource")) |proc| {
        function_pointers.glGetShaderSource = @ptrCast(?function_signatures.glGetShaderSource,  proc);
    } else {
        log.err("entry point glGetShaderSource not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetUniformLocation")) |proc| {
        function_pointers.glGetUniformLocation = @ptrCast(?function_signatures.glGetUniformLocation,  proc);
    } else {
        log.err("entry point glGetUniformLocation not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetUniformfv")) |proc| {
        function_pointers.glGetUniformfv = @ptrCast(?function_signatures.glGetUniformfv,  proc);
    } else {
        log.err("entry point glGetUniformfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetUniformiv")) |proc| {
        function_pointers.glGetUniformiv = @ptrCast(?function_signatures.glGetUniformiv,  proc);
    } else {
        log.err("entry point glGetUniformiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetVertexAttribdv")) |proc| {
        function_pointers.glGetVertexAttribdv = @ptrCast(?function_signatures.glGetVertexAttribdv,  proc);
    } else {
        log.err("entry point glGetVertexAttribdv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetVertexAttribfv")) |proc| {
        function_pointers.glGetVertexAttribfv = @ptrCast(?function_signatures.glGetVertexAttribfv,  proc);
    } else {
        log.err("entry point glGetVertexAttribfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetVertexAttribiv")) |proc| {
        function_pointers.glGetVertexAttribiv = @ptrCast(?function_signatures.glGetVertexAttribiv,  proc);
    } else {
        log.err("entry point glGetVertexAttribiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetVertexAttribPointerv")) |proc| {
        function_pointers.glGetVertexAttribPointerv = @ptrCast(?function_signatures.glGetVertexAttribPointerv,  proc);
    } else {
        log.err("entry point glGetVertexAttribPointerv not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsProgram")) |proc| {
        function_pointers.glIsProgram = @ptrCast(?function_signatures.glIsProgram,  proc);
    } else {
        log.err("entry point glIsProgram not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsShader")) |proc| {
        function_pointers.glIsShader = @ptrCast(?function_signatures.glIsShader,  proc);
    } else {
        log.err("entry point glIsShader not found!", .{});
        success = false;
    }
    if(get_proc_address("glLinkProgram")) |proc| {
        function_pointers.glLinkProgram = @ptrCast(?function_signatures.glLinkProgram,  proc);
    } else {
        log.err("entry point glLinkProgram not found!", .{});
        success = false;
    }
    if(get_proc_address("glShaderSource")) |proc| {
        function_pointers.glShaderSource = @ptrCast(?function_signatures.glShaderSource,  proc);
    } else {
        log.err("entry point glShaderSource not found!", .{});
        success = false;
    }
    if(get_proc_address("glUseProgram")) |proc| {
        function_pointers.glUseProgram = @ptrCast(?function_signatures.glUseProgram,  proc);
    } else {
        log.err("entry point glUseProgram not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform1f")) |proc| {
        function_pointers.glUniform1f = @ptrCast(?function_signatures.glUniform1f,  proc);
    } else {
        log.err("entry point glUniform1f not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform2f")) |proc| {
        function_pointers.glUniform2f = @ptrCast(?function_signatures.glUniform2f,  proc);
    } else {
        log.err("entry point glUniform2f not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform3f")) |proc| {
        function_pointers.glUniform3f = @ptrCast(?function_signatures.glUniform3f,  proc);
    } else {
        log.err("entry point glUniform3f not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform4f")) |proc| {
        function_pointers.glUniform4f = @ptrCast(?function_signatures.glUniform4f,  proc);
    } else {
        log.err("entry point glUniform4f not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform1i")) |proc| {
        function_pointers.glUniform1i = @ptrCast(?function_signatures.glUniform1i,  proc);
    } else {
        log.err("entry point glUniform1i not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform2i")) |proc| {
        function_pointers.glUniform2i = @ptrCast(?function_signatures.glUniform2i,  proc);
    } else {
        log.err("entry point glUniform2i not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform3i")) |proc| {
        function_pointers.glUniform3i = @ptrCast(?function_signatures.glUniform3i,  proc);
    } else {
        log.err("entry point glUniform3i not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform4i")) |proc| {
        function_pointers.glUniform4i = @ptrCast(?function_signatures.glUniform4i,  proc);
    } else {
        log.err("entry point glUniform4i not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform1fv")) |proc| {
        function_pointers.glUniform1fv = @ptrCast(?function_signatures.glUniform1fv,  proc);
    } else {
        log.err("entry point glUniform1fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform2fv")) |proc| {
        function_pointers.glUniform2fv = @ptrCast(?function_signatures.glUniform2fv,  proc);
    } else {
        log.err("entry point glUniform2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform3fv")) |proc| {
        function_pointers.glUniform3fv = @ptrCast(?function_signatures.glUniform3fv,  proc);
    } else {
        log.err("entry point glUniform3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform4fv")) |proc| {
        function_pointers.glUniform4fv = @ptrCast(?function_signatures.glUniform4fv,  proc);
    } else {
        log.err("entry point glUniform4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform1iv")) |proc| {
        function_pointers.glUniform1iv = @ptrCast(?function_signatures.glUniform1iv,  proc);
    } else {
        log.err("entry point glUniform1iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform2iv")) |proc| {
        function_pointers.glUniform2iv = @ptrCast(?function_signatures.glUniform2iv,  proc);
    } else {
        log.err("entry point glUniform2iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform3iv")) |proc| {
        function_pointers.glUniform3iv = @ptrCast(?function_signatures.glUniform3iv,  proc);
    } else {
        log.err("entry point glUniform3iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform4iv")) |proc| {
        function_pointers.glUniform4iv = @ptrCast(?function_signatures.glUniform4iv,  proc);
    } else {
        log.err("entry point glUniform4iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix2fv")) |proc| {
        function_pointers.glUniformMatrix2fv = @ptrCast(?function_signatures.glUniformMatrix2fv,  proc);
    } else {
        log.err("entry point glUniformMatrix2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix3fv")) |proc| {
        function_pointers.glUniformMatrix3fv = @ptrCast(?function_signatures.glUniformMatrix3fv,  proc);
    } else {
        log.err("entry point glUniformMatrix3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix4fv")) |proc| {
        function_pointers.glUniformMatrix4fv = @ptrCast(?function_signatures.glUniformMatrix4fv,  proc);
    } else {
        log.err("entry point glUniformMatrix4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glValidateProgram")) |proc| {
        function_pointers.glValidateProgram = @ptrCast(?function_signatures.glValidateProgram,  proc);
    } else {
        log.err("entry point glValidateProgram not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib1d")) |proc| {
        function_pointers.glVertexAttrib1d = @ptrCast(?function_signatures.glVertexAttrib1d,  proc);
    } else {
        log.err("entry point glVertexAttrib1d not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib1dv")) |proc| {
        function_pointers.glVertexAttrib1dv = @ptrCast(?function_signatures.glVertexAttrib1dv,  proc);
    } else {
        log.err("entry point glVertexAttrib1dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib1f")) |proc| {
        function_pointers.glVertexAttrib1f = @ptrCast(?function_signatures.glVertexAttrib1f,  proc);
    } else {
        log.err("entry point glVertexAttrib1f not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib1fv")) |proc| {
        function_pointers.glVertexAttrib1fv = @ptrCast(?function_signatures.glVertexAttrib1fv,  proc);
    } else {
        log.err("entry point glVertexAttrib1fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib1s")) |proc| {
        function_pointers.glVertexAttrib1s = @ptrCast(?function_signatures.glVertexAttrib1s,  proc);
    } else {
        log.err("entry point glVertexAttrib1s not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib1sv")) |proc| {
        function_pointers.glVertexAttrib1sv = @ptrCast(?function_signatures.glVertexAttrib1sv,  proc);
    } else {
        log.err("entry point glVertexAttrib1sv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib2d")) |proc| {
        function_pointers.glVertexAttrib2d = @ptrCast(?function_signatures.glVertexAttrib2d,  proc);
    } else {
        log.err("entry point glVertexAttrib2d not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib2dv")) |proc| {
        function_pointers.glVertexAttrib2dv = @ptrCast(?function_signatures.glVertexAttrib2dv,  proc);
    } else {
        log.err("entry point glVertexAttrib2dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib2f")) |proc| {
        function_pointers.glVertexAttrib2f = @ptrCast(?function_signatures.glVertexAttrib2f,  proc);
    } else {
        log.err("entry point glVertexAttrib2f not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib2fv")) |proc| {
        function_pointers.glVertexAttrib2fv = @ptrCast(?function_signatures.glVertexAttrib2fv,  proc);
    } else {
        log.err("entry point glVertexAttrib2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib2s")) |proc| {
        function_pointers.glVertexAttrib2s = @ptrCast(?function_signatures.glVertexAttrib2s,  proc);
    } else {
        log.err("entry point glVertexAttrib2s not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib2sv")) |proc| {
        function_pointers.glVertexAttrib2sv = @ptrCast(?function_signatures.glVertexAttrib2sv,  proc);
    } else {
        log.err("entry point glVertexAttrib2sv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib3d")) |proc| {
        function_pointers.glVertexAttrib3d = @ptrCast(?function_signatures.glVertexAttrib3d,  proc);
    } else {
        log.err("entry point glVertexAttrib3d not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib3dv")) |proc| {
        function_pointers.glVertexAttrib3dv = @ptrCast(?function_signatures.glVertexAttrib3dv,  proc);
    } else {
        log.err("entry point glVertexAttrib3dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib3f")) |proc| {
        function_pointers.glVertexAttrib3f = @ptrCast(?function_signatures.glVertexAttrib3f,  proc);
    } else {
        log.err("entry point glVertexAttrib3f not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib3fv")) |proc| {
        function_pointers.glVertexAttrib3fv = @ptrCast(?function_signatures.glVertexAttrib3fv,  proc);
    } else {
        log.err("entry point glVertexAttrib3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib3s")) |proc| {
        function_pointers.glVertexAttrib3s = @ptrCast(?function_signatures.glVertexAttrib3s,  proc);
    } else {
        log.err("entry point glVertexAttrib3s not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib3sv")) |proc| {
        function_pointers.glVertexAttrib3sv = @ptrCast(?function_signatures.glVertexAttrib3sv,  proc);
    } else {
        log.err("entry point glVertexAttrib3sv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4Nbv")) |proc| {
        function_pointers.glVertexAttrib4Nbv = @ptrCast(?function_signatures.glVertexAttrib4Nbv,  proc);
    } else {
        log.err("entry point glVertexAttrib4Nbv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4Niv")) |proc| {
        function_pointers.glVertexAttrib4Niv = @ptrCast(?function_signatures.glVertexAttrib4Niv,  proc);
    } else {
        log.err("entry point glVertexAttrib4Niv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4Nsv")) |proc| {
        function_pointers.glVertexAttrib4Nsv = @ptrCast(?function_signatures.glVertexAttrib4Nsv,  proc);
    } else {
        log.err("entry point glVertexAttrib4Nsv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4Nub")) |proc| {
        function_pointers.glVertexAttrib4Nub = @ptrCast(?function_signatures.glVertexAttrib4Nub,  proc);
    } else {
        log.err("entry point glVertexAttrib4Nub not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4Nubv")) |proc| {
        function_pointers.glVertexAttrib4Nubv = @ptrCast(?function_signatures.glVertexAttrib4Nubv,  proc);
    } else {
        log.err("entry point glVertexAttrib4Nubv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4Nuiv")) |proc| {
        function_pointers.glVertexAttrib4Nuiv = @ptrCast(?function_signatures.glVertexAttrib4Nuiv,  proc);
    } else {
        log.err("entry point glVertexAttrib4Nuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4Nusv")) |proc| {
        function_pointers.glVertexAttrib4Nusv = @ptrCast(?function_signatures.glVertexAttrib4Nusv,  proc);
    } else {
        log.err("entry point glVertexAttrib4Nusv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4bv")) |proc| {
        function_pointers.glVertexAttrib4bv = @ptrCast(?function_signatures.glVertexAttrib4bv,  proc);
    } else {
        log.err("entry point glVertexAttrib4bv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4d")) |proc| {
        function_pointers.glVertexAttrib4d = @ptrCast(?function_signatures.glVertexAttrib4d,  proc);
    } else {
        log.err("entry point glVertexAttrib4d not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4dv")) |proc| {
        function_pointers.glVertexAttrib4dv = @ptrCast(?function_signatures.glVertexAttrib4dv,  proc);
    } else {
        log.err("entry point glVertexAttrib4dv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4f")) |proc| {
        function_pointers.glVertexAttrib4f = @ptrCast(?function_signatures.glVertexAttrib4f,  proc);
    } else {
        log.err("entry point glVertexAttrib4f not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4fv")) |proc| {
        function_pointers.glVertexAttrib4fv = @ptrCast(?function_signatures.glVertexAttrib4fv,  proc);
    } else {
        log.err("entry point glVertexAttrib4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4iv")) |proc| {
        function_pointers.glVertexAttrib4iv = @ptrCast(?function_signatures.glVertexAttrib4iv,  proc);
    } else {
        log.err("entry point glVertexAttrib4iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4s")) |proc| {
        function_pointers.glVertexAttrib4s = @ptrCast(?function_signatures.glVertexAttrib4s,  proc);
    } else {
        log.err("entry point glVertexAttrib4s not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4sv")) |proc| {
        function_pointers.glVertexAttrib4sv = @ptrCast(?function_signatures.glVertexAttrib4sv,  proc);
    } else {
        log.err("entry point glVertexAttrib4sv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4ubv")) |proc| {
        function_pointers.glVertexAttrib4ubv = @ptrCast(?function_signatures.glVertexAttrib4ubv,  proc);
    } else {
        log.err("entry point glVertexAttrib4ubv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4uiv")) |proc| {
        function_pointers.glVertexAttrib4uiv = @ptrCast(?function_signatures.glVertexAttrib4uiv,  proc);
    } else {
        log.err("entry point glVertexAttrib4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttrib4usv")) |proc| {
        function_pointers.glVertexAttrib4usv = @ptrCast(?function_signatures.glVertexAttrib4usv,  proc);
    } else {
        log.err("entry point glVertexAttrib4usv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribPointer")) |proc| {
        function_pointers.glVertexAttribPointer = @ptrCast(?function_signatures.glVertexAttribPointer,  proc);
    } else {
        log.err("entry point glVertexAttribPointer not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix2x3fv")) |proc| {
        function_pointers.glUniformMatrix2x3fv = @ptrCast(?function_signatures.glUniformMatrix2x3fv,  proc);
    } else {
        log.err("entry point glUniformMatrix2x3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix3x2fv")) |proc| {
        function_pointers.glUniformMatrix3x2fv = @ptrCast(?function_signatures.glUniformMatrix3x2fv,  proc);
    } else {
        log.err("entry point glUniformMatrix3x2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix2x4fv")) |proc| {
        function_pointers.glUniformMatrix2x4fv = @ptrCast(?function_signatures.glUniformMatrix2x4fv,  proc);
    } else {
        log.err("entry point glUniformMatrix2x4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix4x2fv")) |proc| {
        function_pointers.glUniformMatrix4x2fv = @ptrCast(?function_signatures.glUniformMatrix4x2fv,  proc);
    } else {
        log.err("entry point glUniformMatrix4x2fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix3x4fv")) |proc| {
        function_pointers.glUniformMatrix3x4fv = @ptrCast(?function_signatures.glUniformMatrix3x4fv,  proc);
    } else {
        log.err("entry point glUniformMatrix3x4fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformMatrix4x3fv")) |proc| {
        function_pointers.glUniformMatrix4x3fv = @ptrCast(?function_signatures.glUniformMatrix4x3fv,  proc);
    } else {
        log.err("entry point glUniformMatrix4x3fv not found!", .{});
        success = false;
    }
    if(get_proc_address("glColorMaski")) |proc| {
        function_pointers.glColorMaski = @ptrCast(?function_signatures.glColorMaski,  proc);
    } else {
        log.err("entry point glColorMaski not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetBooleani_v")) |proc| {
        function_pointers.glGetBooleani_v = @ptrCast(?function_signatures.glGetBooleani_v,  proc);
    } else {
        log.err("entry point glGetBooleani_v not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetIntegeri_v")) |proc| {
        function_pointers.glGetIntegeri_v = @ptrCast(?function_signatures.glGetIntegeri_v,  proc);
    } else {
        log.err("entry point glGetIntegeri_v not found!", .{});
        success = false;
    }
    if(get_proc_address("glEnablei")) |proc| {
        function_pointers.glEnablei = @ptrCast(?function_signatures.glEnablei,  proc);
    } else {
        log.err("entry point glEnablei not found!", .{});
        success = false;
    }
    if(get_proc_address("glDisablei")) |proc| {
        function_pointers.glDisablei = @ptrCast(?function_signatures.glDisablei,  proc);
    } else {
        log.err("entry point glDisablei not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsEnabledi")) |proc| {
        function_pointers.glIsEnabledi = @ptrCast(?function_signatures.glIsEnabledi,  proc);
    } else {
        log.err("entry point glIsEnabledi not found!", .{});
        success = false;
    }
    if(get_proc_address("glBeginTransformFeedback")) |proc| {
        function_pointers.glBeginTransformFeedback = @ptrCast(?function_signatures.glBeginTransformFeedback,  proc);
    } else {
        log.err("entry point glBeginTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address("glEndTransformFeedback")) |proc| {
        function_pointers.glEndTransformFeedback = @ptrCast(?function_signatures.glEndTransformFeedback,  proc);
    } else {
        log.err("entry point glEndTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindBufferRange")) |proc| {
        function_pointers.glBindBufferRange = @ptrCast(?function_signatures.glBindBufferRange,  proc);
    } else {
        log.err("entry point glBindBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindBufferBase")) |proc| {
        function_pointers.glBindBufferBase = @ptrCast(?function_signatures.glBindBufferBase,  proc);
    } else {
        log.err("entry point glBindBufferBase not found!", .{});
        success = false;
    }
    if(get_proc_address("glTransformFeedbackVaryings")) |proc| {
        function_pointers.glTransformFeedbackVaryings = @ptrCast(?function_signatures.glTransformFeedbackVaryings,  proc);
    } else {
        log.err("entry point glTransformFeedbackVaryings not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetTransformFeedbackVarying")) |proc| {
        function_pointers.glGetTransformFeedbackVarying = @ptrCast(?function_signatures.glGetTransformFeedbackVarying,  proc);
    } else {
        log.err("entry point glGetTransformFeedbackVarying not found!", .{});
        success = false;
    }
    if(get_proc_address("glClampColor")) |proc| {
        function_pointers.glClampColor = @ptrCast(?function_signatures.glClampColor,  proc);
    } else {
        log.err("entry point glClampColor not found!", .{});
        success = false;
    }
    if(get_proc_address("glBeginConditionalRender")) |proc| {
        function_pointers.glBeginConditionalRender = @ptrCast(?function_signatures.glBeginConditionalRender,  proc);
    } else {
        log.err("entry point glBeginConditionalRender not found!", .{});
        success = false;
    }
    if(get_proc_address("glEndConditionalRender")) |proc| {
        function_pointers.glEndConditionalRender = @ptrCast(?function_signatures.glEndConditionalRender,  proc);
    } else {
        log.err("entry point glEndConditionalRender not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribIPointer")) |proc| {
        function_pointers.glVertexAttribIPointer = @ptrCast(?function_signatures.glVertexAttribIPointer,  proc);
    } else {
        log.err("entry point glVertexAttribIPointer not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetVertexAttribIiv")) |proc| {
        function_pointers.glGetVertexAttribIiv = @ptrCast(?function_signatures.glGetVertexAttribIiv,  proc);
    } else {
        log.err("entry point glGetVertexAttribIiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetVertexAttribIuiv")) |proc| {
        function_pointers.glGetVertexAttribIuiv = @ptrCast(?function_signatures.glGetVertexAttribIuiv,  proc);
    } else {
        log.err("entry point glGetVertexAttribIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI1i")) |proc| {
        function_pointers.glVertexAttribI1i = @ptrCast(?function_signatures.glVertexAttribI1i,  proc);
    } else {
        log.err("entry point glVertexAttribI1i not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI2i")) |proc| {
        function_pointers.glVertexAttribI2i = @ptrCast(?function_signatures.glVertexAttribI2i,  proc);
    } else {
        log.err("entry point glVertexAttribI2i not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI3i")) |proc| {
        function_pointers.glVertexAttribI3i = @ptrCast(?function_signatures.glVertexAttribI3i,  proc);
    } else {
        log.err("entry point glVertexAttribI3i not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI4i")) |proc| {
        function_pointers.glVertexAttribI4i = @ptrCast(?function_signatures.glVertexAttribI4i,  proc);
    } else {
        log.err("entry point glVertexAttribI4i not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI1ui")) |proc| {
        function_pointers.glVertexAttribI1ui = @ptrCast(?function_signatures.glVertexAttribI1ui,  proc);
    } else {
        log.err("entry point glVertexAttribI1ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI2ui")) |proc| {
        function_pointers.glVertexAttribI2ui = @ptrCast(?function_signatures.glVertexAttribI2ui,  proc);
    } else {
        log.err("entry point glVertexAttribI2ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI3ui")) |proc| {
        function_pointers.glVertexAttribI3ui = @ptrCast(?function_signatures.glVertexAttribI3ui,  proc);
    } else {
        log.err("entry point glVertexAttribI3ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI4ui")) |proc| {
        function_pointers.glVertexAttribI4ui = @ptrCast(?function_signatures.glVertexAttribI4ui,  proc);
    } else {
        log.err("entry point glVertexAttribI4ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI1iv")) |proc| {
        function_pointers.glVertexAttribI1iv = @ptrCast(?function_signatures.glVertexAttribI1iv,  proc);
    } else {
        log.err("entry point glVertexAttribI1iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI2iv")) |proc| {
        function_pointers.glVertexAttribI2iv = @ptrCast(?function_signatures.glVertexAttribI2iv,  proc);
    } else {
        log.err("entry point glVertexAttribI2iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI3iv")) |proc| {
        function_pointers.glVertexAttribI3iv = @ptrCast(?function_signatures.glVertexAttribI3iv,  proc);
    } else {
        log.err("entry point glVertexAttribI3iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI4iv")) |proc| {
        function_pointers.glVertexAttribI4iv = @ptrCast(?function_signatures.glVertexAttribI4iv,  proc);
    } else {
        log.err("entry point glVertexAttribI4iv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI1uiv")) |proc| {
        function_pointers.glVertexAttribI1uiv = @ptrCast(?function_signatures.glVertexAttribI1uiv,  proc);
    } else {
        log.err("entry point glVertexAttribI1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI2uiv")) |proc| {
        function_pointers.glVertexAttribI2uiv = @ptrCast(?function_signatures.glVertexAttribI2uiv,  proc);
    } else {
        log.err("entry point glVertexAttribI2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI3uiv")) |proc| {
        function_pointers.glVertexAttribI3uiv = @ptrCast(?function_signatures.glVertexAttribI3uiv,  proc);
    } else {
        log.err("entry point glVertexAttribI3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI4uiv")) |proc| {
        function_pointers.glVertexAttribI4uiv = @ptrCast(?function_signatures.glVertexAttribI4uiv,  proc);
    } else {
        log.err("entry point glVertexAttribI4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI4bv")) |proc| {
        function_pointers.glVertexAttribI4bv = @ptrCast(?function_signatures.glVertexAttribI4bv,  proc);
    } else {
        log.err("entry point glVertexAttribI4bv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI4sv")) |proc| {
        function_pointers.glVertexAttribI4sv = @ptrCast(?function_signatures.glVertexAttribI4sv,  proc);
    } else {
        log.err("entry point glVertexAttribI4sv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI4ubv")) |proc| {
        function_pointers.glVertexAttribI4ubv = @ptrCast(?function_signatures.glVertexAttribI4ubv,  proc);
    } else {
        log.err("entry point glVertexAttribI4ubv not found!", .{});
        success = false;
    }
    if(get_proc_address("glVertexAttribI4usv")) |proc| {
        function_pointers.glVertexAttribI4usv = @ptrCast(?function_signatures.glVertexAttribI4usv,  proc);
    } else {
        log.err("entry point glVertexAttribI4usv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetUniformuiv")) |proc| {
        function_pointers.glGetUniformuiv = @ptrCast(?function_signatures.glGetUniformuiv,  proc);
    } else {
        log.err("entry point glGetUniformuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindFragDataLocation")) |proc| {
        function_pointers.glBindFragDataLocation = @ptrCast(?function_signatures.glBindFragDataLocation,  proc);
    } else {
        log.err("entry point glBindFragDataLocation not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetFragDataLocation")) |proc| {
        function_pointers.glGetFragDataLocation = @ptrCast(?function_signatures.glGetFragDataLocation,  proc);
    } else {
        log.err("entry point glGetFragDataLocation not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform1ui")) |proc| {
        function_pointers.glUniform1ui = @ptrCast(?function_signatures.glUniform1ui,  proc);
    } else {
        log.err("entry point glUniform1ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform2ui")) |proc| {
        function_pointers.glUniform2ui = @ptrCast(?function_signatures.glUniform2ui,  proc);
    } else {
        log.err("entry point glUniform2ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform3ui")) |proc| {
        function_pointers.glUniform3ui = @ptrCast(?function_signatures.glUniform3ui,  proc);
    } else {
        log.err("entry point glUniform3ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform4ui")) |proc| {
        function_pointers.glUniform4ui = @ptrCast(?function_signatures.glUniform4ui,  proc);
    } else {
        log.err("entry point glUniform4ui not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform1uiv")) |proc| {
        function_pointers.glUniform1uiv = @ptrCast(?function_signatures.glUniform1uiv,  proc);
    } else {
        log.err("entry point glUniform1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform2uiv")) |proc| {
        function_pointers.glUniform2uiv = @ptrCast(?function_signatures.glUniform2uiv,  proc);
    } else {
        log.err("entry point glUniform2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform3uiv")) |proc| {
        function_pointers.glUniform3uiv = @ptrCast(?function_signatures.glUniform3uiv,  proc);
    } else {
        log.err("entry point glUniform3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniform4uiv")) |proc| {
        function_pointers.glUniform4uiv = @ptrCast(?function_signatures.glUniform4uiv,  proc);
    } else {
        log.err("entry point glUniform4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexParameterIiv")) |proc| {
        function_pointers.glTexParameterIiv = @ptrCast(?function_signatures.glTexParameterIiv,  proc);
    } else {
        log.err("entry point glTexParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexParameterIuiv")) |proc| {
        function_pointers.glTexParameterIuiv = @ptrCast(?function_signatures.glTexParameterIuiv,  proc);
    } else {
        log.err("entry point glTexParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetTexParameterIiv")) |proc| {
        function_pointers.glGetTexParameterIiv = @ptrCast(?function_signatures.glGetTexParameterIiv,  proc);
    } else {
        log.err("entry point glGetTexParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetTexParameterIuiv")) |proc| {
        function_pointers.glGetTexParameterIuiv = @ptrCast(?function_signatures.glGetTexParameterIuiv,  proc);
    } else {
        log.err("entry point glGetTexParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glClearBufferiv")) |proc| {
        function_pointers.glClearBufferiv = @ptrCast(?function_signatures.glClearBufferiv,  proc);
    } else {
        log.err("entry point glClearBufferiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glClearBufferuiv")) |proc| {
        function_pointers.glClearBufferuiv = @ptrCast(?function_signatures.glClearBufferuiv,  proc);
    } else {
        log.err("entry point glClearBufferuiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glClearBufferfv")) |proc| {
        function_pointers.glClearBufferfv = @ptrCast(?function_signatures.glClearBufferfv,  proc);
    } else {
        log.err("entry point glClearBufferfv not found!", .{});
        success = false;
    }
    if(get_proc_address("glClearBufferfi")) |proc| {
        function_pointers.glClearBufferfi = @ptrCast(?function_signatures.glClearBufferfi,  proc);
    } else {
        log.err("entry point glClearBufferfi not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetStringi")) |proc| {
        function_pointers.glGetStringi = @ptrCast(?function_signatures.glGetStringi,  proc);
    } else {
        log.err("entry point glGetStringi not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsRenderbuffer")) |proc| {
        function_pointers.glIsRenderbuffer = @ptrCast(?function_signatures.glIsRenderbuffer,  proc);
    } else {
        log.err("entry point glIsRenderbuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindRenderbuffer")) |proc| {
        function_pointers.glBindRenderbuffer = @ptrCast(?function_signatures.glBindRenderbuffer,  proc);
    } else {
        log.err("entry point glBindRenderbuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteRenderbuffers")) |proc| {
        function_pointers.glDeleteRenderbuffers = @ptrCast(?function_signatures.glDeleteRenderbuffers,  proc);
    } else {
        log.err("entry point glDeleteRenderbuffers not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenRenderbuffers")) |proc| {
        function_pointers.glGenRenderbuffers = @ptrCast(?function_signatures.glGenRenderbuffers,  proc);
    } else {
        log.err("entry point glGenRenderbuffers not found!", .{});
        success = false;
    }
    if(get_proc_address("glRenderbufferStorage")) |proc| {
        function_pointers.glRenderbufferStorage = @ptrCast(?function_signatures.glRenderbufferStorage,  proc);
    } else {
        log.err("entry point glRenderbufferStorage not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetRenderbufferParameteriv")) |proc| {
        function_pointers.glGetRenderbufferParameteriv = @ptrCast(?function_signatures.glGetRenderbufferParameteriv,  proc);
    } else {
        log.err("entry point glGetRenderbufferParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsFramebuffer")) |proc| {
        function_pointers.glIsFramebuffer = @ptrCast(?function_signatures.glIsFramebuffer,  proc);
    } else {
        log.err("entry point glIsFramebuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindFramebuffer")) |proc| {
        function_pointers.glBindFramebuffer = @ptrCast(?function_signatures.glBindFramebuffer,  proc);
    } else {
        log.err("entry point glBindFramebuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteFramebuffers")) |proc| {
        function_pointers.glDeleteFramebuffers = @ptrCast(?function_signatures.glDeleteFramebuffers,  proc);
    } else {
        log.err("entry point glDeleteFramebuffers not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenFramebuffers")) |proc| {
        function_pointers.glGenFramebuffers = @ptrCast(?function_signatures.glGenFramebuffers,  proc);
    } else {
        log.err("entry point glGenFramebuffers not found!", .{});
        success = false;
    }
    if(get_proc_address("glCheckFramebufferStatus")) |proc| {
        function_pointers.glCheckFramebufferStatus = @ptrCast(?function_signatures.glCheckFramebufferStatus,  proc);
    } else {
        log.err("entry point glCheckFramebufferStatus not found!", .{});
        success = false;
    }
    if(get_proc_address("glFramebufferTexture1D")) |proc| {
        function_pointers.glFramebufferTexture1D = @ptrCast(?function_signatures.glFramebufferTexture1D,  proc);
    } else {
        log.err("entry point glFramebufferTexture1D not found!", .{});
        success = false;
    }
    if(get_proc_address("glFramebufferTexture2D")) |proc| {
        function_pointers.glFramebufferTexture2D = @ptrCast(?function_signatures.glFramebufferTexture2D,  proc);
    } else {
        log.err("entry point glFramebufferTexture2D not found!", .{});
        success = false;
    }
    if(get_proc_address("glFramebufferTexture3D")) |proc| {
        function_pointers.glFramebufferTexture3D = @ptrCast(?function_signatures.glFramebufferTexture3D,  proc);
    } else {
        log.err("entry point glFramebufferTexture3D not found!", .{});
        success = false;
    }
    if(get_proc_address("glFramebufferRenderbuffer")) |proc| {
        function_pointers.glFramebufferRenderbuffer = @ptrCast(?function_signatures.glFramebufferRenderbuffer,  proc);
    } else {
        log.err("entry point glFramebufferRenderbuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetFramebufferAttachmentParameteriv")) |proc| {
        function_pointers.glGetFramebufferAttachmentParameteriv = @ptrCast(?function_signatures.glGetFramebufferAttachmentParameteriv,  proc);
    } else {
        log.err("entry point glGetFramebufferAttachmentParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenerateMipmap")) |proc| {
        function_pointers.glGenerateMipmap = @ptrCast(?function_signatures.glGenerateMipmap,  proc);
    } else {
        log.err("entry point glGenerateMipmap not found!", .{});
        success = false;
    }
    if(get_proc_address("glBlitFramebuffer")) |proc| {
        function_pointers.glBlitFramebuffer = @ptrCast(?function_signatures.glBlitFramebuffer,  proc);
    } else {
        log.err("entry point glBlitFramebuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glRenderbufferStorageMultisample")) |proc| {
        function_pointers.glRenderbufferStorageMultisample = @ptrCast(?function_signatures.glRenderbufferStorageMultisample,  proc);
    } else {
        log.err("entry point glRenderbufferStorageMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address("glFramebufferTextureLayer")) |proc| {
        function_pointers.glFramebufferTextureLayer = @ptrCast(?function_signatures.glFramebufferTextureLayer,  proc);
    } else {
        log.err("entry point glFramebufferTextureLayer not found!", .{});
        success = false;
    }
    if(get_proc_address("glMapBufferRange")) |proc| {
        function_pointers.glMapBufferRange = @ptrCast(?function_signatures.glMapBufferRange,  proc);
    } else {
        log.err("entry point glMapBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address("glFlushMappedBufferRange")) |proc| {
        function_pointers.glFlushMappedBufferRange = @ptrCast(?function_signatures.glFlushMappedBufferRange,  proc);
    } else {
        log.err("entry point glFlushMappedBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address("glBindVertexArray")) |proc| {
        function_pointers.glBindVertexArray = @ptrCast(?function_signatures.glBindVertexArray,  proc);
    } else {
        log.err("entry point glBindVertexArray not found!", .{});
        success = false;
    }
    if(get_proc_address("glDeleteVertexArrays")) |proc| {
        function_pointers.glDeleteVertexArrays = @ptrCast(?function_signatures.glDeleteVertexArrays,  proc);
    } else {
        log.err("entry point glDeleteVertexArrays not found!", .{});
        success = false;
    }
    if(get_proc_address("glGenVertexArrays")) |proc| {
        function_pointers.glGenVertexArrays = @ptrCast(?function_signatures.glGenVertexArrays,  proc);
    } else {
        log.err("entry point glGenVertexArrays not found!", .{});
        success = false;
    }
    if(get_proc_address("glIsVertexArray")) |proc| {
        function_pointers.glIsVertexArray = @ptrCast(?function_signatures.glIsVertexArray,  proc);
    } else {
        log.err("entry point glIsVertexArray not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawArraysInstanced")) |proc| {
        function_pointers.glDrawArraysInstanced = @ptrCast(?function_signatures.glDrawArraysInstanced,  proc);
    } else {
        log.err("entry point glDrawArraysInstanced not found!", .{});
        success = false;
    }
    if(get_proc_address("glDrawElementsInstanced")) |proc| {
        function_pointers.glDrawElementsInstanced = @ptrCast(?function_signatures.glDrawElementsInstanced,  proc);
    } else {
        log.err("entry point glDrawElementsInstanced not found!", .{});
        success = false;
    }
    if(get_proc_address("glTexBuffer")) |proc| {
        function_pointers.glTexBuffer = @ptrCast(?function_signatures.glTexBuffer,  proc);
    } else {
        log.err("entry point glTexBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address("glPrimitiveRestartIndex")) |proc| {
        function_pointers.glPrimitiveRestartIndex = @ptrCast(?function_signatures.glPrimitiveRestartIndex,  proc);
    } else {
        log.err("entry point glPrimitiveRestartIndex not found!", .{});
        success = false;
    }
    if(get_proc_address("glCopyBufferSubData")) |proc| {
        function_pointers.glCopyBufferSubData = @ptrCast(?function_signatures.glCopyBufferSubData,  proc);
    } else {
        log.err("entry point glCopyBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetUniformIndices")) |proc| {
        function_pointers.glGetUniformIndices = @ptrCast(?function_signatures.glGetUniformIndices,  proc);
    } else {
        log.err("entry point glGetUniformIndices not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveUniformsiv")) |proc| {
        function_pointers.glGetActiveUniformsiv = @ptrCast(?function_signatures.glGetActiveUniformsiv,  proc);
    } else {
        log.err("entry point glGetActiveUniformsiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveUniformName")) |proc| {
        function_pointers.glGetActiveUniformName = @ptrCast(?function_signatures.glGetActiveUniformName,  proc);
    } else {
        log.err("entry point glGetActiveUniformName not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetUniformBlockIndex")) |proc| {
        function_pointers.glGetUniformBlockIndex = @ptrCast(?function_signatures.glGetUniformBlockIndex,  proc);
    } else {
        log.err("entry point glGetUniformBlockIndex not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveUniformBlockiv")) |proc| {
        function_pointers.glGetActiveUniformBlockiv = @ptrCast(?function_signatures.glGetActiveUniformBlockiv,  proc);
    } else {
        log.err("entry point glGetActiveUniformBlockiv not found!", .{});
        success = false;
    }
    if(get_proc_address("glGetActiveUniformBlockName")) |proc| {
        function_pointers.glGetActiveUniformBlockName = @ptrCast(?function_signatures.glGetActiveUniformBlockName,  proc);
    } else {
        log.err("entry point glGetActiveUniformBlockName not found!", .{});
        success = false;
    }
    if(get_proc_address("glUniformBlockBinding")) |proc| {
        function_pointers.glUniformBlockBinding = @ptrCast(?function_signatures.glUniformBlockBinding,  proc);
    } else {
        log.err("entry point glUniformBlockBinding not found!", .{});
        success = false;
    }
    if(!success)
        return error.EntryPointNotFound;
}

const function_signatures = struct {
    const glGetDoublei_v = fn(_target: GLenum, _index: GLuint, _data: [*c]GLdouble) void;
    const glGetFloati_v = fn(_target: GLenum, _index: GLuint, _data: [*c]GLfloat) void;
    const glDepthRangeIndexed = fn(_index: GLuint, _n: GLdouble, _f: GLdouble) void;
    const glDepthRangeArrayv = fn(_first: GLuint, _count: GLsizei, _v: [*c]const GLdouble) void;
    const glScissorIndexedv = fn(_index: GLuint, _v: [*c]const GLint) void;
    const glScissorIndexed = fn(_index: GLuint, _left: GLint, _bottom: GLint, _width: GLsizei, _height: GLsizei) void;
    const glScissorArrayv = fn(_first: GLuint, _count: GLsizei, _v: [*c]const GLint) void;
    const glViewportIndexedfv = fn(_index: GLuint, _v: [*c]const GLfloat) void;
    const glViewportIndexedf = fn(_index: GLuint, _x: GLfloat, _y: GLfloat, _w: GLfloat, _h: GLfloat) void;
    const glViewportArrayv = fn(_first: GLuint, _count: GLsizei, _v: [*c]const GLfloat) void;
    const glGetVertexAttribLdv = fn(_index: GLuint, _pname: GLenum, _params: [*c]GLdouble) void;
    const glVertexAttribLPointer = fn(_index: GLuint, _size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void;
    const glVertexAttribL4dv = fn(_index: GLuint, _v: [*c]const GLdouble) void;
    const glVertexAttribL3dv = fn(_index: GLuint, _v: [*c]const GLdouble) void;
    const glVertexAttribL2dv = fn(_index: GLuint, _v: [*c]const GLdouble) void;
    const glVertexAttribL1dv = fn(_index: GLuint, _v: [*c]const GLdouble) void;
    const glVertexAttribL4d = fn(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) void;
    const glVertexAttribL3d = fn(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble) void;
    const glVertexAttribL2d = fn(_index: GLuint, _x: GLdouble, _y: GLdouble) void;
    const glVertexAttribL1d = fn(_index: GLuint, _x: GLdouble) void;
    const glValidateProgramPipeline = fn(_pipeline: GLuint) void;
    const glProgramUniformMatrix4x3dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix3x4dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix4x2dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix2x4dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix3x2dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix2x3dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix4x3fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniformMatrix3x4fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniformMatrix4x2fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniformMatrix2x4fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniformMatrix3x2fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniformMatrix2x3fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniformMatrix4dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix3dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix2dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glProgramUniformMatrix4fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniformMatrix3fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniformMatrix2fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glProgramUniform4uiv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLuint) void;
    const glProgramUniform4ui = fn(_program: GLuint, _location: GLint, _v0: GLuint, _v1: GLuint, _v2: GLuint, _v3: GLuint) void;
    const glProgramUniform4dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void;
    const glProgramUniform4d = fn(_program: GLuint, _location: GLint, _v0: GLdouble, _v1: GLdouble, _v2: GLdouble, _v3: GLdouble) void;
    const glProgramUniform4fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void;
    const glProgramUniform4f = fn(_program: GLuint, _location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat, _v3: GLfloat) void;
    const glProgramUniform4iv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLint) void;
    const glProgramUniform4i = fn(_program: GLuint, _location: GLint, _v0: GLint, _v1: GLint, _v2: GLint, _v3: GLint) void;
    const glProgramUniform3uiv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLuint) void;
    const glProgramUniform3ui = fn(_program: GLuint, _location: GLint, _v0: GLuint, _v1: GLuint, _v2: GLuint) void;
    const glProgramUniform3dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void;
    const glProgramUniform3d = fn(_program: GLuint, _location: GLint, _v0: GLdouble, _v1: GLdouble, _v2: GLdouble) void;
    const glProgramUniform3fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void;
    const glProgramUniform3f = fn(_program: GLuint, _location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat) void;
    const glProgramUniform3iv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLint) void;
    const glProgramUniform3i = fn(_program: GLuint, _location: GLint, _v0: GLint, _v1: GLint, _v2: GLint) void;
    const glUseProgramStages = fn(_pipeline: GLuint, _stages: GLbitfield, _program: GLuint) void;
    const glProgramParameteri = fn(_program: GLuint, _pname: GLenum, _value: GLint) void;
    const glGetShaderPrecisionFormat = fn(_shadertype: GLenum, _precisiontype: GLenum, _range: [*c]GLint, _precision: [*c]GLint) void;
    const glShaderBinary = fn(_count: GLsizei, _shaders: [*c]const GLuint, _binaryFormat: GLenum, _binary: ?*const anyopaque, _length: GLsizei) void;
    const glReleaseShaderCompiler = fn() void;
    const glGetQueryIndexediv = fn(_target: GLenum, _index: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glEndQueryIndexed = fn(_target: GLenum, _index: GLuint) void;
    const glBeginQueryIndexed = fn(_target: GLenum, _index: GLuint, _id: GLuint) void;
    const glDrawTransformFeedbackStream = fn(_mode: GLenum, _id: GLuint, _stream: GLuint) void;
    const glDrawTransformFeedback = fn(_mode: GLenum, _id: GLuint) void;
    const glResumeTransformFeedback = fn() void;
    const glPauseTransformFeedback = fn() void;
    const glGetProgramStageiv = fn(_program: GLuint, _shadertype: GLenum, _pname: GLenum, _values: [*c]GLint) void;
    const glGetUniformSubroutineuiv = fn(_shadertype: GLenum, _location: GLint, _params: [*c]GLuint) void;
    const glUniformSubroutinesuiv = fn(_shadertype: GLenum, _count: GLsizei, _indices: [*c]const GLuint) void;
    const glGetActiveSubroutineName = fn(_program: GLuint, _shadertype: GLenum, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _name: [*c]GLchar) void;
    const glCullFace = fn(_mode: GLenum) void;
    const glFrontFace = fn(_mode: GLenum) void;
    const glHint = fn(_target: GLenum, _mode: GLenum) void;
    const glLineWidth = fn(_width: GLfloat) void;
    const glPointSize = fn(_size: GLfloat) void;
    const glPolygonMode = fn(_face: GLenum, _mode: GLenum) void;
    const glScissor = fn(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void;
    const glTexParameterf = fn(_target: GLenum, _pname: GLenum, _param: GLfloat) void;
    const glTexParameterfv = fn(_target: GLenum, _pname: GLenum, _params: [*c]const GLfloat) void;
    const glTexParameteri = fn(_target: GLenum, _pname: GLenum, _param: GLint) void;
    const glTexParameteriv = fn(_target: GLenum, _pname: GLenum, _params: [*c]const GLint) void;
    const glTexImage1D = fn(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void;
    const glTexImage2D = fn(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void;
    const glDrawBuffer = fn(_buf: GLenum) void;
    const glClear = fn(_mask: GLbitfield) void;
    const glClearColor = fn(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) void;
    const glClearStencil = fn(_s: GLint) void;
    const glClearDepth = fn(_depth: GLdouble) void;
    const glStencilMask = fn(_mask: GLuint) void;
    const glColorMask = fn(_red: GLboolean, _green: GLboolean, _blue: GLboolean, _alpha: GLboolean) void;
    const glDepthMask = fn(_flag: GLboolean) void;
    const glDisable = fn(_cap: GLenum) void;
    const glEnable = fn(_cap: GLenum) void;
    const glFinish = fn() void;
    const glFlush = fn() void;
    const glBlendFunc = fn(_sfactor: GLenum, _dfactor: GLenum) void;
    const glLogicOp = fn(_opcode: GLenum) void;
    const glStencilFunc = fn(_func: GLenum, _ref: GLint, _mask: GLuint) void;
    const glStencilOp = fn(_fail: GLenum, _zfail: GLenum, _zpass: GLenum) void;
    const glDepthFunc = fn(_func: GLenum) void;
    const glPixelStoref = fn(_pname: GLenum, _param: GLfloat) void;
    const glPixelStorei = fn(_pname: GLenum, _param: GLint) void;
    const glReadBuffer = fn(_src: GLenum) void;
    const glReadPixels = fn(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) void;
    const glGetBooleanv = fn(_pname: GLenum, _data: [*c]GLboolean) void;
    const glGetDoublev = fn(_pname: GLenum, _data: [*c]GLdouble) void;
    const glGetError = fn() GLenum;
    const glGetFloatv = fn(_pname: GLenum, _data: [*c]GLfloat) void;
    const glGetIntegerv = fn(_pname: GLenum, _data: [*c]GLint) void;
    const glGetString = fn(_name: GLenum) ?[*:0]const GLubyte;
    const glGetTexImage = fn(_target: GLenum, _level: GLint, _format: GLenum, _type: GLenum, _pixels: ?*anyopaque) void;
    const glGetTexParameterfv = fn(_target: GLenum, _pname: GLenum, _params: [*c]GLfloat) void;
    const glGetTexParameteriv = fn(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void;
    const glGetTexLevelParameterfv = fn(_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLfloat) void;
    const glGetTexLevelParameteriv = fn(_target: GLenum, _level: GLint, _pname: GLenum, _params: [*c]GLint) void;
    const glIsEnabled = fn(_cap: GLenum) GLboolean;
    const glDepthRange = fn(_n: GLdouble, _f: GLdouble) void;
    const glViewport = fn(_x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void;
    const glGetProgramPipelineInfoLog = fn(_pipeline: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) void;
    const glProgramUniform2uiv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLuint) void;
    const glProgramUniform2ui = fn(_program: GLuint, _location: GLint, _v0: GLuint, _v1: GLuint) void;
    const glProgramUniform2dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void;
    const glProgramUniform2d = fn(_program: GLuint, _location: GLint, _v0: GLdouble, _v1: GLdouble) void;
    const glProgramUniform2fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void;
    const glProgramUniform2f = fn(_program: GLuint, _location: GLint, _v0: GLfloat, _v1: GLfloat) void;
    const glProgramUniform2iv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLint) void;
    const glProgramUniform2i = fn(_program: GLuint, _location: GLint, _v0: GLint, _v1: GLint) void;
    const glProgramUniform1uiv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLuint) void;
    const glProgramUniform1ui = fn(_program: GLuint, _location: GLint, _v0: GLuint) void;
    const glProgramUniform1dv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void;
    const glProgramUniform1d = fn(_program: GLuint, _location: GLint, _v0: GLdouble) void;
    const glProgramUniform1fv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void;
    const glProgramUniform1f = fn(_program: GLuint, _location: GLint, _v0: GLfloat) void;
    const glProgramUniform1iv = fn(_program: GLuint, _location: GLint, _count: GLsizei, _value: [*c]const GLint) void;
    const glProgramUniform1i = fn(_program: GLuint, _location: GLint, _v0: GLint) void;
    const glGetProgramPipelineiv = fn(_pipeline: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glIsProgramPipeline = fn(_pipeline: GLuint) GLboolean;
    const glGenProgramPipelines = fn(_n: GLsizei, _pipelines: [*c]GLuint) void;
    const glDeleteProgramPipelines = fn(_n: GLsizei, _pipelines: [*c]const GLuint) void;
    const glBindProgramPipeline = fn(_pipeline: GLuint) void;
    const glCreateShaderProgramv = fn(_type: GLenum, _count: GLsizei, _strings: *[:0]const GLchar) GLuint;
    const glActiveShaderProgram = fn(_pipeline: GLuint, _program: GLuint) void;
    const glProgramBinary = fn(_program: GLuint, _binaryFormat: GLenum, _binary: ?*const anyopaque, _length: GLsizei) void;
    const glGetProgramBinary = fn(_program: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _binaryFormat: [*c]GLenum, _binary: ?*anyopaque) void;
    const glClearDepthf = fn(_d: GLfloat) void;
    const glDepthRangef = fn(_n: GLfloat, _f: GLfloat) void;
    const glIsTransformFeedback = fn(_id: GLuint) GLboolean;
    const glGenTransformFeedbacks = fn(_n: GLsizei, _ids: [*c]GLuint) void;
    const glDeleteTransformFeedbacks = fn(_n: GLsizei, _ids: [*c]const GLuint) void;
    const glBindTransformFeedback = fn(_target: GLenum, _id: GLuint) void;
    const glPatchParameterfv = fn(_pname: GLenum, _values: [*c]const GLfloat) void;
    const glPatchParameteri = fn(_pname: GLenum, _value: GLint) void;
    const glDrawArrays = fn(_mode: GLenum, _first: GLint, _count: GLsizei) void;
    const glDrawElements = fn(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) void;
    const glPolygonOffset = fn(_factor: GLfloat, _units: GLfloat) void;
    const glCopyTexImage1D = fn(_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _border: GLint) void;
    const glCopyTexImage2D = fn(_target: GLenum, _level: GLint, _internalformat: GLenum, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei, _border: GLint) void;
    const glCopyTexSubImage1D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei) void;
    const glCopyTexSubImage2D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void;
    const glTexSubImage1D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void;
    const glTexSubImage2D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void;
    const glBindTexture = fn(_target: GLenum, _texture: GLuint) void;
    const glDeleteTextures = fn(_n: GLsizei, _textures: [*c]const GLuint) void;
    const glGenTextures = fn(_n: GLsizei, _textures: [*c]GLuint) void;
    const glIsTexture = fn(_texture: GLuint) GLboolean;
    const glGetActiveSubroutineUniformName = fn(_program: GLuint, _shadertype: GLenum, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _name: [*c]GLchar) void;
    const glGetActiveSubroutineUniformiv = fn(_program: GLuint, _shadertype: GLenum, _index: GLuint, _pname: GLenum, _values: [*c]GLint) void;
    const glGetSubroutineIndex = fn(_program: GLuint, _shadertype: GLenum, _name: [*c]const GLchar) GLuint;
    const glGetSubroutineUniformLocation = fn(_program: GLuint, _shadertype: GLenum, _name: [*c]const GLchar) GLint;
    const glGetUniformdv = fn(_program: GLuint, _location: GLint, _params: [*c]GLdouble) void;
    const glUniformMatrix4x3dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glUniformMatrix4x2dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glUniformMatrix3x4dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glUniformMatrix3x2dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glUniformMatrix2x4dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glUniformMatrix2x3dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glUniformMatrix4dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glUniformMatrix3dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glDrawRangeElements = fn(_mode: GLenum, _start: GLuint, _end: GLuint, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque) void;
    const glTexImage3D = fn(_target: GLenum, _level: GLint, _internalformat: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _border: GLint, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void;
    const glTexSubImage3D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _format: GLenum, _type: GLenum, _pixels: ?*const anyopaque) void;
    const glCopyTexSubImage3D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _x: GLint, _y: GLint, _width: GLsizei, _height: GLsizei) void;
    const glUniformMatrix2dv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLdouble) void;
    const glUniform4dv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void;
    const glUniform3dv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void;
    const glUniform2dv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void;
    const glUniform1dv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLdouble) void;
    const glUniform4d = fn(_location: GLint, _x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) void;
    const glUniform3d = fn(_location: GLint, _x: GLdouble, _y: GLdouble, _z: GLdouble) void;
    const glUniform2d = fn(_location: GLint, _x: GLdouble, _y: GLdouble) void;
    const glUniform1d = fn(_location: GLint, _x: GLdouble) void;
    const glDrawElementsIndirect = fn(_mode: GLenum, _type: GLenum, _indirect: ?*const anyopaque) void;
    const glDrawArraysIndirect = fn(_mode: GLenum, _indirect: ?*const anyopaque) void;
    const glBlendFuncSeparatei = fn(_buf: GLuint, _srcRGB: GLenum, _dstRGB: GLenum, _srcAlpha: GLenum, _dstAlpha: GLenum) void;
    const glBlendFunci = fn(_buf: GLuint, _src: GLenum, _dst: GLenum) void;
    const glBlendEquationSeparatei = fn(_buf: GLuint, _modeRGB: GLenum, _modeAlpha: GLenum) void;
    const glBlendEquationi = fn(_buf: GLuint, _mode: GLenum) void;
    const glMinSampleShading = fn(_value: GLfloat) void;
    const glActiveTexture = fn(_texture: GLenum) void;
    const glSampleCoverage = fn(_value: GLfloat, _invert: GLboolean) void;
    const glCompressedTexImage3D = fn(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) void;
    const glCompressedTexImage2D = fn(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) void;
    const glCompressedTexImage1D = fn(_target: GLenum, _level: GLint, _internalformat: GLenum, _width: GLsizei, _border: GLint, _imageSize: GLsizei, _data: ?*const anyopaque) void;
    const glCompressedTexSubImage3D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _zoffset: GLint, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) void;
    const glCompressedTexSubImage2D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _yoffset: GLint, _width: GLsizei, _height: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) void;
    const glCompressedTexSubImage1D = fn(_target: GLenum, _level: GLint, _xoffset: GLint, _width: GLsizei, _format: GLenum, _imageSize: GLsizei, _data: ?*const anyopaque) void;
    const glGetCompressedTexImage = fn(_target: GLenum, _level: GLint, _img: ?*anyopaque) void;
    const glVertexAttribP4uiv = fn(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: [*c]const GLuint) void;
    const glVertexAttribP4ui = fn(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: GLuint) void;
    const glVertexAttribP3uiv = fn(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: [*c]const GLuint) void;
    const glVertexAttribP3ui = fn(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: GLuint) void;
    const glVertexAttribP2uiv = fn(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: [*c]const GLuint) void;
    const glVertexAttribP2ui = fn(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: GLuint) void;
    const glVertexAttribP1uiv = fn(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: [*c]const GLuint) void;
    const glVertexAttribP1ui = fn(_index: GLuint, _type: GLenum, _normalized: GLboolean, _value: GLuint) void;
    const glVertexAttribDivisor = fn(_index: GLuint, _divisor: GLuint) void;
    const glGetQueryObjectui64v = fn(_id: GLuint, _pname: GLenum, _params: [*c]GLuint64) void;
    const glGetQueryObjecti64v = fn(_id: GLuint, _pname: GLenum, _params: [*c]GLint64) void;
    const glQueryCounter = fn(_id: GLuint, _target: GLenum) void;
    const glGetSamplerParameterIuiv = fn(_sampler: GLuint, _pname: GLenum, _params: [*c]GLuint) void;
    const glGetSamplerParameterfv = fn(_sampler: GLuint, _pname: GLenum, _params: [*c]GLfloat) void;
    const glGetSamplerParameterIiv = fn(_sampler: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glGetSamplerParameteriv = fn(_sampler: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glSamplerParameterIuiv = fn(_sampler: GLuint, _pname: GLenum, _param: [*c]const GLuint) void;
    const glSamplerParameterIiv = fn(_sampler: GLuint, _pname: GLenum, _param: [*c]const GLint) void;
    const glSamplerParameterfv = fn(_sampler: GLuint, _pname: GLenum, _param: [*c]const GLfloat) void;
    const glSamplerParameterf = fn(_sampler: GLuint, _pname: GLenum, _param: GLfloat) void;
    const glSamplerParameteriv = fn(_sampler: GLuint, _pname: GLenum, _param: [*c]const GLint) void;
    const glSamplerParameteri = fn(_sampler: GLuint, _pname: GLenum, _param: GLint) void;
    const glBindSampler = fn(_unit: GLuint, _sampler: GLuint) void;
    const glIsSampler = fn(_sampler: GLuint) GLboolean;
    const glDeleteSamplers = fn(_count: GLsizei, _samplers: [*c]const GLuint) void;
    const glGenSamplers = fn(_count: GLsizei, _samplers: [*c]GLuint) void;
    const glGetFragDataIndex = fn(_program: GLuint, _name: [*c]const GLchar) GLint;
    const glBindFragDataLocationIndexed = fn(_program: GLuint, _colorNumber: GLuint, _index: GLuint, _name: [*c]const GLchar) void;
    const glSampleMaski = fn(_maskNumber: GLuint, _mask: GLbitfield) void;
    const glGetMultisamplefv = fn(_pname: GLenum, _index: GLuint, _val: [*c]GLfloat) void;
    const glTexImage3DMultisample = fn(_target: GLenum, _samples: GLsizei, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _depth: GLsizei, _fixedsamplelocations: GLboolean) void;
    const glTexImage2DMultisample = fn(_target: GLenum, _samples: GLsizei, _internalformat: GLenum, _width: GLsizei, _height: GLsizei, _fixedsamplelocations: GLboolean) void;
    const glFramebufferTexture = fn(_target: GLenum, _attachment: GLenum, _texture: GLuint, _level: GLint) void;
    const glGetBufferParameteri64v = fn(_target: GLenum, _pname: GLenum, _params: [*c]GLint64) void;
    const glBlendFuncSeparate = fn(_sfactorRGB: GLenum, _dfactorRGB: GLenum, _sfactorAlpha: GLenum, _dfactorAlpha: GLenum) void;
    const glMultiDrawArrays = fn(_mode: GLenum, _first: [*c]const GLint, _count: [*c]const GLsizei, _drawcount: GLsizei) void;
    const glMultiDrawElements = fn(_mode: GLenum, _count: [*c]const GLsizei, _type: GLenum, _indices: [*c]const ?*const anyopaque, _drawcount: GLsizei) void;
    const glPointParameterf = fn(_pname: GLenum, _param: GLfloat) void;
    const glPointParameterfv = fn(_pname: GLenum, _params: [*c]const GLfloat) void;
    const glPointParameteri = fn(_pname: GLenum, _param: GLint) void;
    const glPointParameteriv = fn(_pname: GLenum, _params: [*c]const GLint) void;
    const glGetInteger64i_v = fn(_target: GLenum, _index: GLuint, _data: [*c]GLint64) void;
    const glGetSynciv = fn(_sync: GLsync, _pname: GLenum, _count: GLsizei, _length: [*c]GLsizei, _values: [*c]GLint) void;
    const glGetInteger64v = fn(_pname: GLenum, _data: [*c]GLint64) void;
    const glWaitSync = fn(_sync: GLsync, _flags: GLbitfield, _timeout: GLuint64) void;
    const glClientWaitSync = fn(_sync: GLsync, _flags: GLbitfield, _timeout: GLuint64) GLenum;
    const glDeleteSync = fn(_sync: GLsync) void;
    const glIsSync = fn(_sync: GLsync) GLboolean;
    const glFenceSync = fn(_condition: GLenum, _flags: GLbitfield) GLsync;
    const glBlendColor = fn(_red: GLfloat, _green: GLfloat, _blue: GLfloat, _alpha: GLfloat) void;
    const glBlendEquation = fn(_mode: GLenum) void;
    const glProvokingVertex = fn(_mode: GLenum) void;
    const glMultiDrawElementsBaseVertex = fn(_mode: GLenum, _count: [*c]const GLsizei, _type: GLenum, _indices: [*c]const ?*const anyopaque, _drawcount: GLsizei, _basevertex: [*c]const GLint) void;
    const glDrawElementsInstancedBaseVertex = fn(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque, _instancecount: GLsizei, _basevertex: GLint) void;
    const glDrawRangeElementsBaseVertex = fn(_mode: GLenum, _start: GLuint, _end: GLuint, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque, _basevertex: GLint) void;
    const glDrawElementsBaseVertex = fn(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque, _basevertex: GLint) void;
    const glGenQueries = fn(_n: GLsizei, _ids: [*c]GLuint) void;
    const glDeleteQueries = fn(_n: GLsizei, _ids: [*c]const GLuint) void;
    const glIsQuery = fn(_id: GLuint) GLboolean;
    const glBeginQuery = fn(_target: GLenum, _id: GLuint) void;
    const glEndQuery = fn(_target: GLenum) void;
    const glGetQueryiv = fn(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void;
    const glGetQueryObjectiv = fn(_id: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glGetQueryObjectuiv = fn(_id: GLuint, _pname: GLenum, _params: [*c]GLuint) void;
    const glBindBuffer = fn(_target: GLenum, _buffer: GLuint) void;
    const glDeleteBuffers = fn(_n: GLsizei, _buffers: [*c]const GLuint) void;
    const glGenBuffers = fn(_n: GLsizei, _buffers: [*c]GLuint) void;
    const glIsBuffer = fn(_buffer: GLuint) GLboolean;
    const glBufferData = fn(_target: GLenum, _size: GLsizeiptr, _data: ?*const anyopaque, _usage: GLenum) void;
    const glBufferSubData = fn(_target: GLenum, _offset: GLintptr, _size: GLsizeiptr, _data: ?*const anyopaque) void;
    const glGetBufferSubData = fn(_target: GLenum, _offset: GLintptr, _size: GLsizeiptr, _data: ?*anyopaque) void;
    const glMapBuffer = fn(_target: GLenum, _access: GLenum) ?*anyopaque;
    const glUnmapBuffer = fn(_target: GLenum) GLboolean;
    const glGetBufferParameteriv = fn(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void;
    const glGetBufferPointerv = fn(_target: GLenum, _pname: GLenum, _params: ?*?*anyopaque) void;
    const glBlendEquationSeparate = fn(_modeRGB: GLenum, _modeAlpha: GLenum) void;
    const glDrawBuffers = fn(_n: GLsizei, _bufs: [*c]const GLenum) void;
    const glStencilOpSeparate = fn(_face: GLenum, _sfail: GLenum, _dpfail: GLenum, _dppass: GLenum) void;
    const glStencilFuncSeparate = fn(_face: GLenum, _func: GLenum, _ref: GLint, _mask: GLuint) void;
    const glStencilMaskSeparate = fn(_face: GLenum, _mask: GLuint) void;
    const glAttachShader = fn(_program: GLuint, _shader: GLuint) void;
    const glBindAttribLocation = fn(_program: GLuint, _index: GLuint, _name: [*c]const GLchar) void;
    const glCompileShader = fn(_shader: GLuint) void;
    const glCreateProgram = fn() GLuint;
    const glCreateShader = fn(_type: GLenum) GLuint;
    const glDeleteProgram = fn(_program: GLuint) void;
    const glDeleteShader = fn(_shader: GLuint) void;
    const glDetachShader = fn(_program: GLuint, _shader: GLuint) void;
    const glDisableVertexAttribArray = fn(_index: GLuint) void;
    const glEnableVertexAttribArray = fn(_index: GLuint) void;
    const glGetActiveAttrib = fn(_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLint, _type: [*c]GLenum, _name: [*c]GLchar) void;
    const glGetActiveUniform = fn(_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLint, _type: [*c]GLenum, _name: [*c]GLchar) void;
    const glGetAttachedShaders = fn(_program: GLuint, _maxCount: GLsizei, _count: [*c]GLsizei, _shaders: [*c]GLuint) void;
    const glGetAttribLocation = fn(_program: GLuint, _name: [*c]const GLchar) GLint;
    const glGetProgramiv = fn(_program: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glGetProgramInfoLog = fn(_program: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) void;
    const glGetShaderiv = fn(_shader: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glGetShaderInfoLog = fn(_shader: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _infoLog: [*c]GLchar) void;
    const glGetShaderSource = fn(_shader: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _source: [*c]GLchar) void;
    const glGetUniformLocation = fn(_program: GLuint, _name: [*c]const GLchar) GLint;
    const glGetUniformfv = fn(_program: GLuint, _location: GLint, _params: [*c]GLfloat) void;
    const glGetUniformiv = fn(_program: GLuint, _location: GLint, _params: [*c]GLint) void;
    const glGetVertexAttribdv = fn(_index: GLuint, _pname: GLenum, _params: [*c]GLdouble) void;
    const glGetVertexAttribfv = fn(_index: GLuint, _pname: GLenum, _params: [*c]GLfloat) void;
    const glGetVertexAttribiv = fn(_index: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glGetVertexAttribPointerv = fn(_index: GLuint, _pname: GLenum, _pointer: ?*?*anyopaque) void;
    const glIsProgram = fn(_program: GLuint) GLboolean;
    const glIsShader = fn(_shader: GLuint) GLboolean;
    const glLinkProgram = fn(_program: GLuint) void;
    const glShaderSource = fn(_shader: GLuint, _count: GLsizei, _string: *[:0]const GLchar, _length: [*c]const GLint) void;
    const glUseProgram = fn(_program: GLuint) void;
    const glUniform1f = fn(_location: GLint, _v0: GLfloat) void;
    const glUniform2f = fn(_location: GLint, _v0: GLfloat, _v1: GLfloat) void;
    const glUniform3f = fn(_location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat) void;
    const glUniform4f = fn(_location: GLint, _v0: GLfloat, _v1: GLfloat, _v2: GLfloat, _v3: GLfloat) void;
    const glUniform1i = fn(_location: GLint, _v0: GLint) void;
    const glUniform2i = fn(_location: GLint, _v0: GLint, _v1: GLint) void;
    const glUniform3i = fn(_location: GLint, _v0: GLint, _v1: GLint, _v2: GLint) void;
    const glUniform4i = fn(_location: GLint, _v0: GLint, _v1: GLint, _v2: GLint, _v3: GLint) void;
    const glUniform1fv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void;
    const glUniform2fv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void;
    const glUniform3fv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void;
    const glUniform4fv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLfloat) void;
    const glUniform1iv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLint) void;
    const glUniform2iv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLint) void;
    const glUniform3iv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLint) void;
    const glUniform4iv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLint) void;
    const glUniformMatrix2fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glUniformMatrix3fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glUniformMatrix4fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glValidateProgram = fn(_program: GLuint) void;
    const glVertexAttrib1d = fn(_index: GLuint, _x: GLdouble) void;
    const glVertexAttrib1dv = fn(_index: GLuint, _v: [*c]const GLdouble) void;
    const glVertexAttrib1f = fn(_index: GLuint, _x: GLfloat) void;
    const glVertexAttrib1fv = fn(_index: GLuint, _v: [*c]const GLfloat) void;
    const glVertexAttrib1s = fn(_index: GLuint, _x: GLshort) void;
    const glVertexAttrib1sv = fn(_index: GLuint, _v: [*c]const GLshort) void;
    const glVertexAttrib2d = fn(_index: GLuint, _x: GLdouble, _y: GLdouble) void;
    const glVertexAttrib2dv = fn(_index: GLuint, _v: [*c]const GLdouble) void;
    const glVertexAttrib2f = fn(_index: GLuint, _x: GLfloat, _y: GLfloat) void;
    const glVertexAttrib2fv = fn(_index: GLuint, _v: [*c]const GLfloat) void;
    const glVertexAttrib2s = fn(_index: GLuint, _x: GLshort, _y: GLshort) void;
    const glVertexAttrib2sv = fn(_index: GLuint, _v: [*c]const GLshort) void;
    const glVertexAttrib3d = fn(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble) void;
    const glVertexAttrib3dv = fn(_index: GLuint, _v: [*c]const GLdouble) void;
    const glVertexAttrib3f = fn(_index: GLuint, _x: GLfloat, _y: GLfloat, _z: GLfloat) void;
    const glVertexAttrib3fv = fn(_index: GLuint, _v: [*c]const GLfloat) void;
    const glVertexAttrib3s = fn(_index: GLuint, _x: GLshort, _y: GLshort, _z: GLshort) void;
    const glVertexAttrib3sv = fn(_index: GLuint, _v: [*c]const GLshort) void;
    const glVertexAttrib4Nbv = fn(_index: GLuint, _v: [*c]const GLbyte) void;
    const glVertexAttrib4Niv = fn(_index: GLuint, _v: [*c]const GLint) void;
    const glVertexAttrib4Nsv = fn(_index: GLuint, _v: [*c]const GLshort) void;
    const glVertexAttrib4Nub = fn(_index: GLuint, _x: GLubyte, _y: GLubyte, _z: GLubyte, _w: GLubyte) void;
    const glVertexAttrib4Nubv = fn(_index: GLuint, _v: ?[*:0]const GLubyte) void;
    const glVertexAttrib4Nuiv = fn(_index: GLuint, _v: [*c]const GLuint) void;
    const glVertexAttrib4Nusv = fn(_index: GLuint, _v: [*c]const GLushort) void;
    const glVertexAttrib4bv = fn(_index: GLuint, _v: [*c]const GLbyte) void;
    const glVertexAttrib4d = fn(_index: GLuint, _x: GLdouble, _y: GLdouble, _z: GLdouble, _w: GLdouble) void;
    const glVertexAttrib4dv = fn(_index: GLuint, _v: [*c]const GLdouble) void;
    const glVertexAttrib4f = fn(_index: GLuint, _x: GLfloat, _y: GLfloat, _z: GLfloat, _w: GLfloat) void;
    const glVertexAttrib4fv = fn(_index: GLuint, _v: [*c]const GLfloat) void;
    const glVertexAttrib4iv = fn(_index: GLuint, _v: [*c]const GLint) void;
    const glVertexAttrib4s = fn(_index: GLuint, _x: GLshort, _y: GLshort, _z: GLshort, _w: GLshort) void;
    const glVertexAttrib4sv = fn(_index: GLuint, _v: [*c]const GLshort) void;
    const glVertexAttrib4ubv = fn(_index: GLuint, _v: ?[*:0]const GLubyte) void;
    const glVertexAttrib4uiv = fn(_index: GLuint, _v: [*c]const GLuint) void;
    const glVertexAttrib4usv = fn(_index: GLuint, _v: [*c]const GLushort) void;
    const glVertexAttribPointer = fn(_index: GLuint, _size: GLint, _type: GLenum, _normalized: GLboolean, _stride: GLsizei, _pointer: ?*const anyopaque) void;
    const glUniformMatrix2x3fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glUniformMatrix3x2fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glUniformMatrix2x4fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glUniformMatrix4x2fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glUniformMatrix3x4fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glUniformMatrix4x3fv = fn(_location: GLint, _count: GLsizei, _transpose: GLboolean, _value: [*c]const GLfloat) void;
    const glColorMaski = fn(_index: GLuint, _r: GLboolean, _g: GLboolean, _b: GLboolean, _a: GLboolean) void;
    const glGetBooleani_v = fn(_target: GLenum, _index: GLuint, _data: [*c]GLboolean) void;
    const glGetIntegeri_v = fn(_target: GLenum, _index: GLuint, _data: [*c]GLint) void;
    const glEnablei = fn(_target: GLenum, _index: GLuint) void;
    const glDisablei = fn(_target: GLenum, _index: GLuint) void;
    const glIsEnabledi = fn(_target: GLenum, _index: GLuint) GLboolean;
    const glBeginTransformFeedback = fn(_primitiveMode: GLenum) void;
    const glEndTransformFeedback = fn() void;
    const glBindBufferRange = fn(_target: GLenum, _index: GLuint, _buffer: GLuint, _offset: GLintptr, _size: GLsizeiptr) void;
    const glBindBufferBase = fn(_target: GLenum, _index: GLuint, _buffer: GLuint) void;
    const glTransformFeedbackVaryings = fn(_program: GLuint, _count: GLsizei, _varyings: *[:0]const GLchar, _bufferMode: GLenum) void;
    const glGetTransformFeedbackVarying = fn(_program: GLuint, _index: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _size: [*c]GLsizei, _type: [*c]GLenum, _name: [*c]GLchar) void;
    const glClampColor = fn(_target: GLenum, _clamp: GLenum) void;
    const glBeginConditionalRender = fn(_id: GLuint, _mode: GLenum) void;
    const glEndConditionalRender = fn() void;
    const glVertexAttribIPointer = fn(_index: GLuint, _size: GLint, _type: GLenum, _stride: GLsizei, _pointer: ?*const anyopaque) void;
    const glGetVertexAttribIiv = fn(_index: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glGetVertexAttribIuiv = fn(_index: GLuint, _pname: GLenum, _params: [*c]GLuint) void;
    const glVertexAttribI1i = fn(_index: GLuint, _x: GLint) void;
    const glVertexAttribI2i = fn(_index: GLuint, _x: GLint, _y: GLint) void;
    const glVertexAttribI3i = fn(_index: GLuint, _x: GLint, _y: GLint, _z: GLint) void;
    const glVertexAttribI4i = fn(_index: GLuint, _x: GLint, _y: GLint, _z: GLint, _w: GLint) void;
    const glVertexAttribI1ui = fn(_index: GLuint, _x: GLuint) void;
    const glVertexAttribI2ui = fn(_index: GLuint, _x: GLuint, _y: GLuint) void;
    const glVertexAttribI3ui = fn(_index: GLuint, _x: GLuint, _y: GLuint, _z: GLuint) void;
    const glVertexAttribI4ui = fn(_index: GLuint, _x: GLuint, _y: GLuint, _z: GLuint, _w: GLuint) void;
    const glVertexAttribI1iv = fn(_index: GLuint, _v: [*c]const GLint) void;
    const glVertexAttribI2iv = fn(_index: GLuint, _v: [*c]const GLint) void;
    const glVertexAttribI3iv = fn(_index: GLuint, _v: [*c]const GLint) void;
    const glVertexAttribI4iv = fn(_index: GLuint, _v: [*c]const GLint) void;
    const glVertexAttribI1uiv = fn(_index: GLuint, _v: [*c]const GLuint) void;
    const glVertexAttribI2uiv = fn(_index: GLuint, _v: [*c]const GLuint) void;
    const glVertexAttribI3uiv = fn(_index: GLuint, _v: [*c]const GLuint) void;
    const glVertexAttribI4uiv = fn(_index: GLuint, _v: [*c]const GLuint) void;
    const glVertexAttribI4bv = fn(_index: GLuint, _v: [*c]const GLbyte) void;
    const glVertexAttribI4sv = fn(_index: GLuint, _v: [*c]const GLshort) void;
    const glVertexAttribI4ubv = fn(_index: GLuint, _v: ?[*:0]const GLubyte) void;
    const glVertexAttribI4usv = fn(_index: GLuint, _v: [*c]const GLushort) void;
    const glGetUniformuiv = fn(_program: GLuint, _location: GLint, _params: [*c]GLuint) void;
    const glBindFragDataLocation = fn(_program: GLuint, _color: GLuint, _name: [*c]const GLchar) void;
    const glGetFragDataLocation = fn(_program: GLuint, _name: [*c]const GLchar) GLint;
    const glUniform1ui = fn(_location: GLint, _v0: GLuint) void;
    const glUniform2ui = fn(_location: GLint, _v0: GLuint, _v1: GLuint) void;
    const glUniform3ui = fn(_location: GLint, _v0: GLuint, _v1: GLuint, _v2: GLuint) void;
    const glUniform4ui = fn(_location: GLint, _v0: GLuint, _v1: GLuint, _v2: GLuint, _v3: GLuint) void;
    const glUniform1uiv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLuint) void;
    const glUniform2uiv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLuint) void;
    const glUniform3uiv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLuint) void;
    const glUniform4uiv = fn(_location: GLint, _count: GLsizei, _value: [*c]const GLuint) void;
    const glTexParameterIiv = fn(_target: GLenum, _pname: GLenum, _params: [*c]const GLint) void;
    const glTexParameterIuiv = fn(_target: GLenum, _pname: GLenum, _params: [*c]const GLuint) void;
    const glGetTexParameterIiv = fn(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void;
    const glGetTexParameterIuiv = fn(_target: GLenum, _pname: GLenum, _params: [*c]GLuint) void;
    const glClearBufferiv = fn(_buffer: GLenum, _drawbuffer: GLint, _value: [*c]const GLint) void;
    const glClearBufferuiv = fn(_buffer: GLenum, _drawbuffer: GLint, _value: [*c]const GLuint) void;
    const glClearBufferfv = fn(_buffer: GLenum, _drawbuffer: GLint, _value: [*c]const GLfloat) void;
    const glClearBufferfi = fn(_buffer: GLenum, _drawbuffer: GLint, _depth: GLfloat, _stencil: GLint) void;
    const glGetStringi = fn(_name: GLenum, _index: GLuint) ?[*:0]const GLubyte;
    const glIsRenderbuffer = fn(_renderbuffer: GLuint) GLboolean;
    const glBindRenderbuffer = fn(_target: GLenum, _renderbuffer: GLuint) void;
    const glDeleteRenderbuffers = fn(_n: GLsizei, _renderbuffers: [*c]const GLuint) void;
    const glGenRenderbuffers = fn(_n: GLsizei, _renderbuffers: [*c]GLuint) void;
    const glRenderbufferStorage = fn(_target: GLenum, _internalformat: GLenum, _width: GLsizei, _height: GLsizei) void;
    const glGetRenderbufferParameteriv = fn(_target: GLenum, _pname: GLenum, _params: [*c]GLint) void;
    const glIsFramebuffer = fn(_framebuffer: GLuint) GLboolean;
    const glBindFramebuffer = fn(_target: GLenum, _framebuffer: GLuint) void;
    const glDeleteFramebuffers = fn(_n: GLsizei, _framebuffers: [*c]const GLuint) void;
    const glGenFramebuffers = fn(_n: GLsizei, _framebuffers: [*c]GLuint) void;
    const glCheckFramebufferStatus = fn(_target: GLenum) GLenum;
    const glFramebufferTexture1D = fn(_target: GLenum, _attachment: GLenum, _textarget: GLenum, _texture: GLuint, _level: GLint) void;
    const glFramebufferTexture2D = fn(_target: GLenum, _attachment: GLenum, _textarget: GLenum, _texture: GLuint, _level: GLint) void;
    const glFramebufferTexture3D = fn(_target: GLenum, _attachment: GLenum, _textarget: GLenum, _texture: GLuint, _level: GLint, _zoffset: GLint) void;
    const glFramebufferRenderbuffer = fn(_target: GLenum, _attachment: GLenum, _renderbuffertarget: GLenum, _renderbuffer: GLuint) void;
    const glGetFramebufferAttachmentParameteriv = fn(_target: GLenum, _attachment: GLenum, _pname: GLenum, _params: [*c]GLint) void;
    const glGenerateMipmap = fn(_target: GLenum) void;
    const glBlitFramebuffer = fn(_srcX0: GLint, _srcY0: GLint, _srcX1: GLint, _srcY1: GLint, _dstX0: GLint, _dstY0: GLint, _dstX1: GLint, _dstY1: GLint, _mask: GLbitfield, _filter: GLenum) void;
    const glRenderbufferStorageMultisample = fn(_target: GLenum, _samples: GLsizei, _internalformat: GLenum, _width: GLsizei, _height: GLsizei) void;
    const glFramebufferTextureLayer = fn(_target: GLenum, _attachment: GLenum, _texture: GLuint, _level: GLint, _layer: GLint) void;
    const glMapBufferRange = fn(_target: GLenum, _offset: GLintptr, _length: GLsizeiptr, _access: GLbitfield) ?*anyopaque;
    const glFlushMappedBufferRange = fn(_target: GLenum, _offset: GLintptr, _length: GLsizeiptr) void;
    const glBindVertexArray = fn(_array: GLuint) void;
    const glDeleteVertexArrays = fn(_n: GLsizei, _arrays: [*c]const GLuint) void;
    const glGenVertexArrays = fn(_n: GLsizei, _arrays: [*c]GLuint) void;
    const glIsVertexArray = fn(_array: GLuint) GLboolean;
    const glDrawArraysInstanced = fn(_mode: GLenum, _first: GLint, _count: GLsizei, _instancecount: GLsizei) void;
    const glDrawElementsInstanced = fn(_mode: GLenum, _count: GLsizei, _type: GLenum, _indices: ?*const anyopaque, _instancecount: GLsizei) void;
    const glTexBuffer = fn(_target: GLenum, _internalformat: GLenum, _buffer: GLuint) void;
    const glPrimitiveRestartIndex = fn(_index: GLuint) void;
    const glCopyBufferSubData = fn(_readTarget: GLenum, _writeTarget: GLenum, _readOffset: GLintptr, _writeOffset: GLintptr, _size: GLsizeiptr) void;
    const glGetUniformIndices = fn(_program: GLuint, _uniformCount: GLsizei, _uniformNames: *[:0]const GLchar, _uniformIndices: [*c]GLuint) void;
    const glGetActiveUniformsiv = fn(_program: GLuint, _uniformCount: GLsizei, _uniformIndices: [*c]const GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glGetActiveUniformName = fn(_program: GLuint, _uniformIndex: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _uniformName: [*c]GLchar) void;
    const glGetUniformBlockIndex = fn(_program: GLuint, _uniformBlockName: [*c]const GLchar) GLuint;
    const glGetActiveUniformBlockiv = fn(_program: GLuint, _uniformBlockIndex: GLuint, _pname: GLenum, _params: [*c]GLint) void;
    const glGetActiveUniformBlockName = fn(_program: GLuint, _uniformBlockIndex: GLuint, _bufSize: GLsizei, _length: [*c]GLsizei, _uniformBlockName: [*c]GLchar) void;
    const glUniformBlockBinding = fn(_program: GLuint, _uniformBlockIndex: GLuint, _uniformBlockBinding: GLuint) void;
};

const function_pointers = struct {
    var glGetDoublei_v: ?function_signatures.glGetDoublei_v = null;
    var glGetFloati_v: ?function_signatures.glGetFloati_v = null;
    var glDepthRangeIndexed: ?function_signatures.glDepthRangeIndexed = null;
    var glDepthRangeArrayv: ?function_signatures.glDepthRangeArrayv = null;
    var glScissorIndexedv: ?function_signatures.glScissorIndexedv = null;
    var glScissorIndexed: ?function_signatures.glScissorIndexed = null;
    var glScissorArrayv: ?function_signatures.glScissorArrayv = null;
    var glViewportIndexedfv: ?function_signatures.glViewportIndexedfv = null;
    var glViewportIndexedf: ?function_signatures.glViewportIndexedf = null;
    var glViewportArrayv: ?function_signatures.glViewportArrayv = null;
    var glGetVertexAttribLdv: ?function_signatures.glGetVertexAttribLdv = null;
    var glVertexAttribLPointer: ?function_signatures.glVertexAttribLPointer = null;
    var glVertexAttribL4dv: ?function_signatures.glVertexAttribL4dv = null;
    var glVertexAttribL3dv: ?function_signatures.glVertexAttribL3dv = null;
    var glVertexAttribL2dv: ?function_signatures.glVertexAttribL2dv = null;
    var glVertexAttribL1dv: ?function_signatures.glVertexAttribL1dv = null;
    var glVertexAttribL4d: ?function_signatures.glVertexAttribL4d = null;
    var glVertexAttribL3d: ?function_signatures.glVertexAttribL3d = null;
    var glVertexAttribL2d: ?function_signatures.glVertexAttribL2d = null;
    var glVertexAttribL1d: ?function_signatures.glVertexAttribL1d = null;
    var glValidateProgramPipeline: ?function_signatures.glValidateProgramPipeline = null;
    var glProgramUniformMatrix4x3dv: ?function_signatures.glProgramUniformMatrix4x3dv = null;
    var glProgramUniformMatrix3x4dv: ?function_signatures.glProgramUniformMatrix3x4dv = null;
    var glProgramUniformMatrix4x2dv: ?function_signatures.glProgramUniformMatrix4x2dv = null;
    var glProgramUniformMatrix2x4dv: ?function_signatures.glProgramUniformMatrix2x4dv = null;
    var glProgramUniformMatrix3x2dv: ?function_signatures.glProgramUniformMatrix3x2dv = null;
    var glProgramUniformMatrix2x3dv: ?function_signatures.glProgramUniformMatrix2x3dv = null;
    var glProgramUniformMatrix4x3fv: ?function_signatures.glProgramUniformMatrix4x3fv = null;
    var glProgramUniformMatrix3x4fv: ?function_signatures.glProgramUniformMatrix3x4fv = null;
    var glProgramUniformMatrix4x2fv: ?function_signatures.glProgramUniformMatrix4x2fv = null;
    var glProgramUniformMatrix2x4fv: ?function_signatures.glProgramUniformMatrix2x4fv = null;
    var glProgramUniformMatrix3x2fv: ?function_signatures.glProgramUniformMatrix3x2fv = null;
    var glProgramUniformMatrix2x3fv: ?function_signatures.glProgramUniformMatrix2x3fv = null;
    var glProgramUniformMatrix4dv: ?function_signatures.glProgramUniformMatrix4dv = null;
    var glProgramUniformMatrix3dv: ?function_signatures.glProgramUniformMatrix3dv = null;
    var glProgramUniformMatrix2dv: ?function_signatures.glProgramUniformMatrix2dv = null;
    var glProgramUniformMatrix4fv: ?function_signatures.glProgramUniformMatrix4fv = null;
    var glProgramUniformMatrix3fv: ?function_signatures.glProgramUniformMatrix3fv = null;
    var glProgramUniformMatrix2fv: ?function_signatures.glProgramUniformMatrix2fv = null;
    var glProgramUniform4uiv: ?function_signatures.glProgramUniform4uiv = null;
    var glProgramUniform4ui: ?function_signatures.glProgramUniform4ui = null;
    var glProgramUniform4dv: ?function_signatures.glProgramUniform4dv = null;
    var glProgramUniform4d: ?function_signatures.glProgramUniform4d = null;
    var glProgramUniform4fv: ?function_signatures.glProgramUniform4fv = null;
    var glProgramUniform4f: ?function_signatures.glProgramUniform4f = null;
    var glProgramUniform4iv: ?function_signatures.glProgramUniform4iv = null;
    var glProgramUniform4i: ?function_signatures.glProgramUniform4i = null;
    var glProgramUniform3uiv: ?function_signatures.glProgramUniform3uiv = null;
    var glProgramUniform3ui: ?function_signatures.glProgramUniform3ui = null;
    var glProgramUniform3dv: ?function_signatures.glProgramUniform3dv = null;
    var glProgramUniform3d: ?function_signatures.glProgramUniform3d = null;
    var glProgramUniform3fv: ?function_signatures.glProgramUniform3fv = null;
    var glProgramUniform3f: ?function_signatures.glProgramUniform3f = null;
    var glProgramUniform3iv: ?function_signatures.glProgramUniform3iv = null;
    var glProgramUniform3i: ?function_signatures.glProgramUniform3i = null;
    var glUseProgramStages: ?function_signatures.glUseProgramStages = null;
    var glProgramParameteri: ?function_signatures.glProgramParameteri = null;
    var glGetShaderPrecisionFormat: ?function_signatures.glGetShaderPrecisionFormat = null;
    var glShaderBinary: ?function_signatures.glShaderBinary = null;
    var glReleaseShaderCompiler: ?function_signatures.glReleaseShaderCompiler = null;
    var glGetQueryIndexediv: ?function_signatures.glGetQueryIndexediv = null;
    var glEndQueryIndexed: ?function_signatures.glEndQueryIndexed = null;
    var glBeginQueryIndexed: ?function_signatures.glBeginQueryIndexed = null;
    var glDrawTransformFeedbackStream: ?function_signatures.glDrawTransformFeedbackStream = null;
    var glDrawTransformFeedback: ?function_signatures.glDrawTransformFeedback = null;
    var glResumeTransformFeedback: ?function_signatures.glResumeTransformFeedback = null;
    var glPauseTransformFeedback: ?function_signatures.glPauseTransformFeedback = null;
    var glGetProgramStageiv: ?function_signatures.glGetProgramStageiv = null;
    var glGetUniformSubroutineuiv: ?function_signatures.glGetUniformSubroutineuiv = null;
    var glUniformSubroutinesuiv: ?function_signatures.glUniformSubroutinesuiv = null;
    var glGetActiveSubroutineName: ?function_signatures.glGetActiveSubroutineName = null;
    var glCullFace: ?function_signatures.glCullFace = null;
    var glFrontFace: ?function_signatures.glFrontFace = null;
    var glHint: ?function_signatures.glHint = null;
    var glLineWidth: ?function_signatures.glLineWidth = null;
    var glPointSize: ?function_signatures.glPointSize = null;
    var glPolygonMode: ?function_signatures.glPolygonMode = null;
    var glScissor: ?function_signatures.glScissor = null;
    var glTexParameterf: ?function_signatures.glTexParameterf = null;
    var glTexParameterfv: ?function_signatures.glTexParameterfv = null;
    var glTexParameteri: ?function_signatures.glTexParameteri = null;
    var glTexParameteriv: ?function_signatures.glTexParameteriv = null;
    var glTexImage1D: ?function_signatures.glTexImage1D = null;
    var glTexImage2D: ?function_signatures.glTexImage2D = null;
    var glDrawBuffer: ?function_signatures.glDrawBuffer = null;
    var glClear: ?function_signatures.glClear = null;
    var glClearColor: ?function_signatures.glClearColor = null;
    var glClearStencil: ?function_signatures.glClearStencil = null;
    var glClearDepth: ?function_signatures.glClearDepth = null;
    var glStencilMask: ?function_signatures.glStencilMask = null;
    var glColorMask: ?function_signatures.glColorMask = null;
    var glDepthMask: ?function_signatures.glDepthMask = null;
    var glDisable: ?function_signatures.glDisable = null;
    var glEnable: ?function_signatures.glEnable = null;
    var glFinish: ?function_signatures.glFinish = null;
    var glFlush: ?function_signatures.glFlush = null;
    var glBlendFunc: ?function_signatures.glBlendFunc = null;
    var glLogicOp: ?function_signatures.glLogicOp = null;
    var glStencilFunc: ?function_signatures.glStencilFunc = null;
    var glStencilOp: ?function_signatures.glStencilOp = null;
    var glDepthFunc: ?function_signatures.glDepthFunc = null;
    var glPixelStoref: ?function_signatures.glPixelStoref = null;
    var glPixelStorei: ?function_signatures.glPixelStorei = null;
    var glReadBuffer: ?function_signatures.glReadBuffer = null;
    var glReadPixels: ?function_signatures.glReadPixels = null;
    var glGetBooleanv: ?function_signatures.glGetBooleanv = null;
    var glGetDoublev: ?function_signatures.glGetDoublev = null;
    var glGetError: ?function_signatures.glGetError = null;
    var glGetFloatv: ?function_signatures.glGetFloatv = null;
    var glGetIntegerv: ?function_signatures.glGetIntegerv = null;
    var glGetString: ?function_signatures.glGetString = null;
    var glGetTexImage: ?function_signatures.glGetTexImage = null;
    var glGetTexParameterfv: ?function_signatures.glGetTexParameterfv = null;
    var glGetTexParameteriv: ?function_signatures.glGetTexParameteriv = null;
    var glGetTexLevelParameterfv: ?function_signatures.glGetTexLevelParameterfv = null;
    var glGetTexLevelParameteriv: ?function_signatures.glGetTexLevelParameteriv = null;
    var glIsEnabled: ?function_signatures.glIsEnabled = null;
    var glDepthRange: ?function_signatures.glDepthRange = null;
    var glViewport: ?function_signatures.glViewport = null;
    var glGetProgramPipelineInfoLog: ?function_signatures.glGetProgramPipelineInfoLog = null;
    var glProgramUniform2uiv: ?function_signatures.glProgramUniform2uiv = null;
    var glProgramUniform2ui: ?function_signatures.glProgramUniform2ui = null;
    var glProgramUniform2dv: ?function_signatures.glProgramUniform2dv = null;
    var glProgramUniform2d: ?function_signatures.glProgramUniform2d = null;
    var glProgramUniform2fv: ?function_signatures.glProgramUniform2fv = null;
    var glProgramUniform2f: ?function_signatures.glProgramUniform2f = null;
    var glProgramUniform2iv: ?function_signatures.glProgramUniform2iv = null;
    var glProgramUniform2i: ?function_signatures.glProgramUniform2i = null;
    var glProgramUniform1uiv: ?function_signatures.glProgramUniform1uiv = null;
    var glProgramUniform1ui: ?function_signatures.glProgramUniform1ui = null;
    var glProgramUniform1dv: ?function_signatures.glProgramUniform1dv = null;
    var glProgramUniform1d: ?function_signatures.glProgramUniform1d = null;
    var glProgramUniform1fv: ?function_signatures.glProgramUniform1fv = null;
    var glProgramUniform1f: ?function_signatures.glProgramUniform1f = null;
    var glProgramUniform1iv: ?function_signatures.glProgramUniform1iv = null;
    var glProgramUniform1i: ?function_signatures.glProgramUniform1i = null;
    var glGetProgramPipelineiv: ?function_signatures.glGetProgramPipelineiv = null;
    var glIsProgramPipeline: ?function_signatures.glIsProgramPipeline = null;
    var glGenProgramPipelines: ?function_signatures.glGenProgramPipelines = null;
    var glDeleteProgramPipelines: ?function_signatures.glDeleteProgramPipelines = null;
    var glBindProgramPipeline: ?function_signatures.glBindProgramPipeline = null;
    var glCreateShaderProgramv: ?function_signatures.glCreateShaderProgramv = null;
    var glActiveShaderProgram: ?function_signatures.glActiveShaderProgram = null;
    var glProgramBinary: ?function_signatures.glProgramBinary = null;
    var glGetProgramBinary: ?function_signatures.glGetProgramBinary = null;
    var glClearDepthf: ?function_signatures.glClearDepthf = null;
    var glDepthRangef: ?function_signatures.glDepthRangef = null;
    var glIsTransformFeedback: ?function_signatures.glIsTransformFeedback = null;
    var glGenTransformFeedbacks: ?function_signatures.glGenTransformFeedbacks = null;
    var glDeleteTransformFeedbacks: ?function_signatures.glDeleteTransformFeedbacks = null;
    var glBindTransformFeedback: ?function_signatures.glBindTransformFeedback = null;
    var glPatchParameterfv: ?function_signatures.glPatchParameterfv = null;
    var glPatchParameteri: ?function_signatures.glPatchParameteri = null;
    var glDrawArrays: ?function_signatures.glDrawArrays = null;
    var glDrawElements: ?function_signatures.glDrawElements = null;
    var glPolygonOffset: ?function_signatures.glPolygonOffset = null;
    var glCopyTexImage1D: ?function_signatures.glCopyTexImage1D = null;
    var glCopyTexImage2D: ?function_signatures.glCopyTexImage2D = null;
    var glCopyTexSubImage1D: ?function_signatures.glCopyTexSubImage1D = null;
    var glCopyTexSubImage2D: ?function_signatures.glCopyTexSubImage2D = null;
    var glTexSubImage1D: ?function_signatures.glTexSubImage1D = null;
    var glTexSubImage2D: ?function_signatures.glTexSubImage2D = null;
    var glBindTexture: ?function_signatures.glBindTexture = null;
    var glDeleteTextures: ?function_signatures.glDeleteTextures = null;
    var glGenTextures: ?function_signatures.glGenTextures = null;
    var glIsTexture: ?function_signatures.glIsTexture = null;
    var glGetActiveSubroutineUniformName: ?function_signatures.glGetActiveSubroutineUniformName = null;
    var glGetActiveSubroutineUniformiv: ?function_signatures.glGetActiveSubroutineUniformiv = null;
    var glGetSubroutineIndex: ?function_signatures.glGetSubroutineIndex = null;
    var glGetSubroutineUniformLocation: ?function_signatures.glGetSubroutineUniformLocation = null;
    var glGetUniformdv: ?function_signatures.glGetUniformdv = null;
    var glUniformMatrix4x3dv: ?function_signatures.glUniformMatrix4x3dv = null;
    var glUniformMatrix4x2dv: ?function_signatures.glUniformMatrix4x2dv = null;
    var glUniformMatrix3x4dv: ?function_signatures.glUniformMatrix3x4dv = null;
    var glUniformMatrix3x2dv: ?function_signatures.glUniformMatrix3x2dv = null;
    var glUniformMatrix2x4dv: ?function_signatures.glUniformMatrix2x4dv = null;
    var glUniformMatrix2x3dv: ?function_signatures.glUniformMatrix2x3dv = null;
    var glUniformMatrix4dv: ?function_signatures.glUniformMatrix4dv = null;
    var glUniformMatrix3dv: ?function_signatures.glUniformMatrix3dv = null;
    var glDrawRangeElements: ?function_signatures.glDrawRangeElements = null;
    var glTexImage3D: ?function_signatures.glTexImage3D = null;
    var glTexSubImage3D: ?function_signatures.glTexSubImage3D = null;
    var glCopyTexSubImage3D: ?function_signatures.glCopyTexSubImage3D = null;
    var glUniformMatrix2dv: ?function_signatures.glUniformMatrix2dv = null;
    var glUniform4dv: ?function_signatures.glUniform4dv = null;
    var glUniform3dv: ?function_signatures.glUniform3dv = null;
    var glUniform2dv: ?function_signatures.glUniform2dv = null;
    var glUniform1dv: ?function_signatures.glUniform1dv = null;
    var glUniform4d: ?function_signatures.glUniform4d = null;
    var glUniform3d: ?function_signatures.glUniform3d = null;
    var glUniform2d: ?function_signatures.glUniform2d = null;
    var glUniform1d: ?function_signatures.glUniform1d = null;
    var glDrawElementsIndirect: ?function_signatures.glDrawElementsIndirect = null;
    var glDrawArraysIndirect: ?function_signatures.glDrawArraysIndirect = null;
    var glBlendFuncSeparatei: ?function_signatures.glBlendFuncSeparatei = null;
    var glBlendFunci: ?function_signatures.glBlendFunci = null;
    var glBlendEquationSeparatei: ?function_signatures.glBlendEquationSeparatei = null;
    var glBlendEquationi: ?function_signatures.glBlendEquationi = null;
    var glMinSampleShading: ?function_signatures.glMinSampleShading = null;
    var glActiveTexture: ?function_signatures.glActiveTexture = null;
    var glSampleCoverage: ?function_signatures.glSampleCoverage = null;
    var glCompressedTexImage3D: ?function_signatures.glCompressedTexImage3D = null;
    var glCompressedTexImage2D: ?function_signatures.glCompressedTexImage2D = null;
    var glCompressedTexImage1D: ?function_signatures.glCompressedTexImage1D = null;
    var glCompressedTexSubImage3D: ?function_signatures.glCompressedTexSubImage3D = null;
    var glCompressedTexSubImage2D: ?function_signatures.glCompressedTexSubImage2D = null;
    var glCompressedTexSubImage1D: ?function_signatures.glCompressedTexSubImage1D = null;
    var glGetCompressedTexImage: ?function_signatures.glGetCompressedTexImage = null;
    var glVertexAttribP4uiv: ?function_signatures.glVertexAttribP4uiv = null;
    var glVertexAttribP4ui: ?function_signatures.glVertexAttribP4ui = null;
    var glVertexAttribP3uiv: ?function_signatures.glVertexAttribP3uiv = null;
    var glVertexAttribP3ui: ?function_signatures.glVertexAttribP3ui = null;
    var glVertexAttribP2uiv: ?function_signatures.glVertexAttribP2uiv = null;
    var glVertexAttribP2ui: ?function_signatures.glVertexAttribP2ui = null;
    var glVertexAttribP1uiv: ?function_signatures.glVertexAttribP1uiv = null;
    var glVertexAttribP1ui: ?function_signatures.glVertexAttribP1ui = null;
    var glVertexAttribDivisor: ?function_signatures.glVertexAttribDivisor = null;
    var glGetQueryObjectui64v: ?function_signatures.glGetQueryObjectui64v = null;
    var glGetQueryObjecti64v: ?function_signatures.glGetQueryObjecti64v = null;
    var glQueryCounter: ?function_signatures.glQueryCounter = null;
    var glGetSamplerParameterIuiv: ?function_signatures.glGetSamplerParameterIuiv = null;
    var glGetSamplerParameterfv: ?function_signatures.glGetSamplerParameterfv = null;
    var glGetSamplerParameterIiv: ?function_signatures.glGetSamplerParameterIiv = null;
    var glGetSamplerParameteriv: ?function_signatures.glGetSamplerParameteriv = null;
    var glSamplerParameterIuiv: ?function_signatures.glSamplerParameterIuiv = null;
    var glSamplerParameterIiv: ?function_signatures.glSamplerParameterIiv = null;
    var glSamplerParameterfv: ?function_signatures.glSamplerParameterfv = null;
    var glSamplerParameterf: ?function_signatures.glSamplerParameterf = null;
    var glSamplerParameteriv: ?function_signatures.glSamplerParameteriv = null;
    var glSamplerParameteri: ?function_signatures.glSamplerParameteri = null;
    var glBindSampler: ?function_signatures.glBindSampler = null;
    var glIsSampler: ?function_signatures.glIsSampler = null;
    var glDeleteSamplers: ?function_signatures.glDeleteSamplers = null;
    var glGenSamplers: ?function_signatures.glGenSamplers = null;
    var glGetFragDataIndex: ?function_signatures.glGetFragDataIndex = null;
    var glBindFragDataLocationIndexed: ?function_signatures.glBindFragDataLocationIndexed = null;
    var glSampleMaski: ?function_signatures.glSampleMaski = null;
    var glGetMultisamplefv: ?function_signatures.glGetMultisamplefv = null;
    var glTexImage3DMultisample: ?function_signatures.glTexImage3DMultisample = null;
    var glTexImage2DMultisample: ?function_signatures.glTexImage2DMultisample = null;
    var glFramebufferTexture: ?function_signatures.glFramebufferTexture = null;
    var glGetBufferParameteri64v: ?function_signatures.glGetBufferParameteri64v = null;
    var glBlendFuncSeparate: ?function_signatures.glBlendFuncSeparate = null;
    var glMultiDrawArrays: ?function_signatures.glMultiDrawArrays = null;
    var glMultiDrawElements: ?function_signatures.glMultiDrawElements = null;
    var glPointParameterf: ?function_signatures.glPointParameterf = null;
    var glPointParameterfv: ?function_signatures.glPointParameterfv = null;
    var glPointParameteri: ?function_signatures.glPointParameteri = null;
    var glPointParameteriv: ?function_signatures.glPointParameteriv = null;
    var glGetInteger64i_v: ?function_signatures.glGetInteger64i_v = null;
    var glGetSynciv: ?function_signatures.glGetSynciv = null;
    var glGetInteger64v: ?function_signatures.glGetInteger64v = null;
    var glWaitSync: ?function_signatures.glWaitSync = null;
    var glClientWaitSync: ?function_signatures.glClientWaitSync = null;
    var glDeleteSync: ?function_signatures.glDeleteSync = null;
    var glIsSync: ?function_signatures.glIsSync = null;
    var glFenceSync: ?function_signatures.glFenceSync = null;
    var glBlendColor: ?function_signatures.glBlendColor = null;
    var glBlendEquation: ?function_signatures.glBlendEquation = null;
    var glProvokingVertex: ?function_signatures.glProvokingVertex = null;
    var glMultiDrawElementsBaseVertex: ?function_signatures.glMultiDrawElementsBaseVertex = null;
    var glDrawElementsInstancedBaseVertex: ?function_signatures.glDrawElementsInstancedBaseVertex = null;
    var glDrawRangeElementsBaseVertex: ?function_signatures.glDrawRangeElementsBaseVertex = null;
    var glDrawElementsBaseVertex: ?function_signatures.glDrawElementsBaseVertex = null;
    var glGenQueries: ?function_signatures.glGenQueries = null;
    var glDeleteQueries: ?function_signatures.glDeleteQueries = null;
    var glIsQuery: ?function_signatures.glIsQuery = null;
    var glBeginQuery: ?function_signatures.glBeginQuery = null;
    var glEndQuery: ?function_signatures.glEndQuery = null;
    var glGetQueryiv: ?function_signatures.glGetQueryiv = null;
    var glGetQueryObjectiv: ?function_signatures.glGetQueryObjectiv = null;
    var glGetQueryObjectuiv: ?function_signatures.glGetQueryObjectuiv = null;
    var glBindBuffer: ?function_signatures.glBindBuffer = null;
    var glDeleteBuffers: ?function_signatures.glDeleteBuffers = null;
    var glGenBuffers: ?function_signatures.glGenBuffers = null;
    var glIsBuffer: ?function_signatures.glIsBuffer = null;
    var glBufferData: ?function_signatures.glBufferData = null;
    var glBufferSubData: ?function_signatures.glBufferSubData = null;
    var glGetBufferSubData: ?function_signatures.glGetBufferSubData = null;
    var glMapBuffer: ?function_signatures.glMapBuffer = null;
    var glUnmapBuffer: ?function_signatures.glUnmapBuffer = null;
    var glGetBufferParameteriv: ?function_signatures.glGetBufferParameteriv = null;
    var glGetBufferPointerv: ?function_signatures.glGetBufferPointerv = null;
    var glBlendEquationSeparate: ?function_signatures.glBlendEquationSeparate = null;
    var glDrawBuffers: ?function_signatures.glDrawBuffers = null;
    var glStencilOpSeparate: ?function_signatures.glStencilOpSeparate = null;
    var glStencilFuncSeparate: ?function_signatures.glStencilFuncSeparate = null;
    var glStencilMaskSeparate: ?function_signatures.glStencilMaskSeparate = null;
    var glAttachShader: ?function_signatures.glAttachShader = null;
    var glBindAttribLocation: ?function_signatures.glBindAttribLocation = null;
    var glCompileShader: ?function_signatures.glCompileShader = null;
    var glCreateProgram: ?function_signatures.glCreateProgram = null;
    var glCreateShader: ?function_signatures.glCreateShader = null;
    var glDeleteProgram: ?function_signatures.glDeleteProgram = null;
    var glDeleteShader: ?function_signatures.glDeleteShader = null;
    var glDetachShader: ?function_signatures.glDetachShader = null;
    var glDisableVertexAttribArray: ?function_signatures.glDisableVertexAttribArray = null;
    var glEnableVertexAttribArray: ?function_signatures.glEnableVertexAttribArray = null;
    var glGetActiveAttrib: ?function_signatures.glGetActiveAttrib = null;
    var glGetActiveUniform: ?function_signatures.glGetActiveUniform = null;
    var glGetAttachedShaders: ?function_signatures.glGetAttachedShaders = null;
    var glGetAttribLocation: ?function_signatures.glGetAttribLocation = null;
    var glGetProgramiv: ?function_signatures.glGetProgramiv = null;
    var glGetProgramInfoLog: ?function_signatures.glGetProgramInfoLog = null;
    var glGetShaderiv: ?function_signatures.glGetShaderiv = null;
    var glGetShaderInfoLog: ?function_signatures.glGetShaderInfoLog = null;
    var glGetShaderSource: ?function_signatures.glGetShaderSource = null;
    var glGetUniformLocation: ?function_signatures.glGetUniformLocation = null;
    var glGetUniformfv: ?function_signatures.glGetUniformfv = null;
    var glGetUniformiv: ?function_signatures.glGetUniformiv = null;
    var glGetVertexAttribdv: ?function_signatures.glGetVertexAttribdv = null;
    var glGetVertexAttribfv: ?function_signatures.glGetVertexAttribfv = null;
    var glGetVertexAttribiv: ?function_signatures.glGetVertexAttribiv = null;
    var glGetVertexAttribPointerv: ?function_signatures.glGetVertexAttribPointerv = null;
    var glIsProgram: ?function_signatures.glIsProgram = null;
    var glIsShader: ?function_signatures.glIsShader = null;
    var glLinkProgram: ?function_signatures.glLinkProgram = null;
    var glShaderSource: ?function_signatures.glShaderSource = null;
    var glUseProgram: ?function_signatures.glUseProgram = null;
    var glUniform1f: ?function_signatures.glUniform1f = null;
    var glUniform2f: ?function_signatures.glUniform2f = null;
    var glUniform3f: ?function_signatures.glUniform3f = null;
    var glUniform4f: ?function_signatures.glUniform4f = null;
    var glUniform1i: ?function_signatures.glUniform1i = null;
    var glUniform2i: ?function_signatures.glUniform2i = null;
    var glUniform3i: ?function_signatures.glUniform3i = null;
    var glUniform4i: ?function_signatures.glUniform4i = null;
    var glUniform1fv: ?function_signatures.glUniform1fv = null;
    var glUniform2fv: ?function_signatures.glUniform2fv = null;
    var glUniform3fv: ?function_signatures.glUniform3fv = null;
    var glUniform4fv: ?function_signatures.glUniform4fv = null;
    var glUniform1iv: ?function_signatures.glUniform1iv = null;
    var glUniform2iv: ?function_signatures.glUniform2iv = null;
    var glUniform3iv: ?function_signatures.glUniform3iv = null;
    var glUniform4iv: ?function_signatures.glUniform4iv = null;
    var glUniformMatrix2fv: ?function_signatures.glUniformMatrix2fv = null;
    var glUniformMatrix3fv: ?function_signatures.glUniformMatrix3fv = null;
    var glUniformMatrix4fv: ?function_signatures.glUniformMatrix4fv = null;
    var glValidateProgram: ?function_signatures.glValidateProgram = null;
    var glVertexAttrib1d: ?function_signatures.glVertexAttrib1d = null;
    var glVertexAttrib1dv: ?function_signatures.glVertexAttrib1dv = null;
    var glVertexAttrib1f: ?function_signatures.glVertexAttrib1f = null;
    var glVertexAttrib1fv: ?function_signatures.glVertexAttrib1fv = null;
    var glVertexAttrib1s: ?function_signatures.glVertexAttrib1s = null;
    var glVertexAttrib1sv: ?function_signatures.glVertexAttrib1sv = null;
    var glVertexAttrib2d: ?function_signatures.glVertexAttrib2d = null;
    var glVertexAttrib2dv: ?function_signatures.glVertexAttrib2dv = null;
    var glVertexAttrib2f: ?function_signatures.glVertexAttrib2f = null;
    var glVertexAttrib2fv: ?function_signatures.glVertexAttrib2fv = null;
    var glVertexAttrib2s: ?function_signatures.glVertexAttrib2s = null;
    var glVertexAttrib2sv: ?function_signatures.glVertexAttrib2sv = null;
    var glVertexAttrib3d: ?function_signatures.glVertexAttrib3d = null;
    var glVertexAttrib3dv: ?function_signatures.glVertexAttrib3dv = null;
    var glVertexAttrib3f: ?function_signatures.glVertexAttrib3f = null;
    var glVertexAttrib3fv: ?function_signatures.glVertexAttrib3fv = null;
    var glVertexAttrib3s: ?function_signatures.glVertexAttrib3s = null;
    var glVertexAttrib3sv: ?function_signatures.glVertexAttrib3sv = null;
    var glVertexAttrib4Nbv: ?function_signatures.glVertexAttrib4Nbv = null;
    var glVertexAttrib4Niv: ?function_signatures.glVertexAttrib4Niv = null;
    var glVertexAttrib4Nsv: ?function_signatures.glVertexAttrib4Nsv = null;
    var glVertexAttrib4Nub: ?function_signatures.glVertexAttrib4Nub = null;
    var glVertexAttrib4Nubv: ?function_signatures.glVertexAttrib4Nubv = null;
    var glVertexAttrib4Nuiv: ?function_signatures.glVertexAttrib4Nuiv = null;
    var glVertexAttrib4Nusv: ?function_signatures.glVertexAttrib4Nusv = null;
    var glVertexAttrib4bv: ?function_signatures.glVertexAttrib4bv = null;
    var glVertexAttrib4d: ?function_signatures.glVertexAttrib4d = null;
    var glVertexAttrib4dv: ?function_signatures.glVertexAttrib4dv = null;
    var glVertexAttrib4f: ?function_signatures.glVertexAttrib4f = null;
    var glVertexAttrib4fv: ?function_signatures.glVertexAttrib4fv = null;
    var glVertexAttrib4iv: ?function_signatures.glVertexAttrib4iv = null;
    var glVertexAttrib4s: ?function_signatures.glVertexAttrib4s = null;
    var glVertexAttrib4sv: ?function_signatures.glVertexAttrib4sv = null;
    var glVertexAttrib4ubv: ?function_signatures.glVertexAttrib4ubv = null;
    var glVertexAttrib4uiv: ?function_signatures.glVertexAttrib4uiv = null;
    var glVertexAttrib4usv: ?function_signatures.glVertexAttrib4usv = null;
    var glVertexAttribPointer: ?function_signatures.glVertexAttribPointer = null;
    var glUniformMatrix2x3fv: ?function_signatures.glUniformMatrix2x3fv = null;
    var glUniformMatrix3x2fv: ?function_signatures.glUniformMatrix3x2fv = null;
    var glUniformMatrix2x4fv: ?function_signatures.glUniformMatrix2x4fv = null;
    var glUniformMatrix4x2fv: ?function_signatures.glUniformMatrix4x2fv = null;
    var glUniformMatrix3x4fv: ?function_signatures.glUniformMatrix3x4fv = null;
    var glUniformMatrix4x3fv: ?function_signatures.glUniformMatrix4x3fv = null;
    var glColorMaski: ?function_signatures.glColorMaski = null;
    var glGetBooleani_v: ?function_signatures.glGetBooleani_v = null;
    var glGetIntegeri_v: ?function_signatures.glGetIntegeri_v = null;
    var glEnablei: ?function_signatures.glEnablei = null;
    var glDisablei: ?function_signatures.glDisablei = null;
    var glIsEnabledi: ?function_signatures.glIsEnabledi = null;
    var glBeginTransformFeedback: ?function_signatures.glBeginTransformFeedback = null;
    var glEndTransformFeedback: ?function_signatures.glEndTransformFeedback = null;
    var glBindBufferRange: ?function_signatures.glBindBufferRange = null;
    var glBindBufferBase: ?function_signatures.glBindBufferBase = null;
    var glTransformFeedbackVaryings: ?function_signatures.glTransformFeedbackVaryings = null;
    var glGetTransformFeedbackVarying: ?function_signatures.glGetTransformFeedbackVarying = null;
    var glClampColor: ?function_signatures.glClampColor = null;
    var glBeginConditionalRender: ?function_signatures.glBeginConditionalRender = null;
    var glEndConditionalRender: ?function_signatures.glEndConditionalRender = null;
    var glVertexAttribIPointer: ?function_signatures.glVertexAttribIPointer = null;
    var glGetVertexAttribIiv: ?function_signatures.glGetVertexAttribIiv = null;
    var glGetVertexAttribIuiv: ?function_signatures.glGetVertexAttribIuiv = null;
    var glVertexAttribI1i: ?function_signatures.glVertexAttribI1i = null;
    var glVertexAttribI2i: ?function_signatures.glVertexAttribI2i = null;
    var glVertexAttribI3i: ?function_signatures.glVertexAttribI3i = null;
    var glVertexAttribI4i: ?function_signatures.glVertexAttribI4i = null;
    var glVertexAttribI1ui: ?function_signatures.glVertexAttribI1ui = null;
    var glVertexAttribI2ui: ?function_signatures.glVertexAttribI2ui = null;
    var glVertexAttribI3ui: ?function_signatures.glVertexAttribI3ui = null;
    var glVertexAttribI4ui: ?function_signatures.glVertexAttribI4ui = null;
    var glVertexAttribI1iv: ?function_signatures.glVertexAttribI1iv = null;
    var glVertexAttribI2iv: ?function_signatures.glVertexAttribI2iv = null;
    var glVertexAttribI3iv: ?function_signatures.glVertexAttribI3iv = null;
    var glVertexAttribI4iv: ?function_signatures.glVertexAttribI4iv = null;
    var glVertexAttribI1uiv: ?function_signatures.glVertexAttribI1uiv = null;
    var glVertexAttribI2uiv: ?function_signatures.glVertexAttribI2uiv = null;
    var glVertexAttribI3uiv: ?function_signatures.glVertexAttribI3uiv = null;
    var glVertexAttribI4uiv: ?function_signatures.glVertexAttribI4uiv = null;
    var glVertexAttribI4bv: ?function_signatures.glVertexAttribI4bv = null;
    var glVertexAttribI4sv: ?function_signatures.glVertexAttribI4sv = null;
    var glVertexAttribI4ubv: ?function_signatures.glVertexAttribI4ubv = null;
    var glVertexAttribI4usv: ?function_signatures.glVertexAttribI4usv = null;
    var glGetUniformuiv: ?function_signatures.glGetUniformuiv = null;
    var glBindFragDataLocation: ?function_signatures.glBindFragDataLocation = null;
    var glGetFragDataLocation: ?function_signatures.glGetFragDataLocation = null;
    var glUniform1ui: ?function_signatures.glUniform1ui = null;
    var glUniform2ui: ?function_signatures.glUniform2ui = null;
    var glUniform3ui: ?function_signatures.glUniform3ui = null;
    var glUniform4ui: ?function_signatures.glUniform4ui = null;
    var glUniform1uiv: ?function_signatures.glUniform1uiv = null;
    var glUniform2uiv: ?function_signatures.glUniform2uiv = null;
    var glUniform3uiv: ?function_signatures.glUniform3uiv = null;
    var glUniform4uiv: ?function_signatures.glUniform4uiv = null;
    var glTexParameterIiv: ?function_signatures.glTexParameterIiv = null;
    var glTexParameterIuiv: ?function_signatures.glTexParameterIuiv = null;
    var glGetTexParameterIiv: ?function_signatures.glGetTexParameterIiv = null;
    var glGetTexParameterIuiv: ?function_signatures.glGetTexParameterIuiv = null;
    var glClearBufferiv: ?function_signatures.glClearBufferiv = null;
    var glClearBufferuiv: ?function_signatures.glClearBufferuiv = null;
    var glClearBufferfv: ?function_signatures.glClearBufferfv = null;
    var glClearBufferfi: ?function_signatures.glClearBufferfi = null;
    var glGetStringi: ?function_signatures.glGetStringi = null;
    var glIsRenderbuffer: ?function_signatures.glIsRenderbuffer = null;
    var glBindRenderbuffer: ?function_signatures.glBindRenderbuffer = null;
    var glDeleteRenderbuffers: ?function_signatures.glDeleteRenderbuffers = null;
    var glGenRenderbuffers: ?function_signatures.glGenRenderbuffers = null;
    var glRenderbufferStorage: ?function_signatures.glRenderbufferStorage = null;
    var glGetRenderbufferParameteriv: ?function_signatures.glGetRenderbufferParameteriv = null;
    var glIsFramebuffer: ?function_signatures.glIsFramebuffer = null;
    var glBindFramebuffer: ?function_signatures.glBindFramebuffer = null;
    var glDeleteFramebuffers: ?function_signatures.glDeleteFramebuffers = null;
    var glGenFramebuffers: ?function_signatures.glGenFramebuffers = null;
    var glCheckFramebufferStatus: ?function_signatures.glCheckFramebufferStatus = null;
    var glFramebufferTexture1D: ?function_signatures.glFramebufferTexture1D = null;
    var glFramebufferTexture2D: ?function_signatures.glFramebufferTexture2D = null;
    var glFramebufferTexture3D: ?function_signatures.glFramebufferTexture3D = null;
    var glFramebufferRenderbuffer: ?function_signatures.glFramebufferRenderbuffer = null;
    var glGetFramebufferAttachmentParameteriv: ?function_signatures.glGetFramebufferAttachmentParameteriv = null;
    var glGenerateMipmap: ?function_signatures.glGenerateMipmap = null;
    var glBlitFramebuffer: ?function_signatures.glBlitFramebuffer = null;
    var glRenderbufferStorageMultisample: ?function_signatures.glRenderbufferStorageMultisample = null;
    var glFramebufferTextureLayer: ?function_signatures.glFramebufferTextureLayer = null;
    var glMapBufferRange: ?function_signatures.glMapBufferRange = null;
    var glFlushMappedBufferRange: ?function_signatures.glFlushMappedBufferRange = null;
    var glBindVertexArray: ?function_signatures.glBindVertexArray = null;
    var glDeleteVertexArrays: ?function_signatures.glDeleteVertexArrays = null;
    var glGenVertexArrays: ?function_signatures.glGenVertexArrays = null;
    var glIsVertexArray: ?function_signatures.glIsVertexArray = null;
    var glDrawArraysInstanced: ?function_signatures.glDrawArraysInstanced = null;
    var glDrawElementsInstanced: ?function_signatures.glDrawElementsInstanced = null;
    var glTexBuffer: ?function_signatures.glTexBuffer = null;
    var glPrimitiveRestartIndex: ?function_signatures.glPrimitiveRestartIndex = null;
    var glCopyBufferSubData: ?function_signatures.glCopyBufferSubData = null;
    var glGetUniformIndices: ?function_signatures.glGetUniformIndices = null;
    var glGetActiveUniformsiv: ?function_signatures.glGetActiveUniformsiv = null;
    var glGetActiveUniformName: ?function_signatures.glGetActiveUniformName = null;
    var glGetUniformBlockIndex: ?function_signatures.glGetUniformBlockIndex = null;
    var glGetActiveUniformBlockiv: ?function_signatures.glGetActiveUniformBlockiv = null;
    var glGetActiveUniformBlockName: ?function_signatures.glGetActiveUniformBlockName = null;
    var glUniformBlockBinding: ?function_signatures.glUniformBlockBinding = null;
};

test "test" {
    _ = load;
    @setEvalBranchQuota(100_000); // Yes, this is necessary. OpenGL gets quite large!
    std.testing.refAllDecls(@This());
}
