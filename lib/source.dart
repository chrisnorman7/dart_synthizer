/// Provides source classes.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'context.dart';
import 'generator.dart';

/// The base class for all sources.
class Source extends Pausable {
  Source(Context context) : super(context.synthizer, calloc<Uint64>());

  /// Add a generator to this source.
  void addGenerator(Generator generator) => synthizer.check(synthizer.synthizer
      .syz_sourceAddGenerator(handle.value, generator.handle.value));

  /// Remove a generator from this source.
  void removeGenerator(Generator generator) =>
      synthizer.check(synthizer.synthizer
          .syz_sourceRemoveGenerator(handle.value, generator.handle.value));
}

/// A direct source.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/direct_source.html]
///
/// Direct sources can be created with [Context.createDirectSource].
class DirectSource extends Source {
  DirectSource(Context context) : super(context) {
    synthizer.check(synthizer.synthizer
        .syz_createDirectSource(handle, context.handle.value));
  }
}
