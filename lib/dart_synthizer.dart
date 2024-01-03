/// Bindings for [Synthizer](https://synthizer.github.io/).
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
library dart_synthizer;

import 'src/synthizer.dart';

export 'src/automation.dart';
export 'src/biquad.dart';
export 'src/buffer.dart';
export 'src/classes.dart';
export 'src/context.dart';
export 'src/effects.dart';
export 'src/enumerations.dart';
export 'src/events.dart';
export 'src/generators/base.dart';
export 'src/generators/buffer_generator.dart';
export 'src/generators/fast_sine_bank_generator.dart';
export 'src/generators/noise_generator.dart';
export 'src/generators/streaming_generator.dart';
export 'src/properties.dart';
export 'src/source.dart';
export 'src/stream.dart';
export 'src/synthizer.dart';
export 'src/synthizer_error.dart';
export 'src/synthizer_property.dart';
export 'src/synthizer_version.dart';
