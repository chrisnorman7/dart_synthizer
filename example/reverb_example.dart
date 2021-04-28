import 'package:dart_synthizer/dart_synthizer.dart';

/// Create reverb and exit.

Future<void> main() async {
  final synthizer = Synthizer.fromPath('synthizer.dll')..initialize();
  final ctx = synthizer.createContext();
  final source = ctx.createDirectSource();
  final generator = ctx.createStreamingGenerator('file', 'sound.wav')
    ..looping = true;
  source.addGenerator(generator);
  final reverb = ctx.createGlobalFdnReverb()
    ..t60 = 5
    ..meanFreePath = 0.5;
  ctx.ConfigRoute(source, reverb);
  await Future<void>.delayed(Duration(seconds: 5));
  [source, ctx, generator, reverb].forEach((element) => element.destroy());
  synthizer.shutdown();
}
