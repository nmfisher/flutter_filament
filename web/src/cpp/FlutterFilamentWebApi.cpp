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
    std::future<int> accumulate_future = prom.get_future();
    std::cout << accumulate_future.get() << std::endl;
  }

  void HandleResponse(void* data, int32_t length)
  {
    this->data = data;
    this->length = length;
    std::cout << "GOT CALLBACK FOR DATA OF LENGTH" << length  << std::endl;
    prom.set_value(69);
  }
void* data = nullptr;
int32_t length = 0;

private:
  std::mutex mutex_;
  std::condition_variable cv_;
  bool notified_ = false;
  std::promise<int> prom;
  

};

using emscripten::val;

extern "C"
{

  // extern void loadResourceToBuffer(void* context);
  
  EMSCRIPTEN_WEBGL_CONTEXT_HANDLE context;

  FLUTTER_PLUGIN_EXPORT int main() {
    std::cout << "main called, is main runtime thread " << emscripten_is_main_runtime_thread() << std::endl;
    
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
    std::cout << "flutter_filament_web_create_gl_context called, is main runtime thread " << emscripten_is_main_runtime_thread() << std::endl;
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
    std::cout << "created context  " << context << " with major/minor ver " << attr.majorVersion << " " << attr.minorVersion << std::endl;

    auto success = emscripten_webgl_make_context_current((EMSCRIPTEN_WEBGL_CONTEXT_HANDLE)context);
      if(success != EMSCRIPTEN_RESULT_SUCCESS) {
        std::cout << "failed to make context current  " << std::endl;
      }
    glClearColor(0.1f, 0.5f, 0.7f, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    emscripten_webgl_commit_frame();
    emscripten_webgl_make_context_current((EMSCRIPTEN_WEBGL_CONTEXT_HANDLE)NULL);


    return context;
  }

  int _lastResourceId = 0;

  FLUTTER_PLUGIN_EXPORT ResourceBuffer flutter_filament_web_load_resource(const char* path)
  {

    std::cout << "Loading asset " << path << std::endl;
    emscripten_fetch_attr_t attr;
    emscripten_fetch_attr_init(&attr);
    attr.onsuccess = [](emscripten_fetch_t* fetch) {
      std::cout << "FINISHED" << std::endl;
    };
    attr.onerror = [](emscripten_fetch_t* fetch) {
      std::cout << "ERROR" << std::endl;
    };
    attr.onprogress = [](emscripten_fetch_t* fetch) {
      std::cout << "progress" << std::endl;
    };
    attr.onreadystatechange = [](emscripten_fetch_t* fetch) {
      std::cout << "readyustatechanged" << std::endl;
    };
    attr.attributes = EMSCRIPTEN_FETCH_LOAD_TO_MEMORY | EMSCRIPTEN_FETCH_SYNCHRONOUS;
    auto pathString = std::string("http://localhost:8080/assets/");
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
    std::cout << "Closed " << std::endl;
    return rb;
  }

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_free_resource(ResourceBuffer rb) {
    std::cout << "FREE" << std::endl;
  }

  FLUTTER_PLUGIN_EXPORT void* const flutter_filament_web_get_resource_loader_wrapper() {
    auto resourceLoader = new ResourceLoaderWrapper(flutter_filament_web_load_resource, flutter_filament_web_free_resource);
    // resourceLoader->load("assets/web/foo.txt");
    return resourceLoader;
  }
}