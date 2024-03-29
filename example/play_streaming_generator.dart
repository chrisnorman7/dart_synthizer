// ignore_for_file: avoid_print
import 'package:dart_synthizer/dart_synthizer.dart';

/// create a streaming generator and exit.
Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  print('Synthizer initialized.');
  final ctx = Context(synthizer);
  print('Created context $ctx.');
  final source = DirectSource(ctx);
  print('Created source $source.');
  final generator = StreamingGenerator(ctx, 'file', 'sound.wav');
  print('Created generator $generator.');
  source.addGenerator(generator);
  await Future<void>.delayed(const Duration(seconds: 2));
  print(generator.playbackPosition.value);
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
