import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:animation_tools_dart/animation_tools_dart.dart';
import 'package:dart_filament/dart_filament/abstract_filament_viewer.dart';
import 'package:dart_filament/dart_filament/entities/filament_entity.dart';
import 'package:dart_filament/dart_filament/scene.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart_filament_js_extension_type.dart';

class JsInteropFilamentViewer implements AbstractFilamentViewer {
  late final DartFilamentJSShim _jsObject;

  JsInteropFilamentViewer(String globalPropertyName) {
    print(
        "Initializing interop viewer with global property $globalPropertyName");
    this._jsObject = globalContext.getProperty(globalPropertyName.toJS)
        as DartFilamentJSShim;
  }

  @override
  Future<bool> get initialized async {
    var inited = _jsObject.initialized;
    final JSBoolean result = await inited.toDart;
    return result.toDart;
  }

  @override
  Stream<FilamentPickResult> get pickResult {
    throw UnimplementedError();
  }

  @override
  bool get rendering => _jsObject.rendering;

  @override
  Future<void> setRendering(bool render) async {
    await _jsObject.setRendering(render).toDart;
  }

  @override
  Future<void> render() async {
    await _jsObject.render().toDart;
  }

  @override
  Future<void> setFrameRate(int framerate) async {
    await _jsObject.setFrameRate(framerate).toDart;
  }

  @override
  Future<void> dispose() async {
    await _jsObject.dispose().toDart;
  }

  @override
  Future<void> setBackgroundImage(String path,
      {bool fillHeight = false}) async {
    await _jsObject.setBackgroundImage(path, fillHeight).toDart;
  }

  @override
  Future<void> setBackgroundImagePosition(double x, double y,
      {bool clamp = false}) async {
    await _jsObject.setBackgroundImagePosition(x, y, clamp).toDart;
  }

  @override
  Future<void> clearBackgroundImage() async {
    await _jsObject.clearBackgroundImage().toDart;
  }

  @override
  Future<void> setBackgroundColor(
      double r, double g, double b, double alpha) async {
    await _jsObject.setBackgroundColor(r, g, b, alpha).toDart;
  }

  @override
  Future<void> loadSkybox(String skyboxPath) async {
    await _jsObject.loadSkybox(skyboxPath).toDart;
  }

  @override
  Future<void> removeSkybox() async {
    await _jsObject.removeSkybox().toDart;
  }

  @override
  Future<void> loadIbl(String lightingPath, {double intensity = 30000}) async {
    await _jsObject.loadIbl(lightingPath, intensity).toDart;
  }

  @override
  Future<void> rotateIbl(Matrix3 rotation) async {
    throw UnimplementedError();
    // final JSMatrix3 jsRotation = rotation.storage;
    // await _jsObject.rotateIbl(jsRotation).toDart;
  }

  @override
  Future<void> removeIbl() async {
    await _jsObject.removeIbl().toDart;
  }

  @override
  Future<FilamentEntity> addLight(
      int type,
      double colour,
      double intensity,
      double posX,
      double posY,
      double posZ,
      double dirX,
      double dirY,
      double dirZ,
      bool castShadows) async {
    return (await _jsObject
            .addLight(type, colour, intensity, posX, posY, posZ, dirX, dirY,
                dirZ, castShadows)
            .toDart)
        .toDartInt;
  }

  @override
  Future<void> removeLight(FilamentEntity light) async {
    await _jsObject.removeLight(light).toDart;
  }

  @override
  Future<void> clearLights() async {
    await _jsObject.clearLights().toDart;
  }

  @override
  Future<FilamentEntity> loadGlb(String path, {int numInstances = 1}) async {
    return (await _jsObject.loadGlb(path, numInstances).toDart).toDartInt;
  }

  @override
  Future<FilamentEntity> createInstance(FilamentEntity entity) async {
    return (await _jsObject.createInstance(entity).toDart).toDartInt;
  }

  @override
  Future<int> getInstanceCount(FilamentEntity entity) async {
    return (await _jsObject.getInstanceCount(entity).toDart).toDartInt;
  }

  @override
  Future<List<FilamentEntity>> getInstances(FilamentEntity entity) async {
    throw UnimplementedError();
    // final List<JSObject> jsInstances =
    //     await _jsObject.getInstances(entity).toDart;
    // return jsInstances
    //     .map((js) => FilamentEntity._fromJSObject(js))
    //     .toList()
    //     .toDart;
  }

