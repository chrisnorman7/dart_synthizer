/// Provides the [Context] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'buffer.dart';
import 'classes.dart';
import 'dart_synthizer.dart';
import 'enumerations.dart';
import 'generator.dart';
import 'properties.dart';
import 'source.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// A synthizer context.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/context.html]
///
/// Contexts can be created with [Synthizer.createContext] function.
class Context extends SynthizerObject
    with PausableMixin, Properties3DMixin, GainMixin {
  /// Create a context.
  Context(Synthizer synthizer, {bool events = false}) : super(synthizer) {
    synthizer.check(synthizer.synthizer.syz_createContext(handle));
    if (events) {
      enableEvents();
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

  /// Get the panner strategy for this context.
  PannerStrategies get pannerStrategy => synthizer.getPannerStrategy(handle);

  /// Set the panner strategy for this context.
  set pannerStrategy(PannerStrategies value) =>
      synthizer.setPannerStrategy(handle, value);

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

  /// Create a panned source.
  PannedSource createPannedSource() => PannedSource(this);

  /// Create a 3d source.
  Source3D createSource3D() => Source3D(this);

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
}
