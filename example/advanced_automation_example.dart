// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';

const stepsBeforeWait = 10;
const secondsPerStep = 0.1;
const degreesPerStep = 5.0;

/// Enqueue some automation including the event to drive things forward.  Uses
/// iters_so_far to maintain state, which we read back from the event this
/// schedules.
void enqueueAutomation(
  final Context context,
  final Source3D source,
  final double timebase,
  final int itersSoFar,
) {
  final batch = AutomationBatch(context);
  for (var i = 0; i < stepsBeforeWait; i++) {
    final iter = itersSoFar + i;
    batch.appendDouble3(
      source.handle,
      timebase + iter * secondsPerStep,
      Properties.position,
      Double3(
        10.0 * sin(iter * degreesPerStep * pi / 180.0),
        10.0 * cos(iter * degreesPerStep * pi / 180.0),
        0,
      ),
    );
  }
  batch
    ..sendUserEvent(
      source.handle,
      (itersSoFar + stepsBeforeWait) * secondsPerStep,
      itersSoFar + stepsBeforeWait,
    )
    ..execute()
    ..destroy();
}

void main() async {
  final synthizer = Synthizer()
    ..initialize(
      logLevel: LogLevel.debug,
      loggingBackend: LoggingBackend.stderr,
    );
  final context = synthizer.createContext(events: true)
    ..defaultPannerStrategy.value = PannerStrategy.hrtf;
  final source = context.createSource3D();
  final buffer = Buffer.fromFile(synthizer, File('sound.wav'));
  final generator = context.createBufferGenerator(buffer: buffer)
    ..looping.value = true;
  source.addGenerator(generator);
  // Create a reverb to make it a bit more obvious when the sound passes behind.
  final reverb = context.createGlobalFdnReverb()
    ..gain.value = 0.5
    ..t60.value = 3;
  context.configRoute(source, reverb);
  final timebase = context.currentTime.value;
  var itersSoFar = 0;
  while (itersSoFar < 300) {
    print('Beginning iteration $itersSoFar.');
    enqueueAutomation(context, source, timebase, itersSoFar);
    SynthizerEvent? event;
    do {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      event = context.getEvent();
    } while (event is! UserAutomationEvent);

    itersSoFar = event.param;
  }

  for (final thing in [context, generator, buffer, source, reverb]) {
    thing.destroy();
  }
  synthizer.shutdown();
}
