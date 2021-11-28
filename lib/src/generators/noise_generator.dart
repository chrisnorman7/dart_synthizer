/// Provides the [NoiseGenerator] class.
import 'dart:ffi';

import '../context.dart';
import '../enumerations.dart';
import '../synthizer.dart';
import '../synthizer_property.dart';
import 'base.dart';

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
