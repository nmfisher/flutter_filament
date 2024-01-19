// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_filament/ffi/ffi.dart';

/// A web implementation of the FlutterFilamentPlatform of the FlutterFilament plugin.
class FlutterFilamentPluginWeb {
  static final _isInitialized = Completer<bool>();
  static Future get isInitialized => _isInitialized.future;

  static void registerWith(Registrar registrar) async {
    final MethodChannel channel = MethodChannel("app.polyvox.filament/event",
        const StandardMethodCodec(), registrar.messenger);
    final FlutterFilamentPluginWeb instance = FlutterFilamentPluginWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
    await initializeBindings(rootBundle);
    _isInitialized.complete(true);
  }

  Future handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "createTexture":
        // we could create the WebGL context here (i.e. on the main/Flutter thread):
        // var context = flutter_filament_web_create_gl_context();
        // however, this leads to unstable behaviour
        // which seem to be avoided if we create the context on the FFI thread (see FlutterFilamentFFIApi.cpp)
        // (it's uglier, but it works)
        // so here, we just return nullptr
        var context = 0;
        return [0, 0, 0, context];
      case "getResourceLoaderWrapper":
        final ptr = flutter_filament_web_get_resource_loader_wrapper();
        return ptr.address;
      case "getRenderCallback":
        return [0, 0];
      case "destroyTexture":
        return true;
    }
  }
}
