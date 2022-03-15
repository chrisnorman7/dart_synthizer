/// Provides the [Synthizer] class.
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'automation.dart';
import 'biquad.dart';
import 'buffer.dart';
import 'classes.dart';
import 'context.dart';
import 'effects.dart';
import 'enumerations.dart';
import 'error.dart';
import 'events.dart';
import 'generators/base.dart';
import 'generators/buffer_generator.dart';
import 'generators/fast_sine_bank_generator.dart';
import 'generators/noise_generator.dart';
import 'generators/streaming_generator.dart';
import 'source.dart';
import 'synthizer_bindings.dart';
import 'synthizer_property.dart';
import 'synthizer_version.dart';

/// The filename to use to load the Synthizer library from the current process.
///
/// This uses [DynamicLibrary.process] under the hood.
const synthizerProcessFilename = ':process:';

/// The filename to use to load Synthizer from the current executable.
///
/// This uses [DynamicLibrary.executable] under the hood.
const synthizerExecutableFilename = ':executable:';

/// The main synthizer class.
///
/// You must create an instance of this class in order to use the library.
class Synthizer {
  /// Create an instance.
  Synthizer({String? filename})
      : _eventPointer = calloc<syz_Event>(),
        intPointer = calloc<Int32>(),
        bigIntPointer = calloc<Uint64>(),
        majorPointer = calloc<Uint32>(),
        minorPointer = calloc<Uint32>(),
        patchPointer = calloc<Uint32>(),
        routeConfig = calloc<syz_RouteConfig>(),
        doublePointer = calloc<Double>(),
        x1 = calloc<Double>(),
        y1 = calloc<Double>(),
        z1 = calloc<Double>(),
        x2 = calloc<Double>(),
        y2 = calloc<Double>(),
        z2 = calloc<Double>(),
        userdataFreeCallbackPointer = nullptr.cast<syz_UserdataFreeCallback>(),
        deleteBehaviorConfigPointer = calloc<syz_DeleteBehaviorConfig>(),
        sineBankWavePointer = calloc<syz_SineBankWave>(),
        sineBankConfigPointer = calloc<syz_SineBankConfig>(),
        _wasInit = false {
    final DynamicLibrary library;
    if (filename == null) {
      if (Platform.isWindows) {
        library = DynamicLibrary.open('synthizer.dll');
      } else if (Platform.isLinux) {
        library = DynamicLibrary.open(
          path.join(Directory.current.path, 'libsynthizer.so'),
        );
      } else if (Platform.isMacOS) {
        library = DynamicLibrary.open('libsynthizer.dylib');
      } else {
        throw SynthizerError('Unhandled platform.', -1);
      }
    } else if (filename == synthizerExecutableFilename) {
      library = DynamicLibrary.executable();
    } else if (filename == synthizerProcessFilename) {
      library = DynamicLibrary.process();
    } else {
      library = DynamicLibrary.open(filename);
    }
    synthizer = DartSynthizer(library);
  }

  /// Create an instance with the library loaded from the current process.
  factory Synthizer.fromProcess() =>
      Synthizer(filename: synthizerProcessFilename);

  /// Create an instance with the library loaded from the current executable.
  factory Synthizer.fromExecutable() =>
      Synthizer(filename: synthizerExecutableFilename);

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

  /// The handle used by [SynthizerIntProperty], [SynthizerBoolProperty], and
  /// [SynthizerPannerStrategyProperty].
  final Pointer<Int32> intPointer;

  /// The handle to a bigger int.
  final Pointer<Uint64> bigIntPointer;

  /// Handles used by [version].
  final Pointer<Uint32> majorPointer;

  /// Handles used by [version].
  final Pointer<Uint32> minorPointer;

  /// Handles used by [version].
  final Pointer<Uint32> patchPointer;

  /// The handle used by [Context.ConfigRoute].
  final Pointer<syz_RouteConfig> routeConfig;

  /// The handle used by [SynthizerDoubleProperty].
  final Pointer<Double> doublePointer;

  /// Handles used by [SynthizerDouble3Property].
  final Pointer<Double> x1;

  /// Handles used by [SynthizerDouble3Property].
  final Pointer<Double> y1;

  /// Handles used by [SynthizerDouble3Property].
  final Pointer<Double> z1;

