/// Create a buffer and quit.
import 'dart:ffi';

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  initialize(synthizer);
  final ctx = Context(synthizer);
  final buff = Buffer.fromStream(ctx, 'file', 'sound.wav');
  print('Created buffer $buff.');
  shutdown(synthizer);
  print('Synthizer shutdown.');
}
