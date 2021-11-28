/// Provides the [FastSineBankGenerator] class.
import 'dart:ffi';

import '../classes.dart';
import '../context.dart';
import '../enumerations.dart';
import '../synthizer.dart';
import '../synthizer_property.dart';
import 'base.dart';

/// A sine bank wave.
class SineBankWave {
  /// Create an instance.
  const SineBankWave(
      {this.frequencyMul = 1.0, this.gain = 1.0, this.phase = 0.0});

  /// Frequency multiplier.
  final double frequencyMul;

  /// Phase shift.
  final double phase;

  /// The gain of the wave.
  final double gain;
}

/// A sine bank generator.
class FastSineBankGenerator extends Generator with GainMixin, PausableMixin {
  /// Create an instance.
  FastSineBankGenerator(
    Context context,
    SineBankWave sineBankWave, {
    double initialFrequency = 440.0,
    int waveCount = 1,
  }) : super(context) {
    synthizer.sineBankWavePointer.ref
      ..gain = sineBankWave.gain
      ..frequency_mul = sineBankWave.frequencyMul
      ..phase = sineBankWave.phase;
    synthizer.synthizer.syz_initSineBankConfig(synthizer.sineBankConfigPointer);
    synthizer.sineBankConfigPointer.ref
      ..wave_count = waveCount
      ..initial_frequency = initialFrequency
      ..waves = synthizer.sineBankWavePointer;
    synthizer.check(synthizer.synthizer.syz_createFastSineBankGenerator(
        handle,
        context.handle.value,
        synthizer.sineBankConfigPointer,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle.
  FastSineBankGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// Sine wave.
  FastSineBankGenerator.sine(Context context, double initialFrequency)
      : super(context) {
    synthizer.check(synthizer.synthizer.syz_createFastSineBankGeneratorSine(
        handle,
        context.handle.value,
        initialFrequency,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
  }

  /// Triangle wave.
  FastSineBankGenerator.triangle(
      Context context, double initialFrequency, int partials)
      : super(context) {
    synthizer.check(synthizer.synthizer.syz_createFastSineBankGeneratorTriangle(
        handle,
        context.handle.value,
        initialFrequency,
        partials,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
  }

  /// Square wave.
  FastSineBankGenerator.square(
      Context context, double initialFrequency, int partials)
      : super(context) {
    synthizer.check(synthizer.synthizer.syz_createFastSineBankGeneratorSquare(
        handle,
        context.handle.value,
        initialFrequency,
        partials,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
  }

  /// Saw wave.
  FastSineBankGenerator.saw(
      Context context, double initialFrequency, int partials)
      : super(context) {
    synthizer.check(synthizer.synthizer.syz_createFastSineBankGeneratorSaw(
        handle,
        context.handle.value,
        initialFrequency,
        partials,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
  }

  /// The frequency of this wave.
  SynthizerDoubleProperty get frequency =>
      SynthizerDoubleProperty(synthizer, handle, Properties.frequency);
}
