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
  SynthizerStream(super.synthizer);

  /// Create a stream from a file.
  factory SynthizerStream.fromFile(
    final Synthizer synthizer,
    final String path,
  ) {
    final s = SynthizerStream(synthizer);
    final pathPtr = path.toNativeUtf8().cast<Char>();
    synthizer.check(
      synthizer.synthizer.syz_createStreamHandleFromFile(
        s.handle,
        pathPtr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
    malloc.free(pathPtr);
    return s;
  }
}
