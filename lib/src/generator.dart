/// Provides generator classes.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'buffer.dart';
import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// The base class for all generators.
abstract class Generator extends SynthizerObject with PausableMixin, GainMixin {
  /// Create a generator.
  Generator(Context context) : super(context.synthizer);

  /// Create an instance from a handle.
  Generator.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);

  /// Get whether or not this generator is looping.
  bool get looping => synthizer.getBool(handle, Properties.looping);

  /// Set whether or not this generator should loop.
  set looping(bool value) =>
      synthizer.setBool(handle, Properties.looping, value);

  /// Get the current pitch bend.
  double get pitchBend => synthizer.getDouble(handle, Properties.pitchBend);

  /// Set the pitch bend.
  set pitchBend(double value) =>
      synthizer.setDouble(handle, Properties.pitchBend, value);
}

/// Add playback position to [Generator] subclasses.
mixin PlaybackPosition on Generator {
  /// Get the current playback position.
  double get playbackPosition =>
      synthizer.getDouble(handle, Properties.playbackPosition);

  /// Set [playbackPosition].
  set playbackPosition(double value) =>
      synthizer.setDouble(handle, Properties.playbackPosition, value);
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
      setBuffer(buffer);
    }
  }

  /// Return an instance from a handle.
  BufferGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

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
  }

  /// Create an instance from a handle value.
  NoiseGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// Get the noise type for this generator.
  NoiseType get noiseType {
    final i = synthizer.getInt(handle, Properties.noiseType);
    switch (i) {
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_FILTERED_BROWN:
        return NoiseType.filteredBrown;
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_UNIFORM:
        return NoiseType.uniform;
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_VM:
        return NoiseType.vm;
      default:
        throw Exception('Invalid noise type: $i.');
    }
  }

  /// Set the noise type for this generator.
  set noiseType(NoiseType value) {
    final int i;
    switch (value) {
      case NoiseType.filteredBrown:
        i = SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_FILTERED_BROWN;
        break;
      case NoiseType.uniform:
        i = SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_UNIFORM;
        break;
      case NoiseType.vm:
        i = SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_VM;
        break;
      case NoiseType.count:
        i = SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_COUNT;
        break;
    }
    synthizer.setInt(handle, Properties.noiseType, i);
  }
}
