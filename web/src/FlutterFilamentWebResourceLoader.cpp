#include "FlutterFilamentWebResourceLoader.h"
#include "ResourceBuffer.hpp"
#include <thread>
#include <mutex>
#include <future>
#include <iostream>


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

    // std::unique_lock<std::mutex> lock(mutex_);
    // while (!notified_)
    // {
      // std::this_thread::sleep_for(std::chrono::seconds(1));
      // std::cout << "sleep" << std::endl;
        // cv_.wait(lock); /
    // }
  }

  void HandleResponse(void* data, int32_t length)
  {
    std::cout << "GOT CALLBACK FOR DATA OF LENGTH" << length  << std::endl;
    prom.set_value(69);
    // std::cout << "data is " << (char*) data << std::endl;
    // notified_ = true;
    // cv_.notify_one();
  }

private:
  std::mutex mutex_;
  std::condition_variable cv_;
  bool notified_ = false;
  std::promise<int> prom;

};

static LoadFilamentResource _load_resource_callback = nullptr;
static Dart_Port _callback_port;


extern "C"
{

  extern void loadResourceToBuffer(void* context);

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_load_resource_callback(void* data, int32_t length, void* context) {
    ((PendingCall*)context)->HandleResponse(data, length);
  }

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_set(char* ptr, int32_t offset, int32_t val) {
    // std::cout << "setting offset " << offset << " to char "  << (char) val << " at address " << (void*)ptr << std::endl;
    memset(ptr+offset, val, 1);
  }

  FLUTTER_PLUGIN_EXPORT void* flutter_filament_web_allocate(int32_t size) {
    char* allocated = (char*)calloc(size, 1);
    // std::cout << "Allocated " << size << " bytes at address " << allocated << std::endl;
    // allocated[0] = '7';
    // std::cout << "Set val to " << allocated[0] << std::endl;
    return allocated;
  }

  static std::thread* _t;

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_set_load_resource_fn(void* fn)
  {

    auto pendingCall = new PendingCall();
    
   loadResourceToBuffer((void*)pendingCall);  
    _t = new std::thread([=] {
      
      std::cout << "call finished " << std::endl;
      pendingCall->Wait();
      std::cout << "wait finished " << std::endl;
      // std::cout << "call finished " << std::endl;
      
    });

    // _load_resource_callback = (LoadFilamentResource)callback;
  }
}