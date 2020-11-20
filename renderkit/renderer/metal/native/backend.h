#pragma once

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#include "metal.h"

// pipeline cache
//- depthAttachmentPixelFormat (later)
//- stencilAttachmentPixelFormat (later)
//- multiple color attachments (later)

typedef struct {
	uint32_t shader_id;
	uint32_t vertex_buffer_type_ids[4];
	uint32_t index_buffer_type_id;
	Blend_t blend_state;
	uint32_t pipeline_handle;
} mtl_pipeline_cache_item_t;

typedef struct {
	int capacity;
	int num_items;
	mtl_pipeline_cache_item_t* items;
} mtl_pipeline_cache_t;

// sampler cache
typedef struct {
    TextureFilter_t min_filter;
    TextureFilter_t mag_filter;
    TextureWrap_t wrap_u;
    TextureWrap_t wrap_v;
	uint32_t sampler_handle;
} mtl_sampler_cache_item_t;

typedef struct {
    int capacity;
    int num_items;
    mtl_sampler_cache_item_t* items;
} mtl_sampler_cache_t;

typedef struct {
    uint32_t frame_index; // frame index at which it is safe to release this resource
    uint32_t slot_index;
} mtl_release_item_t;

typedef struct {
    uint32_t num_slots;
    uint32_t free_queue_top;
    uint32_t* free_queue;
    uint32_t release_queue_front;
    uint32_t release_queue_back;
    mtl_release_item_t* release_queue;
} mtl_idpool_t;


@interface RKMetalBackend : NSObject
@property (nonatomic, retain) NSMutableArray* objectPool;
- (instancetype)initWithRendererDesc:(RendererDesc_t)desc;
@end

@implementation RKMetalBackend

static mtl_pipeline_cache_t pipeline_cache;
static mtl_sampler_cache_t sampler_cache;
static mtl_idpool_t idpool;

- (instancetype)initWithRendererDesc:(RendererDesc_t)desc {
    if (self = [super init]) {
        // setup the objectPool and its idpool
        idpool.num_slots = 2 *
            (
                2 * desc.pool_sizes.buffers +
                2 * desc.pool_sizes.texture +
                4 * desc.pool_sizes.shaders +
                desc.pool_sizes.offscreen_pass
            );
        self.objectPool = [NSMutableArray arrayWithCapacity:idpool.num_slots];
        
        NSNull* null = [NSNull null];
        for (uint32_t i = 0; i < idpool.num_slots; i++)
            [self.objectPool addObject:null];

        // a queue of currently free slot indices
        idpool.free_queue_top = 0;
        idpool.free_queue = (uint32_t*)malloc(idpool.num_slots * sizeof(uint32_t));
        
        // pool slot 0 is reserved!
        for (int i = idpool.num_slots - 1; i >= 1; i--)
            idpool.free_queue[idpool.free_queue_top++] = (uint32_t)i;
        
        // a circular queue which holds release items (frame index when a resource is to be released, and the resource's pool index
        idpool.release_queue_front = 0;
        idpool.release_queue_back = 0;
        idpool.release_queue = (mtl_release_item_t*)malloc(idpool.num_slots * sizeof(mtl_release_item_t));
        for (uint32_t i = 0; i < idpool.num_slots; i++) {
            idpool.release_queue[i].frame_index = 0;
            idpool.release_queue[i].slot_index = 0;
        }
		
		memset(&pipeline_cache, 0, sizeof(mtl_pipeline_cache_t));
		pipeline_cache.capacity = 32;
		const int pip_cache_size = pipeline_cache.capacity * sizeof(mtl_pipeline_cache_item_t);
		pipeline_cache.items = (mtl_pipeline_cache_item_t*) malloc(pip_cache_size);
		memset(pipeline_cache.items, 0, pip_cache_size);
        
        memset(&sampler_cache, 0, sizeof(mtl_sampler_cache_t));
        sampler_cache.capacity = 20;
        const int sampler_cache_size = sampler_cache.capacity * sizeof(mtl_sampler_cache_item_t);
        sampler_cache.items = (mtl_sampler_cache_item_t*) malloc(sampler_cache_size);
        memset(sampler_cache.items, 0, sampler_cache_size);
    }
    
    return self;
}

