/// Provides generator classes.
import '../classes.dart';
import '../context.dart';
import '../enumerations.dart';
import '../synthizer_property.dart';

/// The base class for all generators.
abstract class Generator extends SynthizerObject with PausableMixin, GainMixin {
  /// Create a generator.
  Generator(final Context context) : super(context.synthizer);

  /// Create an instance from a handle.
  Generator.fromHandle(super.synthizer, final int pointer)
      : super(pointer: pointer);

  /// Whether or not this generator is looping.
  SynthizerBoolProperty get looping =>
      SynthizerBoolProperty(synthizer, handle, Properties.looping);

  /// The pitch bend for this generator.
  SynthizerDoubleProperty get pitchBend =>
      SynthizerDoubleProperty(synthizer, handle, Properties.pitchBend);
}
