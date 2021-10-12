// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

/// Simple automation with Synthizer.

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)..looping = true;
  final source = ctx.createDirectSource()..addGenerator(generator);
  var time = ctx.currentTime;
  ctx.executeAutomation(generator, [
    AutomationAppendPropertyCommand(time + 0.5, Properties.gain, 1.0),
    AutomationAppendPropertyCommand(time + 5.0, Properties.gain, 0.0)
  ]).destroy();
  await Future<void>.delayed(Duration(milliseconds: 5500));
  print('Gain is ${generator.gain}.');
  time = ctx.currentTime;
  ctx.executeAutomation(generator, [
    AutomationAppendPropertyCommand(time, Properties.gain, 0.0),
    AutomationAppendPropertyCommand(time + 5.0, Properties.gain, 1.0)
  ]).destroy();
  await Future<void>.delayed(Duration(milliseconds: 5500));
  print('Final gain is ${generator.gain}.');
  for (final thing in <SynthizerObject>[
    ctx,
    buffer,
    source,
    generator,
  ]) {
    thing.destroy();
  }
  synthizer.shutdown();
}
