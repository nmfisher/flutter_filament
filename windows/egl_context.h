#ifndef _EGL_CONTEXT_H
#define _EGL_CONTEXT_H

#include "flutter_angle_texture.h"
#include "backend/platforms/PlatformEGL.h"

namespace flutter_filament {

class EGLContext : public FlutterRenderingContext {
public:
  EGLContext(flutter::PluginRegistrarWindows* pluginRegistrar, flutter::TextureRegistrar* textureRegistrar);
private:
  EGLContext _context = NULL;
  EGLConfig _eglConfig = NULL;
  EGLDisplay _eglDisplay = NULL;
  std::unique_ptr<FlutterAngleTexture> _active = nullptr;
  std::unique_ptr<FlutterAngleTexture> _inactive = nullptr;
  ID3D11Device* _D3D11Device = nullptr;
  ID3D11DeviceContext* _D3D11DeviceContext = nullptr;
  filament::backend::Platform* _platform = nullptr;
}

}

#endif