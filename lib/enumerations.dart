/// Provides Synthizer enumerations.

/// The log level enum.
enum LogLevel {
  /// SYZ_LOG_LEVEL_ERROR = 0
  error,

  /// SYZ_LOG_LEVEL_WARN = 10
  warn,

  /// SYZ_LOG_LEVEL_INFO = 20
  info,

  /// SYZ_LOG_LEVEL_DEBUG = 30
  debug
}

/// The logging backends enum.
enum LoggingBackend {
  /// static const int SYZ_LOGGING_BACKEND_NONE = 0;
  none,

  /// SYZ_LOGGING_BACKEND_STDERR = 0
  stderr
}

/// All the properties supported by Synthizer.
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

  /// static const int SYZ_P_ROLLOFF = 14
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
}

/// All noise types.
enum NoiseTypes {
  /// SYZ_NOISE_TYPE_UNIFORM
  uniform,

  /// SYZ_NOISE_TYPE_VM
  vm,

  /// SYZ_NOISE_TYPE_FILTERED_BROWN
  filteredBrown
}

/// Synthizer panner strategies.
enum PannerStrategies {
  /// SYZ_PANNER_STRATEGY_HRTF = 0
  hrtf,

  /// SYZ_PANNER_STRATEGY_STEREO = 1
  stereo
}

/// Synthizer distance models.
enum DistanceModels {
  /// SYZ_DISTANCE_MODEL_NONE
  none,

  /// SYZ_DISTANCE_MODEL_LINEAR
  linear,

  /// SYZ_DISTANCE_MODEL_EXPONENTIAL
  exponential,

  /// SYZ_DISTANCE_MODEL_INVERSE
  inverse,
}

/// Synthizer interpolation types.
enum InterpolationTypes {
  /// SYZ_INTERPOLATION_TYPE_NONE
  none,

  /// SYZ_INTERPOLATION_TYPE_LINEAR
  linear,
}

/// Synthizer object types.
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
  source3D,

  /// SYZ_OTYPE_GLOBAL_ECHO = 9
  globalEcho,

  /// SYZ_OTYPE_GLOBAL_FDN_REVERB = 10
  globalFdnReverb,

  /// SYZ_OTYPE_STREAM_HANDLE = 11
  streamHandle,

  /// SYZ_OTYPE_AUTOMATION_TIMELINE = 12
  automationTimeline,
}
