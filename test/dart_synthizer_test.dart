import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:test/test.dart';

void main() {
  final synthizer = Synthizer()..initialize();

  tearDownAll(synthizer.shutdown);

  group('Context', () {
    test('.isValid', () {
      final ctx = synthizer.createContext();
      expect(ctx.isValid, isTrue);
      ctx.destroy();
      expect(ctx.isValid, isFalse);
    });
    test('Check properties', () async {
      final ctx = synthizer.createContext();
      expect(
          ctx.orientation.value, equals(Double6(0.0, 1.0, 0.0, 0.0, 0.0, 1.0)));
      expect(ctx.defaultClosenessBoost.value, equals(0.0));
      expect(ctx.defaultClosenessBoostDistance.value, equals(0.0));
      expect(ctx.defaultDistanceMax.value, equals(50.0));
      expect(ctx.defaultDistanceModel.value, equals(DistanceModel.linear));
      expect(ctx.defaultDistanceRef.value, equals(1.0));
      expect(ctx.defaultPannerStrategy.value, equals(PannerStrategy.stereo));
      expect(ctx.defaultRolloff.value, equals(1.0));
      expect(ctx.position.value, equals(Double3(0.0, 0.0, 0.0)));
      expect(ctx.gain.value, equals(1.0));
    });
  });

  group('Buffer', () {
    test('.fromStream', () {
      expect(Buffer.fromStreamParams(synthizer, 'file', 'sound.wav'),
          isA<Buffer>());
    });
    test('.fromFile', () {
      expect(Buffer.fromFile(synthizer, File('sound.wav')), isA<Buffer>());
    });
    test('Invalid file', () {
      expect(
          () => Buffer.fromStreamParams(synthizer, 'file', 'nothing.invalid'),
          throwsA(isA<SynthizerError>()));
    });
    test('Test lengthInSamples', () {
      final buffer = Buffer.fromStreamParams(synthizer, 'file', 'sound.wav');
      expect(buffer.lengthInSamples, equals(11520));
    });
    test('Test lengthInSeconds', () {
      final buffer = Buffer.fromStreamParams(synthizer, 'file', 'sound.wav');
      expect(buffer.lengthInSeconds.toStringAsFixed(4), equals('0.2612'));
    });
  });
  group('Linger Behaviour', () {
    final ctx = synthizer.createContext();
    final s = ctx.createDirectSource();
    test('See if linger crashes', () {
      s.configDeleteBehavior(linger: true);
    });
  });
}
