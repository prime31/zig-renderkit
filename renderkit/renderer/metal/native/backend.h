#pragma once

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#include "metal.h"


// sampler cache
typedef struct {
    TextureFilter_t min_filter;
    TextureFilter_t mag_filter;
    TextureWrap_t wrap_u;
    TextureWrap_t wrap_v;
    uintptr_t sampler_handle;
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

static mtl_sampler_cache_t sampler_cache;
static mtl_idpool_t idpool;

- (instancetype)initWithRendererDesc:(RendererDesc_t)desc {
    if (self = [super init]) {
        // setup the objectPool and its idpool
        idpool.num_slots = 2 *
            (
                2 * desc.pool_sizes.buffers +
                5 * desc.pool_sizes.texture +
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
        for (int i = idpool.num_slots-1; i >= 1; i--)
            idpool.free_queue[idpool.free_queue_top++] = (uint32_t)i;
        
        // a circular queue which holds release items (frame index when a resource is to be released, and the resource's pool index
        idpool.release_queue_front = 0;
        idpool.release_queue_back = 0;
        idpool.release_queue = (mtl_release_item_t*)malloc(idpool.num_slots * sizeof(mtl_release_item_t));
        for (uint32_t i = 0; i < idpool.num_slots; i++) {
            idpool.release_queue[i].frame_index = 0;
            idpool.release_queue[i].slot_index = 0;
        }
        
        memset(&sampler_cache, 0, sizeof(mtl_sampler_cache_t));
        sampler_cache.capacity = 20;
        const int size = sampler_cache.capacity * sizeof(mtl_sampler_cache_item_t);
        sampler_cache.items = (mtl_sampler_cache_item_t*) malloc(size);
        memset(sampler_cache.items, 0, size);
    }
    
    return self;
}

- (void)dealloc {
    free(sampler_cache.items);
    free(idpool.free_queue);
}

- (uint32_t)addResource:(id)res {
    if (nil == res) {
        return 0;
    }
    
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

- (void)addSamplerCacheItem:(const ImageDesc_t*)img_desc handle:(uintptr_t)sampler_handle {
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
    } else {
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
}

@end
