#ifndef _FLUTTER_FILAMENT_WEB_RESOURCE_LOADER_H
#define _FLUTTER_FILAMENT_WEB_RESOURCE_LOADER_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#include <emscripten/emscripten.h>
#include <emscripten/html5_webgl.h>


#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default"))) 

#ifdef __cplusplus
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void flutter_filament_web_load_resource_callback(void* data, int32_t length, void* context);
FLUTTER_PLUGIN_EXPORT char flutter_filament_web_get(char* ptr, int32_t offset);
FLUTTER_PLUGIN_EXPORT void flutter_filament_web_set(char* ptr, int32_t offset, int32_t val);
FLUTTER_PLUGIN_EXPORT void* flutter_filament_web_get_address(void** out);
FLUTTER_PLUGIN_EXPORT void* flutter_filament_web_allocate(int32_t size);
FLUTTER_PLUGIN_EXPORT void flutter_filament_web_free(void* ptr);
EMSCRIPTEN_WEBGL_CONTEXT_HANDLE flutter_filament_web_create_gl_context();
FLUTTER_PLUGIN_EXPORT void* const flutter_filament_web_get_resource_loader_wrapper();

#ifdef __cplusplus
}
#endif

#endif