- (void)dealloc {
    free(sampler_cache.items);
    free(idpool.free_queue);
}

- (uint32_t)addResource:(id)res {
    if (nil == res)
        return 0;
    
    // get a new free resource pool slot
    RK_ASSERT(idpool.free_queue_top > 0);
    const uint32_t slot_index = idpool.free_queue[--idpool.free_queue_top];
    RK_ASSERT((slot_index > 0) && (slot_index < idpool.num_slots));
    
    self.objectPool[slot_index] = res;
    
    return slot_index;
}

- (void)releaseResourceWithFrameIndex:(uint32_t)frame_index slotIndex:(uint32_t)slot_index {
    if (slot_index == 0) return;

    RK_ASSERT(self.objectPool[slot_index] != [NSNull null]);
    int release_index = idpool.release_queue_front++;
    if (idpool.release_queue_front >= idpool.num_slots) {
        // wrap-around
        idpool.release_queue_front = 0;
    }
    
    // release queue full?
    RK_ASSERT(idpool.release_queue_front != idpool.release_queue_back);
    RK_ASSERT(0 == idpool.release_queue[release_index].frame_index);
    const uint32_t safe_to_release_frame_index = frame_index + NUM_INFLIGHT_FRAMES + 1;
    idpool.release_queue[release_index].frame_index = safe_to_release_frame_index;
    idpool.release_queue[release_index].slot_index = slot_index;
}

// run garbage-collection pass on all resources in the release-queue
- (void)garbageCollectResources:(uint32_t)frame_index {
    while (idpool.release_queue_back != idpool.release_queue_front) {
        if (frame_index < idpool.release_queue[idpool.release_queue_back].frame_index) {
            // don't need to check further, release-items past this are too young
            break;
        }
        
        // safe to release this resource
        const uint32_t slot_index = idpool.release_queue[idpool.release_queue_back].slot_index;
        RK_ASSERT((slot_index > 0) && (slot_index < idpool.num_slots));
        RK_ASSERT(self.objectPool[slot_index] != [NSNull null]);
        self.objectPool[slot_index] = [NSNull null];
        
        // put the now free pool index back on the free queue
        RK_ASSERT(idpool.free_queue_top < idpool.num_slots);
        RK_ASSERT((slot_index > 0) && (slot_index < idpool.num_slots));
        idpool.free_queue[idpool.free_queue_top++] = slot_index;
        
        // reset the release queue slot and advance the back index
        idpool.release_queue[idpool.release_queue_back].frame_index = 0;
        idpool.release_queue[idpool.release_queue_back].slot_index = 0;
        idpool.release_queue_back++;
        if (idpool.release_queue_back >= idpool.num_slots) {
            // wrap-around
            idpool.release_queue_back = 0;
        }
    }
}

// pipeline cache
- (int)findPipelineState:(uint32_t)shader_id blendState:(Blend_t*)blend_state bindings:(MtlBufferBindings_t*)bindings {
	for (int i = 0; i < pipeline_cache.num_items; i++) {
		const mtl_pipeline_cache_item_t* item = &pipeline_cache.items[i];
		if (item->shader_id == shader_id &&
			_mtl_blend_states_eq(&item->blend_state, blend_state) &&
			item->index_buffer_type_id == bindings->index_buffer->type_id &&
			(item->vertex_buffer_type_ids[0] == bindings->vertex_buffers[0]->type_id) &&
			(bindings->vertex_buffers[1] == nil || item->vertex_buffer_type_ids[1] == bindings->vertex_buffers[1]->type_id) &&
			(bindings->vertex_buffers[2] == nil || item->vertex_buffer_type_ids[2] == bindings->vertex_buffers[2]->type_id) &&
			(bindings->vertex_buffers[3] == nil || item->vertex_buffer_type_ids[3] == bindings->vertex_buffers[3]->type_id))
		{
			return i;
		}
	}
	
	return -1;
}

