export 'web_wasm/ffi_web_wasm.dart'
    if (dart.library.html) 'web_js/ffi_web_js.dart'
    if (dart.library.io) 'ffi_native/ffi_native.dart';
