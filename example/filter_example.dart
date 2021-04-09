import 'package:dart_synthizer/dart_synthizer.dart';

Future<void> main() async {
  final synthizer = Synthizer.fromPath('synthizer.dll')
    ..setLogLevel(LogLevel.debug)
    ..configureLoggingBackend(LoggingBackend.stderr)
    ..initialize();
  final ctx = synthizer.createContext();
  final s = ctx.createDirectSource();
  final g = ctx.createStreamingGenerator('file', 'sound.wav')..looping = true;
  s.addGenerator(g);
  var frequency = 22000.0;
  while (frequency > 20) {
    s.filter = synthizer.designLowpass(frequency);
    frequency -= 10;
    await Future.delayed(Duration(milliseconds: 1));
  }
  g.destroy();
  s.destroy();
  ctx.destroy();
  synthizer.shutdown();
}
