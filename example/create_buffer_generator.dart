// ignore_for_file: avoid_print
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

/// create a buffer generator and exit.
void main() {
  final synthizer = Synthizer()..initialize();
  print('Synthizer initialized.');
  final ctx = synthizer.createContext();
  print('Created context $ctx.');
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer);
  print('Created generator $generator.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
