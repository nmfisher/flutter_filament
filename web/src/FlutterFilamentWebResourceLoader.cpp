#include "FlutterFilamentWebResourceLoader.h"
#include "ResourceBuffer.hpp"
#include <thread>
#include <mutex>
#include <future>
#include <iostream>
#include "dart/dart_api_dl.h"

class PendingCall
{
public:
  PendingCall(void **buffer, int32_t *length)
      : response_buffer_(buffer), response_length_(length)
  {
  }
  ~PendingCall() {}

  void Complete()
  {
    notified_ = true;
    cv_.notify_one();
    std::cout << "COPLETED" << std::endl;
    std::cout << "Got length " << *response_length_ << std::endl;
    prom.set_value(69); // Notify future
  }

  void Wait()
  {
    // std::future<int> accumulate_future = prom.get_future();
    // std::cout << accumulate_future.get() << std::endl;

    // std::unique_lock<std::mutex> lock(mutex_);
    while (!notified_)
    {
      std::this_thread::sleep_for(std::chrono::seconds(1));
      //   cv_.wait(lock);
    }
  }

  static void HandleResponse()//void *userData)
  {
    std::cout << "RESPONE HANDLED!" << std::endl;
    // auto pendingCall = reinterpret_cast<PendingCall *>(userData);
    // pendingCall->Complete();
  }

private:
  std::mutex mutex_;
  std::condition_variable cv_;
  bool notified_ = false;
  std::promise<int> prom;

  void **response_buffer_;
  int32_t *response_length_;
};

static LoadFilamentResource _load_resource_callback = nullptr;
static Dart_Port _callback_port;


extern "C"
{

  FLUTTER_PLUGIN_EXPORT intptr_t flutter_filament_web_init_dart_api_dl(void* data) {
    return Dart_InitializeApiDL(data);
  }

  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_register_ports(Dart_Port callback_port) {
    _callback_port = callback_port;
  }


  FLUTTER_PLUGIN_EXPORT void flutter_filament_web_set_load_resource_fn(void *loadResource)
  {

    std::cout << "SETTING LOAD RESOURCE FN" << std::endl;

    Dart_CObject dart_object;
    dart_object.type = Dart_CObject_kBool;
    dart_object.value.as_bool = true;
    
    const bool result = Dart_PostCObject_DL(_callback_port, &dart_object);
    
    std::cout << "Callback to port success : " << result << std::endl;
    
    // auto fn = (void(*)())loadResource;
    // fn();

    // void** responseBuffer = nullptr;
    // int32_t responseLength = 0;

    // PendingCall pendingCall(responseBuffer, &responseLength);

    // auto fn = (void(*)(void* data, int32_t* len, void* callback, void* userData))loadResource;

    // fn((void*)responseBuffer, &responseLength, (void*)&(pendingCall.HandleResponse), &pendingCall);

    // pendingCall.Wait();

    // std::cout << "Got length " << responseLength << std::endl;

    // _load_resource_callback = (LoadFilamentResource)callback;
  }
}