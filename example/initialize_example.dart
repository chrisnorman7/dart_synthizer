/// Initialise the library and exit.
import 'dart:ffi';

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  synthizer.initialize();
  print('Synthizer initialized.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