- (void)addPipelineStateItem:(uint32_t)shader_id
				  blendState:(Blend_t*)blend_state
					bindings:(MtlBufferBindings_t*)bindings
					  handle:(uint32_t)pipeline_handle {
	const int item_index = pipeline_cache.num_items++;
	mtl_pipeline_cache_item_t* item = &pipeline_cache.items[item_index];
	
	item->pipeline_handle = pipeline_handle;
	item->shader_id = shader_id;
	item->blend_state.enabled = blend_state->enabled;
	item->blend_state.src_factor_rgb = blend_state->src_factor_rgb;
	item->blend_state.dst_factor_rgb = blend_state->dst_factor_rgb;
	item->blend_state.op_rgb = blend_state->op_rgb;
	item->blend_state.src_factor_alpha = blend_state->src_factor_alpha;
	item->blend_state.dst_factor_alpha = blend_state->dst_factor_alpha;
	item->blend_state.op_alpha = blend_state->op_alpha;
	item->blend_state.color_write_mask = blend_state->color_write_mask;
	item->blend_state.color[0] = blend_state->color[0];
	item->blend_state.color[1] = blend_state->color[1];
	item->blend_state.color[2] = blend_state->color[2];
	item->blend_state.color[3] = blend_state->color[3];
	
	item->index_buffer_type_id = bindings->index_buffer->type_id;
	for (int i = 0; i < 4; i++)
		item->vertex_buffer_type_ids[i] = bindings->vertex_buffers[i] != nil ? bindings->vertex_buffers[i]->type_id : 0;
}

- (id<MTLRenderPipelineState>)getOrCreatePipelineStateItem:(_mtl_shader*)shader
							  blendState:(Blend_t*)blend_state
								bindings:(MtlBufferBindings_t*)bindings
							  metalLayer:(CAMetalLayer*)layer {
	int index = [self findPipelineState:shader->shader_id blendState:blend_state bindings:bindings];
	if (index >= 0) {
		// reuse existing pipeline
		return self.objectPool[pipeline_cache.items[index].pipeline_handle];
	}
	
	printf("--- no existing pipeline. creating now\n");
	
	// create a new PipelineState object and add to pipeline cache
	MTLRenderPipelineDescriptor* pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
	pipelineStateDescriptor.label = @"Sprite Pipeline";
	pipelineStateDescriptor.vertexFunction = self.objectPool[shader->vs_func];
	pipelineStateDescriptor.fragmentFunction = self.objectPool[shader->fs_func];
	pipelineStateDescriptor.colorAttachments[0].pixelFormat = layer.pixelFormat;
	pipelineStateDescriptor.colorAttachments[0].writeMask = _mtl_color_write_mask(blend_state->color_write_mask);
	
	if (blend_state->enabled) {
		pipelineStateDescriptor.colorAttachments[0].blendingEnabled = blend_state->enabled;
		pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = _mtl_blend_op(blend_state->op_alpha);
		pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = _mtl_blend_op(blend_state->op_rgb);
		pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = _mtl_blend_factor(blend_state->dst_factor_alpha);
		pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = _mtl_blend_factor(blend_state->dst_factor_rgb);
		pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = _mtl_blend_factor(blend_state->src_factor_alpha);
		pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = _mtl_blend_factor(blend_state->src_factor_rgb);
	}

	// preprare the MTLVertexDescriptor
	MTLVertexDescriptor* vertexDesc = [MTLVertexDescriptor vertexDescriptor];

	int attr_index = 0;
	for (int i = 0; i < 4; i++) {
		if (bindings->vertex_buffers[i] == NULL) break;
		_mtl_buffer* buff = bindings->vertex_buffers[i];

		// attributes
		for (int j = 0; j < 8; j++) {
			mtl_vertex_attribute_t attr = buff->vertex_attrs[j];
			// an offset of 0 for an attribute other than the first indicates we are done
			if (j > 0 && attr.offset == 0) break;

			vertexDesc.attributes[attr_index].format = attr.format;
			vertexDesc.attributes[attr_index].offset = attr.offset;
			vertexDesc.attributes[attr_index].bufferIndex = i;

			attr_index++;
		}

		// layout
		for (int j = 0; j < 4; j++) {
			mtl_vertex_layout_t layout = buff->vertex_layout[j];
			if (layout.stride == 0) break;

			vertexDesc.layouts[j].stepFunction = layout.step_func;
			vertexDesc.layouts[j].stride = layout.stride;
		}
	}

	pipelineStateDescriptor.vertexDescriptor = vertexDesc;

	// Create Pipeline State Object
	NSError* error = nil;
	id<MTLRenderPipelineState> pipelineState = [layer.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];

	if (error) {
		NSLog(@"Failed to created pipeline state, error %@", error);
		return 0;
	}
	
	uint32_t pipeline_handle = [self addResource:pipelineState];
	[self addPipelineStateItem:shader->shader_id blendState:blend_state bindings:bindings handle:pipeline_handle];
	return pipelineState;
}

