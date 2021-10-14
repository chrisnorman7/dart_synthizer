/// Provides the [Context] class.
import 'dart:ffi';

import 'biquad.dart';
import 'buffer.dart';
import 'classes.dart';
import 'effects.dart';
import 'enumerations.dart';
import 'events.dart';
import 'generator.dart';
import 'source.dart';
import 'synthizer.dart';
import 'synthizer_property.dart';

/// A synthizer context.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/context.html)
///
/// Contexts can be created with the [Synthizer.createContext] function.
class Context extends SynthizerObject with PausableMixin {
  /// Create a context.
  Context(Synthizer synthizer, {bool events = false, int? pointer})
      : super(synthizer, pointer: pointer) {
    if (pointer == null) {
      synthizer.check(synthizer.synthizer.syz_createContext(
          handle, nullptr, synthizer.userdataFreeCallbackPointer));
      if (events) {
        enableEvents();
      }
    }
    orientation =
        SynthizerDouble6Property(synthizer, handle, Properties.orientation);
    defaultClosenessBoost = SynthizerDoubleProperty(
        synthizer, handle, Properties.defaultClosenessBoost);
    defaultClosenessBoostDistance = SynthizerDoubleProperty(
        synthizer, handle, Properties.defaultClosenessBoostDistance);
    defaultDistanceMax = SynthizerDoubleProperty(
        synthizer, handle, Properties.defaultDistanceMax);
    defaultRolloff =
        SynthizerDoubleProperty(synthizer, handle, Properties.defaultRolloff);
    defaultDistanceRef = SynthizerDoubleProperty(
        synthizer, handle, Properties.defaultDistanceRef);
    position = SynthizerDouble3Property(synthizer, handle, Properties.position);
    gain = SynthizerDoubleProperty(synthizer, handle, Properties.gain);
    defaultPannerStrategy = SynthizerPannerStrategyProperty(
        synthizer, handle, Properties.defaultPannerStrategy);
    defaultDistanceModel = SynthizerDistanceModelProperty(
        synthizer, handle, Properties.defaultDistanceModel);
  }

  /// Enable the streaming of context events.
  void enableEvents() => synthizer
      .check(synthizer.synthizer.syz_contextEnableEvents(handle.value));

  /// The orientation of this context.
  late final SynthizerDouble6Property orientation;

  /// The default panner strategy for this context.
  late final SynthizerPannerStrategyProperty defaultPannerStrategy;

  /// The default closeness boost for this object.
  late final SynthizerDoubleProperty defaultClosenessBoost;

  /// The default closeness boost distance for this object.
  late final SynthizerDoubleProperty defaultClosenessBoostDistance;

  /// The default distance max for this object.
  late final SynthizerDoubleProperty defaultDistanceMax;

  /// The default rolloff for this object.
  late final SynthizerDoubleProperty defaultRolloff;

  /// The default distance model for this object.
  late final SynthizerDistanceModelProperty defaultDistanceModel;

  /// The default distance ref for this object.
  late final SynthizerDoubleProperty defaultDistanceRef;

  /// The position of this object.
  late final SynthizerDouble3Property position;

  /// The gain for this instance.
  late final SynthizerDoubleProperty gain;

  /// Create a buffer generator.
  BufferGenerator createBufferGenerator({Buffer? buffer}) =>
      BufferGenerator(this, buffer: buffer);

  /// Create a streaming generator.
  StreamingGenerator createStreamingGenerator(String protocol, String path,
          {String options = ''}) =>
      StreamingGenerator(this, protocol, path, options: options);

  /// Create a noise generator.
  NoiseGenerator createNoiseGenerator({int channels = 1}) =>
      NoiseGenerator(this, channels: channels);

  /// Create a direct source.
  DirectSource createDirectSource() => DirectSource(this);

  /// Create a panned source with an azimuth and an elevation.
  AngularPannedSource createAngularPannedSource(
          {PannerStrategy pannerStrategy = PannerStrategy.delegate,
          double azimuth = 0.0,
          double elevation = 0.0}) =>
      AngularPannedSource(this,
          initialAzimuth: azimuth,
          initialElevation: elevation,
          pannerStrategy: pannerStrategy);

  /// Create a panned source with a scalar.
  ScalarPannedSource createScalarPannedSource(
          {PannerStrategy panningStrategy = PannerStrategy.delegate,
          double panningScalar = 0.0}) =>
      ScalarPannedSource(this,
          initialPanningScalar: panningScalar,
          panningStrategy: panningStrategy);

  /// Create a 3d source.
  Source3D createSource3D(
          {double x = 0.0,
          double y = 0.0,
          double z = 0.0,
          PannerStrategy pannerStrategy = PannerStrategy.delegate}) =>
      Source3D(this, pannerStrategy: pannerStrategy, x: x, y: y, z: z);

  /// Create a global echo.
  GlobalEcho createGlobalEcho() => GlobalEcho(this);

  /// Create a reverb.
  GlobalFdnReverb createGlobalFdnReverb() => GlobalFdnReverb(this);

  /// Configure an fx send.
  void ConfigRoute(SynthizerObject output, SynthizerObject input,
      {double gain = 1.0, double fadeTime = 0.01, BiquadConfig? filter}) {
    synthizer
        .check(synthizer.synthizer.syz_initRouteConfig(synthizer.routeConfig));
    if (filter != null) {
      synthizer.routeConfig.ref.filter = filter.config.ref;
    }
    synthizer.routeConfig.ref
      ..gain = gain
      ..fade_time = fadeTime;
    synthizer.check(synthizer.synthizer.syz_routingConfigRoute(handle.value,
        output.handle.value, input.handle.value, synthizer.routeConfig));
  }

  /// Remove an fx route.
  void removeRoute(SynthizerObject output, SynthizerObject input,
          {double fadeTime = 0.01}) =>
      synthizer.check(synthizer.synthizer.syz_routingRemoveRoute(
          handle.value, output.handle.value, input.handle.value, fadeTime));

  /// Get the next Synthizer event.
  SynthizerEvent? getEvent() => synthizer.getContextEvent(this);

  /// Get a stream of events.
  ///
  /// A pause of [duration] will be awaited between polling for events.
  Stream<SynthizerEvent> getEvents({Duration duration = Duration.zero}) async* {
    while (synthizer.wasInit) {
      final event = getEvent();
      if (event != null) {
        yield event;
      }
      await Future<void>.delayed(duration);
    }
  }

  /// Get a stream of synthizer events.
  ///
  /// This method uses the [getEvents] method with the default wait time.
  Stream<SynthizerEvent> get events => getEvents();
}
