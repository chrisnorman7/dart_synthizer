/// create a streaming generator and exit.
import 'dart:ffi';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  initialize(synthizer);
  print('Synthizer initialized.');
  final ctx = Context(synthizer);
  print('Created context $ctx.');
  final source = DirectSource(ctx);
  print('Created source $source.');
  final generator = StreamingGenerator(ctx, 'file', 'sound.wav');
  print('Created generator $generator.');
  source.addGenerator(generator);
  await Future.delayed(Duration(seconds: 2));
  shutdown(synthizer);
  print('Synthizer shutdown.');
}
