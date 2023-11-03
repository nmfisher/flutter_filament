// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

(async function () {
  let dart2wasm_runtime;
  let moduleInstance;
  try {
    var Module = {};
    
    Module['instantiateWasm'] = function(imports, successCallback) {
      imports["env"]["loadResourceToBuffer"] = (out, length, callback, userData) => { 
        return moduleInstance.exports.loadResourceToBuffer(out, length, callback, userData);
      }
      imports["env"]["__main_argc_argv"] = (argc, argv) => {
        console.log("main");
      }
      fetch('assets/assets/web/libflutter_filament_web.wasm', { credentials: 'same-origin' }).then(async (response)  => {
        var result = await WebAssembly.instantiateStreaming(response, imports);
        result.module["foo"] = "bar";
        console.log(result.module);
        successCallback(result.instance,result.module);
      });
      return {};
    }
    const imports = {"libflutter_filament":await libflutter_filament(Module)};;
    const dartModulePromise = WebAssembly.compileStreaming(fetch('main.dart.wasm'));
        
    dart2wasm_runtime = await import('./main.dart.mjs');
    moduleInstance = await dart2wasm_runtime.instantiate(dartModulePromise, imports);
  } catch (exception) {
    console.error(`Failed to fetch and instantiate wasm module: ${exception}`);
    console.error('See https://flutter.dev/wasm for more information.');
  }

  if (moduleInstance) {
    try {
      await dart2wasm_runtime.invoke(moduleInstance);
    } catch (exception) {
      console.error(`Exception while invoking test: ${exception}`);
    }
  }
})();
