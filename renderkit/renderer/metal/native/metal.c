#if __has_feature(objc_arc) && !__has_feature(objc_arc_fields)
    #error "Metal requires __has_feature(objc_arc_field) if ARC is enabled (use a more recent compiler version)"
#endif

#include "metal.h"

#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

enum {
    NUM_INFLIGHT_FRAMES = 1,
};

// typedef struct {
//     bool valid;
//     uint32_t frame_index;
//     uint32_t cur_frame_rotate_index;
//     bool in_pass;
//     bool pass_valid;
//     int cur_width;
//     int cur_height;
//     // _sg_mtl_state_cache_t state_cache;
//     // _mtl_sampler_cache_t sampler_cache;
//     // _sg_mtl_idpool_t idpool;
//     dispatch_semaphore_t sem;
//     id<MTLDevice> device;
//     id<MTLCommandQueue> cmd_queue;
//     id<MTLCommandBuffer> cmd_buffer;
//     id<MTLRenderCommandEncoder> cmd_encoder;
//     id<MTLBuffer> uniform_buffers[SG_NUM_INFLIGHT_FRAMES];
// } _sg_mtl_backend_t;

CAMetalLayer* layer;
id<MTLCommandQueue> cmd_queue;
id<MTLCommandBuffer> cmd_buffer;
id<MTLRenderCommandEncoder> cmd_encoder;
id<CAMetalDrawable> cur_drawable;
dispatch_semaphore_t render_semaphore;

bool origin_top_left = true;
bool in_pass = false;
bool pass_valid = false;
int cur_width;
int cur_height;


// render state
void metal_set_render_state(RenderState_t state) {
    printf("metal_set_render_state\n");
    assert(!in_pass);
    if (!pass_valid) return;
    assert(cmd_encoder != nil);

    [cmd_encoder setBlendColorRed:state.blend.color[0] green: state.blend.color[1] blue: state.blend.color[2] alpha: state.blend.color[3]];
    [cmd_encoder setStencilReferenceValue:state.stencil.ref];
    // [cmd_encoder setRenderPipelineState:_sg_mtl_id(pip->mtl.rps)];
    // [cmd_encoder setDepthStencilState:_sg_mtl_id(pip->mtl.dss)];
}

void metal_viewport(int x, int y, int w, int h) {
    printf("metal_viewport\n");
    assert(in_pass);
    if (!pass_valid) return;
    assert(cmd_encoder != nil);

    MTLViewport vp;
    vp.originX = (double) x;
    vp.originY = (double) (origin_top_left ? y : (cur_height - (y + h)));
    vp.width   = (double) w;
    vp.height  = (double) h;
    vp.znear   = 0.0;
    vp.zfar    = 1.0;
    [cmd_encoder setViewport:vp];
}

void metal_scissor(int x, int y, int w, int h) {
    printf("metal_scissor\n");
    assert(in_pass);
    if (!pass_valid) return;
    assert(cmd_encoder != nil);

    // clip against framebuffer rect
    x = min(max(0, x), cur_width - 1);
    y = min(max(0, y), cur_height - 1);
    if ((x + w) > cur_width) {
        w = cur_width - x;
    }
    if ((y + h) > cur_height) {
        h = cur_height - y;
    }
    w = max(w, 1);
    h = max(h, 1);

    MTLScissorRect r;
    r.x = x;
    r.y = origin_top_left ? y : (cur_height - (y + h));
    r.width = w;
    r.height = h;
    [cmd_encoder setScissorRect:r];
}


// id pool
typedef struct {
	NSMutableArray* pool;
	uint32_t num_slots;
	uint32_t free_queue_top;
	uint32_t* free_queue;
	uint32_t release_queue_front;
	uint32_t release_queue_back;
} _mtl_idpool_t;

// sampler cache
typedef struct {
	TextureFilter_t min_filter;
	TextureFilter_t mag_filter;
	TextureWrap_t wrap_u;
	TextureWrap_t wrap_v;
	uintptr_t sampler_handle;
} _mtl_sampler_cache_item_t;

typedef struct {
	int capacity;
	int num_items;
	_mtl_sampler_cache_item_t* items;
} _mtl_sampler_cache_t;

