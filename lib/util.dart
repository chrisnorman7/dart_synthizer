/// Provides utility methods.
import 'error.dart';
import 'synthizer_bindings.dart';

/// Check if a returned value is an error.
void check(Synthizer syz, int value) {
  if (value != 0) {
    throw SynthizerError.fromLib(syz);
  }
}
