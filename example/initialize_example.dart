/// Initialise the library and exit.

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final synthizer = Synthizer.fromPath('synthizer.dll')..initialize();
  print('Synthizer initialized.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
