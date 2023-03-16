/// Provides generator classes.
import '../classes.dart';
import '../enumerations.dart';
import '../synthizer_property.dart';

/// The base class for all generators.
abstract class Generator extends ContextualSynthizerObject
    with PausableMixin, GainMixin {
  /// Create a generator.
  Generator(super.context);

  /// Create an instance from a handle.
  /// Whether or not this generator is looping.
  SynthizerBoolProperty get looping => SynthizerBoolProperty(
        synthizer: synthizer,
        targetHandle: handle,
        property: Properties.looping,
      );

  /// The pitch bend for this generator.
  SynthizerAutomatableDoubleProperty get pitchBend =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.pitchBend,
      );
}