  /// Extra handles used by double6.
  final Pointer<Double> x2;

  /// Extra handles used by double6.
  final Pointer<Double> y2;

  /// Extra handles used by double6.
  final Pointer<Double> z2;

  /// The default pointer for freeing user data.
  final Pointer<syz_UserdataFreeCallback> userdataFreeCallbackPointer;

  /// The delete configuration.
  final Pointer<syz_DeleteBehaviorConfig> deleteBehaviorConfigPointer;

  /// A pointer for use by [FastSineBankGenerator].
  final Pointer<syz_SineBankWave> sineBankWavePointer;

  /// Another pointer used by [FastSineBankGenerator].
  final Pointer<syz_SineBankConfig> sineBankConfigPointer;

  /// Check if a returned value is an error.
  void check(int value) {
    if (value != 0) {
      throw SynthizerError.fromLib(synthizer);
    }
  }

  /// Initialise the library.
  void initialize(
      {LogLevel? logLevel,
      LoggingBackend? loggingBackend,
      String? libsndfilePath}) {
    final config = calloc<syz_LibraryConfig>();
    synthizer.syz_libraryConfigSetDefaults(config);
    if (logLevel != null) {
      config.ref.log_level = logLevel.toInt();
    }
    if (loggingBackend != null) {
      config.ref.logging_backend = loggingBackend.toInt();
    }
    Pointer<Int8>? libSndFilePointer;
    if (libsndfilePath != null) {
      libSndFilePointer = libsndfilePath.toNativeUtf8().cast<Int8>();
      config.ref.libsndfile_path = libSndFilePointer;
    }
    check(synthizer.syz_initializeWithConfig(config));
    if (libSndFilePointer != null) {
      malloc.free(libSndFilePointer);
    }
    calloc.free(config);
    _wasInit = true;
  }

  /// Shutdown the library.
  void shutdown() {
    check(synthizer.syz_shutdown());
    [
      _eventPointer,
      intPointer,
      bigIntPointer,
      majorPointer,
      minorPointer,
      patchPointer,
      routeConfig,
      doublePointer,
      x1,
      y1,
      z1,
      x2,
      y2,
      z2,
      userdataFreeCallbackPointer,
      deleteBehaviorConfigPointer,
      sineBankWavePointer,
      sineBankConfigPointer
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
    check(synthizer.syz_handleGetObjectType(intPointer, handle));
    return intPointer.value.toObjectType();
  }

  /// Get an object from [handle].
  ///
  /// *NOTE*: Objects constructed by this method should be used for comparison
  /// only.
  ///
  /// If you try to access properties for example, the behaviour is undefined.
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
      case ObjectType.automationBatch:
        return AutomationBatch.fromHandle(this, handle);
      case ObjectType.fastSineBankGenerator:
        return FastSineBankGenerator.fromHandle(this, handle);
    }
  }

  /// Get the next event for [context].
  SynthizerEvent? getContextEvent(Context context) {
    SynthizerEvent? value;
    check(synthizer.syz_contextGetNextEvent(
        _eventPointer, context.handle.value, 0));
    final sourceHandle = _eventPointer.ref.source;
    final eventType = _eventPointer.ref.type.toEventTypes();
    switch (eventType) {
      case EventTypes.finished:
        value = FinishedEvent(context, getObject(sourceHandle));
        break;
      case EventTypes.looped:
        value = LoopedEvent(context, getObject(sourceHandle) as Generator);
        break;
      case EventTypes.userAutomation:
        value = UserAutomationEvent(context, getObject(sourceHandle),
            _eventPointer.ref.payload.user_automation.param);
        break;
      case EventTypes.invalid:
        return null;
    }
    synthizer.syz_eventDeinit(_eventPointer);
    return value;
  }

  /// Get the synthizer version.
  SynthizerVersion get version {
    synthizer.syz_getVersion(majorPointer, minorPointer, patchPointer);
    return SynthizerVersion(
        majorPointer.value, minorPointer.value, patchPointer.value);
  }

  /// Increase the reference count for the object with the given [handle].
  void incRef(int handle) => check(synthizer.syz_handleIncRef(handle));

  /// Decrease the reference count for the object with the given [handle].
  void decRef(int handle) => check(synthizer.syz_handleDecRef(handle));
}
