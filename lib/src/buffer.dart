import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'stream.dart';
import 'synthizer.dart';

/// A synthizer buffer.
///
/// Instead of using the default constructor directly, use one of the named
/// constructors.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/buffer.html)
class Buffer extends SynthizerObject {
  /// Default constructor. Do not use.
  Buffer(super.synthizer, {final int? handle}) : super(pointer: handle);

  /// Create a buffer from stream parameters.
  factory Buffer.fromStreamParams(
    final Synthizer synthizer,
    final String protocol,
    final String path, {
    final String options = '',
  }) {
    final protocolPointer = protocol.toNativeUtf8().cast<Char>();
    final pathPointer = path.toNativeUtf8().cast<Char>();
    final optionsPointer = options.toNativeUtf8().cast<Void>();
    synthizer.check(
      synthizer.synthizer.syz_createBufferFromStreamParams(
        synthizer.bigIntPointer,
        protocolPointer,
        pathPointer,
        optionsPointer,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
    [
      protocolPointer,
      pathPointer,
      optionsPointer,
    ].forEach(malloc.free);
    return Buffer(synthizer, handle: synthizer.bigIntPointer.value);
  }

  /// Create a buffer from a stream.
  factory Buffer.fromStreamHandle(
    final Synthizer synthizer,
    final SynthizerStream stream,
  ) {
    synthizer.check(
      synthizer.synthizer.syz_createBufferFromStreamHandle(
        synthizer.bigIntPointer,
        stream.handle.value,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
    return Buffer(synthizer, handle: synthizer.bigIntPointer.value);
  }

  /// Create a buffer from a file object.
  factory Buffer.fromFile(final Synthizer synthizer, final File file) =>
      Buffer.fromStreamParams(synthizer, 'file', file.absolute.path);

  /// Create a buffer from a list of integers.
  ///
  /// You can use this with a list returned by [File.readAsBytesSync] for
  /// example.
  factory Buffer.fromBytes(final Synthizer synthizer, final List<int> bytes) {
    final a = malloc<Char>(bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      a[i] = bytes[i];
    }
    synthizer.check(
      synthizer.synthizer.syz_createBufferFromEncodedData(
        synthizer.bigIntPointer,
        bytes.length,
        a,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
    malloc.free(a);
    return Buffer(synthizer, handle: synthizer.bigIntPointer.value);
  }

  /// Create a buffer from a string.
  ///
  /// This method is used by [Buffer.fromString].
  factory Buffer.fromString(final Synthizer synthizer, final String data) =>
      Buffer.fromBytes(synthizer, data.codeUnits);

  /// Create a buffer from a list of floats.
  factory Buffer.fromDoubles(
    final Synthizer synthizer,
    final int sampleRate,
    final int channels,
    final int frames,
    final List<double> data,
  ) {
    final a = malloc<Float>(data.length);
    for (var i = 0; i < data.length; i++) {
      a[i] = data[i];
    }
    synthizer.check(
      synthizer.synthizer.syz_createBufferFromFloatArray(
        synthizer.bigIntPointer,
        sampleRate,
        channels,
        frames,
        a,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
    malloc.free(a);
    return Buffer(synthizer, handle: synthizer.bigIntPointer.value);
  }

  /// Get the number of channels for this buffer.
  int get channels {
    synthizer.check(
      synthizer.synthizer
          .syz_bufferGetChannels(synthizer.majorPointer, handle.value),
    );
    return synthizer.majorPointer.value;
  }

  /// Get the length of this buffer in samples.
  int get lengthInSamples {
    synthizer.check(
      synthizer.synthizer
          .syz_bufferGetLengthInSamples(synthizer.majorPointer, handle.value),
    );
    return synthizer.majorPointer.value;
  }

  /// Get the length of this buffer in seconds.
  double get lengthInSeconds {
    synthizer.check(
      synthizer.synthizer
          .syz_bufferGetLengthInSeconds(synthizer.doublePointer, handle.value),
    );
    return synthizer.doublePointer.value;
  }

  /// Get the amount of memory (in bytes) this buffer is taking up.
  int get size {
    synthizer.check(
      synthizer.synthizer
          .syz_bufferGetSizeInBytes(synthizer.bigIntPointer, handle.value),
    );
    return synthizer.bigIntPointer.value;
  }
}
