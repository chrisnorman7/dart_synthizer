/// Provides the [Buffer] class.
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
  Buffer(Synthizer synthizer, {int? handle})
      : super(synthizer, pointer: handle);

  /// Create a buffer from stream parameters.
  factory Buffer.fromStreamParams(
      Synthizer synthizer, String protocol, String path,
      {String options = ''}) {
    final out = calloc<Uint64>();
    final protocolPointer = protocol.toNativeUtf8().cast<Int8>();
    final pathPointer = path.toNativeUtf8().cast<Int8>();
    final optionsPointer = options.toNativeUtf8().cast<Void>();
    synthizer.check(synthizer.synthizer.syz_createBufferFromStreamParams(
        out,
        protocolPointer,
        pathPointer,
        optionsPointer,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    [protocolPointer, pathPointer, optionsPointer, out].forEach(calloc.free);
    return Buffer(synthizer, handle: out.value);
  }

  /// Create a buffer from a stream.
  factory Buffer.fromStreamHandle(Synthizer synthizer, SynthizerStream stream) {
    final out = calloc<Uint64>();
    synthizer.check(synthizer.synthizer.syz_createBufferFromStreamHandle(out,
        stream.handle.value, nullptr, synthizer.userdataFreeCallbackPointer));
    calloc.free(out);
    return Buffer(synthizer, handle: out.value);
  }

  /// Create a buffer from a file object.
  factory Buffer.fromFile(Synthizer synthizer, File file) =>
      Buffer.fromStreamParams(synthizer, 'file', file.absolute.path);

  /// Create a buffer from a list of integers.
  ///
  /// You can use this with a list returned by [File.readAsBytesSync] for
  /// example.
  factory Buffer.fromBytes(Synthizer synthizer, List<int> bytes) {
    final out = calloc<Uint64>();
    final a = malloc<Int8>(bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      a[i] = bytes[i];
    }
    synthizer.check(synthizer.synthizer.syz_createBufferFromEncodedData(
        out, bytes.length, a, nullptr, synthizer.userdataFreeCallbackPointer));
    malloc.free(a);
    return Buffer(synthizer, handle: out.value);
  }

  /// Create a buffer from a string.
  ///
  /// This method is used by [Buffer.fromString].
  factory Buffer.fromString(Synthizer synthizer, String data) =>
      Buffer.fromBytes(synthizer, data.codeUnits);

  /// Create a buffer from a list of floats.
  factory Buffer.fromDoubles(Synthizer synthizer, int sampleRate, int channels,
      int frames, List<double> data) {
    final out = calloc<Uint64>();
    final a = malloc<Float>(data.length);
    for (var i = 0; i < data.length; i++) {
      a[i] = data[i];
    }
    synthizer.check(synthizer.synthizer.syz_createBufferFromFloatArray(
        out,
        sampleRate,
        channels,
        frames,
        a,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    calloc.free(out);
    malloc.free(a);
    return Buffer(synthizer, handle: out.value);
  }

  /// Get the number of channels for this buffer.
  int get channels {
    synthizer.check(synthizer.synthizer
        .syz_bufferGetChannels(synthizer.majorPointer, handle.value));
    return synthizer.majorPointer.value;
  }

  /// Get the length of this buffer in samples.
  int get lengthInSamples {
    synthizer.check(synthizer.synthizer
        .syz_bufferGetLengthInSamples(synthizer.majorPointer, handle.value));
    return synthizer.majorPointer.value;
  }

  /// Get the length of this buffer in seconds.
  double get lengthInSeconds {
    synthizer.check(synthizer.synthizer
        .syz_bufferGetLengthInSeconds(synthizer.doublePointer, handle.value));
    return synthizer.doublePointer.value;
  }

  /// Get the amount of memory (in bytes) this buffer is taking up.
  int get size {
    synthizer.check(synthizer.synthizer
        .syz_bufferGetSizeInBytes(synthizer.bigIntPointer, handle.value));
    return synthizer.bigIntPointer.value;
  }
}
