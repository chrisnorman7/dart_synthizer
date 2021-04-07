/// Play noise until killed.
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer.fromPath('synthizer.dll');
  synthizer.initialize();
  final ctx = synthizer.createContext();
  final noiseGenerator = ctx.createNoiseGenerator(channels: 2);
  noiseGenerator.gain = 0.1;
  final source = ctx.createDirectSource();
  source.addGenerator(noiseGenerator);

  /// Listen for kill signal.
  ProcessSignal.sigint.watch().listen((event) {
    synthizer.shutdown();
    print('Synthizer shutdown.');
    exit(0);
  });
  while (true) {
    for (final noiseType in NoiseTypes.values) {
      print('Noise type is ${noiseGenerator.noiseType}.');
      await Future.delayed(Duration(seconds: 1));
      noiseGenerator.noiseType = noiseType;
    }
  }
}