  @override
  Future<FilamentEntity> loadGltf(String path, String relativeResourcePath,
      {bool force = false}) async {
    throw UnimplementedError();
    // final FilamentEntity jsEntity = await _jsObject
    //     .loadGltf(path, relativeResourcePath, force: force)
    //     .toDart;
    // return FilamentEntity._fromJSObject(jsEntity).toDart;
  }

  @override
  Future<void> panStart(double x, double y) async {
    await _jsObject.panStart(x, y).toDart;
  }

  @override
  Future<void> panUpdate(double x, double y) async {
    await _jsObject.panUpdate(x, y).toDart;
  }

  @override
  Future<void> panEnd() async {
    await _jsObject.panEnd().toDart;
  }

  @override
  Future<void> rotateStart(double x, double y) async {
    await _jsObject.rotateStart(x, y).toDart;
  }

  @override
  Future<void> rotateUpdate(double x, double y) async {
    await _jsObject.rotateUpdate(x, y).toDart;
  }

  @override
  Future<void> rotateEnd() async {
    await _jsObject.rotateEnd().toDart;
  }

  @override
  Future<void> setMorphTargetWeights(
      FilamentEntity entity, List<double> weights) async {
    throw UnimplementedError();

    //     JSArray<JSNumber>.withLength(weights.length)
    // await _jsObject.setMorphTargetWeights(entity, weights.toJSBox as JSArray<JSNumber>).toDart;
  }

  @override
  Future<List<String>> getMorphTargetNames(
      FilamentEntity entity, String meshName) async {
    var result = _jsObject.getMorphTargetNames(entity, meshName).toDart;
    var dartResult = (await result).toDart;
    return dartResult.map((r) => r.toDart).toList();
  }

  @override
  Future<List<String>> getAnimationNames(FilamentEntity entity) async {
    var names = (await (_jsObject.getAnimationNames(entity).toDart))
        .toDart
        .map((x) => x.toDart)
        .toList();
    return names;
  }

  @override
  Future<double> getAnimationDuration(
      FilamentEntity entity, int animationIndex) async {
    return (await _jsObject.getAnimationDuration(entity, animationIndex).toDart)
        .toDartDouble;
  }

  @override
  Future<void> setMorphAnimationData(
      FilamentEntity entity, MorphAnimationData animation,
      {List<String>? targetMeshNames}) async {
    await _jsObject
        .setMorphAnimationData(
            entity,
            animation.data
                .map((x) => x.map((y) => y.toJS).toList().toJS)
                .toList()
                .toJS,
            animation.morphTargets.map((x) => x.toJS).toList().toJS,
            targetMeshNames?.map((x) => x.toJS).toList().toJS)
        .toDart;
  }

  @override
  Future<void> resetBones(FilamentEntity entity) async {
    await _jsObject.resetBones(entity).toDart;
  }

  @override
  Future<void> addBoneAnimation(
      FilamentEntity entity, BoneAnimationData animation) async {
    throw UnimplementedError();
    // await _jsObject.addBoneAnimation(entity, animation).toDart;
  }

  @override
  Future<void> removeEntity(FilamentEntity entity) async {
    await _jsObject.removeEntity(entity).toDart;
  }

  @override
  Future<void> clearEntities() async {
    await _jsObject.clearEntities().toDart;
  }

  @override
  Future<void> zoomBegin() async {
    await _jsObject.zoomBegin().toDart;
  }

  @override
  Future<void> zoomUpdate(double x, double y, double z) async {
    await _jsObject.zoomUpdate(x, y, z).toDart;
  }

  @override
  Future<void> zoomEnd() async {
    await _jsObject.zoomEnd().toDart;
  }

  @override
  Future<void> playAnimation(FilamentEntity entity, int index,
      {bool loop = false,
      bool reverse = false,
      bool replaceActive = true,
      double crossfade = 0.0}) async {
    await _jsObject
        .playAnimation(entity, index, loop, reverse, replaceActive, crossfade)
        .toDart;
  }

  @override
  Future<void> playAnimationByName(FilamentEntity entity, String name,
      {bool loop = false,
      bool reverse = false,
      bool replaceActive = true,
      double crossfade = 0.0}) async {
    await _jsObject
        .playAnimationByName(
            entity, name, loop, reverse, replaceActive, crossfade)
        .toDart;
  }

