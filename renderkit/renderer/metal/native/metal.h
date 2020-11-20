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

// forward declarations
typedef struct _mtl_image _mtl_image;

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
		case usage_immutable: return MTLResourceStorageModeShared;
		case usage_dynamic:
		case usage_stream:
			return MTLCPUCacheModeWriteCombined | MTLResourceStorageModeManaged;
		default:
			RK_UNREACHABLE;
			return 0;
	}
}

typedef enum BufferType_t {
    buffer_type_vertex,
    buffer_type_index,
} BufferType_t;

typedef enum PrimitiveType_t {
    primitive_type_points,
    primitive_type_line_strip,
    primitive_type_lines,
    primitive_type_triangle_strip,
    primitive_type_triangles,
} PrimitiveType_t;

typedef enum ElementType_t {
    element_type_u8,
    element_type_u16,
    element_type_u32,
} ElementType_t;

typedef enum CompareFunc_t {
    compre_func_never,
    compre_func_less,
    compre_func_equal,
    compre_func_less_equal,
    compre_func_greater,
    compre_func_not_equal,
    compre_func_greater_equal,
    compre_func_always,
} CompareFunc_t;

MTLCompareFunction _mtl_compare_func(CompareFunc_t f) {
	switch (f) {
		case compre_func_never:          return MTLCompareFunctionNever;
		case compre_func_less:           return MTLCompareFunctionLess;
		case compre_func_equal:          return MTLCompareFunctionEqual;
		case compre_func_less_equal:     return MTLCompareFunctionLessEqual;
		case compre_func_greater:        return MTLCompareFunctionGreater;
		case compre_func_not_equal:      return MTLCompareFunctionNotEqual;
		case compre_func_greater_equal:  return MTLCompareFunctionGreaterEqual;
		case compre_func_always:         return MTLCompareFunctionAlways;
		default: RK_UNREACHABLE; return (MTLCompareFunction)0;
	}
}

typedef enum StencilOp_t {
    stencil_op_keep,
    stencil_op_zero,
    stencil_op_replace,
    stencil_op_incr_clamp,
    stencil_op_decr_clamp,
    stencil_op_invert,
    stencil_op_incr_wrap,
    stencil_op_decr_wrap,
} StencilOp_t;

MTLStencilOperation _sg_mtl_stencil_op(StencilOp_t op) {
	switch (op) {
		case stencil_op_keep:         return MTLStencilOperationKeep;
		case stencil_op_zero:         return MTLStencilOperationZero;
		case stencil_op_replace:      return MTLStencilOperationReplace;
		case stencil_op_incr_clamp:   return MTLStencilOperationIncrementClamp;
		case stencil_op_decr_clamp:   return MTLStencilOperationDecrementClamp;
		case stencil_op_invert:       return MTLStencilOperationInvert;
		case stencil_op_incr_wrap:    return MTLStencilOperationIncrementWrap;
		case stencil_op_decr_wrap:    return MTLStencilOperationDecrementWrap;
		default: RK_UNREACHABLE; return (MTLStencilOperation)0;
	}
}

typedef enum BlendFactor_t {
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
} BlendFactor_t;

MTLBlendFactor _mtl_blend_factor(BlendFactor_t f) {
	switch (f) {
		case blend_zero:                   return MTLBlendFactorZero;
		case blend_one:                    return MTLBlendFactorOne;
		case blend_src_color:              return MTLBlendFactorSourceColor;
		case blend_one_minus_src_color:    return MTLBlendFactorOneMinusSourceColor;
		case blend_src_alpha:              return MTLBlendFactorSourceAlpha;
		case blend_one_minus_src_alpha:    return MTLBlendFactorOneMinusSourceAlpha;
		case blend_dst_color:              return MTLBlendFactorDestinationColor;
		case blend_one_minus_dst_color:    return MTLBlendFactorOneMinusDestinationColor;
		case blend_dst_alpha:              return MTLBlendFactorDestinationAlpha;
		case blend_one_minus_dst_alpha:    return MTLBlendFactorOneMinusDestinationAlpha;
		case blend_src_alpha_saturated:    return MTLBlendFactorSourceAlphaSaturated;
		case blend_blend_color:            return MTLBlendFactorBlendColor;
		case blend_one_minus_blend_color:  return MTLBlendFactorOneMinusBlendColor;
		case blend_blend_alpha:            return MTLBlendFactorBlendAlpha;
		case blend_one_minus_blend_alpha:  return MTLBlendFactorOneMinusBlendAlpha;
		default: RK_UNREACHABLE; 			return (MTLBlendFactor)0;
	}
}

