/// Provides generator classes.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'buffer.dart';
import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'synthizer.dart';
import 'synthizer_property.dart';

/// The base class for all generators.
abstract class Generator extends SynthizerObject with PausableMixin, GainMixin {
  /// Create a generator.
  Generator(Context context) : super(context.synthizer);

  /// Create an instance from a handle.
  Generator.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);

  /// Whether or not this generator is looping.
  SynthizerBoolProperty get looping =>
      SynthizerBoolProperty(synthizer, handle, Properties.looping);

  /// The pitch bend for this generator.
  SynthizerDoubleProperty get pitchBend =>
      SynthizerDoubleProperty(synthizer, handle, Properties.pitchBend);
}

/// A streaming generator.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/streaming_generator.html)
///
/// Streaming generators can be created with [Context.createStreamingGenerator].
///
/// The `options` argument is as yet undocumented.
class StreamingGenerator extends Generator with PlaybackPosition {
  /// Create a generator.
  StreamingGenerator(Context context, String protocol, String path,
      {String options = ''})
      : super(context) {
    final protocolPointer = protocol.toNativeUtf8().cast<Int8>();
    final pathPointer = path.toNativeUtf8().cast<Int8>();
    final optionsPointer = options.toNativeUtf8().cast<Void>();
    synthizer.check(synthizer.synthizer
        .syz_createStreamingGeneratorFromStreamParams(
            handle,
            context.handle.value,
            protocolPointer,
            pathPointer,
            optionsPointer,
            nullptr,
            nullptr,
            synthizer.userdataFreeCallbackPointer));
    [protocolPointer, pathPointer, optionsPointer].forEach(calloc.free);
  }

  /// Return an instance from a handle.
  StreamingGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);
}

/// A buffer generator.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/buffer_generator.html)
///
/// Buffer generators can be created with [Context.createBufferGenerator].
class BufferGenerator extends Generator with PlaybackPosition {
  /// Create a buffer generator.
  BufferGenerator(Context context, {Buffer? buffer}) : super(context) {
    synthizer.check(synthizer.synthizer.syz_createBufferGenerator(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    if (buffer != null) {
      this.buffer.value = buffer;
    }
  }

  /// Return an instance from a handle.
  BufferGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The buffer for this generator.
  SynthizerObjectProperty get buffer =>
      SynthizerObjectProperty(synthizer, handle, Properties.buffer);
}

/// A noise generator.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/noise_generator.html)
///
/// Noise generators can be created with [Context.createNoiseGenerator].
class NoiseGenerator extends Generator {
  /// Create a noise generator.
  NoiseGenerator(Context context, {int channels = 1}) : super(context) {
    synthizer.check(synthizer.synthizer.syz_createNoiseGenerator(
        handle,
        context.handle.value,
        channels,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle value.
  NoiseGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The noise type for this generator.
  SynthizerNoiseTypeProperty get noiseType =>
      SynthizerNoiseTypeProperty(synthizer, handle, Properties.noiseType);
}
