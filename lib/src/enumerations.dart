import 'synthizer_bindings.dart';
import 'synthizer_error.dart';

/// SYZ_LOGGING_BACKEND.
enum LoggingBackend {
  /// SYZ_LOGGING_BACKEND_NONE = 0
  none,

  /// SYZ_LOGGING_BACKEND_STDERR = 1
  stderr,
}

/// An extension for converting Dart to Synthizer values.
extension LoggingBackendToInt on LoggingBackend {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case LoggingBackend.none:
        return SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_NONE;
      case LoggingBackend.stderr:
        return SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_STDERR;
    }
  }
}

/// SYZ_LOG_LEVEL.
enum LogLevel {
  /// SYZ_LOG_LEVEL_ERROR = 0
  error,

  /// SYZ_LOG_LEVEL_WARN = 10
  warn,

  /// SYZ_LOG_LEVEL_INFO = 20
  info,

  /// SYZ_LOG_LEVEL_DEBUG = 30
  debug,
}

/// An extension for converting Dart to Synthizer values.
extension LogLevelToInt on LogLevel {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case LogLevel.error:
        return SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR;
      case LogLevel.warn:
        return SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN;
      case LogLevel.info:
        return SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO;
      case LogLevel.debug:
        return SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG;
    }
  }
}

/// SYZ_OBJECT_TYPE.
enum ObjectType {
  /// SYZ_OTYPE_CONTEXT = 0
  context,

  /// SYZ_OTYPE_BUFFER = 1
  buffer,

  /// SYZ_OTYPE_BUFFER_GENERATOR = 2
  bufferGenerator,

  /// SYZ_OTYPE_STREAMING_GENERATOR = 3
  streamingGenerator,

  /// SYZ_OTYPE_NOISE_GENERATOR = 4
  noiseGenerator,

  /// SYZ_OTYPE_DIRECT_SOURCE = 5
  directSource,

  /// SYZ_OTYPE_ANGULAR_PANNED_SOURCE = 6
  angularPannedSource,

  /// SYZ_OTYPE_SCALAR_PANNED_SOURCE = 7
  scalarPannedSource,

  /// SYZ_OTYPE_SOURCE_3D = 8
  source3d,

  /// SYZ_OTYPE_GLOBAL_ECHO = 9
  globalEcho,

  /// SYZ_OTYPE_GLOBAL_FDN_REVERB = 10
  globalFdnReverb,

  /// SYZ_OTYPE_STREAM_HANDLE = 11
  streamHandle,

  /// SYZ_OTYPE_AUTOMATION_BATCH = 12
  automationBatch,

  /// SYZ_OTYPE_FAST_SINE_BANK_GENERATOR = 13
  fastSineBankGenerator,
}

/// An extension for converting Dart to Synthizer values.
extension ObjectTypeToInt on ObjectType {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case ObjectType.context:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_CONTEXT;
      case ObjectType.buffer:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_BUFFER;
      case ObjectType.bufferGenerator:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_BUFFER_GENERATOR;
      case ObjectType.streamingGenerator:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_STREAMING_GENERATOR;
      case ObjectType.noiseGenerator:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_NOISE_GENERATOR;
      case ObjectType.directSource:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_DIRECT_SOURCE;
      case ObjectType.angularPannedSource:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_ANGULAR_PANNED_SOURCE;
      case ObjectType.scalarPannedSource:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_SCALAR_PANNED_SOURCE;
      case ObjectType.source3d:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_SOURCE_3D;
      case ObjectType.globalEcho:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_GLOBAL_ECHO;
      case ObjectType.globalFdnReverb:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_GLOBAL_FDN_REVERB;
      case ObjectType.streamHandle:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_STREAM_HANDLE;
      case ObjectType.automationBatch:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_AUTOMATION_BATCH;
      case ObjectType.fastSineBankGenerator:
        return SYZ_OBJECT_TYPE.SYZ_OTYPE_FAST_SINE_BANK_GENERATOR;
    }
  }
}

/// SYZ_PANNER_STRATEGY.
enum PannerStrategy {
  /// SYZ_PANNER_STRATEGY_DELEGATE = 0
  delegate,

  /// SYZ_PANNER_STRATEGY_HRTF = 1
  hrtf,

  /// SYZ_PANNER_STRATEGY_STEREO = 2
  stereo,