  @override
  Future<void> setAnimationFrame(
      FilamentEntity entity, int index, int animationFrame) async {
    await _jsObject.setAnimationFrame(entity, index, animationFrame).toDart;
  }

  @override
  Future<void> stopAnimation(FilamentEntity entity, int animationIndex) async {
    await _jsObject.stopAnimation(entity, animationIndex).toDart;
  }

  @override
  Future<void> stopAnimationByName(FilamentEntity entity, String name) async {
    await _jsObject.stopAnimationByName(entity, name).toDart;
  }

  @override
  Future<void> setCamera(FilamentEntity entity, String? name) async {
    await _jsObject.setCamera(entity, name).toDart;
  }

  @override
  Future<void> setMainCamera() async {
    await _jsObject.setMainCamera().toDart;
  }

  @override
  Future<FilamentEntity> getMainCamera() async {
    throw UnimplementedError();
    // final FilamentEntity jsEntity = await _jsObject.getMainCamera().toDart;
    // return FilamentEntity._fromJSObject(jsEntity).toDart;
  }

  @override
  Future<void> setCameraFov(double degrees, double width, double height) async {
    await _jsObject.setCameraFov(degrees, width, height).toDart;
  }

  @override
  Future<void> setToneMapping(ToneMapper mapper) async {
    await _jsObject.setToneMapping(mapper.index).toDart;
  }

  @override
  Future<void> setBloom(double bloom) async {
    await _jsObject.setBloom(bloom).toDart;
  }

  @override
  Future<void> setCameraFocalLength(double focalLength) async {
    await _jsObject.setCameraFocalLength(focalLength).toDart;
  }

  @override
  Future<void> setCameraCulling(double near, double far) async {
    await _jsObject.setCameraCulling(near, far).toDart;
  }

  @override
  Future<double> getCameraCullingNear() async {
    return (await _jsObject.getCameraCullingNear().toDart).toDartDouble;
  }

  @override
  Future<double> getCameraCullingFar() async {
    return (await _jsObject.getCameraCullingFar().toDart).toDartDouble;
  }

  @override
  Future<void> setCameraFocusDistance(double focusDistance) async {
    await _jsObject.setCameraFocusDistance(focusDistance).toDart;
  }

  @override
  Future<Vector3> getCameraPosition() async {
    final jsPosition = (await _jsObject.getCameraPosition().toDart).toDart;
    return Vector3(jsPosition[0].toDartDouble, jsPosition[1].toDartDouble,
        jsPosition[2].toDartDouble);
  }

  @override
  Future<Matrix4> getCameraModelMatrix() async {
    throw UnimplementedError();
    // final JSMatrix4 jsMatrix = await _jsObject.getCameraModelMatrix().toDart;
    // return Matrix4.fromList(jsMatrix.storage).toDart;
  }

  @override
  Future<Matrix4> getCameraViewMatrix() async {
    throw UnimplementedError();
    // final JSMatrix4 jsMatrix = await _jsObject.getCameraViewMatrix().toDart;
    // return Matrix4.fromList(jsMatrix.storage).toDart;
  }

  @override
  Future<Matrix4> getCameraProjectionMatrix() async {
    throw UnimplementedError();
    // final JSMatrix4 jsMatrix =
    //     await _jsObject.getCameraProjectionMatrix().toDart;
    // return Matrix4.fromList(jsMatrix.storage).toDart;
  }

  @override
  Future<Matrix4> getCameraCullingProjectionMatrix() async {
    throw UnimplementedError();
    // final JSMatrix4 jsMatrix =
    //     await _jsObject.getCameraCullingProjectionMatrix().toDart;
    // return Matrix4.fromList(jsMatrix.storage).toDart;
  }

  @override
  Future<Frustum> getCameraFrustum() async {
    throw UnimplementedError();
    // final JSObject jsFrustum = await _jsObject.getCameraFrustum().toDart;
    // // Assuming Frustum is a class that can be constructed from the JSObject
    // return Frustum._fromJSObject(jsFrustum).toDart;
  }

  @override
  Future<void> setCameraPosition(double x, double y, double z) async {
    await _jsObject.setCameraPosition(x, y, z).toDart;
  }

