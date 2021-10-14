// ignore_for_file: avoid_print
/// The basics of Synthizer.
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  print('Using Synthizer v${synthizer.version}.');
  final ctx = synthizer.createContext();
  print('Created context.');
  final source = ctx.createDirectSource();
  print('Created source.');
  final generator = ctx.createBufferGenerator(
      buffer: Buffer.fromFile(synthizer, File('sound.wav')))
    ..looping.value = true;
  source.addGenerator(generator);
  await Future<void>.delayed(Duration(seconds: 2));
  generator.destroy();
  print('Generator destroyed.');
  source.destroy();
  print('Source destroyed.');
  ctx.destroy();
  print('Context destroyed.');
  synthizer.shutdown();
  print('Done.');
}
