// ignore_for_file: avoid_print
/// Demonstrate events in Synthizer.
import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext(events: true);
  ctx.events.listen((final event) {
    if (event is FinishedEvent) {
      print('Finished: ${event.source}');
    } else if (event is LoopedEvent) {
      print('Looped: ${event.generator}');
    } else if (event is UserAutomationEvent) {
      print('User automation: ${event.target} ${event.param}.');
    } else {
      print(event);
    }
  });
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)
    ..looping.value = true;
  final source = ctx.createDirectSource()..addGenerator(generator);
  // final commands = [
  //   for (var i = 0; i < 10; i += 2)
  //     AutomationSendUserEventCommand(i.toDouble(), i * 2)
  // ];
  // ctx.executeAutomation(source, commands);
  await Future<void>.delayed(const Duration(seconds: 10));
  source.destroy();
  generator.destroy();
  ctx.destroy();
  synthizer.shutdown();
  print('Done.');
}
