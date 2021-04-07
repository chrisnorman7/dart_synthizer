/// Provides Synthizer enumerations.

/// The log level enum.
enum LogLevel { error, warn, info, debug }

/// The logging backends enum.
enum LoggingBackend { stderr }

/// All the properties supported by Synthizer.
enum Properties {
  azimuth,
  buffer,
  closenessBoost,
  closenessBoostDistance,
  distanceMax,
  distanceModel,
  distanceRef,
  elevation,
  gain,
  pannerStrategy,
  panningScalar,
  position,
  orientation,
  rolloff,

  looping,

  noiseType,

  pitchBend,

  inputFilterEnabled,
  inputFilterCutoff,
  meanFreePath,
  t60,
  lateReflectionsLFRolloff,
  lateReflectionsLFReference,
  lateReflectionsHFRolloff,
  lateReflectionsHFReference,
  lateReflectionsDiffusion,
  lateReflectionsModulationDepth,
  lateReflectionsModulationFrequency,
  lateReflectionsDelay,

  filter,
  filterDirect,
  filterEffects,
  filterInput,
}

/// All noise types.
enum NoiseTypes { uniform, vm, filteredBrown }

/// Synthizer panner strategies.
enum PannerStrategies { hrtf, stereo }

/// Synthizer distance models.
enum DistanceModels {
  none,
  linear,
  exponential,
  inverse,
}
