// ignore_for_file: avoid_print
/// Play a buffer generator and exit.
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  print('Synthizer initialized.');
  final ctx = synthizer.createContext();
  print('Created context $ctx with gain ${ctx.gain.value}.');
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer);
  print('Created generator $generator with gain ${generator.gain.value}.');
  generator.gain.value = 0.5;
  ctx.createDirectSource().addGenerator(generator);
  await Future<void>.delayed(const Duration(seconds: 2));
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
