/// Provides various classes for use with Synthizer.
import 'dart:ffi';

import 'enumerations.dart';
import 'synthizer.dart';

/// The base class for all synthizer objects.
class SynthizerObject {
  /// The synthizer instance.
  final Synthizer synthizer;

  /// The handle for this context.
  final Pointer<Uint64> handle;

  /// Create an instance.
  SynthizerObject(this.synthizer, this.handle);

  /// Destroy this object.
  void destroy() =>
      synthizer.check(synthizer.synthizer.syz_handleFree(handle.value));
}

/// An object which can be played and paused.
class Pausable extends SynthizerObject {
  Pausable(Synthizer synthizer, Pointer<Uint64> handle)
      : super(synthizer, handle);

  /// Pause this object.
  void pause() => synthizer.check(synthizer.synthizer.syz_pause(handle.value));

  /// Play this object.
  void play() => synthizer.check(synthizer.synthizer.syz_play(handle.value));

  /// Get the gain of this object.
  double get gain => synthizer.getDouble(handle, Properties.gain);

  /// Set the gain of this object.
  set gain(double value) => synthizer.setDouble(handle, Properties.gain, value);
}
