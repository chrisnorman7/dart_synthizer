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
/// final synthizer = Synthizer.fromPath('synthizer.dll');
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

export 'buffer.dart';
export 'context.dart';
export 'enumerations.dart';
export 'error.dart';
export 'generator.dart';
export 'source.dart';
export 'synthizer.dart';
export 'synthizer_bindings.dart';
