#include "FlutterFilamentWebApi.h"
#include "ResourceBuffer.hpp"
#include <thread>
#include <mutex>
#include <future>
#include <iostream>
#include <GL/gl.h>
#include <emscripten/emscripten.h>
#include <emscripten/html5.h>
#include <emscripten/threading.h>
#include <emscripten/val.h>

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
    std::cout << "GOT CALLBACK FOR DATA OF LENGTH" << length  << std::endl;
    prom.set_value(69);
  }

private:
  std::mutex mutex_;
  std::condition_variable cv_;
  bool notified_ = false;
  std::promise<int> prom;

};

using emscripten::val;

extern "C"
{

  extern void loadResourceToBuffer(void* context);
  
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

  static std::thread* _t;

  FLUTTER_PLUGIN_EXPORT EMSCRIPTEN_WEBGL_CONTEXT_HANDLE  flutter_filament_web_create_gl_context() {
        std::cout << "flutter_filament_web_create_gl_context called, is main runtime thread " << emscripten_is_main_runtime_thread() << std::endl;

    EmscriptenWebGLContextAttributes attr;
    emscripten_webgl_init_context_attributes(&attr);
    attr.explicitSwapControl = EM_TRUE;
    context = emscripten_webgl_create_context("#canvas", &attr);
    emscripten_webgl_make_context_current(context);
    double color = 0;
    for(int i = 0; i < 100; ++i)
    {
      color += 0.01;
      glClearColor(0, color, 0.0, 1);
      glClear(GL_COLOR_BUFFER_BIT);
      EMSCRIPTEN_RESULT r = emscripten_webgl_commit_frame();
      double now = emscripten_get_now();
      while(emscripten_get_now() - now < 100) /*no-op*/;
    }
    return context;
  }

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_set_load_resource_fn(void* fn)
  {

    auto pendingCall = new PendingCall();

    
   loadResourceToBuffer((void*)pendingCall);  
    _t = new std::thread([=] {
      
      std::cout << "call finished " << std::endl;
      pendingCall->Wait();
      std::cout << "wait finished " << std::endl;
      
    });

  }
}