// ignore_for_file: avoid_print
/// Initialise the library and exit.
import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final synthizer = Synthizer()..initialize();
  print('Synthizer initialized.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
