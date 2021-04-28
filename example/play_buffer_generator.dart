// ignore_for_file: avoid_print
/// Play a buffer generator and exit.
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer.fromPath('synthizer.dll')..initialize();
  print('Synthizer initialized.');
  final ctx = synthizer.createContext();
  print('Created context $ctx with gain ${ctx.gain}.');
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer);
  print('Created generator $generator with gain ${generator.gain}.');
  generator.gain = 0.5;
  ctx.createDirectSource().addGenerator(generator);
  await Future<void>.delayed(Duration(seconds: 2));
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
