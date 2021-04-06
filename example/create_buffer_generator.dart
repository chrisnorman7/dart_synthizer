/// create a buffer generator and exit.
import 'dart:ffi';
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  initialize(synthizer);
  print('Synthizer initialized.');
  final ctx = Context(synthizer);
  print('Created context $ctx.');
  final buffer = Buffer.fromFile(ctx, File('sound.wav'));
  final generator = BufferGenerator(ctx, buffer: buffer);
  print('Created generator $generator.');
  shutdown(synthizer);
  print('Synthizer shutdown.');
}
