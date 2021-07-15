// ignore_for_file: avoid_print
/// create a streaming generator and exit.
import 'package:dart_synthizer/dart_synthizer.dart';

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
