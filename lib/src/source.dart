/// Provides source classes.
import 'dart:ffi';

import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'generator.dart';
import 'synthizer.dart';
import 'synthizer_property.dart';

/// The base class for all sources.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/source.html)
abstract class Source extends SynthizerObject with PausableMixin {
  /// Create a source.
  Source(Context context) : super(context.synthizer) {
    gain = SynthizerDoubleProperty(synthizer, handle, Properties.gain);
    filter =
        SynthizerBiquadConfigProperty(synthizer, handle, Properties.filter);
  }

  /// Create an instance from a handle value.
  Source.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);

  /// The gain for this source.
  late final SynthizerDoubleProperty gain;

  /// Filter property.
  late final SynthizerBiquadConfigProperty filter;

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
/// [Synthizer docs](https://synthizer.github.io/object_reference/direct_source.html)
///
/// Direct sources can be created with [Context.createDirectSource].
class DirectSource extends Source {
  /// Create a direct source.
  DirectSource(Context context) : super(context) {
    synthizer.check(synthizer.synthizer.syz_createDirectSource(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle value.
  DirectSource.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);
}

/// A source with azimuth and elevation panning done by hand.
///
class AngularPannedSource extends Source {
  /// Create an instance.
  AngularPannedSource(Context context,
      {PannerStrategy pannerStrategy = PannerStrategy.delegate,
      double initialAzimuth = 0.0,
      double initialElevation = 0.0})
      : super(context) {
    synthizer.check(synthizer.synthizer.syz_createAngularPannedSource(
        handle,
        context.handle.value,
        pannerStrategy.toInt(),
        initialAzimuth,
        initialElevation,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    azimuth = SynthizerDoubleProperty(synthizer, handle, Properties.azimuth);
    elevation =
        SynthizerDoubleProperty(synthizer, handle, Properties.elevation);
  }

  /// Get an instance from a handle.
  AngularPannedSource.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The azimuth for this source.
  late final SynthizerDoubleProperty azimuth;

  /// The elevation for this source.
  late final SynthizerDoubleProperty elevation;
}

/// A source with panning done by way of a [panningScalar].
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/panned_source.html)
///
/// Instances can be created with [Context.createScalarPannedSource].
class ScalarPannedSource extends Source {
  /// Create a panned source with a scalar.
  ScalarPannedSource(Context context,
      {PannerStrategy panningStrategy = PannerStrategy.delegate,
      double initialPanningScalar = 0.0})
      : super(context) {
    synthizer.check(synthizer.synthizer.syz_createScalarPannedSource(
        handle,
        context.handle.value,
        panningStrategy.toInt(),
        initialPanningScalar,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    panningScalar =
        SynthizerDoubleProperty(synthizer, handle, Properties.panningScalar);
  }

  /// Create an instance from a handle value.
  ScalarPannedSource.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The panning scalar for this source.
  late final SynthizerDoubleProperty panningScalar;
}

/// A source with 3D parameters.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/source_3d.html)
///
/// Source 3ds can be created with [Context.createSource3D].
class Source3D extends Source {
  /// Create a 3d source.
  Source3D(Context context,
      {double x = 0.0,
      double y = 0.0,
      double z = 0.0,
      PannerStrategy pannerStrategy = PannerStrategy.delegate})
      : super(context) {
    synthizer.check(synthizer.synthizer.syz_createSource3D(
        handle,
        context.handle.value,
        pannerStrategy.toInt(),
        x,
        y,
        z,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    distanceMax =
        SynthizerDoubleProperty(synthizer, handle, Properties.distanceMax);
    distanceRef =
        SynthizerDoubleProperty(synthizer, handle, Properties.distanceRef);
    rolloff = SynthizerDoubleProperty(synthizer, handle, Properties.rolloff);
    closenessBoost =
        SynthizerDoubleProperty(synthizer, handle, Properties.closenessBoost);
    closenessBoostDistance = SynthizerDoubleProperty(
        synthizer, handle, Properties.closenessBoostDistance);
    position = SynthizerDouble3Property(synthizer, handle, Properties.position);
    distanceModel = SynthizerDistanceModelProperty(
        synthizer, handle, Properties.distanceModel);
  }

  /// Create an instance from a handle value.
  Source3D.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);

  /// The distance model for this object.
  late final SynthizerDistanceModelProperty distanceModel;

  /// The distance ref for this object.
  late final SynthizerDoubleProperty distanceRef;

  /// The distance max for this object.
  late final SynthizerDoubleProperty distanceMax;

  /// The rolloff for this object.
  late final SynthizerDoubleProperty rolloff;

  /// The closeness boost for this object.
  late final SynthizerDoubleProperty closenessBoost;

  /// The closeness boost distance for this object.
  late final SynthizerDoubleProperty closenessBoostDistance;

  /// The position of this object.
  late final SynthizerDouble3Property position;
}
