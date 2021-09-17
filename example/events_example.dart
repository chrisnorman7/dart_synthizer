// ignore_for_file: avoid_print
/// Demonstrate events in Synthizer.
import 'dart:ffi';
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext(events: true);
  ctx.events.listen((event) {
    if (event is FinishedEvent) {
      print('Finished: ${event.source}');
    } else if (event is LoopedEvent) {
      print('Looped: ${event.generator}');
    }
  });
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)..looping = true;
  print(synthizer.getObject(ctx.handle.value).handle.value);
  print(ctx.handle.value);
  final source = ctx.createDirectSource()..addGenerator(generator);
  await Future<void>.delayed(Duration(seconds: 10));
  source.destroy();
  generator.destroy();
  ctx.destroy();
  synthizer.shutdown();
  print('Done.');
}