  /// SYZ_PANNER_STRATEGY_COUNT = 3
  count,
}

/// An extension for converting Dart to Synthizer values.
extension PannerStrategyToInt on PannerStrategy {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case PannerStrategy.delegate:
        return SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_DELEGATE;
      case PannerStrategy.hrtf:
        return SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_HRTF;
      case PannerStrategy.stereo:
        return SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_STEREO;
      case PannerStrategy.count:
        return SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_COUNT;
    }
  }
}

/// SYZ_DISTANCE_MODEL.
enum DistanceModel {
  /// SYZ_DISTANCE_MODEL_NONE = 0
  none,

  /// SYZ_DISTANCE_MODEL_LINEAR = 1
  linear,

  /// SYZ_DISTANCE_MODEL_EXPONENTIAL = 2
  exponential,

  /// SYZ_DISTANCE_MODEL_INVERSE = 3
  inverse,

  /// SYZ_DISTANCE_MODEL_COUNT = 4
  count,
}

/// An extension for converting Dart to Synthizer values.
extension DistanceModelToInt on DistanceModel {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case DistanceModel.none:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_NONE;
      case DistanceModel.linear:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_LINEAR;
      case DistanceModel.exponential:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_EXPONENTIAL;
      case DistanceModel.inverse:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_INVERSE;
      case DistanceModel.count:
        return SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_COUNT;
    }
  }
}

/// SYZ_NOISE_TYPE.
enum NoiseType {
  /// SYZ_NOISE_TYPE_UNIFORM = 0
  uniform,

  /// SYZ_NOISE_TYPE_VM = 1
  vm,

  /// SYZ_NOISE_TYPE_FILTERED_BROWN = 2
  filteredBrown,

  /// SYZ_NOISE_TYPE_COUNT = 3
  count,
}

/// An extension for converting Dart to Synthizer values.
extension NoiseTypeToInt on NoiseType {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case NoiseType.uniform:
        return SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_UNIFORM;
      case NoiseType.vm:
        return SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_VM;
      case NoiseType.filteredBrown:
        return SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_FILTERED_BROWN;
      case NoiseType.count:
        return SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_COUNT;
    }
  }
}

/// SYZ_PROPERTIES.
enum Properties {
  /// SYZ_P_AZIMUTH = 0
  azimuth,

  /// SYZ_P_BUFFER = 1
  buffer,

  /// SYZ_P_ELEVATION = 2
  elevation,

  /// SYZ_P_GAIN = 3
  gain,

  /// SYZ_P_DEFAULT_PANNER_STRATEGY = 4
  defaultPannerStrategy,

  /// SYZ_P_PANNING_SCALAR = 5
  panningScalar,

  /// SYZ_P_PLAYBACK_POSITION = 6
  playbackPosition,

  /// SYZ_P_POSITION = 7
  position,

  /// SYZ_P_ORIENTATION = 8
  orientation,

  /// SYZ_P_CLOSENESS_BOOST = 9
  closenessBoost,

  /// SYZ_P_CLOSENESS_BOOST_DISTANCE = 10
  closenessBoostDistance,

  /// SYZ_P_DISTANCE_MAX = 11
  distanceMax,

  /// SYZ_P_DISTANCE_MODEL = 12
  distanceModel,

  /// SYZ_P_DISTANCE_REF = 13
  distanceRef,

  /// SYZ_P_ROLLOFF = 14
  rolloff,

  /// SYZ_P_DEFAULT_CLOSENESS_BOOST = 15
  defaultClosenessBoost,

  /// SYZ_P_DEFAULT_CLOSENESS_BOOST_DISTANCE = 16
  defaultClosenessBoostDistance,

  /// SYZ_P_DEFAULT_DISTANCE_MAX = 17
  defaultDistanceMax,

  /// SYZ_P_DEFAULT_DISTANCE_MODEL = 18
  defaultDistanceModel,

  /// SYZ_P_DEFAULT_DISTANCE_REF = 19
  defaultDistanceRef,

  /// SYZ_P_DEFAULT_ROLLOFF = 20
  defaultRolloff,

  /// SYZ_P_LOOPING = 21
  looping,

  /// SYZ_P_NOISE_TYPE = 22
  noiseType,

  /// SYZ_P_PITCH_BEND = 23
  pitchBend,