- (void)removeShader:(_mtl_shader*)shader frameIndex:(uint32_t)frame_index {
	// swap remove any pipelines with this shader and zero out the item we swapped from
	int i = 0;
	while (i < pipeline_cache.num_items) {
		const mtl_pipeline_cache_item_t* item = &pipeline_cache.items[i];
		if (item->shader_id == shader->shader_id) {
			printf("----- shader %d died so need to kill pip %d\n", item->shader_id, item->pipeline_handle);
			[self releaseResourceWithFrameIndex:frame_index slotIndex:(uint32_t)item->pipeline_handle];
			pipeline_cache.items[i] = pipeline_cache.items[pipeline_cache.num_items - 1];
			memset(&pipeline_cache.items[pipeline_cache.num_items - 1], 0, sizeof(mtl_pipeline_cache_item_t));
			pipeline_cache.num_items--;
		} else {
			i++;
		}
	}
	
	[self releaseResourceWithFrameIndex:frame_index slotIndex:shader->vs_lib];
	[self releaseResourceWithFrameIndex:frame_index slotIndex:shader->fs_lib];
	[self releaseResourceWithFrameIndex:frame_index slotIndex:shader->vs_func];
	[self releaseResourceWithFrameIndex:frame_index slotIndex:shader->fs_func];
}

// sampler cache
- (int)findSamplerState:(ImageDesc_t*)img_desc {
    for (int i = 0; i < sampler_cache.num_items; i++) {
        const mtl_sampler_cache_item_t* item = &sampler_cache.items[i];
        if ((img_desc->min_filter == item->min_filter) &&
            (img_desc->mag_filter == item->mag_filter) &&
            (img_desc->wrap_u == item->wrap_u) &&
            (img_desc->wrap_v == item->wrap_v))
        {
            return i;
        }
    }
    
    return -1;
}

- (void)addSamplerCacheItem:(const ImageDesc_t*)img_desc handle:(uint32_t)sampler_handle {
    const int item_index = sampler_cache.num_items++;
    mtl_sampler_cache_item_t* item = &sampler_cache.items[item_index];
    item->min_filter = img_desc->min_filter;
    item->mag_filter = img_desc->mag_filter;
    item->wrap_u = img_desc->wrap_u;
    item->wrap_v = img_desc->wrap_v;
    item->sampler_handle = sampler_handle;
}

- (uint32_t)createSampler:(id<MTLDevice>)mtl_device withImageDesc:(ImageDesc_t*)img_desc {
    int index = [self findSamplerState:img_desc];
    if (index >= 0) {
        // reuse existing sampler
        return (uint32_t)sampler_cache.items[index].sampler_handle;
    }
	
	// create a new Metal sampler state object and add to sampler cache
	MTLSamplerDescriptor *mtl_desc = [[MTLSamplerDescriptor alloc] init];
	mtl_desc.sAddressMode = _mtl_address_mode(img_desc->wrap_u);
	mtl_desc.tAddressMode = _mtl_address_mode(img_desc->wrap_v);
	mtl_desc.minFilter = _mtl_minmag_filter(img_desc->min_filter);
	mtl_desc.magFilter = _mtl_minmag_filter(img_desc->mag_filter);
	mtl_desc.normalizedCoordinates = YES;
	
	id<MTLSamplerState> mtl_sampler = [mtl_device newSamplerStateWithDescriptor:mtl_desc];
	uint32_t sampler_handle = [self addResource:mtl_sampler];
	[self addSamplerCacheItem:img_desc handle:sampler_handle];

	return sampler_handle;
}

@end
