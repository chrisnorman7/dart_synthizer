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
import 'src/synthizer.dart';

export 'src/automation.dart';
export 'src/biquad.dart';
export 'src/buffer.dart';
export 'src/classes.dart';
export 'src/context.dart';
export 'src/effects.dart';
export 'src/enumerations.dart';
export 'src/error.dart';
export 'src/events.dart';
export 'src/generator.dart';
export 'src/properties.dart';
export 'src/source.dart';
export 'src/stream.dart';
export 'src/synthizer.dart';
