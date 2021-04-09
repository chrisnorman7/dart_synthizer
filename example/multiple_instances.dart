import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  const p = 'synthizer.dll';
  var synthizer = Synthizer.fromPath(p)..initialize();
  print('Initialise first instance.');
  synthizer.shutdown();
  print('Shutdown first instance.');
  synthizer = Synthizer.fromPath(p)..initialize();
  print('Initialize second instance.');
  synthizer.shutdown();
  print('Shutdown second instance.');
}
