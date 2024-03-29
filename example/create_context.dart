// ignore_for_file: avoid_print
import 'package:dart_synthizer/dart_synthizer.dart';

/// create a context and exit.
void main() {
  final synthizer = Synthizer()..initialize();
  print('Synthizer initialized.');
  final ctx = Context(synthizer);
  print('Created context $ctx.');
  ctx.destroy();
  print('Context destroyed.');
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
