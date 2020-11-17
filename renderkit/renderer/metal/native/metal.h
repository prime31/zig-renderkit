// this code is all entirely based off of the excellent Sokol by @floooh: https://github.com/floooh/sokol
#pragma once

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#ifndef RK_ASSERT
	#include <assert.h>
	#define RK_ASSERT(c) assert(c)
#endif

#ifndef RK_UNREACHABLE
	#define RK_UNREACHABLE RK_ASSERT(false)
#endif

enum {
    NUM_INFLIGHT_FRAMES = 1,
};

typedef enum TextureFilter_t {
    texture_filter_nearest,
    texture_filter_linear,
} TextureFilter_t;

MTLSamplerMinMagFilter _mtl_minmag_filter(TextureFilter_t f) {
	switch (f) {
		case texture_filter_nearest: return MTLSamplerMinMagFilterNearest;
		case texture_filter_linear: return MTLSamplerMinMagFilterLinear;
		default:
			RK_UNREACHABLE; return (MTLSamplerMinMagFilter)0;
	}
}


typedef enum TextureWrap_t {
    texture_wrap_clamp,
    texture_wrap_repeat,
} TextureWrap_t;

MTLSamplerAddressMode _mtl_address_mode(TextureWrap_t w) {
	switch (w) {
		case texture_wrap_repeat:    return MTLSamplerAddressModeRepeat;
		case texture_wrap_clamp:     return MTLSamplerAddressModeClampToEdge;
		default: RK_UNREACHABLE; return (MTLSamplerAddressMode)0;
	}
}

typedef enum PixelFormat_t {
    pixel_format_rgba,
    pixel_format_stencil,
    pixel_format_depth_stencil,
} PixelFormat_t;

typedef enum Usage_t {
    usage_immutable,
    usage_dynamic,
    usage_stream,
} Usage_t;

MTLResourceOptions _mtl_buffer_resource_options(enum Usage_t usg) {
	switch (usg) {
		case usage_immutable:
			return MTLResourceStorageModeShared;
		case usage_dynamic:
		case usage_stream:
			return MTLCPUCacheModeWriteCombined|MTLResourceStorageModeManaged;
		default:
			RK_UNREACHABLE;
			return 0;
	}
}

typedef enum BufferType_t {
    buffer_type_vertex,
    buffer_type_index,
} BufferType_t;

enum VertexBufferUsage_t {
    vertex_buffer_usage_stream_draw,
    vertex_buffer_usage_static_draw,
    vertex_buffer_usage_dynamic_draw,
};

enum PrimitiveType_t {
    primitive_type_points,
    primitive_type_line_strip,
    primitive_type_lines,
    primitive_type_triangle_strip,
    primitive_type_triangles,
};

enum ElementType_t {
    element_type_u8,
    element_type_u16,
    element_type_u32,
};

enum CompareFunc_t {
    compre_func_never,
    compre_func_less,
    compre_func_equal,
    compre_func_less_equal,
    compre_func_greater,
    compre_func_not_equal,
    compre_func_greater_equal,
    compre_func_always,
};

enum StencilOp_t {
    stencil_op_keep,
    stencil_op_zero,
    stencil_op_replace,
    stencil_op_incr_clamp,
    stencil_op_decr_clamp,
    stencil_op_invert,
    stencil_op_incr_wrap,
    stencil_op_decr_wrap,
};

enum BlendFactor_t {
    blend_zero,
    blend_one,
    blend_src_color,
    blend_one_minus_src_color,
    blend_src_alpha,
    blend_one_minus_src_alpha,
    blend_dst_color,
    blend_one_minus_dst_color,
    blend_dst_alpha,
    blend_one_minus_dst_alpha,
    blend_src_alpha_saturated,
    blend_blend_color,
    blend_one_minus_blend_color,
    blend_blend_alpha,
    blend_one_minus_blend_alpha,
};

enum BlendOp_t {
    blend_op_add,
    blend_op_subtract,
    blend_op_reverse_subtract,
};

enum ClearAction_t {
    clear_action_clear,
    clear_action_dontcare,
    clear_action_load,
};

MTLLoadAction _mtl_load_action(enum ClearAction_t a) {
    switch (a) {
        case clear_action_clear:    return MTLLoadActionClear;
        case clear_action_dontcare: return MTLLoadActionDontCare;
        case clear_action_load:     return MTLLoadActionLoad;
		default: RK_UNREACHABLE; return (MTLLoadAction)0;
    }
}

typedef enum ColorMask_t {
    color_mask_none,
    color_mask_r,
    color_mask_g,
    color_mask_b = 4,
    color_mask_a = 8,
    color_mask_rgb,
    color_mask_rgba = 15,
    color_mask_force_u32 = 2147483647,
} ColorMask_t;

MTLColorWriteMask _mtl_color_write_mask(ColorMask_t m) {
	MTLColorWriteMask mtl_mask = MTLColorWriteMaskNone;
	if (m & color_mask_r) {
		mtl_mask |= MTLColorWriteMaskRed;
	}
	if (m & color_mask_g) {
		mtl_mask |= MTLColorWriteMaskGreen;
	}
	if (m & color_mask_b) {
		mtl_mask |= MTLColorWriteMaskBlue;
	}
	if (m & color_mask_a) {
		mtl_mask |= MTLColorWriteMaskAlpha;
	}
	return mtl_mask;
}

