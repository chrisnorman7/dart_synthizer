/// Provides the [SynthizerStream] class.
import 'dart:ffi';

import 'classes.dart';
import 'synthizer.dart';

/// Synthizer streams.
///
/// This class is not simply called `Stream` because of the name conflict with
/// the Dart standard library.
class SynthizerStream extends SynthizerObject {
  /// Create a stream.
  ///
  /// Don't use this constructor directly, but instead use one of the named
  /// constructors.
  SynthizerStream(Synthizer synthizer, Pointer<Uint64> handle)
      : super(synthizer, pointer: handle);
}
