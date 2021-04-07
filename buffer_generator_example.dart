/// create a buffer generator and exit.
import 'dart:ffi';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final lib = DynamicLibrary.open('synthizer.lib/synthizer.dll');
  final s = Synthizer(lib);
  s.initialize();
  print(s);
}
