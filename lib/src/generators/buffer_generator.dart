import 'dart:ffi';

import '../buffer.dart';
import '../classes.dart';
import '../context.dart';
import '../enumerations.dart';
import '../synthizer_property.dart';
import 'base.dart';

/// A buffer generator.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/buffer_generator.html)
///
/// Buffer generators can be created with [Context.createBufferGenerator].
class BufferGenerator extends Generator with PlaybackPosition {
  /// Create a buffer generator.
  BufferGenerator(final Context context, {final Buffer? buffer})
      : super(context) {
    synthizer.check(
      synthizer.synthizer.syz_createBufferGenerator(
        handle,
        context.handle.value,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
    if (buffer != null) {
      this.buffer.value = buffer;
    }
  }

  /// The buffer for this generator.
  SynthizerObjectProperty get buffer => SynthizerObjectProperty(
        synthizer: synthizer,
        targetHandle: handle,
        property: Properties.buffer,
      );
}
