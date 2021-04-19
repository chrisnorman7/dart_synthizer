/// Provides generator classes.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'buffer.dart';
import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'synthizer_bindings.dart';

/// The base class for all generators.
abstract class Generator extends SynthizerObject with PausableMixin, GainMixin {
  /// Create a generator.
  Generator(Context context) : super(context.synthizer);

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

/// A streaming generator.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/streaming_generator.html]
///
/// Streaming generators can be created with [Context.createStreamingGenerator].
///
/// The `options` argument is as yet undocumented.
class StreamingGenerator extends Generator {
  /// Create a generator.
  StreamingGenerator(Context context, String protocol, String path,
      {String options = ''})
      : super(context) {
    synthizer.check(synthizer.synthizer.syz_createStreamingGenerator(
        handle,
        context.handle.value,
        protocol.toNativeUtf8().cast<Int8>(),
        path.toNativeUtf8().cast<Int8>(),
        options.toNativeUtf8().cast<Int8>()));
  }
}

/// A buffer generator.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/buffer_generator.html]
///
/// Buffer generators can be created with [Context.createBufferGenerator].
class BufferGenerator extends Generator {
  /// Create a buffer generator.
  BufferGenerator(Context context, {Buffer? buffer}) : super(context) {
    synthizer.check(synthizer.synthizer
        .syz_createBufferGenerator(handle, context.handle.value));
    if (buffer != null) {
      setBuffer(buffer);
    }
  }

  /// Set the buffer for this generator.
  void setBuffer(Buffer? buffer) =>
      synthizer.check(synthizer.synthizer.syz_setO(handle.value,
          SYZ_PROPERTIES.SYZ_P_BUFFER, buffer?.handle.value ?? 0));
}

/// A noise generator.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/noise_generator.html]
///
/// Noise generators can be created with [Context.createNoiseGenerator].
class NoiseGenerator extends Generator {
  /// Create a noise generator.
  NoiseGenerator(Context context, {int channels = 1}) : super(context) {
    synthizer.check(synthizer.synthizer
        .syz_createNoiseGenerator(handle, context.handle.value, channels));
  }

  /// Get the noise type for this generator.
  NoiseTypes get noiseType {
    final i = synthizer.getInt(handle, Properties.noiseType);
    switch (i) {
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_FILTERED_BROWN:
        return NoiseTypes.filteredBrown;
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_UNIFORM:
        return NoiseTypes.uniform;
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_VM:
        return NoiseTypes.vm;
      default:
        throw Exception('Invalid noise type: $i.');
    }
  }

  /// Set the noise type for this generator.
  set noiseType(NoiseTypes value) {
    final int i;
    switch (value) {
      case NoiseTypes.filteredBrown:
        i = SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_FILTERED_BROWN;
        break;
      case NoiseTypes.uniform:
        i = SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_UNIFORM;
        break;
      case NoiseTypes.vm:
        i = SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_VM;
        break;
    }
    synthizer.setInt(handle, Properties.noiseType, i);
  }
}
