import 'dart:ffi';
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:test/test.dart';

void main() {
  group('Test buffers', () {
    final synthizer = Synthizer(DynamicLibrary.open('synthizer.dll'));
    synthizer.initialize();

    test('Test Buffer.fromStream', () {
      expect(Buffer.fromStream(synthizer, 'file', 'sound.wav'), isA<Buffer>());
    });

    test('Test Buffer.fromFile', () {
      expect(Buffer.fromFile(synthizer, File('sound.wav')), isA<Buffer>());
    });

    test('Try to load an invalid file', () {
      expect(() {
        return Buffer.fromStream(synthizer, 'file', 'nothing.invalid');
      }, throwsA(TypeMatcher<SynthizerError>()));
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
