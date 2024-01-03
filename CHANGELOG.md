# Changelog

## [0.11.3]

- Code cleanup.

## [0.11.2]

- Updated dependencies.
- Updated Synthizer.
- Fixed a memory leak in buffer factory constructors.

## [0.11.1]

- Updated dependencies.

## [0.11.0]

- Many property fixes.
- Properties now accept only named arguments.
- The `automate` method is only available on properties that can actually be automated.
- The `automate` method now takes no arguments.
- Synthizer events now use handles, rather than trying to guess objects.
- Removed the `Synthizer.getObject` method.

## [0.10.0]

- Updated minimum SDK constraint.
- Regenerate bindings.

## [0.9.0]

- Updated the SDK constraint.

## [0.8.0]

- Updated analysis options.
- Fixed the name of `Context.configRoute`.

## [0.7.11]

- Use an absolute path on Linux (again).

## [0.7.10]

- Reverted the changes from [0.7.9].

## [0.7.9]

- Start using a fully-qualified path when running under Linux.

## [0.7.8]

- The library should now load unaided on Mac OS.

## [0.7.7]

- Cleaned up the `initialize` method.

## [0.7.6]

- Added the `AddGenerators` and `removeGenerators` methods to the `Source` class.
- Bound the waves API.

## [0.7.5]

- Added methods for dealing with reference counts to the `SynthizerObject` class.

## [0.7.4]

- Updated Synthizer.
- Use Synthizer's notion of buffer size, rather than the (probably mildly slower) Dart equivalent.

## [0.7.3]

- Hopefully start supporting Linux.

## [0.7.2]

- Fixed some docs.

## [0.7.1]

- Exposed a bunch of previously-hidden classes.

## [0.7.0]

- Filled some gaps in the implementation of sources.
- Added the `SynthizerProperty` class, and it's subclasses.
- It is now easier to create automation batches using various methods on the `AutomationBatch` class.
- Added the `Context.clearAllProperties` method.
- Added the `Context.clearEvents` method.
- Switched all properties to the new `SynthizerProperty` API.
- Changed `BufferGenerator.setBuffer` to be a `SynthizerObjectProperty`.
- You can no longer use the `AutomationCommand` classes or the `AutomationBatch.commands` list.
- The automation batch method on `Context` has been removed. Now you must instantiate an `AutomationBatch` class and use its `execute` method.

## [0.6.5]

- Update Synthizer.

## [0.6.4]

- It is now possible to load Synthizer from the current process, or the current executable.

## [0.6.3]

- Added `SynthizerObject.currentTime` and `SynthizerObject.suggestedAutomationTime`.
- Code cleanup.

## [0.6.2]

- Fixed a bunch of broken documentation links.

## [0.6.1]

- Added the `playbackPosition` property for `BufferGenerator` and `StreamingGenerator`.

## [0.6.0]

- Brought code structure to be more in line with Google's guidelines.

## [0.5.0]

- Removed the `BufferCache` class.

## [0.4.0]

- Updated Synthizer.
- Shorten the code for `Synthizer.getObjectType`.

- The `ObjectTypes.automationTimeline` member has been removed.

## [0.3.0]

- Removed the deprecated automation API and updated it.

### Added

- Added 2 automation examples.

## [0.2.1]

- Added the `elevation` property to `AngularPannedSource` where it should be.

## [0.2.0]

- Updated Synthizer.
- Added `ScalarPannedSource`.
- Added `AngularPannedSource`.
- Added the `Context.createAngularPannedSource` method.
- Removed `PannedSource`.
- Renamed `Context.createPannedSource` to `createScalarPannedSource`.

## [0.1.0]

- Add `getEvent` and `getEvents` methods on `Context`.
- Add the ability to recreate objects from their handles with `Synthizer.getObject`.
- Added the `Synthizer.getContextEvent` method.

## [0.0.4]

- Updated the readme.

## [0.0.3]

- Changed the `website` field to a `repository` field, so that issues work as expected.

## [0.0.2]

- Added an example to show on the package site.

## [0.0.1]

- Initial version.