void _mtl_smpcache_init(_mtl_sampler_cache_t* cache, int capacity) {
	RENDERKIT_ASSERT(cache && (capacity > 0));
	memset(cache, 0, sizeof(_mtl_sampler_cache_t));
	cache->capacity = capacity;
	const int size = cache->capacity * sizeof(_mtl_sampler_cache_item_t);
	cache->items = (_mtl_sampler_cache_item_t*) malloc(size);
	memset(cache->items, 0, size);
}

void _mtl_smpcache_discard(_mtl_sampler_cache_t* cache) {
	RENDERKIT_ASSERT(cache && cache->items);
	free(cache->items);
	cache->items = 0;
	cache->num_items = 0;
	cache->capacity = 0;
}

int _mtl_smpcache_find_item(const _mtl_sampler_cache_t* cache, const ImageDesc_t* img_desc) {
	// return matching sampler cache item index or -1
	RENDERKIT_ASSERT(cache && cache->items);
	RENDERKIT_ASSERT(img_desc);

	for (int i = 0; i < cache->num_items; i++) {
		const _mtl_sampler_cache_item_t* item = &cache->items[i];
		if ((img_desc->min_filter == item->min_filter) &&
			(img_desc->mag_filter == item->mag_filter) &&
			(img_desc->wrap_u == item->wrap_u) &&
			(img_desc->wrap_v == item->wrap_v))
		{
			return i;
		}
	}
	/* fallthrough: no matching cache item found */
	return -1;
}

void _mtl_smpcache_add_item(_mtl_sampler_cache_t* cache, const ImageDesc_t* img_desc, uintptr_t sampler_handle) {
	RENDERKIT_ASSERT(cache && cache->items);
	RENDERKIT_ASSERT(img_desc);
	RENDERKIT_ASSERT(cache->num_items < cache->capacity);
	
	const int item_index = cache->num_items++;
	_mtl_sampler_cache_item_t* item = &cache->items[item_index];
	item->min_filter = img_desc->min_filter;
	item->mag_filter = img_desc->mag_filter;
	item->wrap_u = img_desc->wrap_u;
	item->wrap_v = img_desc->wrap_v;
	item->sampler_handle = sampler_handle;
}

uintptr_t _mtl_smpcache_sampler(_mtl_sampler_cache_t* cache, int item_index) {
	RENDERKIT_ASSERT(cache && cache->items);
	RENDERKIT_ASSERT((item_index >= 0) && (item_index < cache->num_items));
	return cache->items[item_index].sampler_handle;
}

typedef struct {
	_mtl_sampler_cache_t sampler_cache;
	_mtl_idpool_t idpool;
} _mtl_backend_t;
static _mtl_backend_t _mtl;

//-- a pool for all Metal resource objects, with deferred release queue -------
void _mtl_init_pool(const RendererDesc_t desc) {
	_mtl.idpool.num_slots = 2 *
		(
			2 * desc.pool_sizes.buffers +
			5 * desc.pool_sizes.texture +
			4 * desc.pool_sizes.shaders +
			desc.pool_sizes.offscreen_pass
		);
	_mtl.idpool.pool = [NSMutableArray arrayWithCapacity:_mtl.idpool.num_slots];
	NSNull* null = [NSNull null];
	for (uint32_t i = 0; i < _mtl.idpool.num_slots; i++) {
		[_mtl.idpool.pool addObject:null];
	}
	RENDERKIT_ASSERT([_mtl.idpool.pool count] == _mtl.idpool.num_slots);
	// a queue of currently free slot indices
	_mtl.idpool.free_queue_top = 0;
	_mtl.idpool.free_queue = (uint32_t*)malloc(_mtl.idpool.num_slots * sizeof(uint32_t));
	// pool slot 0 is reserved!
	for (int i = _mtl.idpool.num_slots-1; i >= 1; i--) {
		_mtl.idpool.free_queue[_mtl.idpool.free_queue_top++] = (uint32_t)i;
	}
}

// get a new free resource pool slot
uint32_t _mtl_alloc_pool_slot(void) {
	RENDERKIT_ASSERT(_mtl.idpool.free_queue_top > 0);
	const uint32_t slot_index = _mtl.idpool.free_queue[--_mtl.idpool.free_queue_top];
	RENDERKIT_ASSERT((slot_index > 0) && (slot_index < _mtl.idpool.num_slots));
	return slot_index;
}