  /// SYZ_P_INPUT_FILTER_ENABLED = 24
  inputFilterEnabled,

  /// SYZ_P_INPUT_FILTER_CUTOFF = 25
  inputFilterCutoff,

  /// SYZ_P_MEAN_FREE_PATH = 26
  meanFreePath,

  /// SYZ_P_T60 = 27
  t60,

  /// SYZ_P_LATE_REFLECTIONS_LF_ROLLOFF = 28
  lateReflectionsLfRolloff,

  /// SYZ_P_LATE_REFLECTIONS_LF_REFERENCE = 29
  lateReflectionsLfReference,

  /// SYZ_P_LATE_REFLECTIONS_HF_ROLLOFF = 30
  lateReflectionsHfRolloff,

  /// SYZ_P_LATE_REFLECTIONS_HF_REFERENCE = 31
  lateReflectionsHfReference,

  /// SYZ_P_LATE_REFLECTIONS_DIFFUSION = 32
  lateReflectionsDiffusion,

  /// SYZ_P_LATE_REFLECTIONS_MODULATION_DEPTH = 33
  lateReflectionsModulationDepth,

  /// SYZ_P_LATE_REFLECTIONS_MODULATION_FREQUENCY = 34
  lateReflectionsModulationFrequency,

  /// SYZ_P_LATE_REFLECTIONS_DELAY = 35
  lateReflectionsDelay,

  /// SYZ_P_FILTER = 36
  filter,

  /// SYZ_P_FILTER_DIRECT = 37
  filterDirect,

  /// SYZ_P_FILTER_EFFECTS = 38
  filterEffects,

  /// SYZ_P_FILTER_INPUT = 39
  filterInput,

  /// SYZ_P_CURRENT_TIME = 40
  currentTime,

  /// SYZ_P_SUGGESTED_AUTOMATION_TIME = 41
  suggestedAutomationTime,

  /// SYZ_P_FREQUENCY = 42
  frequency,
}

/// An extension for converting Dart to Synthizer values.
extension PropertiesToInt on Properties {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case Properties.azimuth:
        return SYZ_PROPERTIES.SYZ_P_AZIMUTH;
      case Properties.buffer:
        return SYZ_PROPERTIES.SYZ_P_BUFFER;
      case Properties.elevation:
        return SYZ_PROPERTIES.SYZ_P_ELEVATION;
      case Properties.gain:
        return SYZ_PROPERTIES.SYZ_P_GAIN;
      case Properties.defaultPannerStrategy:
        return SYZ_PROPERTIES.SYZ_P_DEFAULT_PANNER_STRATEGY;
      case Properties.panningScalar:
        return SYZ_PROPERTIES.SYZ_P_PANNING_SCALAR;
      case Properties.playbackPosition:
        return SYZ_PROPERTIES.SYZ_P_PLAYBACK_POSITION;
      case Properties.position:
        return SYZ_PROPERTIES.SYZ_P_POSITION;
      case Properties.orientation:
        return SYZ_PROPERTIES.SYZ_P_ORIENTATION;
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
      case Properties.rolloff:
        return SYZ_PROPERTIES.SYZ_P_ROLLOFF;
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
      case Properties.lateReflectionsLfRolloff:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_LF_ROLLOFF;
      case Properties.lateReflectionsLfReference:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_LF_REFERENCE;
      case Properties.lateReflectionsHfRolloff:
        return SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_HF_ROLLOFF;
      case Properties.lateReflectionsHfReference:
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
      case Properties.currentTime:
        return SYZ_PROPERTIES.SYZ_P_CURRENT_TIME;
      case Properties.suggestedAutomationTime:
        return SYZ_PROPERTIES.SYZ_P_SUGGESTED_AUTOMATION_TIME;
      case Properties.frequency:
        return SYZ_PROPERTIES.SYZ_P_FREQUENCY;
    }
  }
}

/// SYZ_EVENT_TYPES.
enum EventTypes {
  /// SYZ_EVENT_TYPE_INVALID = 0
  invalid,

  /// SYZ_EVENT_TYPE_LOOPED = 1
  looped,

  /// SYZ_EVENT_TYPE_FINISHED = 2
  finished,

  /// SYZ_EVENT_TYPE_USER_AUTOMATION = 3
  userAutomation,
}

