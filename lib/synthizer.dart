/// Provides the [Synthizer] class.
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'biquad.dart';
import 'classes.dart';
import 'context.dart';
import 'dart_synthizer.dart';
import 'enumerations.dart';
import 'error.dart';
import 'properties.dart';
import 'synthizer_bindings.dart';

/// The main synthizer class.
///
/// You must create an instance of this class in order to use the library.
class Synthizer {
  /// Create an instance.
  Synthizer({String? filename})
      : _eventPointer = calloc<syz_Event>(),
        _wasInit = false {
    userdataFreeCallbackPointer = nullptr.cast<syz_UserdataFreeCallback>();
    deleteBehaviorConfigPointer = calloc<syz_DeleteBehaviorConfig>();
    if (filename == null) {
      if (Platform.isWindows) {
        filename = 'synthizer.dll';
      } else {
        throw SynthizerError('Unhandled platform.', -1);
      }
    }
    synthizer = DartSynthizer(DynamicLibrary.open(filename));
  }

  /// The handle used by [getContextEvent].
  final Pointer<syz_Event> _eventPointer;

  bool _wasInit;

  /// Whether or not [initialize] has been called.
  bool get wasInit => _wasInit;

  /// The C portion of the library.
  ///
  /// This member should not be accessed outside of this library. Instead,
  /// utility methods provided by this package should be used.
  late final DartSynthizer synthizer;

  /// The handle used by all calls to [getInt], [setInt], [getBool], and
  /// [setBool].
  final Pointer<Int32> _intPointer = calloc<Int32>();

  /// The handle used for all calls to [getDouble] and [setDouble].
  final Pointer<Double> _doublePointer = calloc<Double>();

  /// The handles used by [getDouble3].
  final Pointer<Double> _x1 = calloc<Double>();
  final Pointer<Double> _y1 = calloc<Double>();
  final Pointer<Double> _z1 = calloc<Double>();

  /// The extra handles used by double6.
  final Pointer<Double> _x2 = calloc<Double>();
  final Pointer<Double> _y2 = calloc<Double>();
  final Pointer<Double> _z2 = calloc<Double>();

  /// The default pointer for freeing user data.
  late final Pointer<syz_UserdataFreeCallback> userdataFreeCallbackPointer;

  /// The delete configuration.
  late final Pointer<syz_DeleteBehaviorConfig> deleteBehaviorConfigPointer;

  /// Check if a returned value is an error.
  void check(int value) {
    if (value != 0) {
      throw SynthizerError.fromLib(synthizer);
    }
  }

  /// Get an integer property.
  int getInt(Pointer<Uint64> handle, Properties property) {
    check(synthizer.syz_getI(_intPointer, handle.value, property.toInt()));
    return _intPointer.value;
  }

  /// Set a int property.
  void setInt(Pointer<Uint64> handle, Properties property, int value) =>
      check(synthizer.syz_setI(handle.value, property.toInt(), value));

  /// Get a boolean property.
  bool getBool(Pointer<Uint64> handle, Properties property) =>
      getInt(handle, property) == 1;

  /// Set a boolean property.
  void setBool(Pointer<Uint64> handle, Properties property, bool value) =>
      check(synthizer.syz_setI(handle.value, property.toInt(), value ? 1 : 0));

  /// Get a double property.
  double getDouble(Pointer<Uint64> handle, Properties property) {
    check(synthizer.syz_getD(_doublePointer, handle.value, property.toInt()));
    return _doublePointer.value;
  }

  /// Set a double property.
  void setDouble(Pointer<Uint64> handle, Properties property, double value) =>
      check(synthizer.syz_setD(handle.value, property.toInt(), value));

  /// Get a double3 property.
  Double3 getDouble3(Pointer<Uint64> handle, Properties property) {
    check(synthizer.syz_getD3(_x1, _y1, _z1, handle.value, property.toInt()));
    return Double3(_x1.value, _y1.value, _z1.value);
  }

