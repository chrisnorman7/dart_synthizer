// ignore_for_file: avoid_print
import 'package:dart_synthizer/dart_synthizer.dart';

/// create a streaming generator and exit.
void main() {
  final synthizer = Synthizer()..initialize();
  print('Synthizer initialized.');
  final ctx = Context(synthizer);
  print('Created context $ctx.');
  final generator = StreamingGenerator(ctx, 'file', 'sound.wav');
  print('Created generator $generator.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
