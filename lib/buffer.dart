/// Provides the [Buffer] class.
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'synthizer.dart';

/// A synthizer buffer.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/buffer.html]
class Buffer extends SynthizerObject {
  Buffer(Synthizer synthizer, Pointer<Uint64> handle)
      : super(synthizer, handle);

  /// Create a buffer from a stream.
  factory Buffer.fromStream(Synthizer synthizer, String protocol, String path,
      {String options = ''}) {
    final out = calloc<Uint64>();
    synthizer.check(synthizer.synthizer.syz_createBufferFromStream(
        out,
        protocol.toNativeUtf8().cast<Int8>(),
        path.toNativeUtf8().cast<Int8>(),
        options.toNativeUtf8().cast<Int8>()));
    return Buffer(synthizer, out);
  }

  /// Create a buffer from a file object.
  factory Buffer.fromFile(Synthizer synthizer, File file) {
    return Buffer.fromStream(synthizer, 'file', file.absolute.path);
  }

  /// Get the number of channels for this buffer.
  int get channels {
    final out = calloc<Uint32>();
    synthizer
        .check(synthizer.synthizer.syz_bufferGetChannels(out, handle.value));
    return out.value;
  }

  /// Get the length of this buffer in samples.
  int get lengthInSamples {
    final out = calloc<Uint32>();
    synthizer.check(
        synthizer.synthizer.syz_bufferGetLengthInSamples(out, handle.value));
    return out.value;
  }

  /// Get the length of this buffer in seconds.
  double get lengthInSeconds {
    final out = calloc<Double>();
    synthizer.check(
        synthizer.synthizer.syz_bufferGetLengthInSeconds(out, handle.value));
    return out.value;
  }
}