/// An extension for converting Dart to Synthizer values.
extension EventTypesToInt on EventTypes {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case EventTypes.invalid:
        return SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_INVALID;
      case EventTypes.looped:
        return SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_LOOPED;
      case EventTypes.finished:
        return SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_FINISHED;
      case EventTypes.userAutomation:
        return SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_USER_AUTOMATION;
    }
  }
}

/// SYZ_INTERPOLATION_TYPES.
enum InterpolationTypes {
  /// SYZ_INTERPOLATION_TYPE_NONE = 0
  none,

  /// SYZ_INTERPOLATION_TYPE_LINEAR = 1
  linear,
}

/// An extension for converting Dart to Synthizer values.
extension InterpolationTypesToInt on InterpolationTypes {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case InterpolationTypes.none:
        return SYZ_INTERPOLATION_TYPES.SYZ_INTERPOLATION_TYPE_NONE;
      case InterpolationTypes.linear:
        return SYZ_INTERPOLATION_TYPES.SYZ_INTERPOLATION_TYPE_LINEAR;
    }
  }
}

/// SYZ_AUTOMATION_COMMANDS.
enum AutomationCommands {
  /// SYZ_AUTOMATION_COMMAND_APPEND_PROPERTY = 0
  appendProperty,

  /// SYZ_AUTOMATION_COMMAND_SEND_USER_EVENT = 1
  sendUserEvent,

  /// SYZ_AUTOMATION_COMMAND_CLEAR_PROPERTY = 2
  clearProperty,

  /// SYZ_AUTOMATION_COMMAND_CLEAR_EVENTS = 3
  clearEvents,

  /// SYZ_AUTOMATION_COMMAND_CLEAR_ALL_PROPERTIES = 4
  clearAllProperties,
}

/// An extension for converting Dart to Synthizer values.
extension AutomationCommandsToInt on AutomationCommands {
  /// Return an integer.
  int toInt() {
    switch (this) {
      case AutomationCommands.appendProperty:
        return SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_APPEND_PROPERTY;
      case AutomationCommands.sendUserEvent:
        return SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_SEND_USER_EVENT;
      case AutomationCommands.clearProperty:
        return SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_CLEAR_PROPERTY;
      case AutomationCommands.clearEvents:
        return SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_CLEAR_EVENTS;
      case AutomationCommands.clearAllProperties:
        return SYZ_AUTOMATION_COMMANDS
            .SYZ_AUTOMATION_COMMAND_CLEAR_ALL_PROPERTIES;
    }
  }
}