  /// Set a double3 property.
  void setDouble3(Pointer<Uint64> handle, Properties property, Double3 value) =>
      check(synthizer.syz_setD3(
          handle.value, property.toInt(), value.x, value.y, value.z));

  /// Get a double6 property.
  Double6 getDouble6(Pointer<Uint64> handle, Properties property) {
    check(synthizer.syz_getD6(
        _x1, _y1, _z1, _x2, _y2, _z2, handle.value, property.toInt()));
    return Double6(
        _x1.value, _y1.value, _z1.value, _x2.value, _y2.value, _z2.value);
  }

  /// Set a double6 property.
  void setDouble6(Pointer<Uint64> handle, Properties property, Double6 value) =>
      check(synthizer.syz_setD6(handle.value, property.toInt(), value.x1,
          value.y1, value.z1, value.x2, value.y2, value.z2));

  /// Get a default panner strategy property.
  PannerStrategy getDefaultPannerStrategy(Pointer<Uint64> handle) =>
      getInt(handle, Properties.defaultPannerStrategy).toPannerStrategy();

  /// Set a default panner strategy.
  void setDefaultPannerStrategy(Pointer<Uint64> handle, PannerStrategy value) =>
      setInt(handle, Properties.defaultPannerStrategy, value.toInt());

  /// Get a distance model property.
  DistanceModel getDistanceModel(Pointer<Uint64> handle) =>
      getInt(handle, Properties.distanceModel).toDistanceModel();

  /// Set a distance model property.
  void setDistanceModel(Pointer<Uint64> handle, DistanceModel value) =>
      setInt(handle, Properties.distanceModel, value.toInt());

  /// Get a default distance model property.
  DistanceModel getDefaultDistanceModel(Pointer<Uint64> handle) =>
      getInt(handle, Properties.defaultDistanceModel).toDistanceModel();

  /// Set a default distance model property.
  void setDefaultDistanceModel(Pointer<Uint64> handle, DistanceModel value) =>
      setInt(handle, Properties.defaultDistanceModel, value.toInt());

  /// Set a biquad property.
  void setBiquad(
          Pointer<Uint64> handle, Properties property, BiquadConfig config) =>
      check(synthizer.syz_setBiquad(
          handle.value, property.toInt(), config.config));

  /// Initialise the library.
  void initialize(
      {LogLevel? logLevel,
      LoggingBackend? loggingBackend,
      String? libsndfilePath}) {
    final config = calloc<syz_LibraryConfig>();
    synthizer.syz_libraryConfigSetDefaults(config);
    if (logLevel != null) {
      final int level;
      switch (logLevel) {
        case LogLevel.error:
          level = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR;
          break;
        case LogLevel.warn:
          level = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN;
          break;
        case LogLevel.info:
          level = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO;
          break;
        case LogLevel.debug:
          level = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG;
          break;
      }
      config.ref.log_level = level;
    }
    if (loggingBackend != null) {
      final int backend;
      switch (loggingBackend) {
        case LoggingBackend.none:
          backend = SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_NONE;
          break;
        case LoggingBackend.stderr:
          backend = SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_STDERR;
          break;
      }
      config.ref.logging_backend = backend;
    }
    if (libsndfilePath != null) {
      config.ref.libsndfile_path = libsndfilePath.toNativeUtf8().cast<Int8>();
    }
    check(synthizer.syz_initializeWithConfig(config));
    _wasInit = true;
  }

  /// Shutdown the library.
  void shutdown() {
    check(synthizer.syz_shutdown());
    [
      _eventPointer,
      _intPointer,
      _doublePointer,
      _x1,
      _y1,
      _z1,
      _x2,
      _y2,
      _z2,
    ].forEach(calloc.free);
    _wasInit = false;
  }

  /// Create a context.
  Context createContext({bool events = false}) => Context(this, events: events);

  /// Shorthand for [BiquadConfig.designIdentity].
  BiquadConfig designIdentify() => BiquadConfig.designIdentity(this);

