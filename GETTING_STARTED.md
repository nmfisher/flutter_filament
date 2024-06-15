# Thermion
Thermion is a package for creating 3D applications with Dart and/or Flutter.

## Overview

### Packages 
The two most relevant Thermion packages are:- [thermion_dart], which contains all the code needed to create a viewer, - [thermion_flutter], which is a Flutter-only package that contains all the logic necessary to create/embed a rendering surface inside a Flutter app. 
By decoupling the Flutter-specific components from the Dart-only components, Thermion can be used for rendering in both Flutter and non-Flutter applications. As far as the latter is concerned, Thermion ships with examples for  Javascript/WASM/HTML, and for CLI/headless mode on MacOS. 

### pubspec.yaml
If you are creating a Flutter application, add [thermion_flutter] as a dependency to your `pubspec.yaml`.
```$ cd /path/to/your/flutter/project$ flutter pub add thermion_flutter```

### ThermionFlutterPlugin
Create an instance of `ThermionFlutterPlugin` in your app.
```dart
class _MyAppState extends State<MyApp> {
  late ThermionFlutterPlugin _thermionFlutterPlugin;  late Future<ThermionViewer> _thermionViewer;
  void initState() {    _thermionFlutterPlugin = ThermionFlutterPlugin();    _thermionViewer = _thermionFlutterPlugin.createViewer();  }}```
`ThermionFlutterPlugin` is a singleton, and mostly just handles creating a 3D rendering surface that can be embedded in a Flutter widget hierarchy.  [ThermionViewer] is the interface for actually interacting with the scene (loading assets, manipulating the camera, and so on). Call `createViewer` on `ThermionFlutterPlugin` to obtain a reference to `ThermionViewer` (which is also a singleton).
Note: `ThermionFlutterPlugin` and `ThermionViewer` were designed as separate classes so we can use `ThermionViewer` in non-Flutter apps.
### ThermionWidget
On most platforms[0], [ThermionWidget] is the widget where your rendered content (i.e. your viewport) will appear. This can be any size; the 3D viewport will be scaled to fit the dimensions on this widget. On most platforms, a [ThermionWidget] can be positioned above or below any other widget in the hierarchy and the Z-order will be preserved.
```class _MyAppState extends State<MyApp> {
  late ThermionFlutterPlugin _thermionFlutterPlugin;  late Future<ThermionViewer> _thermionViewer;
  void initState() {    _thermionFlutterPlugin = ThermionFlutterPlugin();    _thermionViewer = _thermionFlutterPlugin.createViewer();  }    Widget build(BuildContext context) {       return Stack(children:[      Positioned.fill(        child:ThermionWidget(          plugin:_thermionFlutterPlugin        )      )    ]);  }}```

[0] Currently, the rendering surface on Windows and Web will always appear at the bottom of the application. You still need a ThermionWidget, but this only keeps track of the dimensions of your viewport and punches a transparent hole in the hierarchy; the actual rendering surface is attached beneath the Flutter window.
`ThermionWidget` will not display the rendering surface (even an empty one) until the call to `createViewer` has been completed.
- by default a Container will be rendered with solid red. If you want to change this, pass a widget as the initial paramer to the ThermionWidget constructor.on the second frame, ThermionWidget will pass its dimensions/pixel ratio to the FilamentController

 You can then call createViewer to create:the rendering surface (on most platforms, a backing texture that will be registered with Flutter for use in a Texture widget)a rendering threada ThermionViewerFFI and an AssetManager, which will allow you to load assets/cameras/lighting/etc via the FilamentControllerafter an indeterminate number of frames, FilamentController will notify ThermionWidget when a rendering surface is available the viewportThermionWidget will replace the default initial Widget with the viewport (which will initially be solid black or white, depending on your platform).IMPORTANT: there will be a delay between adding a ThermionWidget, calling createViewer and the actual rendering viewport becoming available. This is why we fill ThermionWidget with red - to make it abundantly clear that you need to handle this asynchronous delay appropriately. Once createViewer has completed, the viewport is available for rendering.
Currently, the initial widget will also be displayed whenever the viewport is resized (including changing orientation on mobile and drag-to-resize on desktop). You probably want to change this from the default red.
Congratulations! You now have a scene. It's completely empty, so you probably want to add something visible.



