#ifndef _FLUTTER_FILAMENT_WEB_RESOURCE_LOADER_H
#define _FLUTTER_FILAMENT_WEB_RESOURCE_LOADER_H

#include "dart/dart_api_dl.h"

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default"))) 

#ifdef __cplusplus
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void flutter_filament_web_set_load_resource_fn(void* fn);

#ifdef __cplusplus
}
#endif

#endif