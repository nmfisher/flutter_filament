// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_filament/ffi/ffi_web/generated_bindings_web.dart';
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

@pragma("wasm:export")
void loadFlutterAsset(Pointer<Char> path, Pointer<Void> context) async {
  final codeUnits = path.cast<Uint8>();
  var length = 0;
  var bytes = <int>[];
  int i = 0;
  while (true) {
    var val = flutter_filament_web_get(path, i);
    i++;
    if (val != 0) {
      bytes.add(val);
    } else {
      break;
    }
  }
  var pathString = utf8.decode(bytes);

  var bd = await rootBundle.load(pathString);

  var dataPtr = Pointer<Char>.fromAddress(
      flutter_filament_web_allocate(bd.lengthInBytes));

  for (int i = 0; i < bd.lengthInBytes; i++) {
    flutter_filament_web_set(dataPtr, i, bd.getUint8(i));
  }
  flutter_filament_web_load_resource_callback(
      dataPtr.cast<Void>(), bd.lengthInBytes, context);
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
        print("Creating gl context");
        var context = flutter_filament_web_create_gl_context();
        return [0, 0, 0, context];
      case "getResourceLoaderWrapper":
        return flutter_filament_web_get_resource_loader_wrapper();
      case "getRenderCallback":
        return [0, 0];
      case "destroyTexture":
        return true;
    }
  }
}
