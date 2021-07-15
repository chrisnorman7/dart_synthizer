//ignore_for_file: avoid_print
import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final synthizer1 = Synthizer();
  print('Created first instance.');
  final synthizer2 = Synthizer();
  print('Created second instance.');
  synthizer1.initialize();
  print('Initialised first instance.');
  synthizer2.initialize();
  print('Initialise second instance.'); // You probably won't see this line.
  synthizer1.shutdown();
  print('Shutdown first instance.');
  synthizer2.shutdown();
  print('Shutdown second instance.');
}
