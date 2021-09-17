/// Bindings for the [Synthizer](https://synthizer.github.io/) manual.
///
/// ## Working with Synthizer
///
/// For Synthizer-specific docs, see the [Synthizer manual](https://synthizer.github.io/).
///
/// ## Working with Dart
///
/// To begin, create a [Synthizer] instance:
///
/// ```
/// final synthizer = Synthizer();
/// ```
///
/// Then initialise the library:
/// ```
/// synthizer.initialize();
/// ```
///
/// Then create a [Context]:
///
/// ```
/// final ctx = synthizer.createContext();
/// ```
///
/// For more help, see the API docs.
import 'synthizer.dart';

export 'automation.dart';
export 'biquad.dart';
export 'buffer.dart';
export 'buffer_cache.dart';
export 'context.dart';
export 'effects.dart';
export 'enumerations.dart';
export 'error.dart';
export 'events.dart';
export 'generator.dart';
export 'properties.dart';
export 'source.dart';
export 'stream.dart';
export 'synthizer.dart';
