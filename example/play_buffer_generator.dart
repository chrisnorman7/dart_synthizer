/// Play a buffer generator and exit.
import 'dart:ffi';
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  initialize(synthizer);
  print('Synthizer initialized.');
  final ctx = Context(synthizer);
  print('Created context $ctx with gain ${ctx.gain}.');
  final buffer = Buffer.fromFile(ctx, File('sound.wav'));
  final generator = BufferGenerator(ctx, buffer: buffer);
  print('Created generator $generator with gain ${generator.gain}.');
  generator.gain = 0.5;
  final source = DirectSource(ctx);
  source.addGenerator(generator);
  await Future.delayed(Duration(seconds: 2));
  shutdown(synthizer);
  print('Synthizer shutdown.');
}
