import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_filament/filament_controller.dart';
import 'package:flutter_filament/widgets/filament_gesture_detector.dart';
import 'package:flutter_filament/widgets/filament_widget.dart';

class ExampleViewport extends StatelessWidget {
  final FilamentController? controller;
  final EdgeInsets padding;

  const ExampleViewport(
      {super.key, required this.controller, required this.padding});

  @override
  Widget build(BuildContext context) {
    return controller != null
        ? Padding(
            padding: padding,
            child: FilamentGestureDetector(
                showControlOverlay: true,
                controller: controller!,
                enablePick: !kIsWeb,
                enableGestures: true,
                child: FilamentWidget(
                  controller: controller!,
                )))
        : Container();
  }
}