typedef enum VertexStep_t {
	per_vertex,
	per_instance,
} VertexStep_t;

MTLVertexStepFunction _mtl_step_function(VertexStep_t step) {
	switch (step) {
		case per_vertex:      return MTLVertexStepFunctionPerVertex;
		case per_instance:    return MTLVertexStepFunctionPerInstance;
		default: RK_UNREACHABLE; return (MTLVertexStepFunction)0;
	}
}

typedef struct Depth_t {
   bool enabled;
   enum CompareFunc_t compare_func;
} Depth_t;

typedef struct Stencil_t {
   bool enabled;
   enum StencilOp_t fail_op;
   enum StencilOp_t depth_fail_op;
   enum StencilOp_t pass_op;
   enum CompareFunc_t compare_func;
   uint8_t read_mask;
   uint8_t write_mask;
   uint8_t ref;
} Stencil_t;

typedef struct Blend_t {
   bool enabled;
   enum BlendFactor_t src_factor_rgb;
   enum BlendFactor_t dst_factor_rgb;
   enum BlendOp_t op_rgb;
   enum BlendFactor_t src_factor_alpha;
   enum BlendFactor_t dst_factor_alpha;
   enum BlendOp_t op_alpha;
   enum ColorMask_t color_write_mask;
   float color[4];
} Blend_t;

typedef struct RenderState_t {
   Depth_t depth;
   Stencil_t stencil;
   Blend_t blend;
   bool scissor;
} RenderState_t;

typedef struct ClearCommand_t {
   enum ClearAction_t color_action;
   float color[4];
   enum ClearAction_t stencil_action;
   uint8_t stencil;
   enum ClearAction_t depth_action;
   double depth;
} ClearCommand_t;


// descriptor structs
typedef struct PoolSizes_t {
   uint8_t texture;
   uint8_t offscreen_pass;
   uint8_t buffers;
   uint8_t shaders;
} PoolSizes_t;

typedef struct MetalSetup_t {
   void* ca_layer;
} MetalSetup_t;

typedef struct RendererDesc_t {
   void* allocator;
   const void* (*getProcAddress)(uint8_t*);
   PoolSizes_t pool_sizes;
   MetalSetup_t metal;
} RendererDesc_t;

typedef struct ImageDesc_t {
   bool render_target;
   int32_t width;
   int32_t height;
   enum Usage_t usage;
   enum PixelFormat_t pixel_format;
   enum TextureFilter_t min_filter;
   enum TextureFilter_t mag_filter;
   enum TextureWrap_t wrap_u;
   enum TextureWrap_t wrap_v;
   uint8_t* content;
} ImageDesc_t;

typedef struct MtlBufferDesc_T {
    long size; // either size (for stream buffers) or content (for static/dynamic) must be set
    BufferType_t type;
    Usage_t usage;
    uint8_t* content;
    VertexStep_t step_func;
} MtlBufferDesc_T;

typedef struct PassDesc_t {
   uint16_t color_img;
   uint16_t depth_stencil_img;
} PassDesc_t;

typedef struct ShaderDesc_t {
   uint8_t* vs;
   uint8_t* fs;
   uint8_t** images;
} ShaderDesc_t;

// internal storage that gets passed back to zig and cached there
typedef struct _mtl_image {
	uint32_t tex;
    uint32_t depth_tex;
    uint32_t stencil_tex;
	uint32_t sampler_state;
} _mtl_image;

typedef struct _mtl_buffer {
	uint32_t buffer;
} _mtl_buffer;


#import "backend.h"

void metal_setup(RendererDesc_t desc);
void metal_shutdown(void);

void metal_set_render_state(RenderState_t arg0);
void metal_viewport(int arg0, int arg1, int arg2, int arg3);
void metal_scissor(int arg0, int arg1, int arg2, int arg3);

_mtl_image* metal_create_image(ImageDesc_t desc);
void metal_destroy_image(_mtl_image* arg0);
void metal_update_image(_mtl_image* img, void* data);
void metal_bind_image(_mtl_image* img, uint32_t slot);

uint16_t metal_create_pass(PassDesc_t desc);
void metal_destroy_pass(uint16_t pass);
void metal_begin_pass(uint16_t pass, ClearCommand_t clear, int w, int h);
void metal_end_pass(void);
void metal_commit_frame(void);

_mtl_buffer* metal_create_buffer(MtlBufferDesc_T desc);
void metal_destroy_buffer(_mtl_buffer* buffer);
void metal_update_buffer(_mtl_buffer* buffer, const void* data, uint32_t data_size);

uint16_t metal_create_buffer_bindings(uint16_t arg0, uint16_t arg1);
void metal_destroy_buffer_bindings(uint16_t arg0);
void metal_draw_buffer_bindings(uint16_t arg0, int arg1);
void metal_bind_image_to_buffer_bindings(uint16_t bindings, _mtl_image* img, uint32_t slot);

uint16_t metal_create_shader(ShaderDesc_t arg0);
void metal_destroy_shader(uint16_t arg0);
void metal_use_shader(uint16_t arg0);
void metal_set_shader_uniform(uint16_t arg0, uint8_t* arg1, void* arg2);

