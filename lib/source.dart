/// Provides source classes.
import 'dart:ffi';

import 'classes.dart';
import 'context.dart';
import 'dart_synthizer.dart';
import 'enumerations.dart';
import 'generator.dart';

/// The base class for all sources.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/source.html]
abstract class Source extends SynthizerObject with PausableMixin, GainMixin {
  /// Create a source.
  Source(Context context) : super(context.synthizer);

  /// Create an instance from a handle value.
  Source.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);

  /// Set filter property.
  set filter(BiquadConfig config) =>
      synthizer.setBiquad(handle, Properties.filter, config);

  /// Add a generator to this source.
  void addGenerator(Generator generator) => synthizer.check(synthizer.synthizer
      .syz_sourceAddGenerator(handle.value, generator.handle.value));

  /// Remove a generator from this source.
  void removeGenerator(Generator generator) =>
      synthizer.check(synthizer.synthizer
          .syz_sourceRemoveGenerator(handle.value, generator.handle.value));
}

/// A source with no panning.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/direct_source.html]
///
/// Direct sources can be created with [Context.createDirectSource].
class DirectSource extends Source {
  /// Create a direct source.
  DirectSource(Context context) : super(context) {
    synthizer.check(synthizer.synthizer.syz_createDirectSource(handle,
        context.handle.value, nullptr, synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle value.
  DirectSource.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);
}

/// Properties common to [PannedSource] and [Source3D].
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/spatialized_source.html]
mixin SpatializedSource on Source {
  /// Get the panner strategy for this source.
  PannerStrategies get pannerStrategy => synthizer.getPannerStrategy(handle);

  /// Set the panner strategy for this source.
  set pannerStrategy(PannerStrategies value) =>
      synthizer.setPannerStrategy(handle, value);
}

/// A source with azimuth and elevation panning done by hand.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/panned_source.html]
///
/// Panned sources can be created with [Context.createPannedSource].
class PannedSource extends Source with SpatializedSource {
  /// Create a panned source.
  PannedSource(Context context) : super(context) {
    synthizer.check(synthizer.synthizer.syz_createPannedSource(handle,
        context.handle.value, nullptr, synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle value.
  PannedSource.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// Get the azimuth for this source.
  double get azimuth => synthizer.getDouble(handle, Properties.azimuth);

  /// Set the azimuth for this source.
  set azimuth(double value) =>
      synthizer.setDouble(handle, Properties.azimuth, value);

  /// Get the elevation for this source.
  double get elevation => synthizer.getDouble(handle, Properties.elevation);

  /// Set the elevation for this source.
  set elevation(double value) =>
      synthizer.setDouble(handle, Properties.elevation, value);

  /// Get the panning scalar for this source.
  double get panningScalar =>
      synthizer.getDouble(handle, Properties.panningScalar);

  /// Set the panning scala for this source.
  set panningScalar(double value) =>
      synthizer.setDouble(handle, Properties.panningScalar, value);
}

/// A source with 3D parameters.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/source_3d.html]
///
/// Source 3ds can be created with [Context.createSource3D].
class Source3D extends Source with SpatializedSource {
  /// Create a 3d source.
  Source3D(Context context) : super(context) {
    synthizer.check(synthizer.synthizer.syz_createSource3D(handle,
        context.handle.value, nullptr, synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle value.
  Source3D.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

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
