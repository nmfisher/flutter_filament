#include "FlutterFilamentWebApi.h"
#include "ResourceBuffer.hpp"

#include <thread>
#include <mutex>
#include <future>
#include <iostream>

#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <emscripten/emscripten.h>
#include <emscripten/html5.h>
#include <emscripten/threading.h>
#include <emscripten/val.h>
#include <emscripten/fetch.h>

class PendingCall
{
public:
  PendingCall()
  {
  }
  ~PendingCall() {}

  void Wait()
  {
    std::future<void*> accumulate_future = prom.get_future();
  }

  void HandleResponse(void* data, int32_t length)
  {
    this->data = data;
    this->length = length;
    prom.set_value(data);
  }
void* data = nullptr;
int32_t length = 0;

private:
  std::mutex mutex_;
  std::condition_variable cv_;
  bool notified_ = false;
  std::promise<void*> prom;

};

using emscripten::val;

extern "C"
{

 
  EMSCRIPTEN_WEBGL_CONTEXT_HANDLE context;

  // 
  // Since are using -sMAIN_MODULE with -sPTHREAD_POOL_SIZE=1, main will be called when the first worker is spawned
  //
  FLUTTER_PLUGIN_EXPORT int main() {
    return 0;
  }

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_load_resource_callback(void* data, int32_t length, void* context) {
    ((PendingCall*)context)->HandleResponse(data, length);
  }

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_set(char* ptr, int32_t offset, int32_t val) {
    memset(ptr+offset, val, 1);
  }

  FLUTTER_PLUGIN_EXPORT void* flutter_filament_web_allocate(int32_t size) {
    char* allocated = (char*)calloc(size, 1);
    return allocated;
  }

  FLUTTER_PLUGIN_EXPORT void* flutter_filament_web_get_address(void** out) {
    return *out;
  }

  FLUTTER_PLUGIN_EXPORT EMSCRIPTEN_WEBGL_CONTEXT_HANDLE  flutter_filament_web_create_gl_context() {
    EmscriptenWebGLContextAttributes attr;
    
    emscripten_webgl_init_context_attributes(&attr);
    attr.alpha = EM_FALSE;
    attr.depth = EM_TRUE;
    attr.antialias = EM_FALSE;
    attr.explicitSwapControl = EM_FALSE;
    attr.preserveDrawingBuffer = EM_TRUE;
    attr.proxyContextToMainThread = EMSCRIPTEN_WEBGL_CONTEXT_PROXY_ALWAYS;
    // attr.renderViaOffscreenBackBuffer = EM_FALSE;
    attr.majorVersion = 2;
    
    context = emscripten_webgl_create_context("#canvas", &attr);
    std::cout << "Created WebGL context with major/minor " << attr.majorVersion << "." << attr.minorVersion << std::endl;

    auto success = emscripten_webgl_make_context_current((EMSCRIPTEN_WEBGL_CONTEXT_HANDLE)context);
    if(success != EMSCRIPTEN_RESULT_SUCCESS) {

    }
    emscripten_webgl_make_context_current((EMSCRIPTEN_WEBGL_CONTEXT_HANDLE)NULL);
    return context;
  }

  int _lastResourceId = 0;

  FLUTTER_PLUGIN_EXPORT ResourceBuffer flutter_filament_web_load_resource(const char* path)
  {
    emscripten_fetch_attr_t attr;
    emscripten_fetch_attr_init(&attr);
    attr.onsuccess = [](emscripten_fetch_t* fetch) {
      
    };
    attr.onerror = [](emscripten_fetch_t* fetch) {
      
    };
    attr.onprogress = [](emscripten_fetch_t* fetch) {
      
    };
    attr.onreadystatechange = [](emscripten_fetch_t* fetch) {
      
    };
    attr.attributes = EMSCRIPTEN_FETCH_LOAD_TO_MEMORY | EMSCRIPTEN_FETCH_SYNCHRONOUS;
    auto pathString = std::string("assets/");
    pathString += std::string(path);
    auto request = emscripten_fetch(&attr, pathString.c_str());
    
    if(!request) {
      std::cout << "Request failed?" << std::endl;  
    }
    auto data = malloc(request->numBytes);
    memcpy(data, request->data, request->numBytes);
    // send a get request
    auto rb = ResourceBuffer { data, (int32_t) request->numBytes, _lastResourceId  } ;
    _lastResourceId++;
    emscripten_fetch_close(request);
    return rb;
  }

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_free_resource(ResourceBuffer rb) {
    free(rb.data);
  }

  FLUTTER_PLUGIN_EXPORT void* const flutter_filament_web_get_resource_loader_wrapper() {
    return new ResourceLoaderWrapper(flutter_filament_web_load_resource, flutter_filament_web_free_resource)
  }
}