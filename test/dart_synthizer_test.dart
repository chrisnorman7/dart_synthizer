import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:test/test.dart';

void main() {
  final synthizer = Synthizer()..initialize();

  tearDownAll(synthizer.shutdown);

  group('Base object tests', () {
    test('isValid', () {
      final ctx = synthizer.createContext();
      expect(ctx.isValid, isTrue);
      ctx.destroy();
      expect(ctx.isValid, isFalse);
    });
  });

  group('Context properties', () {
    final ctx = synthizer.createContext();
    test('Check properties', () async {
      expect(ctx.orientation, equals(Double6(0.0, 1.0, 0.0, 0.0, 0.0, 1.0)));
      expect(ctx.defaultClosenessBoost, equals(0.0));
      expect(ctx.defaultClosenessBoostDistance, equals(0.0));
      expect(ctx.defaultDistanceMax, equals(50.0));
      expect(ctx.defaultDistanceModel, equals(DistanceModel.linear));
      expect(ctx.defaultDistanceRef, equals(1.0));
      expect(ctx.defaultPannerStrategy, equals(PannerStrategy.stereo));
      expect(ctx.defaultRolloff, equals(1.0));
      expect(ctx.position, equals(Double3(0.0, 0.0, 0.0)));
      expect(ctx.gain, equals(1.0));
    });
  });

  group('Test buffers', () {
    test('Test Buffer.fromStream', () {
      expect(Buffer.fromStreamParams(synthizer, 'file', 'sound.wav'),
          isA<Buffer>());
    });

    test('Test Buffer.fromFile', () {
      expect(Buffer.fromFile(synthizer, File('sound.wav')), isA<Buffer>());
    });

    test('Try to load an invalid file', () {
      expect(
          () => Buffer.fromStreamParams(synthizer, 'file', 'nothing.invalid'),
          throwsA(TypeMatcher<SynthizerError>()));
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
  group('Linger Behaviour Tests', () {
    final ctx = synthizer.createContext();
    final s = ctx.createDirectSource();
    test('See if linger crashes', () {
      s.configDeleteBehavior(linger: true);
    });
  });
}
