// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final source = ctx.createDirectSource();
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)..looping = true;
  source.addGenerator(generator);
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration(seconds: 1));
    print('Playback position: ${generator.playbackPosition}.');
  }
  await Future<void>.delayed(Duration(seconds: 1));
  generator.playbackPosition = 0.0;
  print('Restarted generator.');
  await Future<void>.delayed(Duration(seconds: 1));
  for (final thing in [source, generator, ctx, buffer]) {
    thing.destroy();
  }
  synthizer.shutdown();
  print('Done.');
}