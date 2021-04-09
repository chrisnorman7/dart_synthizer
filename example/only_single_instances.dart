import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final synthizer1 = Synthizer.fromPath('synthizer.dll');
  print('Created first instance.');
  final synthizer2 = Synthizer.fromPath('synthizer.dll');
  print('Created second instance.');
  synthizer1.initialize();
  print('Initialised first instance.');
  synthizer2.initialize();
  print('Initialise second instance.'); // You probably won't see this line.
  synthizer1.shutdown();
  print('Shut down first instance.');
  synthizer2.shutdown();
  print('Shut down second instance.');
}
