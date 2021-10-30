# Changelog

## [0.7.5]

### Added

* Added methods for dealing with reference counts to the `SynthizerObject` class.

## [0.7.4]

### Changed

* Updated Synthizer.
* Use Synthizer's notion of buffer size, rather than the (probably mildly slower) Dart equivalent.

## [0.7.3]

### Changed

* Hopefully start supporting Linux.

## [0.7.2]

### Changed

* Fixed some docs.

## [0.7.1]

### Changed

* Exposed a bunch of previously-hidden classes.

## [0.7.0]

### Fixed

* Filled some gaps in the implementation of sources.

## [0.7.0]

### Added

* Added the `SynthizerProperty` class, and it's subclasses.
* It is now easier to create automation batches using various methods on the `AutomationBatch` class.
* Added the `Context.clearAllProperties` method.
* Added the `Context.clearEvents` method.

### Changed

* Switched all properties to the new `SynthizerProperty` API.
* Changed `BufferGenerator.setBuffer` to be a `SynthizerObjectProperty`.

### Removed

* You can no longer use the `AutomationCommand` classes or the `AutomationBatch.commands` list.
* The automation batch method on `Context` has been removed. Now you must instantiate an `AutomationBatch` class and use its `execute` method.

## [0.6.5]

### Changed

* Update Synthizer.

## [0.6.4]

### Changed

* It is now possible to load Synthizer from the current process, or the current executable.

## [0.6.3]

### Added

* Added `SynthizerObject.currentTime` and `SynthizerObject.suggestedAutomationTime`.

### Changed

* Code cleanup.

## [0.6.2]

### Fixed

* Fixed a bunch of broken documentation links.

## [0.6.1]

### Added

* Added the `playbackPosition` property for `BufferGenerator` and `StreamingGenerator`.

## [0.6.0]

### Changed

* Brought code structure to be more in line with Google's guidelines.

## [0.5.0]

### Removed

* Removed the `BufferCache` class.

## [0.4.0]

### Changed

* Updated Synthizer.
* Shorten the code for `Synthizer.getObjectType`.

### Removed

* The `ObjectTypes.automationTimeline` member has been removed.

## [0.3.0]

### Changed

* Removed the deprecated automation API and updated it.

### Added

* Added 2 automation examples.

## [0.2.1]

### Added

* Added the `elevation` property to `AngularPannedSource` where it should be.

## [0.2.0]

### Changed

* Updated Synthizer.
* Added `ScalarPannedSource`.
* Added `AngularPannedSource`.
* Added the `Context.createAngularPannedSource` method.

### Removed

* Removed `PannedSource`.

### Changed

* Renamed `Context.createPannedSource` to `createScalarPannedSource`.

## [0.1.0]

### Added

* Add `getEvent` and `getEvents` methods on `Context`.`.
* Add the ability to recreate objects from their handles with `Synthizer.getObject`.
* Added the `Synthizer.getContextEvent` method.

## [0.0.4]

### Changed

* Updated the readme.

## [0.0.3]

### Changed

* Changed the `website` field to a `repository` field, so that issues work as expected.

## [0.0.2]

### Added

* Added an example to show on the package site.

## [0.0.1]

Initial version.
