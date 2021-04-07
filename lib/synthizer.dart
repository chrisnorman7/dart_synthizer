/// Provides the [Synthizer] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'context.dart';
import 'enumerations.dart';
import 'error.dart';
import 'properties.dart';
import 'synthizer_bindings.dart';

/// The main synthizer class.
///
/// You must create an instance of this class in order to use the library.
class Synthizer {
  /// The C portion of the library.
  ///
  /// This member should not be accessed outside of this library. Instead, utility methods provided by this package should be used.
  final DartSynthizer synthizer;

  /// The handle used by all calls to [getInt], [setInt], [getBool], and [setBool].
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

  /// Create an instance.
  ///
  /// If you would rather create an instance from a filename, use the [fromPath] constructor.
  Synthizer(DynamicLibrary lib) : synthizer = DartSynthizer(lib);

  /// Create an instance from a filename.
  ///
  /// If you would rather create a [DynamicLibrary] manually, use the default constructor.
  Synthizer.fromPath(String path)
      : synthizer = DartSynthizer(DynamicLibrary.open(path));

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
      getInt(handle, property) == 1 ? true : false;

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

  /// Initialise the library.
  void initialize() => check(synthizer.syz_initialize());

  /// Shutdown the library.
  void shutdown() => check(synthizer.syz_shutdown());

  /// Set the logging level.
  void setLogLevel(LogLevel level) {
    final int logLevel;
    switch (level) {
      case LogLevel.error:
        logLevel = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR;
        break;
      case LogLevel.warn:
        logLevel = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN;
        break;
      case LogLevel.info:
        logLevel = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO;
        break;
      case LogLevel.debug:
        logLevel = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG;
        break;
    }
    synthizer.syz_setLogLevel(logLevel);
  }

  /// Configure the logging backend to use.
  void configureLoggingBackend(LoggingBackend backend) {
    final int loggingBackend;
    switch (backend) {
      case LoggingBackend.stderr:
        loggingBackend = SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_STDERR;
        break;
    }
    synthizer.syz_configureLoggingBackend(loggingBackend, nullptr);
  }

  /// Create a context.
  Context createContext({bool events = false}) => Context(this, events: events);
}