/// An extension for converting integers to Dart values.
extension IntToSynthizer on int {
  /// Convert from a [SYZ_LOGGING_BACKEND] member.
  LoggingBackend toLoggingBackend() {
    switch (this) {
      case SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_NONE:
        return LoggingBackend.none;
      case SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_STDERR:
        return LoggingBackend.stderr;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_LOGGING_BACKEND` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_LOG_LEVEL] member.
  LogLevel toLogLevel() {
    switch (this) {
      case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR:
        return LogLevel.error;
      case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN:
        return LogLevel.warn;
      case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO:
        return LogLevel.info;
      case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG:
        return LogLevel.debug;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_LOG_LEVEL` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_OBJECT_TYPE] member.
  ObjectType toObjectType() {
    switch (this) {
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_CONTEXT:
        return ObjectType.context;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_BUFFER:
        return ObjectType.buffer;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_BUFFER_GENERATOR:
        return ObjectType.bufferGenerator;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_STREAMING_GENERATOR:
        return ObjectType.streamingGenerator;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_NOISE_GENERATOR:
        return ObjectType.noiseGenerator;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_DIRECT_SOURCE:
        return ObjectType.directSource;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_ANGULAR_PANNED_SOURCE:
        return ObjectType.angularPannedSource;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_SCALAR_PANNED_SOURCE:
        return ObjectType.scalarPannedSource;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_SOURCE_3D:
        return ObjectType.source3d;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_GLOBAL_ECHO:
        return ObjectType.globalEcho;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_GLOBAL_FDN_REVERB:
        return ObjectType.globalFdnReverb;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_STREAM_HANDLE:
        return ObjectType.streamHandle;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_AUTOMATION_BATCH:
        return ObjectType.automationBatch;
      case SYZ_OBJECT_TYPE.SYZ_OTYPE_FAST_SINE_BANK_GENERATOR:
        return ObjectType.fastSineBankGenerator;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_OBJECT_TYPE` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_PANNER_STRATEGY] member.
  PannerStrategy toPannerStrategy() {
    switch (this) {
      case SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_DELEGATE:
        return PannerStrategy.delegate;
      case SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_HRTF:
        return PannerStrategy.hrtf;
      case SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_STEREO:
        return PannerStrategy.stereo;
      case SYZ_PANNER_STRATEGY.SYZ_PANNER_STRATEGY_COUNT:
        return PannerStrategy.count;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_PANNER_STRATEGY` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_DISTANCE_MODEL] member.
  DistanceModel toDistanceModel() {
    switch (this) {
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_NONE:
        return DistanceModel.none;
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_LINEAR:
        return DistanceModel.linear;
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_EXPONENTIAL:
        return DistanceModel.exponential;
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_INVERSE:
        return DistanceModel.inverse;
      case SYZ_DISTANCE_MODEL.SYZ_DISTANCE_MODEL_COUNT:
        return DistanceModel.count;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_DISTANCE_MODEL` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_NOISE_TYPE] member.
  NoiseType toNoiseType() {
    switch (this) {
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_UNIFORM:
        return NoiseType.uniform;
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_VM:
        return NoiseType.vm;
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_FILTERED_BROWN:
        return NoiseType.filteredBrown;
      case SYZ_NOISE_TYPE.SYZ_NOISE_TYPE_COUNT:
        return NoiseType.count;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_NOISE_TYPE` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_PROPERTIES] member.
  Properties toProperties() {
    switch (this) {
      case SYZ_PROPERTIES.SYZ_P_AZIMUTH:
        return Properties.azimuth;
      case SYZ_PROPERTIES.SYZ_P_BUFFER:
        return Properties.buffer;
      case SYZ_PROPERTIES.SYZ_P_ELEVATION:
        return Properties.elevation;
      case SYZ_PROPERTIES.SYZ_P_GAIN:
        return Properties.gain;
      case SYZ_PROPERTIES.SYZ_P_DEFAULT_PANNER_STRATEGY:
        return Properties.defaultPannerStrategy;
      case SYZ_PROPERTIES.SYZ_P_PANNING_SCALAR:
        return Properties.panningScalar;
      case SYZ_PROPERTIES.SYZ_P_PLAYBACK_POSITION:
        return Properties.playbackPosition;
      case SYZ_PROPERTIES.SYZ_P_POSITION:
        return Properties.position;
      case SYZ_PROPERTIES.SYZ_P_ORIENTATION:
        return Properties.orientation;
      case SYZ_PROPERTIES.SYZ_P_CLOSENESS_BOOST:
        return Properties.closenessBoost;
      case SYZ_PROPERTIES.SYZ_P_CLOSENESS_BOOST_DISTANCE:
        return Properties.closenessBoostDistance;
      case SYZ_PROPERTIES.SYZ_P_DISTANCE_MAX:
        return Properties.distanceMax;
      case SYZ_PROPERTIES.SYZ_P_DISTANCE_MODEL:
        return Properties.distanceModel;
      case SYZ_PROPERTIES.SYZ_P_DISTANCE_REF:
        return Properties.distanceRef;
      case SYZ_PROPERTIES.SYZ_P_ROLLOFF:
        return Properties.rolloff;
      case SYZ_PROPERTIES.SYZ_P_DEFAULT_CLOSENESS_BOOST:
        return Properties.defaultClosenessBoost;
      case SYZ_PROPERTIES.SYZ_P_DEFAULT_CLOSENESS_BOOST_DISTANCE:
        return Properties.defaultClosenessBoostDistance;
      case SYZ_PROPERTIES.SYZ_P_DEFAULT_DISTANCE_MAX:
        return Properties.defaultDistanceMax;
      case SYZ_PROPERTIES.SYZ_P_DEFAULT_DISTANCE_MODEL:
        return Properties.defaultDistanceModel;
      case SYZ_PROPERTIES.SYZ_P_DEFAULT_DISTANCE_REF:
        return Properties.defaultDistanceRef;
      case SYZ_PROPERTIES.SYZ_P_DEFAULT_ROLLOFF:
        return Properties.defaultRolloff;
      case SYZ_PROPERTIES.SYZ_P_LOOPING:
        return Properties.looping;
      case SYZ_PROPERTIES.SYZ_P_NOISE_TYPE:
        return Properties.noiseType;
      case SYZ_PROPERTIES.SYZ_P_PITCH_BEND:
        return Properties.pitchBend;
      case SYZ_PROPERTIES.SYZ_P_INPUT_FILTER_ENABLED:
        return Properties.inputFilterEnabled;
      case SYZ_PROPERTIES.SYZ_P_INPUT_FILTER_CUTOFF:
        return Properties.inputFilterCutoff;
      case SYZ_PROPERTIES.SYZ_P_MEAN_FREE_PATH:
        return Properties.meanFreePath;
      case SYZ_PROPERTIES.SYZ_P_T60:
        return Properties.t60;
      case SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_LF_ROLLOFF:
        return Properties.lateReflectionsLfRolloff;
      case SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_LF_REFERENCE:
        return Properties.lateReflectionsLfReference;
      case SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_HF_ROLLOFF:
        return Properties.lateReflectionsHfRolloff;
      case SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_HF_REFERENCE:
        return Properties.lateReflectionsHfReference;
      case SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_DIFFUSION:
        return Properties.lateReflectionsDiffusion;
      case SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_MODULATION_DEPTH:
        return Properties.lateReflectionsModulationDepth;
      case SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_MODULATION_FREQUENCY:
        return Properties.lateReflectionsModulationFrequency;
      case SYZ_PROPERTIES.SYZ_P_LATE_REFLECTIONS_DELAY:
        return Properties.lateReflectionsDelay;
      case SYZ_PROPERTIES.SYZ_P_FILTER:
        return Properties.filter;
      case SYZ_PROPERTIES.SYZ_P_FILTER_DIRECT:
        return Properties.filterDirect;
      case SYZ_PROPERTIES.SYZ_P_FILTER_EFFECTS:
        return Properties.filterEffects;
      case SYZ_PROPERTIES.SYZ_P_FILTER_INPUT:
        return Properties.filterInput;
      case SYZ_PROPERTIES.SYZ_P_CURRENT_TIME:
        return Properties.currentTime;
      case SYZ_PROPERTIES.SYZ_P_SUGGESTED_AUTOMATION_TIME:
        return Properties.suggestedAutomationTime;
      case SYZ_PROPERTIES.SYZ_P_FREQUENCY:
        return Properties.frequency;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_PROPERTIES` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_EVENT_TYPES] member.
  EventTypes toEventTypes() {
    switch (this) {
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_INVALID:
        return EventTypes.invalid;
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_LOOPED:
        return EventTypes.looped;
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_FINISHED:
        return EventTypes.finished;
      case SYZ_EVENT_TYPES.SYZ_EVENT_TYPE_USER_AUTOMATION:
        return EventTypes.userAutomation;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_EVENT_TYPES` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_INTERPOLATION_TYPES] member.
  InterpolationTypes toInterpolationTypes() {
    switch (this) {
      case SYZ_INTERPOLATION_TYPES.SYZ_INTERPOLATION_TYPE_NONE:
        return InterpolationTypes.none;
      case SYZ_INTERPOLATION_TYPES.SYZ_INTERPOLATION_TYPE_LINEAR:
        return InterpolationTypes.linear;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_INTERPOLATION_TYPES` member.',
          this,
        );
    }
  }

  /// Convert from a [SYZ_AUTOMATION_COMMANDS] member.
  AutomationCommands toAutomationCommands() {
    switch (this) {
      case SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_APPEND_PROPERTY:
        return AutomationCommands.appendProperty;
      case SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_SEND_USER_EVENT:
        return AutomationCommands.sendUserEvent;
      case SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_CLEAR_PROPERTY:
        return AutomationCommands.clearProperty;
      case SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_CLEAR_EVENTS:
        return AutomationCommands.clearEvents;
      case SYZ_AUTOMATION_COMMANDS.SYZ_AUTOMATION_COMMAND_CLEAR_ALL_PROPERTIES:
        return AutomationCommands.clearAllProperties;
      default:
        throw SynthizerError(
          'Unrecognised `SYZ_AUTOMATION_COMMANDS` member.',
          this,
        );
    }
  }
}
