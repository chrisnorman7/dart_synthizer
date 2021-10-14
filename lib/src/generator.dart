/// Provides generator classes.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'buffer.dart';
import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';
import 'synthizer_property.dart';

/// The base class for all generators.
abstract class Generator extends SynthizerObject with PausableMixin {
  /// Create a generator.
  Generator(Context context) : super(context.synthizer) {
    gain = SynthizerDoubleProperty(synthizer, handle, Properties.gain);
    looping = SynthizerBoolProperty(synthizer, handle, Properties.looping);
    pitchBend =
        SynthizerDoubleProperty(synthizer, handle, Properties.pitchBend);
  }

  /// Create an instance from a handle.
  Generator.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);

  /// The gain for this object.
  late final SynthizerDoubleProperty gain;

  /// Whether or not this generator is looping.
  late final SynthizerBoolProperty looping;

  /// Get the current pitch bend.
  late final SynthizerDoubleProperty pitchBend;
}

/// A streaming generator.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/streaming_generator.html)
///
/// Streaming generators can be created with [Context.createStreamingGenerator].
///
/// The `options` argument is as yet undocumented.
class StreamingGenerator extends Generator {
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
    playbackPosition =
        SynthizerDoubleProperty(synthizer, handle, Properties.playbackPosition);
  }

  /// Return an instance from a handle.
  StreamingGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The playback position of this generator.
  late final SynthizerDoubleProperty playbackPosition;
}

/// A buffer generator.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/buffer_generator.html)
///
/// Buffer generators can be created with [Context.createBufferGenerator].
class BufferGenerator extends Generator {
  /// Create a buffer generator.
  BufferGenerator(Context context, {Buffer? buffer}) : super(context) {
    synthizer.check(synthizer.synthizer.syz_createBufferGenerator(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    if (buffer != null) {
      setBuffer(buffer);
    }
    playbackPosition =
        SynthizerDoubleProperty(synthizer, handle, Properties.playbackPosition);
  }

  /// Return an instance from a handle.
  BufferGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The playback position of this generator.
  late final SynthizerDoubleProperty playbackPosition;

  /// Set the buffer for this generator.
  void setBuffer(Buffer? buffer) =>
      synthizer.check(synthizer.synthizer.syz_setO(handle.value,
          SYZ_PROPERTIES.SYZ_P_BUFFER, buffer?.handle.value ?? 0));
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
    noiseType =
        SynthizerNoiseTypeProperty(synthizer, handle, Properties.noiseType);
  }

  /// Create an instance from a handle value.
  NoiseGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// Get the noise type for this generator.
  late final SynthizerNoiseTypeProperty noiseType;
}
