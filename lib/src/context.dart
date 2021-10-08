/// Provides the [Context] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'automation.dart';
import 'biquad.dart';
import 'buffer.dart';
import 'classes.dart';
import 'effects.dart';
import 'enumerations.dart';
import 'events.dart';
import 'generator.dart';
import 'properties.dart';
import 'source.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// A synthizer context.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/context.html)
///
/// Contexts can be created with the [Synthizer.createContext] function.
class Context extends SynthizerObject with PausableMixin, GainMixin {
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
  }

  /// Enable the streaming of context events.
  void enableEvents() => synthizer
      .check(synthizer.synthizer.syz_contextEnableEvents(handle.value));

  /// Get the orientation of this context.
  Double6 get orientation =>
      synthizer.getDouble6(handle, Properties.orientation);

  /// Set the orientation of this context.
  set orientation(Double6 value) =>
      synthizer.setDouble6(handle, Properties.orientation, value);

  /// Get the default panner strategy for this context.
  PannerStrategy get defaultPannerStrategy =>
      synthizer.getDefaultPannerStrategy(handle);

  /// Set the default panner strategy for this context.
  set defaultPannerStrategy(PannerStrategy value) =>
      synthizer.setDefaultPannerStrategy(handle, value);

  /// Get the default closeness boost for this object.
  double get defaultClosenessBoost =>
      synthizer.getDouble(handle, Properties.defaultClosenessBoost);

  /// Set the default closeness boost for this object.
  set defaultClosenessBoost(double value) =>
      synthizer.setDouble(handle, Properties.defaultClosenessBoost, value);

  /// Get the default closeness boost distance for this object.
  double get defaultClosenessBoostDistance =>
      synthizer.getDouble(handle, Properties.defaultClosenessBoostDistance);

  /// Set the default closeness boost distance for this object.
  set defaultClosenessBoostDistance(double value) => synthizer.setDouble(
      handle, Properties.defaultClosenessBoostDistance, value);

  /// Get the default distance max for this object.
  double get defaultDistanceMax =>
      synthizer.getDouble(handle, Properties.defaultDistanceMax);

  /// Set the default distance max for this object.
  set defaultDistanceMax(double value) =>
      synthizer.setDouble(handle, Properties.defaultDistanceMax, value);

  /// Get the default rolloff for this object.
  double get defaultRolloff =>
      synthizer.getDouble(handle, Properties.defaultRolloff);

  /// Set the default rolloff for this object.
  set defaultRolloff(double value) =>
      synthizer.setDouble(handle, Properties.defaultRolloff, value);

  /// Get the default distance model for this object.
  DistanceModel get defaultDistanceModel =>
      synthizer.getDefaultDistanceModel(handle);

  /// Set the default distance model for this object.
  set defaultDistanceModel(DistanceModel value) =>
      synthizer.setDefaultDistanceModel(handle, value);

  /// Get the default distance ref for this object.
  double get defaultDistanceRef =>
      synthizer.getDouble(handle, Properties.defaultDistanceRef);

  /// Set the default distance ref for this object.
  set defaultDistanceRef(double value) =>
      synthizer.setDouble(handle, Properties.defaultDistanceRef, value);

  /// Get the position of this object.
  Double3 get position => synthizer.getDouble3(handle, Properties.position);

  /// Set the position of this object.
  set position(Double3 value) =>
      synthizer.setDouble3(handle, Properties.position, value);

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
          azimuth: azimuth,
          elevation: elevation,
          pannerStrategy: pannerStrategy);

  /// Create a panned source with a scalar.
  ScalarPannedSource createScalarPannedSource(
          {PannerStrategy panningStrategy = PannerStrategy.delegate,
          double panningScalar = 0.0}) =>
      ScalarPannedSource(this,
          panningScalar: panningScalar, panningStrategy: panningStrategy);

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
    final cfg = calloc<syz_RouteConfig>();
    synthizer.check(synthizer.synthizer.syz_initRouteConfig(cfg));
    if (filter != null) {
      cfg.ref.filter = filter.config.ref;
    }
    cfg.ref
      ..gain = gain
      ..fade_time = fadeTime;
    synthizer.check(synthizer.synthizer.syz_routingConfigRoute(
        handle.value, output.handle.value, input.handle.value, cfg));
    calloc.free(cfg);
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

  /// Start automating [target].
  AutomationBatch executeAutomation(
          SynthizerObject target, List<AutomationCommand> commands) =>
      AutomationBatch(this)
        ..addCommands(target, commands)
        ..execute();
}
