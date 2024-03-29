// ignore_for_file: avoid_print
import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';

/// Demonstrates how to configure echo in a  relatively real-world scenario akin
/// to what a reverb would do for early reflections.
///
/// By setting taps up in various configurations, it's possible to get a number
/// of different effects.
///
/// For best results, use a music file or something that's long enough to play
/// as long as the sleeps at the end of this file.
Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final buffer = Buffer.fromStreamParams(synthizer, 'file', 'sound.wav');
  final gen = ctx.createBufferGenerator(buffer: buffer);
  final src = ctx.createSource3D()..addGenerator(gen);

  // create and connect the effect with a default gain of 1.0.
  final echo = ctx.createGlobalEcho();
  print('Created echo $echo.');
  ctx.configRoute(src, echo);

  /// Generate uniformly distributed random taps.
  ///
  /// Remember: echo currently only allows up to 5 seconds of delay.
  final rng = Random();
  const nTaps = 100;
  const duration = 2.0;
  const delta = duration / nTaps;
  final taps = <EchoTapConfig>[];
  for (var i = 0; i < nTaps; i++) {
    taps.add(
      EchoTapConfig(
        delta + i * delta + rng.nextDouble() * 0.01,
        rng.nextDouble(),
        rng.nextDouble(),
      ),
    );
  }

  /// In general, you'll want to normalize by something, or otherwise work out
  /// how to prevent clipping. Synthizer as well as any other audio library
  /// can't protect from clipping due to too many sources/loud effects/etc. This
  /// script normalizes so that the constant overall power of the echo is around
  /// 1.0, but a simpler strategy is to simply compute an average.  Which works
  /// better depends highly on the use case.
  var normLeft = 0.0;
  for (final element in taps) {
    normLeft += pow(element.gainL, 2);
  }
  var normRight = 0.0;
  for (final element in taps) {
    normRight += pow(element.gainR, 2);
  }
  final norm = 1.0 / sqrt(max(normLeft, normRight));
  print('Taps will be normalised to $norm.');
  echo.setTaps(
    taps
        .map(
          (final e) => EchoTapConfig(
            e.delay,
            e.gainL * norm,
            e.gainR * norm,
          ),
        )
        .toList(),
  );
  print('Taps set.');

  /// Sleep for a bit, to let the audio be heard
  await Future<void>.delayed(const Duration(seconds: 10));

  /// Set the source's gain to 0, which will let the tail of the echo be heard.
  src.gain.value = 0.0;
  print('Now muted.');

  /// Sleep for a bit for the tail.
  await Future<void>.delayed(const Duration(seconds: 5));

  /// Bring it back. This causes a little bit of clipping because of the abrupt
  /// change.
  src.gain.value = 1.0;
  print('Full volume.');

  /// Sleep for long enough to build up audio in the echo:
  await Future<void>.delayed(const Duration(seconds: 5));

  /// Fade the send out over the next 1 seconds:
  ctx.removeRoute(src, echo, fadeTime: 1.0);
  print('Fading.');
  await Future<void>.delayed(const Duration(seconds: 2));
  echo.destroy();
  gen.destroy();
  src.destroy();
  ctx.destroy();
  synthizer.shutdown();
  print('Shutdown.');
}
