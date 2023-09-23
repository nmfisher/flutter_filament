#ifndef RESOURCE_BUFFER_H
#define RESOURCE_BUFFER_H

#include <stdint.h>
#if defined(__cplusplus)
#include "Log.hpp"
extern "C" {
#endif
    // 
    // Pairs a memory buffer with an ID that can be used to unload the backing asset if needed.
    // Use this when you want to load an asset from a resource that requires more than just `free` on the underlying buffer.
    // e.g. 
    // ```
    // uint64_t id = get_next_resource_id();
    // AAsset *asset = AAssetManager_open(am, name, AASSET_MODE_BUFFER);
    // off_t length = AAsset_getLength(asset);
    // const void * buffer = AAsset_getBuffer(asset);
    // uint8_t *buf = new uint8_t[length ];
    // memcpy(buf,buffer,  length);
    // ResourceBuffer rb(buf, length, id);
    // ...
    // ...
    // (elsewhere)
    // AAsset* asset = get_asset_from_id(rb.id);
    // AAsset_close(asset);
    // free_asset_id(rb.id);
    //
    struct ResourceBuffer {
        #if defined(__cplusplus)
        ResourceBuffer(const void* const data, const uint32_t size, const uint32_t id) : data(data), size(size), id(id) {};
        #endif
        const void * const data;
        const uint32_t size;
        const uint32_t id;
    };

    typedef struct ResourceBuffer ResourceBuffer;
    typedef ResourceBuffer (*FlutterFilamentLoadResource)(const char* uri);
    typedef ResourceBuffer (*LoadFilamentResourceFromOwner)(const char* const, void* const owner);
    typedef void (*FlutterFilamentFreeResource)(ResourceBuffer);
    typedef void (*FreeFilamentResourceFromOwner)(ResourceBuffer, void* const owner);
    
    // this may be compiled as either C or C++, depending on which compiler is being invoked (e.g. binding to Swift will compile as C).
    // the former does not allow default initialization to be specified inline), so we need to explicitly set the unused members to nullptr
    struct ResourceLoaderWrapper {
      #if defined(__cplusplus)
        ResourceLoaderWrapper(FlutterFilamentLoadResource loader, FlutterFilamentFreeResource freeResource) : mLoadResource(loader), mFreeResource(freeResource), mLoadFilamentResourceFromOwner(nullptr), mFreeFilamentResourceFromOwner(nullptr),
        mOwner(nullptr) {}
        
        ResourceLoaderWrapper(LoadFilamentResourceFromOwner loader, FreeFilamentResourceFromOwner freeResource, void* const owner) : mLoadResource(nullptr), mFreeResource(nullptr), mLoadFilamentResourceFromOwner(loader), mFreeFilamentResourceFromOwner(freeResource), mOwner(owner) {
            
        };

        ResourceBuffer load(const char* uri) const {
          if(mLoadFilamentResourceFromOwner) {
            return mLoadFilamentResourceFromOwner(uri, mOwner);
          }
          return mLoadResource(uri);
        }

        void free(ResourceBuffer rb) const {
          if(mFreeFilamentResourceFromOwner) {
            mFreeFilamentResourceFromOwner(rb, mOwner);
          } else {
            mFreeResource(rb);
          }
        }
      #endif
        FlutterFilamentLoadResource mLoadResource;
        FlutterFilamentFreeResource mFreeResource;
        LoadFilamentResourceFromOwner mLoadFilamentResourceFromOwner;
        FreeFilamentResourceFromOwner mFreeFilamentResourceFromOwner;
        void* mOwner;
    };
    typedef struct ResourceLoaderWrapper ResourceLoaderWrapper;
    
    
#if defined(__cplusplus)
}
#endif
#endif
