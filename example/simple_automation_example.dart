// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

/// Simple automation with Synthizer.

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)
    ..looping.value = true;
  final source = ctx.createDirectSource()..addGenerator(generator);
  var timebase = ctx.currentTime.value;
  generator.pitchBend.automate(
    startTime: timebase,
    startValue: 1.0,
    endTime: timebase + 10.0,
    endValue: 0.1,
  );
  generator.gain.automate(
    startTime: timebase,
    startValue: 1.0,
    endTime: timebase + 5.0,
    endValue: 0.0,
  );
  await Future<void>.delayed(const Duration(seconds: 5));
  print('Gain is ${generator.gain.value}.');
  timebase = ctx.currentTime.value;
  generator.gain.automate(
    startTime: timebase,
    startValue: 0.0,
    endTime: timebase + 5.0,
    endValue: 1.0,
  );
  await Future<void>.delayed(const Duration(seconds: 5));
  print('Final gain is ${generator.gain.value}.');
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
