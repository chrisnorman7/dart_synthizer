/// Bindings for the [Synthizer](https://synthizer.github.io/) manual.
import 'synthizer_bindings.dart';
import 'util.dart';

export 'classes.dart';
export 'enumerations.dart';
export 'error.dart';
export 'synthizer_bindings.dart';
export 'util.dart';

/// Initialise the library.
void initialize(Synthizer synthizer) =>
    check(synthizer, synthizer.syz_initialize());

/// Shutdown the library.
void shutdown(Synthizer synthizer) =>
    check(synthizer, synthizer.syz_shutdown());
