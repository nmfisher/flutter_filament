import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_filament/entities/entity_transform_controller.dart';
import 'package:flutter_filament/filament_controller.dart';

class HardwareKeyboardPoll {
  final EntityTransformController _controller;
  late Timer _timer;
  HardwareKeyboardPoll(this._controller) {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      print(RawKeyboard.instance.keysPressed);
      if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyW)) {
        _controller.forwardPressed();
      } else {
        _controller.forwardReleased();
      }

      if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyS)) {
        _controller.backPressed();
      } else {
        _controller.backReleased();
      }

      if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyA)) {
        _controller.strafeLeftPressed();
      } else {
        _controller.strafeLeftReleased();
      }

      if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyD)) {
        _controller.strafeRightPressed();
      } else {
        _controller.strafeRightReleased();
      }
    });
  }

  void dispose() {
    _timer.cancel();
  }
}