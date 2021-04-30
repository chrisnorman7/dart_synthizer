// ignore_for_file: avoid_print
/// Load a file into memory, and play it.
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final f = File('sound.wav');
  final synthizer = Synthizer.fromPath('synthizer.dll')
    ..fullLogging()
    ..initialize();
  final ctx = synthizer.createContext();
  final generator = ctx.createBufferGenerator();
  final source = ctx.createDirectSource()..addGenerator(generator);
  final buffer = Buffer.fromBytes(synthizer, f.readAsBytesSync());
  generator.setBuffer(buffer);
  await Future<void>.delayed(Duration(seconds: 2));
  buffer.destroy();
  generator.destroy();
  source.destroy();
  synthizer.shutdown();
}
