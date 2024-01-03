// ignore_for_file: avoid_print
import 'package:dart_synthizer/dart_synthizer.dart';

/// Initialise the library and exit.
void main() {
  final synthizer = Synthizer()..initialize();
  print('Synthizer initialized.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
