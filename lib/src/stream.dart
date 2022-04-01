/// Provides the [SynthizerStream] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

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
  SynthizerStream(final Synthizer synthizer) : super(synthizer);

  /// Create a stream from a file.
  factory SynthizerStream.fromFile(
    final Synthizer synthizer,
    final String path,
  ) {
    final s = SynthizerStream(synthizer);
    synthizer.check(
      synthizer.synthizer.syz_createStreamHandleFromFile(
        s.handle,
        path.toNativeUtf8().cast<Int8>(),
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
    return s;
  }
}
