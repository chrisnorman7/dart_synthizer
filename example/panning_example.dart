// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  var scalar = -1.0;
  final source = ctx.createScalarPannedSource(panningScalar: scalar);
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)..looping = true;
  source.addGenerator(generator);
  while (scalar < 1.0) {
    await Future<void>.delayed(Duration(milliseconds: 200));
    scalar += 0.2;
    print('Scalar is $scalar.');
    source.panningScalar.value = scalar;
  }
  for (final thing in [buffer, source, generator, ctx]) {
    thing.destroy();
  }
  synthizer.shutdown();
}