  @override
  Future<Matrix3> getCameraRotation() async {
    throw UnimplementedError();
    // final JSMatrix3 jsRotation = await _jsObject.getCameraRotation().toDart;
    // return Matrix3.fromList(jsRotation.storage).toDart;
  }

  @override
  Future<void> moveCameraToAsset(FilamentEntity entity) async {
    await _jsObject.moveCameraToAsset(entity).toDart;
  }

  @override
  Future<void> setViewFrustumCulling(bool enabled) async {
    throw UnimplementedError();
    // await _jsObject.setViewFrustumCulling(enabled.toJSBoolean()).toDart;
  }

  @override
  Future<void> setCameraExposure(
      double aperture, double shutterSpeed, double sensitivity) async {
    await _jsObject
        .setCameraExposure(aperture, shutterSpeed, sensitivity)
        .toDart;
  }

  @override
  Future<void> setCameraRotation(Quaternion quaternion) async {
    throw UnimplementedError();
    // final JSQuaternion jsQuaternion = quaternion.toJSQuaternion().toDart;
    // await _jsObject.setCameraRotation(jsQuaternion).toDart;
  }

  @override
  Future<void> setCameraModelMatrix(List<double> matrix) async {
    throw UnimplementedError();

    // await _jsObject.setCameraModelMatrix(matrix.toJSBox).toDart;
  }

  @override
  Future<void> setMaterialColor(FilamentEntity entity, String meshName,
      int materialIndex, double r, double g, double b, double a) async {
    await _jsObject
        .setMaterialColor(entity, meshName, materialIndex, r, g, b, a)
        .toDart;
  }

  @override
  Future<void> transformToUnitCube(FilamentEntity entity) async {
    await _jsObject.transformToUnitCube(entity).toDart;
  }

  @override
  Future<void> setPosition(
      FilamentEntity entity, double x, double y, double z) async {
    await _jsObject.setPosition(entity, x, y, z).toDart;
  }

  @override
  Future<void> setScale(FilamentEntity entity, double scale) async {
    await _jsObject.setScale(entity, scale).toDart;
  }

  @override
  Future<void> setRotation(
      FilamentEntity entity, double rads, double x, double y, double z) async {
    await _jsObject.setRotation(entity, rads, x, y, z).toDart;
  }

  @override
  Future<void> queuePositionUpdate(
      FilamentEntity entity, double x, double y, double z,
      {bool relative = false}) async {
    await _jsObject.queuePositionUpdate(entity, x, y, z, relative).toDart;
  }

  @override
  Future<void> queueRotationUpdate(
      FilamentEntity entity, double rads, double x, double y, double z,
      {bool relative = false}) async {
    await _jsObject.queueRotationUpdate(entity, rads, x, y, z, relative).toDart;
  }

  @override
  Future<void> queueRotationUpdateQuat(FilamentEntity entity, Quaternion quat,
      {bool relative = false}) async {
    throw UnimplementedError();

    // final JSQuaternion jsQuat = quat.toJSQuaternion().toDart;
    // await _jsObject
    //     .queueRotationUpdateQuat(entity, jsQuat, relative: relative)
    //     .toDart;
  }

  @override
  Future<void> setPostProcessing(bool enabled) async {
    throw UnimplementedError();
    // await _jsObject.setPostProcessing(enabled.toJSBoolean()).toDart;
  }

  @override
  Future<void> setAntiAliasing(bool msaa, bool fxaa, bool taa) async {
    throw UnimplementedError();
    // await _jsObject
    //     .setAntiAliasing(
    //         msaa.toJSBoolean(), fxaa.toJSBoolean(), taa.toJSBoolean())
    //     .toDart;
  }

  @override
  Future<void> setRotationQuat(
      FilamentEntity entity, Quaternion rotation) async {
    throw UnimplementedError();
    // final JSQuaternion jsRotation = rotation.toJSQuaternion().toDart;
    // await _jsObject.setRotationQuat(entity, jsRotation).toDart;
  }

  @override
  Future<void> reveal(FilamentEntity entity, String? meshName) async {
    throw UnimplementedError();
    // await _jsObject.reveal(entity, meshName).toDart;
  }

