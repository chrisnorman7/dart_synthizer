// ignore_for_file: avoid_print
/// create a context and exit.
import 'package:dart_synthizer/dart_synthizer.dart';

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
