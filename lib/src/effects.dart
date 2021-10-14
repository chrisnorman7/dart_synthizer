/// Provides classes relating to effects.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';
import 'synthizer_property.dart';

/// The base class for all global effects.
///
/// [Synthizer docs](https://synthizer.github.io/concepts/effects.html)
class GlobalEffect extends SynthizerObject {
  /// Create a global effect.
  GlobalEffect(Synthizer synthizer, {int? pointer})
      : super(synthizer, pointer: pointer) {
    filterInput = SynthizerBiquadConfigProperty(
        synthizer, handle, Properties.filterInput);
  }

  /// The gain for this instance.
  late final SynthizerDoubleProperty gain;

  /// The filter input.
  late final SynthizerBiquadConfigProperty filterInput;

  /// Reset this effect.
  void reset() =>
      synthizer.check(synthizer.synthizer.syz_effectReset(handle.value));
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
/// [Synthizer docs](https://synthizer.github.io/object_reference/echo.html)
class GlobalEcho extends GlobalEffect {
  /// Create an echo.
  GlobalEcho(Context context) : super(context.synthizer) {
    synthizer.check(synthizer.synthizer.syz_createGlobalEcho(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    gain = SynthizerDoubleProperty(synthizer, handle, Properties.gain);
  }

  /// Create an instance from a handle value.
  GlobalEcho.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);

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
/// [Synthizer docs](https://synthizer.github.io/object_reference/fdn_reverb.html)
class GlobalFdnReverb extends GlobalEffect {
  /// Create a reverb.
  GlobalFdnReverb(Context context) : super(context.synthizer) {
    synthizer.check(synthizer.synthizer.syz_createGlobalFdnReverb(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer));
    gain = SynthizerDoubleProperty(synthizer, handle, Properties.gain);
    meanFreePath =
        SynthizerDoubleProperty(synthizer, handle, Properties.meanFreePath);
    t60 = SynthizerDoubleProperty(synthizer, handle, Properties.t60);
    lateReflectionsLfRolloff = SynthizerDoubleProperty(
        synthizer, handle, Properties.lateReflectionsLfRolloff);
    lateReflectionsLfReference = SynthizerDoubleProperty(
        synthizer, handle, Properties.lateReflectionsLfReference);
    lateReflectionsHfRolloff = SynthizerDoubleProperty(
        synthizer, handle, Properties.lateReflectionsHfRolloff);
    lateReflectionsHfReference = SynthizerDoubleProperty(
        synthizer, handle, Properties.lateReflectionsHfReference);
    lateReflectionsDiffusion = SynthizerDoubleProperty(
        synthizer, handle, Properties.lateReflectionsDiffusion);
    lateReflectionsModulationDepth = SynthizerDoubleProperty(
        synthizer, handle, Properties.lateReflectionsModulationDepth);
    lateReflectionsModulationFrequency = SynthizerDoubleProperty(
        synthizer, handle, Properties.lateReflectionsModulationFrequency);
    lateReflectionsDelay = SynthizerDoubleProperty(
        synthizer, handle, Properties.lateReflectionsDelay);
  }

  /// Create an instance from a handle value.
  GlobalFdnReverb.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);

  /// The mean free path.
  late final SynthizerDoubleProperty meanFreePath;

  /// The t60.
  late final SynthizerDoubleProperty t60;

  /// The late reflections LF rolloff.
  late final SynthizerDoubleProperty lateReflectionsLfRolloff;

  /// The late reflections LF reference.
  late final SynthizerDoubleProperty lateReflectionsLfReference;

  /// The late reflections HF rolloff.
  late final SynthizerDoubleProperty lateReflectionsHfRolloff;

  /// The late reflections HF reference.
  late final SynthizerDoubleProperty lateReflectionsHfReference;

  /// The late reflections diffusion.
  late final SynthizerDoubleProperty lateReflectionsDiffusion;

  /// The late reflections modulation depth.
  late final SynthizerDoubleProperty lateReflectionsModulationDepth;

  /// The late reflections modulation frequency.
  late final SynthizerDoubleProperty lateReflectionsModulationFrequency;

  /// The late reflections delay.
  late final SynthizerDoubleProperty lateReflectionsDelay;
}
