// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';

const stepsBeforeWait = 10;
const secondsPerStep = 0.1;
const degreesPerStep = 5.0;
void enqueueEvents(Source3D source, Context ctx, int itersSoFar) {
  final commands = <AutomationCommand>[
    AutomationSendUserEventCommand(
        ctx.currentTime, itersSoFar + stepsBeforeWait)
  ];
  for (var i = 0; i < stepsBeforeWait; i++) {
    final iter = itersSoFar + i;
    commands.insert(
        0,
        AutomationAppendPropertyCommand(
            iter * secondsPerStep,
            Properties.position,
            Double3(10.0 * sin(iter * degreesPerStep * pi / 180.0),
                10.0 * cos(iter * degreesPerStep * pi / 180.0), 0.0)));
  }
  ctx.executeAutomation(source, commands);
}

Future<void> main() async {
  var itersSoFar = 0;
  final synthizer = Synthizer()
    ..initialize(
        logLevel: LogLevel.debug, loggingBackend: LoggingBackend.stderr);
  final ctx = synthizer.createContext(events: true)
    ..orientation = Double6(0.0, 1.0, 0.0, 0.0, 0.0, 1.0);
  final source = ctx.createSource3D();
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = ctx.createBufferGenerator(buffer: buffer)..looping = true;
  source.addGenerator(generator);
  final listener = ctx.events.listen((event) {
    if (event is UserAutomationEvent) {
      print('Starting iteration $itersSoFar.');
      itersSoFar = event.param;
      enqueueEvents(source, ctx, itersSoFar);
    }
  });
  enqueueEvents(source, ctx, itersSoFar);
  stdin
    ..echoMode = false
    ..lineMode = false
    ..listen((event) {
      listener.cancel();
      for (final thing in [ctx, source, generator, buffer]) {
        thing.destroy();
      }
      synthizer.shutdown();
      exit(0);
    });
}
