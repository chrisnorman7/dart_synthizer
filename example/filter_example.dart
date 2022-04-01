import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final s = ctx.createDirectSource();
  final g = ctx.createStreamingGenerator('file', 'sound.wav')
    ..looping.value = true;
  s.addGenerator(g);
  var frequency = 22000.0;
  while (frequency > 20) {
    s.filter.value = synthizer.designLowpass(frequency);
    frequency -= 10;
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  g.destroy();
  s.destroy();
  ctx.destroy();
  synthizer.shutdown();
}