// add an MTLResource to the pool, return pool index or 0 if input was 'nil'
uint32_t _mtl_add_resource(id res) {
	if (nil == res) {
		return 0;
	}
	const uint32_t slot_index = _mtl_alloc_pool_slot();
	RENDERKIT_ASSERT([NSNull null] == _mtl.idpool.pool[slot_index]);
	_mtl.idpool.pool[slot_index] = res;
	return slot_index;
}

uint32_t _mtl_create_sampler(id<MTLDevice> mtl_device, const ImageDesc_t img_desc) {
	int index = _mtl_smpcache_find_item(&_mtl.sampler_cache, &img_desc);
	if (index >= 0) {
		// reuse existing sampler
		return (uint32_t) _mtl_smpcache_sampler(&_mtl.sampler_cache, index);
	}
	else {
		/* create a new Metal sampler state object and add to sampler cache */
		MTLSamplerDescriptor* mtl_desc = [[MTLSamplerDescriptor alloc] init];
		mtl_desc.sAddressMode = _mtl_address_mode(img_desc.wrap_u);
		mtl_desc.tAddressMode = _mtl_address_mode(img_desc.wrap_v);
		mtl_desc.minFilter = _mtl_minmag_filter(img_desc.min_filter);
		mtl_desc.magFilter = _mtl_minmag_filter(img_desc.mag_filter);
		mtl_desc.normalizedCoordinates = YES;
		id<MTLSamplerState> mtl_sampler = [mtl_device newSamplerStateWithDescriptor:mtl_desc];
		uint32_t sampler_handle = _mtl_add_resource(mtl_sampler);
		_mtl_smpcache_add_item(&_mtl.sampler_cache, &img_desc, sampler_handle);
		return sampler_handle;
	}
}


// setup
void metal_setup(RendererDesc_t desc) {
	_mtl_init_pool(desc);
	_mtl_smpcache_init(&_mtl.sampler_cache, 50);
	
	render_semaphore = dispatch_semaphore_create(NUM_INFLIGHT_FRAMES);
	layer = (__bridge CAMetalLayer*)desc.metal.ca_layer;
	layer.device = MTLCreateSystemDefaultDevice();
	layer.pixelFormat = MTLPixelFormatBGRA8Unorm;

	cmd_queue = [layer.device newCommandQueue];
}

void metal_shutdown() {
	printf("----- shutdown\n");

	// wait for the last frame to finish
	for (int i = 0; i < NUM_INFLIGHT_FRAMES; i++)
		dispatch_semaphore_wait(render_semaphore, DISPATCH_TIME_FOREVER);

	// semaphore must be "relinquished" before destruction
	for (int i = 0; i < NUM_INFLIGHT_FRAMES; i++)
		dispatch_semaphore_signal(render_semaphore);

	cmd_buffer = nil;
	cmd_encoder = nil;
}


// images
_mtl_image metal_create_image(ImageDesc_t desc) {
    MTLTextureDescriptor* mtl_desc = [[MTLTextureDescriptor alloc] init];
    mtl_desc.textureType = MTLTextureType2D;
    mtl_desc.pixelFormat = MTLPixelFormatRGBA8Unorm;
    mtl_desc.width = desc.width;
    mtl_desc.height = desc.height;
    mtl_desc.depth = 1;
    mtl_desc.arrayLength = 1;
    mtl_desc.usage = MTLTextureUsageShaderRead;
    if (desc.usage != usage_immutable)
        mtl_desc.cpuCacheMode = MTLCPUCacheModeWriteCombined;
    mtl_desc.resourceOptions = MTLResourceStorageModeManaged;
    mtl_desc.storageMode = MTLStorageModeManaged;

	// initialize MTLTextureDescritor with rendertarget attributes
	if (desc.render_target) {
		// reset the cpuCacheMode to 'default'
		mtl_desc.cpuCacheMode = MTLCPUCacheModeDefaultCache;
		// render targets are only visible to the GPU
		mtl_desc.resourceOptions = MTLResourceStorageModePrivate;
		mtl_desc.storageMode = MTLStorageModePrivate;
		// render targets are shader-readable
		mtl_desc.usage = MTLTextureUsageShaderRead | MTLTextureUsageRenderTarget;
	}

	_mtl_image img;
	
    // special case depth-stencil-buffer
    if (desc.pixel_format == pixel_format_depth_stencil || desc.pixel_format == pixel_format_stencil) {
        assert(desc.render_target);

        id<MTLTexture> tex = [layer.device newTextureWithDescriptor:mtl_desc];
		RENDERKIT_ASSERT(tex != nil);
//		img.depth_tex = _mtl_add_resource(tex);
		img.depth_tex = tex;
		RENDERKIT_UNREACHABLE;
    } else {
        id<MTLTexture> tex = [layer.device newTextureWithDescriptor:mtl_desc];
		if (desc.usage == usage_immutable && !desc.render_target) {
			MTLRegion region = MTLRegionMake2D(0, 0, desc.width, desc.height);
			[tex replaceRegion:region
				   mipmapLevel:0
						 slice:0
					 withBytes:desc.content
				   bytesPerRow:desc.width * 4
				 bytesPerImage:desc.height * desc.width * 4];
		}
		
        // create (possibly shared) sampler state
        img.sampler_state = _mtl_create_sampler(layer.device, desc);
		img.tex = tex;
    }
	
	return img;
}

