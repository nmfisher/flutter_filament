#ifndef UNLIT_MATERIAL_PROVIDER
#define UNLIT_MATERIAL_PROVIDER

#include "material/standard.h"

namespace polyvox {
  class StandardMaterialProvider : public MaterialProvider {

      const Material* _m;
      const Material* _ms[1];

      const Engine* _engine;

      public:
        StandardMaterialProvider(Engine* engine) {
          _engine = engine;
          _m = Material::Builder()
            .package(	STANDARD_STANDARD_DATA, STANDARD_STANDARD_SIZE)
            .build(*engine);
          _ms[0] = _m;
        }

        filament::MaterialInstance* createMaterialInstance(MaterialKey* config, UvMap* uvmap,
                const char* label = "material", const char* extras = nullptr) {
          MaterialInstance* d = (MaterialInstance*)_m->getDefaultInstance();
          return d;
        }

        /**
        * Gets a weak reference to the array of cached materials.
        */
        const filament::Material* const* getMaterials() const noexcept {
          return _ms;
        }

        /**
        * Gets the number of cached materials.
        */
        size_t getMaterialsCount() const noexcept {
          return (size_t)1;
        }

        void destroyMaterials() {
          // TODO - do we need to do anything here?
        }

        bool needsDummyData(filament::VertexAttribute attrib) const noexcept {
          return false;
        }
  };
}

#endif