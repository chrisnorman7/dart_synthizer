// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)..looping = true;
  final source = ctx.createDirectSource()..addGenerator(generator);
  await Future<void>.delayed(Duration(seconds: 1));
  generator.pause();
  await Future<void>.delayed(Duration(seconds: 1));
  generator.play();
  await Future<void>.delayed(Duration(seconds: 1));
  for (final thing in [buffer, generator, source, ctx]) {
    thing.destroy();
  }
  synthizer.shutdown();
  print('Done.');
}