typedef enum BlendOp_t {
    blend_op_add,
    blend_op_subtract,
    blend_op_reverse_subtract,
} BlendOp_t;

MTLBlendOperation _mtl_blend_op(BlendOp_t op) {
	switch (op) {
		case blend_op_add:                	return MTLBlendOperationAdd;
		case blend_op_subtract:           	return MTLBlendOperationSubtract;
		case blend_op_reverse_subtract:   	return MTLBlendOperationReverseSubtract;
		default: RK_UNREACHABLE; 			return (MTLBlendOperation)0;
	}
}

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
		case per_vertex:            return MTLVertexStepFunctionPerVertex;
		case per_instance:          return MTLVertexStepFunctionPerInstance;
		default: RK_UNREACHABLE;    return (MTLVertexStepFunction)0;
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

BOOL _mtl_blend_states_eq(const Blend_t* lhs, const Blend_t* rhs) {
	if (lhs->enabled == rhs->enabled &&
		lhs->src_factor_rgb == rhs->src_factor_rgb &&
		lhs->dst_factor_rgb == rhs->dst_factor_rgb &&
		lhs->op_rgb == rhs->op_rgb &&
		lhs->src_factor_alpha == rhs->src_factor_alpha
		&& lhs->dst_factor_alpha == rhs->dst_factor_alpha &&
		lhs->op_alpha == rhs->op_alpha &&
		lhs->color_write_mask == rhs->color_write_mask &&
		lhs->color[0] == rhs->color[0] && lhs->color[1] == rhs->color[1] &&
		lhs->color[2] == rhs->color[2] && lhs->color[3] == rhs->color[3])
	{
		return YES;
	}
	return NO;
}

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


// MtlBufferDesc_t sub-types
typedef enum VertexFormat_t {
    vertex_format_float,
    vertex_format_float2,
    vertex_format_float3,
    vertex_format_float4,
    vertex_format_u_byte_4n,
} VertexFormat_t;

MTLVertexFormat _mtl_vertex_format(VertexFormat_t format) {
    switch (format) {
        case vertex_format_float:       return MTLVertexFormatFloat;
        case vertex_format_float2:      return MTLVertexFormatFloat2;
        case vertex_format_float3:      return MTLVertexFormatFloat3;
        case vertex_format_float4:      return MTLVertexFormatFloat4;
        case vertex_format_u_byte_4n:   return MTLVertexFormatUChar4Normalized;
        default: RK_UNREACHABLE;        return (MTLVertexFormat)0;
    }
}

typedef enum IndexType_t {
    index_type_uint16,
    index_type_uint32,
} IndexType_t;

MTLIndexType _mtl_index_type(IndexType_t t) {
	switch (t) {
		case index_type_uint16:   return MTLIndexTypeUInt16;
		case index_type_uint32:   return MTLIndexTypeUInt32;
		default: RK_UNREACHABLE; return (MTLIndexType)0;
	}
}

typedef struct VertexAttribute_t {
    VertexFormat_t format;
    int offset;
} VertexAttribute_t;

typedef struct VertexLayout_t {
    int stride;
    VertexStep_t step_func;
} VertexLayout_t;

typedef struct MtlBufferDesc_t {
    long size; // either size (for stream buffers) or content (for static/dynamic) must be set
    BufferType_t type;
    uint8_t type_id;
    Usage_t usage;
    uint8_t* content;
    IndexType_t index_type;
    VertexLayout_t vertex_layout[4];
    VertexAttribute_t vertex_attrs[8];
} MtlBufferDesc_t;


typedef struct PassDesc_t {
	_mtl_image* color_img;
	_mtl_image* depth_stencil_img;
} PassDesc_t;

