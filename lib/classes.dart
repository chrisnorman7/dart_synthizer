/// Provides various classes for use with Synthizer.
import 'dart:ffi';

import 'context.dart';
import 'enumerations.dart';
import 'properties.dart';
import 'source.dart';
import 'synthizer.dart';

/// The base class for all synthizer objects.
class SynthizerObject {
  /// Create an instance.
  SynthizerObject(this.synthizer, this.handle);

  /// The synthizer instance.
  final Synthizer synthizer;

  /// The handle for this context.
  final Pointer<Uint64> handle;

  /// Destroy this object.
  void destroy() =>
      synthizer.check(synthizer.synthizer.syz_handleFree(handle.value));
}

/// An object which can be played and paused.
class Pausable extends SynthizerObject {
  /// Default constructor.
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

/// Adds common properties for [Source3D] and [Context].
mixin Properties3D {
  /// The instance to call methods on.
  late final Synthizer synthizer;

  /// The handle this object uses in C land.
  late final Pointer<Uint64> handle;

  /// Get the distance model for this object.
  DistanceModels get distanceModel => synthizer.getDistanceModel(handle);

  /// Set the distance model for this object.
  set distanceModel(DistanceModels value) =>
      synthizer.setDistanceModel(handle, value);

  /// Get the distance ref for this object.
  double get distanceRef => synthizer.getDouble(handle, Properties.distanceRef);

  /// Set the distance ref for this object.
  set distanceRef(double value) =>
      synthizer.setDouble(handle, Properties.distanceRef, value);

  /// Get the distance max for this object.
  double get distanceMax => synthizer.getDouble(handle, Properties.distanceMax);

  /// Set the distance max for this object.
  set distanceMax(double value) =>
      synthizer.setDouble(handle, Properties.distanceMax, value);

  /// Get the rolloff for this object.
  double get rolloff => synthizer.getDouble(handle, Properties.rolloff);

  /// Set the rolloff for this object.
  set rolloff(double value) =>
      synthizer.setDouble(handle, Properties.rolloff, value);

  /// Get the closeness boost for this object.
  double get closenessBoost =>
      synthizer.getDouble(handle, Properties.closenessBoost);

  /// Set the closeness boost for this object.
  set closenessBoost(double value) =>
      synthizer.setDouble(handle, Properties.closenessBoost, value);

  /// Get the closeness boost distance for this object.
  double get closenessBoostDistance =>
      synthizer.getDouble(handle, Properties.closenessBoostDistance);

  /// Set the closeness boost distance for this object.
  set closenessBoostDistance(double value) =>
      synthizer.setDouble(handle, Properties.closenessBoostDistance, value);

  /// Get the position of this object.
  Double3 get position => synthizer.getDouble3(handle, Properties.position);

  /// Set the position of this object.
  set position(Double3 value) =>
      synthizer.setDouble3(handle, Properties.position, value);
}
