// ignore_for_file: avoid_print
/// Demonstrate events in Synthizer.
import 'dart:ffi';
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext(events: true);
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator()..setBuffer(buffer);
  final source = ctx.createDirectSource()..addGenerator(generator);
  var looping = true;
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration(seconds: 1));
    print(ctx.getEvent());
    print(synthizer.getObjectType(generator.handle.value));
    generator.looping = looping;
    looping = !looping;
  }
  source.destroy();
  generator.destroy();
  ctx.destroy();
  synthizer.shutdown();
}
