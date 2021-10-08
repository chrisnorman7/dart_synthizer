/// Provides the [BiquadConfig] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// Biquad configuration.
///
/// These objects are used for filtering.
///
/// [Synthizer docs](https://synthizer.github.io/concepts/filters.html)
class BiquadConfig {
  /// Default constructor. Do not use.
  ///
  /// Instead of instantiating this class directly, use the named constructors.
  const BiquadConfig(this.config);

  /// Default filter type.
  BiquadConfig.designIdentity(Synthizer synthizer)
      : config = calloc<syz_BiquadConfig>() {
    synthizer.check(synthizer.synthizer.syz_biquadDesignIdentity(config));
  }

  /// Low pass.
  BiquadConfig.designLowpass(Synthizer synthizer, double frequency,
      {double q = 0.7071135624381276})
      : config = calloc<syz_BiquadConfig>() {
    synthizer.check(
        synthizer.synthizer.syz_biquadDesignLowpass(config, frequency, q));
  }

  /// High pass.
  BiquadConfig.designHighpass(Synthizer synthizer, double frequency,
      {double q = 0.7071135624381276})
      : config = calloc<syz_BiquadConfig>() {
    synthizer.check(
        synthizer.synthizer.syz_biquadDesignHighpass(config, frequency, q));
  }

  /// Band pass.
  BiquadConfig.designBandpass(
      Synthizer synthizer, double frequency, double bandwidth)
      : config = calloc<syz_BiquadConfig>() {
    synthizer.check(synthizer.synthizer
        .syz_biquadDesignBandpass(config, frequency, bandwidth));
  }

  /// A pointer to a C struct.
  final Pointer<syz_BiquadConfig> config;

  /// Destroy this object.
  ///
  /// This method frees [config].
  void destroy() => calloc.free(config);
}