  @override
  Future<void> hide(FilamentEntity entity, String? meshName) async {
    throw UnimplementedError();
    // await _jsObject.hide(entity, meshName).toDart;
  }

  @override
  void pick(int x, int y) {
    throw UnimplementedError();
    // _jsObject.pick(x, y).toDart;
  }

  @override
  String? getNameForEntity(FilamentEntity entity) {
    throw UnimplementedError();
    // return _jsObject.getNameForEntity(entity).toDart;
  }

  @override
  Future<void> setCameraManipulatorOptions(
      {ManipulatorMode mode = ManipulatorMode.ORBIT,
      double orbitSpeedX = 0.01,
      double orbitSpeedY = 0.01,
      double zoomSpeed = 0.01}) async {
    throw UnimplementedError();
    // await _jsObject
    //     .setCameraManipulatorOptions(
    //         mode: mode.index,
    //         orbitSpeedX: orbitSpeedX,
    //         orbitSpeedY: orbitSpeedY,
    //         zoomSpeed: zoomSpeed)
    //     .toDart;
  }

  @override
  Future<List<FilamentEntity>> getChildEntities(
      FilamentEntity parent, bool renderableOnly) async {
    throw UnimplementedError();
    // final List<JSObject> jsEntities = await _jsObject
    //     .getChildEntities(parent, renderableOnly.toJSBoolean())
    //     .toDart;
    // return jsEntities
    //     .map((js) => FilamentEntity._fromJSObject(js))
    //     .toList()
    //     .toDart;
  }

  @override
  Future<FilamentEntity> getChildEntity(
      FilamentEntity parent, String childName) async {
    return (await _jsObject.getChildEntity(parent, childName).toDart).toDartInt;
  }

  @override
  Future<List<String>> getChildEntityNames(FilamentEntity entity,
      {bool renderableOnly = true}) async {
    var names =
        await _jsObject.getChildEntityNames(entity, renderableOnly).toDart;
    return names.toDart.map((x) => x.toDart).toList();
  }

  @override
  Future<void> setRecording(bool recording) async {
    throw UnimplementedError();
    // await _jsObject.setRecording(recording.toJSBoolean()).toDart;
  }

  @override
  Future<void> setRecordingOutputDirectory(String outputDirectory) async {
    await _jsObject.setRecordingOutputDirectory(outputDirectory).toDart;
  }

  @override
  Future<void> addAnimationComponent(FilamentEntity entity) async {
    await _jsObject.addAnimationComponent(entity).toDart;
  }

  @override
  Future<void> addCollisionComponent(FilamentEntity entity,
      {void Function(int entityId1, int entityId2)? callback,
      bool affectsTransform = false}) async {
    throw UnimplementedError();
    // final JSFunction? jsCallback = callback != null
    //     ? allowInterop(
    //         (int entityId1, int entityId2) => callback(entityId1, entityId2))
    //     : null;
    // await _jsObject
    //     .addCollisionComponent(entity,
    //         callback: jsCallback,
    //         affectsTransform: affectsTransform.toJSBoolean())
    //     .toDart;
  }

  @override
  Future<void> removeCollisionComponent(FilamentEntity entity) async {
    await _jsObject.removeCollisionComponent(entity).toDart;
  }

  @override
  Future<FilamentEntity> createGeometry(
      List<double> vertices, List<int> indices,
      {String? materialPath,
      PrimitiveType primitiveType = PrimitiveType.TRIANGLES}) async {
    throw UnimplementedError();
    // final FilamentEntity jsEntity = await _jsObject
    //     .createGeometry(vertices, indices,
    //         materialPath: materialPath, primitiveType: primitiveType.index)
    //     .toDart;
    // return FilamentEntity._fromJSObject(jsEntity).toDart;
  }

  @override
  Future<void> setParent(FilamentEntity child, FilamentEntity parent) async {
    await _jsObject.setParent(child, parent).toDart;
  }

  @override
  Future<void> testCollisions(FilamentEntity entity) async {
    await _jsObject.testCollisions(entity).toDart;
  }

  @override
  Future<void> setPriority(FilamentEntity entityId, int priority) async {
    await _jsObject.setPriority(entityId, priority).toDart;
  }

  Scene? _scene;

  // @override
  Scene get scene {
    _scene ??= SceneImpl(this);
    return _scene!;
  }

  AbstractGizmo? get gizmo => null;
}