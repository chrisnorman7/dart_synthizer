// ignore_for_file: avoid_print
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

/// Play noise until killed.
Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final source = ctx.createDirectSource();
  final noiseGenerator = ctx.createNoiseGenerator(channels: 2)
    ..gain.value = 0.1;
  source.addGenerator(noiseGenerator);

  /// Listen for kill signal.
  ProcessSignal.sigint.watch().listen((final event) {
    synthizer.shutdown();
    print('Synthizer shutdown.');
    exit(0);
  });
  while (true) {
    for (final noiseType in NoiseType.values) {
      print('Noise type is ${noiseGenerator.noiseType.value}.');
      await Future<void>.delayed(const Duration(seconds: 1));
      noiseGenerator.noiseType.value = noiseType;
    }
  }
}
