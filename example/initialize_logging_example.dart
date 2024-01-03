// ignore_for_file: avoid_print
import 'package:dart_synthizer/dart_synthizer.dart';

/// Initialise the library with logging and exit.
void main() {
  Synthizer()
    ..initialize()
    ..shutdown();
  print('Synthizer shutdown.');
}
