// ignore_for_file: avoid_print
import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  var synthizer = Synthizer()..initialize();
  print('Initialise first instance.');
  synthizer.shutdown();
  print('Shutdown first instance.');
  synthizer = Synthizer()..initialize();
  print('Initialize second instance.');
  synthizer.shutdown();
  print('Shutdown second instance.');
}
