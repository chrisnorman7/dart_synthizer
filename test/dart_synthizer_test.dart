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
      expect(ctx.pannerStrategy, equals(PannerStrategies.stereo));
      expect(ctx.closenessBoost, equals(0.0));
      expect(ctx.closenessBoostDistance, equals(0.0));
      expect(ctx.distanceMax, equals(50.0));
      expect(ctx.distanceModel, equals(DistanceModels.linear));
      expect(ctx.distanceRef, equals(1.0));
      expect(ctx.position, equals(Double3(0.0, 0.0, 0.0)));
      expect(ctx.rolloff, equals(1.0));
      expect(ctx.gain, equals(1.0));
    });
  });

  group('Test buffers', () {
    test('Test Buffer.fromStream', () {
      expect(Buffer.fromStream(synthizer, 'file', 'sound.wav'), isA<Buffer>());
    });

    test('Test Buffer.fromFile', () {
      expect(Buffer.fromFile(synthizer, File('sound.wav')), isA<Buffer>());
    });

    test('Try to load an invalid file', () {
      expect(() => Buffer.fromStream(synthizer, 'file', 'nothing.invalid'),
          throwsA(TypeMatcher<SynthizerError>()));
    });

    test('Test lengthInSamples', () {
      final buffer = Buffer.fromStream(synthizer, 'file', 'sound.wav');
      expect(buffer.lengthInSamples, equals(11520));
    });

    test('Test lengthInSeconds', () {
      final buffer = Buffer.fromStream(synthizer, 'file', 'sound.wav');
      expect(buffer.lengthInSeconds.toStringAsFixed(4), equals('0.2612'));
    });
  });
}
