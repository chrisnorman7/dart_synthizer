/// Initialise the library with logging and exit.
import 'dart:ffi';

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  synthizer.setLogLevel(LogLevel.debug);
  synthizer.configureLoggingBackend(LoggingBackend.stderr);
  synthizer.initialize();
  synthizer.shutdown();
  print('Synthizer shutdown.');
}
