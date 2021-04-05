/// Initialise the library with logging and exit.
import 'dart:ffi';

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final lib = DynamicLibrary.open('synthizer.dll');
  final synthizer = Synthizer(lib);
  synthizer.syz_setLogLevel(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG);
  synthizer.syz_configureLoggingBackend(
      SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_STDERR, nullptr);
  initialize(synthizer);
  shutdown(synthizer);
  print('Synthizer shutdown.');
}
