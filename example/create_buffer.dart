// ignore_for_file: avoid_print
/// Create a buffer and quit.
library;

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final synthizer = Synthizer()..initialize();
  final buff = Buffer.fromStreamParams(synthizer, 'file', 'sound.wav');
  print('Created buffer $buff.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
