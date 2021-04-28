// ignore_for_file: avoid_print
/// create a streaming generator and exit.
import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer.fromPath('synthizer.dll')..initialize();
  print('Synthizer initialized.');
  final ctx = Context(synthizer);
  print('Created context $ctx.');
  final source = DirectSource(ctx);
  print('Created source $source.');
  final generator = StreamingGenerator(ctx, 'file', 'sound.wav');
  print('Created generator $generator.');
  source.addGenerator(generator);
  await Future<void>.delayed(Duration(seconds: 2));
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
