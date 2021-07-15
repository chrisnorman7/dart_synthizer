// ignore_for_file: avoid_print
/// Initialise the library with logging and exit.
import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  Synthizer()
    ..initialize()
    ..shutdown();
  print('Synthizer shutdown.');
}
