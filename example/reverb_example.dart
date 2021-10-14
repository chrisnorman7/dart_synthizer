// ignore_for_file: avoid_print

import 'package:dart_synthizer/dart_synthizer.dart';

/// Create reverb and exit.

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final source = ctx.createDirectSource();
  final generator = ctx.createStreamingGenerator('file', 'sound.wav')
    ..looping.value = true;
  source.addGenerator(generator);
  final reverb = ctx.createGlobalFdnReverb();
  await Future<void>.delayed(Duration(milliseconds: 200));
  reverb
    ..t60.value = 100
    ..meanFreePath.value = 0.5;
  ctx.ConfigRoute(source, reverb);
  await Future<void>.delayed(Duration(seconds: 5));
  print(reverb.meanFreePath.value);
  print(reverb.t60.value);
  [source, ctx, generator, reverb].forEach((element) => element.destroy());
  synthizer.shutdown();
}
