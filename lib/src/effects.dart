// ignore_for_file: prefer_final_parameters
/// Provides classes relating to effects.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'enumerations.dart';
import 'synthizer_bindings.dart';
import 'synthizer_property.dart';

/// The base class for all global effects.
///
/// [Synthizer docs](https://synthizer.github.io/concepts/effects.html)
class GlobalEffect extends ContextualSynthizerObject with GainMixin {
  /// Create a global effect.
  GlobalEffect(super.context, {super.pointer});

  /// The filter input.
  SynthizerBiquadConfigProperty get filterInput =>
      SynthizerBiquadConfigProperty(
        synthizer: synthizer,
        targetHandle: handle,
        property: Properties.filterInput,
      );

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
  GlobalEcho(super.context) {
    synthizer.check(
      synthizer.synthizer.syz_createGlobalEcho(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
  }

  /// Create an instance from a handle value.
  GlobalEcho.fromHandle(super.synthizer, final int pointer)
      : super(pointer: pointer);

  /// Sets the taps of the echo.
  void setTaps(final List<EchoTapConfig>? taps) {
    if (taps == null || taps.isEmpty) {
      synthizer.check(
        synthizer.synthizer.syz_globalEchoSetTaps(handle.value, 0, nullptr),
      );
    } else {
      final a = malloc<syz_EchoTapConfig>(taps.length);
      for (var i = 0; i < taps.length; i++) {
        final t = taps[i];
        a[i]
          ..delay = t.delay
          ..gain_l = t.gainL
          ..gain_r = t.gainR;
      }
      synthizer.check(
        synthizer.synthizer.syz_globalEchoSetTaps(handle.value, taps.length, a),
      );
      malloc.free(a);
    }
  }
}

/// FDN reverb.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/fdn_reverb.html)
class GlobalFdnReverb extends GlobalEffect {
  /// Create a reverb.
  GlobalFdnReverb(super.context) {
    synthizer.check(
      synthizer.synthizer.syz_createGlobalFdnReverb(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
  }

  /// Create an instance from a handle value.
  GlobalFdnReverb.fromHandle(super.synthizer, final int pointer)
      : super(pointer: pointer);

  /// The mean free path.
  SynthizerAutomatableDoubleProperty get meanFreePath =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.meanFreePath,
      );

  /// The t60.
  SynthizerAutomatableDoubleProperty get t60 =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.t60,
      );

  /// The late reflections LF rolloff.
  SynthizerAutomatableDoubleProperty get lateReflectionsLfRolloff =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.lateReflectionsLfRolloff,
      );

  /// The late reflections LF reference.
  SynthizerAutomatableDoubleProperty get lateReflectionsLfReference =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.lateReflectionsLfReference,
      );

  /// The late reflections HF rolloff.
  SynthizerAutomatableDoubleProperty get lateReflectionsHfRolloff =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.lateReflectionsHfRolloff,
      );

  /// The late reflections HF reference.
  SynthizerAutomatableDoubleProperty get lateReflectionsHfReference =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.lateReflectionsHfReference,
      );

  /// The late reflections diffusion.
  SynthizerAutomatableDoubleProperty get lateReflectionsDiffusion =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.lateReflectionsDiffusion,
      );

  /// The late reflections modulation depth.
  SynthizerAutomatableDoubleProperty get lateReflectionsModulationDepth =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.lateReflectionsModulationDepth,
      );

  /// The late reflections modulation frequency.
  SynthizerAutomatableDoubleProperty get lateReflectionsModulationFrequency =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.lateReflectionsModulationFrequency,
      );

  /// The late reflections delay.
  SynthizerAutomatableDoubleProperty get lateReflectionsDelay =>
      SynthizerAutomatableDoubleProperty(
        context: context,
        targetHandle: handle,
        property: Properties.lateReflectionsDelay,
      );
}
