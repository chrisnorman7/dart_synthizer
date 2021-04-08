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
    synthizer.check(
        synthizer.synthizer.syz_createGlobalEcho(handle, context.handle.value));
  }

  /// Sets the taps of the echo.
  void setTaps(List<EchoTapConfig>? taps) {
    if (taps == null || taps.isEmpty) {
      synthizer
          .check(synthizer.synthizer.syz_echoSetTaps(handle.value, 0, nullptr));
    } else {
      final a = Array<Pointer<syz_EchoTapConfig>>(taps.length);
      for (var i = 0; i < taps.length; i++) {
        final t = taps[i];
        final tc = calloc<syz_EchoTapConfig>();
        tc.ref
          ..delay = t.delay
          ..gain_l = t.gainL
          ..gain_r = t.gainR;
        a[i] = tc;
        print(a);
      }
      synthizer.check(
          synthizer.synthizer.syz_echoSetTaps(handle.value, taps.length, a[0]));
    }
  }
}
