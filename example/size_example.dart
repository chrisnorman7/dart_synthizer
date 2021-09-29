// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';

void main() {
  final synthizer = Synthizer()..initialize();
  final ctx = synthizer.createContext();
  final file1 = File('sound.wav');
  final file2 = File('silence.wav');
  var buffer = Buffer.fromBytes(synthizer, file1.readAsBytesSync());
  print(buffer.size);
  buffer.destroy();
  buffer = Buffer.fromBytes(synthizer, file2.readAsBytesSync());
  print(buffer.size);
  ctx.destroy();
  synthizer.shutdown();
  print('Done.');
}