  /// Shorthand for [BiquadConfig.designLowpass].
  BiquadConfig designLowpass(double frequency,
          {double q = 0.7071135624381276}) =>
      BiquadConfig.designLowpass(this, frequency, q: q);

  /// Shorthand for [BiquadConfig.designHighpass].
  BiquadConfig designHighpass(double frequency,
          {double q = 0.7071135624381276}) =>
      BiquadConfig.designHighpass(this, frequency, q: q);

  /// Shorthand for [BiquadConfig.designBandpass].
  BiquadConfig designBandpass(double frequency, double bandwidth) =>
      BiquadConfig.designBandpass(this, frequency, bandwidth);

  /// Get the type of a handle.
  ObjectType getObjectType(int handle) {
    check(synthizer.syz_handleGetObjectType(_intPointer, handle));
    switch (_intPointer.value) {
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_ANGULAR_PANNED_SOURCE:
        return ObjectType.angularPannedSource;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_AUTOMATION_TIMELINE:
        return ObjectType.automationTimeline;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_BUFFER:
        return ObjectType.buffer;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_BUFFER_GENERATOR:
        return ObjectType.bufferGenerator;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_CONTEXT:
        return ObjectType.context;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_DIRECT_SOURCE:
        return ObjectType.directSource;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_GLOBAL_ECHO:
        return ObjectType.globalEcho;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_GLOBAL_FDN_REVERB:
        return ObjectType.globalFdnReverb;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_NOISE_GENERATOR:
        return ObjectType.noiseGenerator;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_SCALAR_PANNED_SOURCE:
        return ObjectType.scalarPannedSource;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_SOURCE_3D:
        return ObjectType.source3d;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_STREAMING_GENERATOR:
        return ObjectType.streamingGenerator;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_STREAM_HANDLE:
        return ObjectType.streamHandle;
      default:
        throw SynthizerError('Unhandled object type.', _intPointer.value);
    }
  }

  /// Get an object from [handle].
  SynthizerObject getObject(int handle) {
    final type = getObjectType(handle);
    switch (type) {
      case ObjectType.context:
        return Context(this, pointer: handle);
      case ObjectType.buffer:
        return Buffer(this, handle: handle);
      case ObjectType.bufferGenerator:
        return BufferGenerator.fromHandle(this, handle);
      case ObjectType.streamingGenerator:
        return StreamingGenerator.fromHandle(this, handle);
      case ObjectType.noiseGenerator:
        return NoiseGenerator.fromHandle(this, handle);
      case ObjectType.directSource:
        return DirectSource.fromHandle(this, handle);
      case ObjectType.angularPannedSource:
        return AngularPannedSource.fromHandle(this, handle);
      case ObjectType.scalarPannedSource:
        return ScalarPannedSource.fromHandle(this, handle);
      case ObjectType.source3d:
        return Source3D.fromHandle(this, handle);
      case ObjectType.globalEcho:
        return GlobalEcho.fromHandle(this, handle);
      case ObjectType.globalFdnReverb:
        return GlobalFdnReverb.fromHandle(this, handle);
      case ObjectType.streamHandle:
        throw UnimplementedError();
      case ObjectType.automationTimeline:
        throw UnimplementedError();
      case ObjectType.automationBatch:
        return AutomationBatch.fromHandle(this, handle);
    }
  }

  /// Get the next event for [context].
  SynthizerEvent? getContextEvent(Context context) {
    SynthizerEvent? value;
    check(synthizer.syz_contextGetNextEvent(
        _eventPointer, context.handle.value, 0));
    if (_eventPointer.ref.type == SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_INVALID) {
      return null;
    }
    final sourceHandle = _eventPointer.ref.source;
    final source = getObject(sourceHandle);
    switch (_eventPointer.ref.type) {
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_FINISHED:
        value = FinishedEvent(context, source);
        break;
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_LOOPED:
        value = LoopedEvent(context, source as Generator);
        break;
      default:
        throw SynthizerError('Unhandled event type.', _eventPointer.ref.type);
    }
    synthizer.syz_eventDeinit(_eventPointer);
    return value;
  }
}
