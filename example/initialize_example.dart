/// create a buffer generator and exit.
import 'dart:ffi' as ffi;

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final lib = ffi.DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  synthizer.syz_initialize();
  print('Synthizer initialized.');
  synthizer.syz_shutdown();
}
