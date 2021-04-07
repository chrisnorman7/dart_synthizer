/// Create a buffer and quit.
import 'dart:ffi';

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  synthizer.initialize();
  final buff = Buffer.fromStream(synthizer, 'file', 'sound.wav');
  print('Created buffer $buff.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
