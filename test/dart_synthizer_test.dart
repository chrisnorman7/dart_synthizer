import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:test/test.dart';

void main() {
  final synthizer = Synthizer()..initialize();

  tearDownAll(synthizer.shutdown);

  group('Context', () {
    test('.isValid', () {
      final ctx = synthizer.createContext();
      expect(ctx.isValid, isTrue);
      ctx.destroy();
      expect(ctx.isValid, isFalse);
    });
    test('Check properties', () async {
      final ctx = synthizer.createContext();
      expect(
        ctx.orientation.value,
        equals(const Double6(0.0, 1.0, 0.0, 0.0, 0.0, 1.0)),
      );
      ctx.orientation.value = const Double6(1.0, 0.0, 1.0, 1.0, 1.0, 0.0);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(
        ctx.orientation.value,
        equals(const Double6(1.0, 0.0, 1.0, 1.0, 1.0, 0.0)),
      );
      expect(ctx.defaultPannerStrategy.value, equals(PannerStrategy.stereo));
      ctx.defaultPannerStrategy.value = PannerStrategy.hrtf;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.defaultPannerStrategy.value, equals(PannerStrategy.hrtf));
      expect(ctx.defaultClosenessBoost.value, equals(0.0));
      ctx.defaultClosenessBoost.value = 1.0;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.defaultClosenessBoost.value, equals(1.0));
      expect(ctx.defaultClosenessBoostDistance.value, equals(0.0));
      ctx.defaultClosenessBoostDistance.value = 1.0;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.defaultClosenessBoostDistance.value, equals(1.0));
      expect(ctx.defaultDistanceMax.value, equals(50.0));
      ctx.defaultDistanceMax.value = 25.0;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.defaultDistanceMax.value, equals(25.0));
      expect(ctx.defaultRolloff.value, equals(1.0));
      ctx.defaultRolloff.value = 0.5;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.defaultRolloff.value, equals(0.5));
      expect(ctx.defaultDistanceModel.value, equals(DistanceModel.linear));
      ctx.defaultDistanceModel.value = DistanceModel.exponential;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.defaultDistanceModel.value, equals(DistanceModel.exponential));
      expect(ctx.defaultDistanceRef.value, equals(1.0));
      ctx.defaultDistanceRef.value = 0.5;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.defaultDistanceRef.value, equals(0.5));
      expect(ctx.position.value, equals(const Double3(0.0, 0.0, 0.0)));
      ctx.position.value = const Double3(3, 4, 5);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.position.value, equals(const Double3(3, 4, 5)));
      expect(ctx.gain.value, equals(1.0));
      ctx.gain.value = 0.5;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(ctx.gain.value, equals(0.5));
      ctx.destroy();
    });
    test('.createBufferGenerator', () {
      final ctx = synthizer.createContext();
      final generator = ctx.createBufferGenerator();
      expect(generator, isA<BufferGenerator>());
      ctx.destroy();
      generator.destroy();
    });
    test('.createStreamingGenerator', () {
      final ctx = synthizer.createContext();
      final generator = ctx.createStreamingGenerator('file', 'silence.wav');
      expect(generator, isA<StreamingGenerator>());
      expect(
        () => ctx.createStreamingGenerator('invalid', 'silence.wav'),
        throwsA(isA<SynthizerError>()),
      );
      ctx.destroy();
      generator.destroy();
    });
    test('.createNoiseGenerator', () {
      final ctx = synthizer.createContext();
      var generator = ctx.createNoiseGenerator();
      expect(generator, isA<NoiseGenerator>());
      expect(generator.noiseType.value, equals(NoiseType.uniform));
      generator.destroy();
      generator = ctx.createNoiseGenerator(channels: 2);
      expect(generator.noiseType.value, equals(NoiseType.uniform));
      generator.destroy();
      ctx.destroy();
    });
    test('.createDirectSource', () {
      final ctx = synthizer.createContext();
      final source = ctx.createDirectSource();
      expect(source, isA<DirectSource>());
      source.destroy();
      ctx.destroy();
    });
    test('.createAngularSource', () async {
      final ctx = synthizer.createContext();
      var source = ctx.createAngularPannedSource();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(source.azimuth.value, isZero);
      expect(source.elevation.value, isZero);
      source = ctx.createAngularPannedSource(azimuth: 90, elevation: 90);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(source.azimuth.value, equals(90));
      expect(source.elevation.value, equals(90));
      source.destroy();
      ctx.destroy();
    });
    test('.createScalarPannedSource', () async {
      final ctx = synthizer.createContext();
      var source = ctx.createScalarPannedSource();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(source.panningScalar.value, isZero);
      source = ctx.createScalarPannedSource(panningScalar: 1.0);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(source.panningScalar.value, equals(1));
      source.destroy();
      ctx.destroy();
    });
    test('.createSource3D', () async {
      final ctx = synthizer.createContext();
      var source = ctx.createSource3D();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(
        source.closenessBoost.value,
        equals(ctx.defaultClosenessBoost.value),
      );
      expect(
        source.closenessBoostDistance.value,
        equals(ctx.defaultClosenessBoostDistance.value),
      );
      expect(source.distanceMax.value, equals(ctx.defaultDistanceMax.value));
      expect(
        source.distanceModel.value,
        equals(ctx.defaultDistanceModel.value),
      );
      expect(source.orientation.value, equals(ctx.orientation.value));
      expect(source.position.value, equals(const Double3(0, 0, 0)));
      expect(source.rolloff.value, equals(ctx.defaultRolloff.value));
      expect(source.gain.value, equals(1.0));
      source = ctx.createSource3D(x: 3, y: 4, z: 5);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(
        source.closenessBoost.value,
        equals(ctx.defaultClosenessBoost.value),
      );
      expect(
        source.closenessBoostDistance.value,
        equals(ctx.defaultClosenessBoostDistance.value),
      );
      expect(source.distanceMax.value, equals(ctx.defaultDistanceMax.value));
      expect(
        source.distanceModel.value,
        equals(ctx.defaultDistanceModel.value),
      );
      expect(source.orientation.value, equals(ctx.orientation.value));
      expect(source.position.value, equals(const Double3(3, 4, 5)));
      expect(source.rolloff.value, equals(ctx.defaultRolloff.value));
      expect(source.gain.value, equals(1.0));
      source.destroy();
      ctx.destroy();
    });
    test('.createGlobalEcho', () {
      final ctx = synthizer.createContext();
      final echo = ctx.createGlobalEcho();
      expect(echo.gain.value, equals(1.0));
      echo.destroy();
      ctx.destroy();
    });
    test('.createGlobalFdnReverb', () async {
      final ctx = synthizer.createContext();
      final reverb = ctx.createGlobalFdnReverb();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(reverb.meanFreePath.value, equals(0.1));
      expect(reverb.t60.value, equals(0.3));
      expect(reverb.lateReflectionsLfRolloff.value, equals(1.0));
      expect(reverb.lateReflectionsLfReference.value, equals(200));
      expect(reverb.lateReflectionsHfRolloff.value, equals(0.5));
      expect(reverb.lateReflectionsHfReference.value, equals(500));
      expect(reverb.lateReflectionsDiffusion.value, equals(1.0));
      expect(reverb.lateReflectionsModulationDepth.value, equals(0.01));
      expect(reverb.lateReflectionsModulationFrequency.value, equals(0.5));
      expect(reverb.lateReflectionsDelay.value, equals(0.03));
      reverb.destroy();
      ctx.destroy();
    });
    test('.getEvent', () async {
      final ctx = synthizer.createContext(events: true);
      var event = ctx.getEvent();
      expect(event, isNull);
      final source = ctx.createDirectSource();
      final buffer = Buffer.fromFile(synthizer, File('silence.wav'));
      final generator = ctx.createBufferGenerator(buffer: buffer);
      source.addGenerator(generator);
      await Future<void>.delayed(
        Duration(seconds: buffer.lengthInSeconds.round() + 1),
      );
      event = ctx.getEvent();
      expect(event, isA<FinishedEvent>());
      event as FinishedEvent;
      expect(event.source, equals(generator));
      expect(event.context, equals(ctx));
      expect(event.type, equals(EventTypes.finished));
      for (final thing in [buffer, source, generator, ctx]) {
        thing.destroy();
      }
    });
  });

  group('Buffer', () {
    test('.fromStream', () {
      expect(
        Buffer.fromStreamParams(synthizer, 'file', 'sound.wav'),
        isA<Buffer>(),
      );
    });
    test('.fromFile', () {
      expect(Buffer.fromFile(synthizer, File('sound.wav')), isA<Buffer>());
    });
    test('Invalid file', () {
      expect(
        () => Buffer.fromStreamParams(synthizer, 'file', 'nothing.invalid'),
        throwsA(isA<SynthizerError>()),
      );
    });
    test('Test lengthInSamples', () {
      final buffer = Buffer.fromStreamParams(synthizer, 'file', 'sound.wav');
      expect(buffer.lengthInSamples, equals(11520));
    });
    test('Test lengthInSeconds', () {
      final buffer = Buffer.fromStreamParams(synthizer, 'file', 'sound.wav');
      expect(buffer.lengthInSeconds.toStringAsFixed(4), equals('0.2612'));
    });
  });
  group('Linger Behaviour', () {
    final ctx = synthizer.createContext();
    final s = ctx.createDirectSource();
    test('See if linger crashes', () {
      s.configDeleteBehavior(linger: true);
    });
  });
}
