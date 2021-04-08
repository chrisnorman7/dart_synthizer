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
  /// SYZ_LOGGING_BACKEND_STDERR = 0
  stderr
}

/// All the properties supported by Synthizer.
enum Properties {
  /// SYZ_P_AZIMUTH
  azimuth,

  /// SYZ_P_BUFFER
  buffer,

  /// SYZ_P_CLOSENESS_BOOST
  closenessBoost,

  /// SYZ_P_CLOSENESS_BOOST_DISTANCE
  closenessBoostDistance,

  /// SYZ_P_DISTANCE_MAX
  distanceMax,

  /// SYZ_P_DISTANCE_MODEL
  distanceModel,

  /// SYZ_P_DISTANCE_REF
  distanceRef,

  /// SYZ_P_ELEVATION
  elevation,

  /// SYZ_P_GAIN
  gain,

  /// SYZ_P_PANNER_STRATEGY
  pannerStrategy,

  /// SYZ_P_PANNING_SCALAR
  panningScalar,

  /// SYZ_P_POSITION
  position,

  /// SYZ_P_ORIENTATION
  orientation,

  /// SYZ_P_ROLLOFF
  rolloff,

  /// SYZ_P_LOOPING
  looping,

  /// SYZ_P_NOISE_TYPE
  noiseType,

  /// SYZ_P_PITCH_BEND
  pitchBend,

  /// SYZ_P_INPUT_FILTER_ENABLED
  inputFilterEnabled,

  /// SYZ_P_INPUT_FILTER_CUTOFF
  inputFilterCutoff,

  /// SYZ_P_MEAN_FREE_PATH
  meanFreePath,

  /// SYZ_P_T60
  t60,

  /// SYZ_P_LATE_REFLECTIONS_LF_ROLLOFF
  lateReflectionsLFRolloff,

  /// SYZ_P_LATE_REFLECTIONS_LF_REFERENCE
  lateReflectionsLFReference,

  /// SYZ_P_LATE_REFLECTIONS_HF_ROLLOFF
  lateReflectionsHFRolloff,

  /// SYZ_P_LATE_REFLECTIONS_HF_REFERENCE
  lateReflectionsHFReference,

  /// SYZ_P_LATE_REFLECTIONS_DIFFUSION
  lateReflectionsDiffusion,

  /// SYZ_P_LATE_REFLECTIONS_MODULATION_DEPTH
  lateReflectionsModulationDepth,

  /// SYZ_P_LATE_REFLECTIONS_MODULATION_FREQUENCY
  lateReflectionsModulationFrequency,

  /// SYZ_P_LATE_REFLECTIONS_DELAY
  lateReflectionsDelay,

  /// SYZ_P_FILTER
  filter,

  /// SYZ_P_FILTER_DIRECT
  filterDirect,

  /// SYZ_P_FILTER_EFFECTS
  filterEffects,

  /// SYZ_P_FILTER_INPUT
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
