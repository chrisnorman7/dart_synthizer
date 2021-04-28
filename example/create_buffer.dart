// ignore_for_file: avoid_print
/// Create a buffer and quit.
import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final synthizer = Synthizer.fromPath('synthizer.dll')..initialize();
  final buff = Buffer.fromStream(synthizer, 'file', 'sound.wav');
  print('Created buffer $buff.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
