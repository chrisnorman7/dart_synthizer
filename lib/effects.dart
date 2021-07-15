/// Provides classes relating to effects.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'dart_synthizer.dart';
import 'synthizer_bindings.dart';

/// The base class for all global effects.
///
/// Synthizer docs: [https://synthizer.github.io/concepts/effects.html]
class GlobalEffect extends SynthizerObject with GainMixin {
  /// Create a global effect.
  GlobalEffect(Synthizer synthizer) : super(synthizer);

  /// Reset this effect.
  void reset() =>
      synthizer.check(synthizer.synthizer.syz_effectReset(handle.value));

  /// Set the filter input.
  set filterInput(BiquadConfig config) =>
      synthizer.setBiquad(handle, Properties.filterInput, config);
}

/// An echo tap. Passed to GlobalEcho.set_taps.
///
/// For more information on configuring a global echo, see [this page](https://synthizer.github.io/object_reference/echo.html).
class EchoTapConfig {
  /// Create a tap configuration.
  EchoTapConfig(this.delay, this.gainL, this.gainR);

  /// The number of milliseconds before this delay is heard.
  final double delay;

  /// The gain of the left channel.
  double gainL;

  /// The gain of the right channel.
  double gainR;
}

/// Global echo.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/echo.html]
class GlobalEcho extends GlobalEffect {
  /// Create an echo.
  GlobalEcho(Context context) : super(context.synthizer) {
    synthizer.check(synthizer.synthizer.syz_createGlobalEcho(handle,
        context.handle.value, nullptr, synthizer.userdataFreeCallbackPointer));
  }

  /// Sets the taps of the echo.
  void setTaps(List<EchoTapConfig>? taps) {
    if (taps == null || taps.isEmpty) {
      synthizer.check(
          synthizer.synthizer.syz_globalEchoSetTaps(handle.value, 0, nullptr));
    } else {
      final a = malloc<syz_EchoTapConfig>(taps.length);
      for (var i = 0; i < taps.length; i++) {
        final t = taps[i];
        a[i]
          ..delay = t.delay
          ..gain_l = t.gainL
          ..gain_r = t.gainR;
      }
      synthizer.check(synthizer.synthizer
          .syz_globalEchoSetTaps(handle.value, taps.length, a));
      malloc.free(a);
    }
  }
}

/// FDN reverb.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/fdn_reverb.html]
class GlobalFdnReverb extends GlobalEffect {
  /// Create a reverb.
  GlobalFdnReverb(Context context) : super(context.synthizer) {
    synthizer.check(synthizer.synthizer.syz_createGlobalFdnReverb(handle,
        context.handle.value, nullptr, synthizer.userdataFreeCallbackPointer));
  }

  /// Get mean free path.
  double get meanFreePath =>
      synthizer.getDouble(handle, Properties.meanFreePath);

  /// Set mean free path.
  set meanFreePath(double value) =>
      synthizer.setDouble(handle, Properties.meanFreePath, value);

  /// Get t60.
  double get t60 => synthizer.getDouble(handle, Properties.t60);

  /// Set t60.
  set t60(double value) => synthizer.setDouble(handle, Properties.t60, value);

  /// Get late reflections LF rolloff.
  double get lateReflectionsLfRolloff =>
      synthizer.getDouble(handle, Properties.lateReflectionsLFRolloff);

  /// Set late reflections LF rolloff .
  set lateReflectionsLfRolloff(double value) =>
      synthizer.setDouble(handle, Properties.lateReflectionsLFRolloff, value);

  /// Get late reflections LF reference.
  double get lateReflectionsLfReference =>
      synthizer.getDouble(handle, Properties.lateReflectionsLFReference);

  /// Set late reflections LF reference
  set lateReflectionsLfReference(double value) =>
      synthizer.setDouble(handle, Properties.lateReflectionsLFReference, value);

  /// Get late reflections HF rolloff.
  double get lateReflectionsHfRolloff =>
      synthizer.getDouble(handle, Properties.lateReflectionsHFRolloff);

  /// Set late reflections HF Rolloff.
  set lateReflectionsHfRolloff(double value) =>
      synthizer.setDouble(handle, Properties.lateReflectionsHFRolloff, value);

  /// Get late reflections HF reference.
  double get lateReflectionsHfReference =>
      synthizer.getDouble(handle, Properties.lateReflectionsHFReference);

  /// Set late reflections HF reference.
  set lateReflectionsHfReference(double value) =>
      synthizer.setDouble(handle, Properties.lateReflectionsHFReference, value);

  /// Get late reflections diffusion.
  double get lateReflectionsDiffusion =>
      synthizer.getDouble(handle, Properties.lateReflectionsDiffusion);

  /// Set late reflections diffusion.
  set lateReflectionsDiffusion(double value) =>
      synthizer.setDouble(handle, Properties.lateReflectionsDiffusion, value);

  /// Get late reflections modulation depth.
  double get lateReflectionsModulationDepth =>
      synthizer.getDouble(handle, Properties.lateReflectionsModulationDepth);

  /// Set late reflections modulation depth.
  set lateReflectionsModulationDepth(double value) => synthizer.setDouble(
      handle, Properties.lateReflectionsModulationDepth, value);

  /// Get late reflections modulation frequency.
  double get lateReflectionsModulationFrequency => synthizer.getDouble(
      handle, Properties.lateReflectionsModulationFrequency);

  /// Set late reflections modulation frequency.
  set lateReflectionsModulationFrequency(double value) => synthizer.setDouble(
      handle, Properties.lateReflectionsModulationFrequency, value);

  /// Get late reflections delay.
  double get lateReflectionsDelay =>
      synthizer.getDouble(handle, Properties.lateReflectionsDelay);

  /// Set late reflections delay.
  set lateReflectionsDelay(double value) =>
      synthizer.setDouble(handle, Properties.lateReflectionsDelay, value);
}