typedef enum ShaderStage_t {
    shader_stage_fs,
    shader_stage_vs
} ShaderState_t;

typedef struct ShaderDesc_t {
	const char* vs;
	const char* fs;
    uint32_t vs_uniform_size;
    uint32_t fs_uniform_size;
} ShaderDesc_t;

// internal storage that gets passed back to zig and cached there
typedef struct _mtl_image {
	uint32_t tex;
    uint32_t depth_tex;
    uint32_t stencil_tex;
	uint32_t sampler_state;
	uint32_t width;
	uint32_t height;
} _mtl_image;

typedef struct _mtl_pass {
	_mtl_image* color_tex;
	_mtl_image* stencil_tex;
} _mtl_pass;

typedef struct mtl_vertex_layout_t {
    int stride;
    MTLVertexStepFunction step_func;
} mtl_vertex_layout_t;

typedef struct mtl_vertex_attribute_t {
    MTLVertexFormat format;
    int offset;
} mtl_vertex_attribute_t;

typedef struct _mtl_buffer {
	uint8_t type_id;                // unique identifier for they type of the buffer
    int size;                       // size of the buffer in bytes
    uint32_t update_frame_index;    // frame index of last mtl_update_buffer()
    uint32_t append_frame_index;    // frame index of last mtl_append_buffer()
    int append_pos;                 // current position in buffer for sg_append_buffer()
    bool append_overflow;           // is buffer in overflow state (due to sg_append_buffer)
    int num_slots;                  // number of renaming-slots for dynamically updated buffers
    int active_slot;                // currently active write-slot for dynamically updated buffers
    uint32_t buffers[NUM_INFLIGHT_FRAMES];
    mtl_vertex_layout_t vertex_layout[4];
    mtl_vertex_attribute_t vertex_attrs[8];
	MTLIndexType index_type;
} _mtl_buffer;

typedef struct _mtl_shader {
	uint32_t shader_id;
	uint32_t vs_lib;
	uint32_t vs_func;
	uint32_t fs_lib;
	uint32_t fs_func;
    void* vs_uniform_data;
    uint32_t vs_uniform_size;
    void* fs_uniform_data;
    uint32_t fs_uniform_size;
} _mtl_shader;

typedef struct MtlBufferBindings_t {
    _mtl_buffer* index_buffer;
    _mtl_buffer* vertex_buffers[4];
	uint32_t vertex_buffer_offsets[4];
    _mtl_image* images[8];
} MtlBufferBindings_t;


#import "backend.h"

void mtl_setup(RendererDesc_t desc);
void mtl_shutdown(void);

void mtl_set_render_state(RenderState_t arg0);
void mtl_viewport(int x, int y, int w, int h);
void mtl_scissor(int x, int y, int w, int h);

_mtl_image* mtl_create_image(ImageDesc_t desc);
void mtl_destroy_image(_mtl_image* arg0);
void mtl_update_image(_mtl_image* img, void* data);

_mtl_pass* mtl_create_pass(PassDesc_t desc);
void mtl_destroy_pass(_mtl_pass* pass);

void mtl_begin_pass(_mtl_pass* pass, ClearCommand_t clear, int w, int h);
void mtl_end_pass(void);
void mtl_commit_frame(void);

_mtl_buffer* mtl_create_buffer(MtlBufferDesc_t desc);
void mtl_destroy_buffer(_mtl_buffer* buffer);
void mtl_update_buffer(_mtl_buffer* buffer, const void* data, uint32_t data_size);
uint32_t mtl_append_buffer(_mtl_buffer* buffer, const void* data, uint32_t data_size);

_mtl_shader* mtl_create_shader(ShaderDesc_t desc);
void mtl_destroy_shader(_mtl_shader* shader);
void mtl_use_shader(_mtl_shader* shader);
void mtl_set_shader_uniform_block(enum ShaderStage_t stage, const void* data, int num_bytes);
void mtl_set_shader_uniform(_mtl_shader* shader, uint8_t* arg1, void* arg2);

void mtl_apply_bindings(MtlBufferBindings_t bindings);
void mtl_draw(int base_element, int element_count, int instance_count);
