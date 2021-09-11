/// Provides the [Synthizer] class.
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'biquad.dart';
import 'context.dart';
import 'enumerations.dart';
import 'error.dart';
import 'properties.dart';
import 'synthizer_bindings.dart';

/// The main synthizer class.
///
/// You must create an instance of this class in order to use the library.
class Synthizer {
  /// Create an instance.
  Synthizer({String? filename}) : _wasInit = false {
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

  /// Get an integer from a property member.
  int _propertyToInt(Properties property) {
    switch (property) {
      case Properties.azimuth:
        return SYZ_PROPERTIES.SYZ_P_AZIMUTH;
      case Properties.buffer:
        return SYZ_PROPERTIES.SYZ_P_BUFFER;
      case Properties.closenessBoost:
        return SYZ_PROPERTIES.SYZ_P_CLOSENESS_BOOST;
      case Properties.closenessBoostDistance:
        return SYZ_PROPERTIES.SYZ_P_CLOSENESS_BOOST_DISTANCE;
      case Properties.distanceMax:
        return SYZ_PROPERTIES.SYZ_P_DISTANCE_MAX;
      case Properties.distanceModel:
        return SYZ_PROPERTIES.SYZ_P_DISTANCE_MODEL;
      case Properties.distanceRef:
        return SYZ_PROPERTIES.SYZ_P_DISTANCE_REF;
      case Properties.elevation:
        return SYZ_PROPERTIES.SYZ_P_ELEVATION;
      case Properties.gain:
        return SYZ_PROPERTIES.SYZ_P_GAIN;
      case Properties.pannerStrategy:
        return SYZ_PROPERTIES.SYZ_P_PANNER_STRATEGY;
      case Properties.panningScalar:
        return SYZ_PROPERTIES.SYZ_P_PANNING_SCALAR;
      case Properties.position:
        return SYZ_PROPERTIES.SYZ_P_POSITION;
      case Properties.orientation:
        return SYZ_PROPERTIES.SYZ_P_ORIENTATION;
      case Properties.rolloff:
        return SYZ_PROPERTIES.SYZ_P_ROLLOFF;
      case Properties.looping:
        return SYZ_PROPERTIES.SYZ_P_LOOPING;
      case Properties.noiseType:
        return SYZ_PROPERTIES.SYZ_P_NOISE_TYPE;
      case Properties.pitchBend:
        return SYZ_PROPERTIES.SYZ_P_PITCH_BEND;
      case Properties.inputFilterEnabled:
        return SYZ_PROPERTIES.SYZ_P_INPUT_FILTER_ENABLED;
      case Properties.inputFilterCutoff:
        return SYZ_PROPERTIES.SYZ_P_INPUT_FILTER_CUTOFF;
      case Properties.meanFreePath:
        return SYZ_PROPERTIES.SYZ_P_MEAN_FREE_PATH;
      case Properties.t60:
        return SYZ_PROPERTIES.SYZ_P_T60;
      case Properties.lateReflectionsLFRolloff:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_LF_ROLLOFF;
      case Properties.lateReflectionsLFReference:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_LF_REFERENCE;
      case Properties.lateReflectionsHFRolloff:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_HF_ROLLOFF;
      case Properties.lateReflectionsHFReference:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_HF_REFERENCE;
      case Properties.lateReflectionsDiffusion:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_DIFFUSION;
      case Properties.lateReflectionsModulationDepth:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_MODULATION_DEPTH;
      case Properties.lateReflectionsModulationFrequency:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_MODULATION_FREQUENCY;
      case Properties.lateReflectionsDelay:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_DELAY;
      case Properties.filter:
        return SYZ_PROPERTIES.SYZ_P_FILTER;
      case Properties.filterDirect:
        return SYZ_PROPERTIES.SYZ_P_FILTER_DIRECT;
      case Properties.filterEffects:
        return SYZ_PROPERTIES.SYZ_P_FILTER_EFFECTS;
      case Properties.filterInput:
        return SYZ_PROPERTIES.SYZ_P_FILTER_INPUT;
      case Properties.defaultPannerStrategy:
        return SYZ_PROPERTIES.SYZ_P_DEFAULT_PANNER_STRATEGY;
      case Properties.playbackPosition:
        return SYZ_PROPERTIES.SYZ_P_PLAYBACK_POSITION;
      case Properties.defaultClosenessBoost:
        return SYZ_PROPERTIES.SYZ_P_DEFAULT_CLOSENESS_BOOST;
      case Properties.defaultClosenessBoostDistance:
        return SYZ_PROPERTIES.SYZ_P_DEFAULT_CLOSENESS_BOOST_DISTANCE;
      case Properties.defaultDistanceMax:
        return SYZ_PROPERTIES.SYZ_P_DEFAULT_DISTANCE_MAX;
      case Properties.defaultDistanceModel:
        return SYZ_PROPERTIES.SYZ_P_DEFAULT_DISTANCE_MODEL;
      case Properties.defaultDistanceRef:
        return SYZ_PROPERTIES.SYZ_P_DEFAULT_DISTANCE_REF;
      case Properties.defaultRolloff:
        return SYZ_PROPERTIES.SYZ_P_DEFAULT_ROLLOFF;
    }
  }

  /// Get an integer property.
  int getInt(Pointer<Uint64> handle, Properties property) {
    check(synthizer.syz_getI(
        _intPointer, handle.value, _propertyToInt(property)));
    return _intPointer.value;
  }

  /// Set a int property.
  void setInt(Pointer<Uint64> handle, Properties property, int value) =>
      check(synthizer.syz_setI(handle.value, _propertyToInt(property), value));

  /// Get a boolean property.
  bool getBool(Pointer<Uint64> handle, Properties property) =>
      getInt(handle, property) == 1;

  /// Set a boolean property.
  void setBool(Pointer<Uint64> handle, Properties property, bool value) =>
      check(synthizer.syz_setI(
          handle.value, _propertyToInt(property), value ? 1 : 0));

  /// Get a double property.
  double getDouble(Pointer<Uint64> handle, Properties property) {
    check(synthizer.syz_getD(
        _doublePointer, handle.value, _propertyToInt(property)));
    return _doublePointer.value;
  }

  /// Set a double property.
  void setDouble(Pointer<Uint64> handle, Properties property, double value) =>
      check(synthizer.syz_setD(handle.value, _propertyToInt(property), value));

  /// Get a double3 property.
  Double3 getDouble3(Pointer<Uint64> handle, Properties property) {
    check(synthizer.syz_getD3(
        _x1, _y1, _z1, handle.value, _propertyToInt(property)));
    return Double3(_x1.value, _y1.value, _z1.value);
  }

  /// Set a double3 property.
  void setDouble3(Pointer<Uint64> handle, Properties property, Double3 value) =>
      check(synthizer.syz_setD3(
          handle.value, _propertyToInt(property), value.x, value.y, value.z));

  /// Get a double6 property.
  Double6 getDouble6(Pointer<Uint64> handle, Properties property) {
    check(synthizer.syz_getD6(
        _x1, _y1, _z1, _x2, _y2, _z2, handle.value, _propertyToInt(property)));
    return Double6(
        _x1.value, _y1.value, _z1.value, _x2.value, _y2.value, _z2.value);
  }

  /// Set a double6 property.
  void setDouble6(Pointer<Uint64> handle, Properties property, Double6 value) =>
      check(synthizer.syz_setD6(handle.value, _propertyToInt(property),
          value.x1, value.y1, value.z1, value.x2, value.y2, value.z2));

  /// Convert an integer to a panner strategy.
  PannerStrategies _intToPannerStrategy(int i) {
    switch (i) {
      case SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_HRTF:
        return PannerStrategies.hrtf;
      case SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_STEREO:
        return PannerStrategies.stereo;
      default:
        throw SynthizerError('Unrecognised panner strategy.', i);
    }
  }

  /// Convert a panner strategy to an integer.
  int _pannerStrategyToInt(PannerStrategies strategy) {
    switch (strategy) {
      case PannerStrategies.hrtf:
        return SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_HRTF;
      case PannerStrategies.stereo:
        return SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_STEREO;
    }
  }

  /// Get a panner strategy property.
  PannerStrategies getPannerStrategy(Pointer<Uint64> handle) =>
      _intToPannerStrategy(getInt(handle, Properties.pannerStrategy));

  /// Set a panner strategy.
  void setPannerStrategy(Pointer<Uint64> handle, PannerStrategies value) =>
      setInt(handle, Properties.pannerStrategy, _pannerStrategyToInt(value));

  /// Get a default panner strategy property.
  PannerStrategies getDefaultPannerStrategy(Pointer<Uint64> handle) =>
      _intToPannerStrategy(getInt(handle, Properties.defaultPannerStrategy));

  /// Set a default panner strategy.
  void setDefaultPannerStrategy(
          Pointer<Uint64> handle, PannerStrategies value) =>
      setInt(handle, Properties.defaultPannerStrategy,
          _pannerStrategyToInt(value));

  /// Convert an integer to a distance model.
  DistanceModels _intToDistanceModel(int i) {
    switch (i) {
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_EXPONENTIAL:
        return DistanceModels.exponential;
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_INVERSE:
        return DistanceModels.inverse;
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_LINEAR:
        return DistanceModels.linear;
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_NONE:
        return DistanceModels.none;
      default:
        throw SynthizerError('Unrecognised distance model.', i);
    }
  }

  /// Convert a distance model to an integer.
  int _distanceModelToInt(DistanceModels model) {
    switch (model) {
      case DistanceModels.exponential:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_EXPONENTIAL;
      case DistanceModels.none:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_NONE;
      case DistanceModels.linear:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_LINEAR;
      case DistanceModels.inverse:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_INVERSE;
    }
  }

  /// Get a distance model property.
  DistanceModels getDistanceModel(Pointer<Uint64> handle) =>
      _intToDistanceModel(getInt(handle, Properties.distanceModel));

  /// Set a distance model property.
  void setDistanceModel(Pointer<Uint64> handle, DistanceModels value) =>
      setInt(handle, Properties.distanceModel, _distanceModelToInt(value));

  /// Get a default distance model property.
  DistanceModels getDefaultDistanceModel(Pointer<Uint64> handle) =>
      _intToDistanceModel(getInt(handle, Properties.defaultDistanceModel));

  /// Set a default distance model property.
  void setDefaultDistanceModel(Pointer<Uint64> handle, DistanceModels value) =>
      setInt(
          handle, Properties.defaultDistanceModel, _distanceModelToInt(value));

  /// Set a biquad property.
  void setBiquad(
          Pointer<Uint64> handle, Properties property, BiquadConfig config) =>
      check(synthizer.syz_setBiquad(
          handle.value, _propertyToInt(property), config.config));

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
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_PANNED_SOURCE:
        return ObjectType.pannedSource;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_SOURCE_3D:
        return ObjectType.source3D;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_STREAMING_GENERATOR:
        return ObjectType.streamingGenerator;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_STREAM_HANDLE:
        return ObjectType.streamHandle;
      default:
        throw SynthizerError('Unrecognised object type.', _intPointer.value);
    }
  }
}
