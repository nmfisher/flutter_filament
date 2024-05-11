## 0.7.0
* `removeAsset` & `clearAssets` have been renamed `removeEntity` and `clearEntities`
* added support for parenting one entity to another
* added basic collision detection + callbacks
* added keyboard/mouse widgets + controls
* `createViewer` now `awaits` the insertion of `FilamentWidget` so you no longer need to manually defer calling until after FilamentWidget has been rendered  
* `setCameraRotation` now accepts a quaternion instead of an axis/angle
* instancing is now supported.
* `setBoneTransform` has been removed. To set the transform for a bone, just `addBoneAnimation` with a single frame.
* the Dart library has been restructured to expose a cleaner API surface. Import `package:flutter_filament/flutter_filament.dart`
* created a separate `Scene` class to hold lights/entities. For now, this is simply a singleton that holds all `getScene`
* `getChildEntities` now returns the actual entities. The previous method has been renamed to `getChildEntityNames`.

## 0.6.0

* `createViewer` is no longer called by `FilamentWidget` and must be called manually at least one frame after a FilamentWidget has been inserted into the widget hierarchy.


## 0.5.0

* Replaced `isReadyForScene` Future in `FilamentController` with the `Stream<bool>` `hasViewer`. 
* Rendering is set to false when the app is hidden, inactive or paused; on resume, this will be set to the value it held prior to being hidden/inactive/paused.