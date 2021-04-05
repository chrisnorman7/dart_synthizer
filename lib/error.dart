/// Provides the [SynthizerError] class.
import 'package:ffi/ffi.dart';

import 'synthizer_bindings.dart';

/// An error reported by synthizer.
class SynthizerError implements Exception {
  /// The string of the message.
  final String message;

  /// The error code.
  final int code;

  SynthizerError(this.message, this.code);

  factory SynthizerError.fromLib(Synthizer lib) {
    final msg = lib.syz_getLastErrorMessage().cast<Utf8>().toDartString();
    return SynthizerError(msg, lib.syz_getLastErrorCode());
  }

  /// Pretty-printing.
  @override
  String toString() => 'SynthizerError: $message';
}
