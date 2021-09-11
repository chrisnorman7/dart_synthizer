/// Provides the [Context] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'buffer.dart';
import 'classes.dart';
import 'dart_synthizer.dart';
import 'enumerations.dart';
import 'events.dart';
import 'generator.dart';
import 'properties.dart';
import 'source.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// A synthizer context.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/context.html]
///
/// Contexts can be created with the [Synthizer.createContext] function.
class Context extends SynthizerObject with PausableMixin, GainMixin {
  /// Create a context.
  Context(Synthizer synthizer, {bool events = false}) : super(synthizer) {
    synthizer.check(synthizer.synthizer.syz_createContext(
        handle, nullptr, synthizer.userdataFreeCallbackPointer));
    if (events) {
      enableEvents();
    }
  }

  /// The pointer to use for events.
  final Pointer<syz_Event> _eventPointer = calloc<syz_Event>();

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
  PannerStrategies get defaultPannerStrategy =>
      synthizer.getDefaultPannerStrategy(handle);

  /// Set the default panner strategy for this context.
  set defaultPannerStrategy(PannerStrategies value) =>
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
  DistanceModels get defaultDistanceModel =>
      synthizer.getDefaultDistanceModel(handle);

  /// Set the default distance model for this object.
  set defaultDistanceModel(DistanceModels value) =>
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

  @override
  void destroy() {
    super.destroy();
    calloc.free(_eventPointer);
  }

  /// Get the next Synthizer event.
  SynthizerEvent? getEvent() {
    SynthizerEvent? value;
    synthizer.synthizer.syz_contextGetNextEvent(_eventPointer, handle.value, 0);
    final sourceHandle = _eventPointer.ref.source;
    switch (_eventPointer.ref.type) {
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_INVALID:
        // No events left.
        break;
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_FINISHED:
        // Something has finished. Let's find out what.
        final SynthizerObject source;
        final type = synthizer.getObjectType(_eventPointer.ref.source);
        switch (type) {
          case ObjectType.bufferGenerator:
            source = BufferGenerator(this)..handle.value = sourceHandle;
            break;
          case ObjectType.buffer:
            source = Buffer(synthizer)..handle.value = sourceHandle;
            break;
          case ObjectType.context:
            source = this;
            break;
          case ObjectType.streamingGenerator:
            source = StreamingGenerator.fromHandle(this, sourceHandle);
            break;
          case ObjectType.noiseGenerator:
            source = NoiseGenerator.fromHandle(this, sourceHandle);
            break;
          case ObjectType.directSource:
            source = DirectSource(this)..handle.value = sourceHandle;
            break;
          case ObjectType.pannedSource:
            source = PannedSource(this)..handle.value = sourceHandle;
            break;
          case ObjectType.source3D:
            source = Source3D(this)..handle.value = sourceHandle;
            break;
          case ObjectType.globalEcho:
            source = GlobalEcho(this)..handle.value = sourceHandle;
            break;
          case ObjectType.globalFdnReverb:
            source = GlobalFdnReverb(this)..handle.value = sourceHandle;
            break;
          default:
            throw SynthizerError(
                'Unhandled object type: $type.', _eventPointer.ref.source);
        }
        value = FinishedEvent(this, source);
        break;
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_LOOPED:
        final type = synthizer.getObjectType(sourceHandle);
        final Generator generator;
        switch (type) {
          case ObjectType.bufferGenerator:
            generator = BufferGenerator(this)..handle.value = sourceHandle;
            break;
          case ObjectType.streamingGenerator:
            generator = StreamingGenerator.fromHandle(this, sourceHandle);
            break;
          case ObjectType.noiseGenerator:
            generator = NoiseGenerator.fromHandle(this, sourceHandle);
            break;
          default:
            throw SynthizerError(
                'unhandled object type: $type.', _eventPointer.ref.source);
        }
        value = LoopedEvent(this, generator);
        break;
      default:
        throw SynthizerError('Unhandled event type.', _eventPointer.ref.type);
    }
    synthizer.synthizer.syz_eventDeinit(_eventPointer);
    return value;
  }
}
