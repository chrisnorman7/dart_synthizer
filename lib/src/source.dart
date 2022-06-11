/// Provides source classes.
import 'dart:ffi';

import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'generators/base.dart';
import 'synthizer_property.dart';

/// The base class for all sources.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/source.html)
abstract class Source extends ContextualSynthizerObject
    with PausableMixin, GainMixin {
  /// Create a source.
  Source(super.context);

  /// Filter property.
  SynthizerBiquadConfigProperty get filter => SynthizerBiquadConfigProperty(
        synthizer: synthizer,
        targetHandle: handle,
        property: Properties.filter,
      );

  /// The filter direct property.
  SynthizerBiquadConfigProperty get filterDirect =>
      SynthizerBiquadConfigProperty(
        synthizer: synthizer,
        targetHandle: handle,
        property: Properties.filterDirect,
      );

  /// The filter effects property.
  SynthizerBiquadConfigProperty get filterEffects =>
      SynthizerBiquadConfigProperty(
        synthizer: synthizer,
        targetHandle: handle,
        property: Properties.filterEffects,
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
}

/// A source with some kind of panning applied.
abstract class _PannedSource extends Source {
  /// Create an instance.
  _PannedSource(super.context);
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

  /// The azimuth for this source.
  SynthizerAutomatableDoubleProperty get azimuth =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.azimuth,
      );

  /// The elevation for this source.
  SynthizerAutomatableDoubleProperty get elevation =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.elevation,
      );
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

  /// The panning scalar for this source.
  SynthizerAutomatableDoubleProperty get panningScalar =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.panningScalar,
      );
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

  /// The distance model for this object.
  SynthizerDistanceModelProperty get distanceModel =>
      SynthizerDistanceModelProperty(
        synthizer: synthizer,
        targetHandle: handle,
        property: Properties.distanceModel,
      );

  /// The distance ref for this object.
  SynthizerAutomatableDoubleProperty get distanceRef =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.distanceRef,
      );

  /// The distance max for this object.
  SynthizerAutomatableDoubleProperty get distanceMax =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.distanceMax,
      );

  /// The rolloff for this object.
  SynthizerAutomatableDoubleProperty get rolloff =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.rolloff,
      );

  /// The closeness boost for this object.
  SynthizerAutomatableDoubleProperty get closenessBoost =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.closenessBoost,
      );

  /// The closeness boost distance for this object.
  SynthizerAutomatableDoubleProperty get closenessBoostDistance =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.closenessBoostDistance,
      );

  /// The position of this object.
  SynthizerDouble3Property get position => SynthizerDouble3Property(
        context: context,
        targetHandle: handle,
        property: Properties.position,
      );

  /// Orientation.
  SynthizerDouble6Property get orientation => SynthizerDouble6Property(
        context: context,
        targetHandle: handle,
        property: Properties.orientation,
      );
}