void metal_destroy_image(uint16_t img_index) {}

void metal_update_image(uint16_t img_index, void* arg1) {}

void metal_bind_image(uint16_t img_index, uint32_t arg1) {}


void metal_begin_pass(uint16_t pass_index, ClearCommand_t clear, int w, int h) {
    in_pass = true;
    cur_width = w;
    cur_height = h;

    // if this is the first pass in the frame, create a command buffer
    if (cmd_buffer == nil) {
        // block until the oldest frame in flight has finished
        dispatch_semaphore_wait(render_semaphore, DISPATCH_TIME_FOREVER);
        cmd_buffer = [cmd_queue commandBufferWithUnretainedReferences];
    }

    // initialize a render pass descriptor
    MTLRenderPassDescriptor *pass_desc = nil;
    if (pass_index > 0) { // offscreen render pass
        pass_desc = [MTLRenderPassDescriptor renderPassDescriptor];
    } else {
        pass_desc = [MTLRenderPassDescriptor renderPassDescriptor];
        // only do this once per frame. a pass to the framebuffer can be done multiple times in a frame.
        if (cur_drawable == nil)
            cur_drawable = [layer nextDrawable];
        pass_desc.colorAttachments[0].texture = cur_drawable.texture;
    }

    // default pass descriptor will not be valid if window is minimized
    if (pass_desc == nil) {
        pass_valid = false;
        return;
    }
    pass_valid = true;

    // setup pass descriptor for backbuffer or offscreen rendering
    if (pass_index > 0) {
    } else {
        pass_desc.colorAttachments[0].clearColor = MTLClearColorMake(clear.color[0], clear.color[1], clear.color[2], clear.color[3]);
        pass_desc.colorAttachments[0].loadAction  = _mtl_load_action(clear.color_action);
        pass_desc.depthAttachment.loadAction = _mtl_load_action(clear.depth_action);
        pass_desc.depthAttachment.clearDepth = clear.depth;
        pass_desc.stencilAttachment.loadAction = _mtl_load_action(clear.stencil_action);
        pass_desc.stencilAttachment.clearStencil = clear.stencil;
    }

    // create a render command encoder, this might return nil if window is minimized
    cmd_encoder = [cmd_buffer renderCommandEncoderWithDescriptor:pass_desc];
    if (cmd_encoder == nil) {
        pass_valid = false;
        return;
    }
}

void metal_end_pass() {
    in_pass = false;
    pass_valid = false;
    if (cmd_encoder != nil) {
        [cmd_encoder endEncoding];
        cmd_encoder = nil;
    }
}

void metal_commit_frame() {
    assert(!pass_valid);
    assert(cmd_encoder == nil);
    assert(cmd_buffer != nil);

    // present, commit and signal semaphore when done
    [cmd_buffer presentDrawable:cur_drawable];
    [cmd_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
        dispatch_semaphore_signal(render_semaphore);
    }];
    [cmd_buffer commit];
    cmd_buffer = nil;
    cur_drawable = nil;
}
