// ignore_for_file: avoid_print
/// Demonstrate events in Synthizer.
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext(events: true);
  ctx.getEvents().listen((event) {
    if (event is FinishedEvent) {
      print('Finished: ${event.source}');
    } else if (event is LoopedEvent) {
      print('Looped: ${event.generator}');
    }
  });
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)..looping = true;
  final source = ctx.createDirectSource()..addGenerator(generator);
  await Future<void>.delayed(Duration(seconds: 3));
  source.destroy();
  generator.destroy();
  ctx.destroy();
  synthizer.shutdown();
  print('Done.');
}
