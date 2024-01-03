import 'package:ffi/ffi.dart';

import 'synthizer_bindings.dart';

/// An error reported by synthizer.
class SynthizerError implements Exception {
  /// Create a synthizer error.
  ///
  /// If you have a [DartSynthizer] instance, use the [SynthizerError.fromLib]
  /// constructor.
  SynthizerError(this.message, this.code);

  /// Create an instance with a [DartSynthizer] instance.
  ///
  /// If you want to create an instance by hand, use the unnamed constructor.
  factory SynthizerError.fromLib(final DartSynthizer lib) {
    final msg = lib.syz_getLastErrorMessage().cast<Utf8>().toDartString();
    return SynthizerError(msg, lib.syz_getLastErrorCode());
  }

  /// The string of the message.
  final String message;

  /// The error code.
  final int code;

  /// Pretty-printing.
  @override
  String toString() => '$runtimeType($code): $message';
}
