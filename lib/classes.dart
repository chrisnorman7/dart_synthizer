/// Provides various classes for use with Synthizer.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'context.dart';
import 'enumerations.dart';
import 'properties.dart';
import 'source.dart';
import 'synthizer.dart';

/// The base class for all synthizer objects.
class SynthizerObject {
  /// Create an instance.
  SynthizerObject(this.synthizer, {Pointer<Uint64>? handle})
      // ignore: unnecessary_this
      : this.handle = handle ?? calloc<Uint64>();

  /// The synthizer instance.
  final Synthizer synthizer;

  /// The handle for this context.
  final Pointer<Uint64> handle;

  /// Destroy this object.
  void destroy() {
    synthizer.check(synthizer.synthizer.syz_handleFree(handle.value));
    calloc.free(handle);
    handle.value = 0;
  }

  /// Returns `true` if this object is still valid.
  bool get isValid => handle.value != 0;
}

/// Provides a [gain] property.
mixin GainMixin on SynthizerObject {
  /// Get the gain of this object.
  double get gain => synthizer.getDouble(handle, Properties.gain);

  /// Set the gain of this object.
  set gain(double value) => synthizer.setDouble(handle, Properties.gain, value);
}

/// Base class for anything which can be paused. Adds pause and play methods.
mixin PausableMixin on SynthizerObject {
  /// Pause this object.
  void pause() => synthizer.check(synthizer.synthizer.syz_pause(handle.value));

  /// Play this object.
  void play() => synthizer.check(synthizer.synthizer.syz_play(handle.value));
}

/// Adds common properties for [Source3D] and [Context].
mixin Properties3DMixin on SynthizerObject {
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

/// An object which can be looped.
mixin LoopableMixin on SynthizerObject {
  /// Get whether or not this generator is looping.
  bool get looping => synthizer.getBool(handle, Properties.looping);

  /// Set whether or not this generator should loop.
  set looping(bool value) =>
      synthizer.setBool(handle, Properties.looping, value);
}
