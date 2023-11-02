// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_filament/generated_bindings.dart';

import 'dart:ffi';

@AbiSpecificIntegerMapping({
  Abi.androidArm: Uint8(),
  Abi.androidArm64: Uint8(),
  Abi.androidIA32: Int8(),
  Abi.androidX64: Int8(),
  Abi.androidRiscv64: Uint8(),
  Abi.fuchsiaArm64: Uint8(),
  Abi.fuchsiaX64: Int8(),
  Abi.fuchsiaRiscv64: Uint8(),
  Abi.iosArm: Int8(),
  Abi.iosArm64: Int8(),
  Abi.iosX64: Int8(),
  Abi.linuxArm: Uint8(),
  Abi.linuxArm64: Uint8(),
  Abi.linuxIA32: Int8(),
  Abi.linuxX64: Int8(),
  Abi.linuxRiscv32: Uint8(),
  Abi.linuxRiscv64: Uint8(),
  Abi.macosArm64: Int8(),
  Abi.macosX64: Int8(),
  Abi.windowsArm64: Int8(),
  Abi.windowsIA32: Int8(),
  Abi.windowsX64: Int8(),
})
final class FooChar extends AbiSpecificInteger {
  const FooChar();
}

void _loadResourceToBuffer(Pointer context) async {
  print("CALL");
  // _queue.add(Tuple4(out, length, callback, userData));
  var bd = await rootBundle.load("assets/web/foo.txt");

  var dataPtr = Pointer<Uint8>.fromAddress(
      flutter_filament_web_allocate(bd.lengthInBytes));

  for (int i = 0; i < bd.lengthInBytes; i++) {
    flutter_filament_web_set(dataPtr, i, bd.getUint8(i));
  }
  flutter_filament_web_load_resource_callback(
      dataPtr, bd.lengthInBytes, context);
}

@pragma("wasm:export")
void loadResourceToBuffer(Pointer context) {
  _loadResourceToBuffer(context);
}

/// A web implementation of the FlutterFilamentPlatform of the FlutterFilament plugin.
class FlutterFilamentPluginWeb {
  final _dummy = FooChar();

  FlutterFilamentPluginWeb() {}
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel("app.polyvox.filament/event",
        const StandardMethodCodec(), registrar.messenger);
    final FlutterFilamentPluginWeb instance = FlutterFilamentPluginWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "createTexture":
        return [0, 0, 0];
        // var flutterTextureId = platformMessage[0];

        // // void* on iOS (pointer to pixel buffer), Android (pointer to native window), null on macOS/Windows
        // var surfaceAddress = platformMessage[1] as int? ?? 0;

        // // null on iOS/Android, void* on MacOS (pointer to metal texture), GLuid on Windows/Linux
        // var nativeTexture = platformMessage[2] as int? ?? 0;
        return true;
      case "destroyTexture":
        return true;
    }
  }
}
