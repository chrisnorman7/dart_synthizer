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
    synthizer.check(synthizer.synthizer
        .syz_createDirectSource(handle, context.handle.value));
  }
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
    synthizer.check(synthizer.synthizer
        .syz_createPannedSource(handle, context.handle.value));
  }

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
class Source3D extends Source with SpatializedSource, Properties3DMixin {
  /// Create a 3d source.
  Source3D(Context context) : super(context) {
    synthizer.check(
        synthizer.synthizer.syz_createSource3D(handle, context.handle.value));
  }
}
