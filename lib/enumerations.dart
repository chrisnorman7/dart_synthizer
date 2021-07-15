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

  /// SYZ_P_PANNER_STRATEGY = 4
  pannerStrategy,

  /// SYZ_P_DEFAULT_PANNER_STRATEGY = 5
  defaultPannerStrategy,

  /// SYZ_P_PANNING_SCALAR = 6
  panningScalar,

  /// SYZ_P_PLAYBACK_POSITION = 7
  playbackPosition,

  /// SYZ_P_POSITION = 8
  position,

  /// SYZ_P_ORIENTATION = 9
  orientation,

  /// SYZ_P_CLOSENESS_BOOST = 10
  closenessBoost,

  /// SYZ_P_CLOSENESS_BOOST_DISTANCE = 11
  closenessBoostDistance,

  /// SYZ_P_DISTANCE_MAX = 12
  distanceMax,

  /// SYZ_P_DISTANCE_MODEL = 13
  distanceModel,

  /// SYZ_P_DISTANCE_REF = 14
  distanceRef,

  /// SYZ_P_ROLLOFF = 15
  rolloff,

  /// SYZ_P_DEFAULT_CLOSENESS_BOOST = 16
  defaultClosenessBoost,

  /// SYZ_P_DEFAULT_CLOSENESS_BOOST_DISTANCE = 17
  defaultClosenessBoostDistance,

  /// SYZ_P_DEFAULT_DISTANCE_MAX = 18
  defaultDistanceMax,

  /// SYZ_P_DEFAULT_DISTANCE_MODEL = 19;
  defaultDistanceModel,

  /// SYZ_P_DEFAULT_DISTANCE_REF = 20
  defaultDistanceRef,

  /// SYZ_P_DEFAULT_ROLLOFF = 21
  defaultRolloff,

  /// SYZ_P_LOOPING = 22
  looping,

  /// SYZ_P_NOISE_TYPE = 23
  noiseType,

  /// SYZ_P_PITCH_BEND = 24
  pitchBend,

  /// SYZ_P_INPUT_FILTER_ENABLED = 25
  inputFilterEnabled,

  /// SYZ_P_INPUT_FILTER_CUTOFF = 26
  inputFilterCutoff,

  /// SYZ_P_MEAN_FREE_PATH = 27
  meanFreePath,

  /// SYZ_P_T60 = 28
  t60,

  /// SYZ_P_LATE_REFLECTIONS_LF_ROLLOFF = 29
  lateReflectionsLFRolloff,

  /// SYZ_P_LATE_REFLECTIONS_LF_REFERENCE = 30
  lateReflectionsLFReference,

  /// SYZ_P_LATE_REFLECTIONS_HF_ROLLOFF = 31
  lateReflectionsHFRolloff,

  /// SYZ_P_LATE_REFLECTIONS_HF_REFERENCE = 32
  lateReflectionsHFReference,

  /// SYZ_P_LATE_REFLECTIONS_DIFFUSION = 33
  lateReflectionsDiffusion,

  /// SYZ_P_LATE_REFLECTIONS_MODULATION_DEPTH = 34
  lateReflectionsModulationDepth,

  /// SYZ_P_LATE_REFLECTIONS_MODULATION_FREQUENCY = 35
  lateReflectionsModulationFrequency,

  /// SYZ_P_LATE_REFLECTIONS_DELAY = 36
  lateReflectionsDelay,

  /// SYZ_P_FILTER = 37
  filter,

  /// SYZ_P_FILTER_DIRECT = 38
  filterDirect,

  /// SYZ_P_FILTER_EFFECTS = 39
  filterEffects,

  /// SYZ_P_FILTER_INPUT = 40
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
