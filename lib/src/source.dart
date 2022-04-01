/// Provides source classes.
import 'dart:ffi';

import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'generators/base.dart';
import 'synthizer.dart';
import 'synthizer_property.dart';

/// The base class for all sources.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/source.html)
abstract class Source extends SynthizerObject with PausableMixin, GainMixin {
  /// Create a source.
  Source(final Context context) : super(context.synthizer);

  /// Create an instance from a handle value.
  Source.fromHandle(final Synthizer synthizer, final int pointer)
      : super(synthizer, pointer: pointer);

  /// Filter property.
  SynthizerBiquadConfigProperty get filter =>
      SynthizerBiquadConfigProperty(synthizer, handle, Properties.filter);

  /// The filter direct property.
  SynthizerBiquadConfigProperty get filterDirect =>
      SynthizerBiquadConfigProperty(synthizer, handle, Properties.filterDirect);

  /// The filter effects property.
  SynthizerBiquadConfigProperty get filterEffects =>
      SynthizerBiquadConfigProperty(
        synthizer,
        handle,
        Properties.filterEffects,
      );

  /// Add a generator to this source.
  void addGenerator(final Generator generator) => synthizer.check(
        synthizer.synthizer
            .syz_sourceAddGenerator(handle.value, generator.handle.value),
      );

  /// Add an iterator of [generators] to this source.
  void addGenerators(final Iterable<Generator> generators) =>
      generators.forEach(addGenerator);

  /// Remove a generator from this source.
  void removeGenerator(final Generator generator) => synthizer.check(
        synthizer.synthizer
            .syz_sourceRemoveGenerator(handle.value, generator.handle.value),
      );

  /// Remove every generator in [generators] from this source.
  void removeGenerators(final Iterable<Generator> generators) =>
      generators.forEach(removeGenerator);
}

/// A source with no panning.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/direct_source.html)
///
/// Direct sources can be created with [Context.createDirectSource].
class DirectSource extends Source {
  /// Create a direct source.
  DirectSource(final Context context) : super(context) {
    synthizer.check(
      synthizer.synthizer.syz_createDirectSource(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
  }

  /// Create an instance from a handle value.
  DirectSource.fromHandle(final Synthizer synthizer, final int pointer)
      : super.fromHandle(synthizer, pointer);
}

/// A source with some kind of panning applied.
abstract class _PannedSource extends Source {
  /// Create an instance.
  _PannedSource(final Context context) : super(context);

  /// Create an instance from a handle.
  _PannedSource.fromHandle(final Synthizer synthizer, final int pointer)
      : super.fromHandle(synthizer, pointer);
}

/// A source with azimuth and elevation panning done by hand.
///
class AngularPannedSource extends _PannedSource {
  /// Create an instance.
  AngularPannedSource(
    final Context context, {
    final PannerStrategy pannerStrategy = PannerStrategy.delegate,
    final double initialAzimuth = 0.0,
    final double initialElevation = 0.0,
  }) : super(context) {
    synthizer.check(
      synthizer.synthizer.syz_createAngularPannedSource(
        handle,
        context.handle.value,
        pannerStrategy.toInt(),
        initialAzimuth,
        initialElevation,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
  }

  /// Get an instance from a handle.
  AngularPannedSource.fromHandle(final Synthizer synthizer, final int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The azimuth for this source.
  SynthizerDoubleProperty get azimuth =>
      SynthizerDoubleProperty(synthizer, handle, Properties.azimuth);

  /// The elevation for this source.
  SynthizerDoubleProperty get elevation =>
      SynthizerDoubleProperty(synthizer, handle, Properties.elevation);
}

/// A source with panning done by way of a [panningScalar].
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/panned_source.html)
///
/// Instances can be created with [Context.createScalarPannedSource].
class ScalarPannedSource extends _PannedSource {
  /// Create a panned source with a scalar.
  ScalarPannedSource(
    final Context context, {
    final PannerStrategy panningStrategy = PannerStrategy.delegate,
    final double initialPanningScalar = 0.0,
  }) : super(context) {
    synthizer.check(
      synthizer.synthizer.syz_createScalarPannedSource(
        handle,
        context.handle.value,
        panningStrategy.toInt(),
        initialPanningScalar,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
  }

  /// Create an instance from a handle value.
  ScalarPannedSource.fromHandle(final Synthizer synthizer, final int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The panning scalar for this source.
  SynthizerDoubleProperty get panningScalar =>
      SynthizerDoubleProperty(synthizer, handle, Properties.panningScalar);
}

/// A source with 3D parameters.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/source_3d.html)
///
/// Source 3ds can be created with [Context.createSource3D].
class Source3D extends _PannedSource {
  /// Create a 3d source.
  Source3D(
    final Context context, {
    final double x = 0.0,
    final double y = 0.0,
    final double z = 0.0,
    final PannerStrategy pannerStrategy = PannerStrategy.delegate,
  }) : super(context) {
    synthizer.check(
      synthizer.synthizer.syz_createSource3D(
        handle,
        context.handle.value,
        pannerStrategy.toInt(),
        x,
        y,
        z,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
  }

  /// Create an instance from a handle value.
  Source3D.fromHandle(final Synthizer synthizer, final int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The distance model for this object.
  SynthizerDistanceModelProperty get distanceModel =>
      SynthizerDistanceModelProperty(
        synthizer,
        handle,
        Properties.distanceModel,
      );

  /// The distance ref for this object.
  SynthizerDoubleProperty get distanceRef =>
      SynthizerDoubleProperty(synthizer, handle, Properties.distanceRef);

  /// The distance max for this object.
  SynthizerDoubleProperty get distanceMax =>
      SynthizerDoubleProperty(synthizer, handle, Properties.distanceMax);

  /// The rolloff for this object.
  SynthizerDoubleProperty get rolloff =>
      SynthizerDoubleProperty(synthizer, handle, Properties.rolloff);

  /// The closeness boost for this object.
  SynthizerDoubleProperty get closenessBoost =>
      SynthizerDoubleProperty(synthizer, handle, Properties.closenessBoost);

  /// The closeness boost distance for this object.
  SynthizerDoubleProperty get closenessBoostDistance => SynthizerDoubleProperty(
        synthizer,
        handle,
        Properties.closenessBoostDistance,
      );

  /// The position of this object.
  SynthizerDouble3Property get position =>
      SynthizerDouble3Property(synthizer, handle, Properties.position);

  /// Orientation.
  SynthizerDouble6Property get orientation =>
      SynthizerDouble6Property(synthizer, handle, Properties.orientation);
}
