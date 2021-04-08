/// create a buffer generator and exit.
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final synthizer = Synthizer.fromPath('synthizer.dll')..initialize();
  print('Synthizer initialized.');
  final ctx = synthizer.createContext();
  print('Created context $ctx.');
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer);
  print('Created generator $generator.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
