/// Play a buffer generator and exit.
import 'dart:ffi';
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  synthizer.initialize();
  print('Synthizer initialized.');
  final ctx = synthizer.createContext();
  print('Created context $ctx with gain ${ctx.gain}.');
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer);
  print('Created generator $generator with gain ${generator.gain}.');
  generator.gain = 0.5;
  final source = DirectSource(ctx);
  source.addGenerator(generator);
  await Future.delayed(Duration(seconds: 2));
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
