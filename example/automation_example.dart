// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final source = ctx.createDirectSource();
  final generator = ctx.createBufferGenerator(
      buffer: Buffer.fromFile(synthizer, File('sound.wav')))
    ..looping = true
    ..setAutomation(
        Properties.gain, [AutomationPoint(0, 1.0), AutomationPoint(2.0, 0.0)]);
  source.addGenerator(generator);
  await Future<void>.delayed(Duration(seconds: 3));
  print('Generator has faded out.');
  generator.setAutomation(
      Properties.gain, [AutomationPoint(0, 0), AutomationPoint(2.0, 1.0)]);
  await Future<void>.delayed(Duration(seconds: 3));
  print('Generator has faded in.');
  source.destroy();
  generator.destroy();
  ctx.destroy();
  synthizer.shutdown();
}
