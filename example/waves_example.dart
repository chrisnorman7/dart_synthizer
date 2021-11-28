// ignore_for_file: avoid_print

import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final sources = <ScalarPannedSource>[];
  final notes = <FastSineBankGenerator>[];
  var initialFrequency = 55.0;
  var gain = 1.0;
  final random = Random();
  while (initialFrequency <= 22000) {
    final source = ctx.createScalarPannedSource(
        panningScalar: (random.nextDouble() * 2) - 1);
    sources.add(source);
    print('Creating wave $initialFrequency HZ with gain $gain.');
    final note = ctx.createSine(initialFrequency, 1)..gain.value = gain;
    notes.add(note);
    source.addGenerator(note);
    await Future<void>.delayed(Duration(milliseconds: 500));
    initialFrequency *= 2;
    gain /= 2;
  }
  await Future<void>.delayed(Duration(seconds: 2));
  final timebase = ctx.suggestedAutomationTime.value;
  for (final note in notes) {
    note.gain.automate(ctx,
        startTime: timebase,
        startValue: note.gain.value,
        endTime: timebase + 5.0,
        endValue: 0.0);
  }
  await Future<void>.delayed(Duration(seconds: 5));
  for (final thing in <SynthizerObject>[ctx] + sources + notes) {
    thing.destroy();
  }
  synthizer.shutdown();
}
