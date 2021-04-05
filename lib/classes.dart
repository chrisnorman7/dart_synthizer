/// Provides various classes for use with Synthizer.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'synthizer_bindings.dart';
import 'util.dart';

/// The base class for all synthizer objects.
class SynthizerObject {
  /// The synthizer instance.
  final Synthizer synthizer;

  /// The handle for this context.
  final Pointer<Uint64> handle;

  /// Create an instance.
  SynthizerObject(this.synthizer, this.handle);
}

/// An object which can be played and paused.
class Pausable extends SynthizerObject {
  Pausable(Synthizer synthizer, Pointer<Uint64> handle)
      : super(synthizer, handle);

  /// Pause this object.
  void pause() => synthizer.syz_pause(handle.value);

  /// Play this object.
  void play() => synthizer.syz_play(handle.value);
}

class Context extends SynthizerObject {
  /// Create a context.
  @override
  Context(Synthizer synthizer, {bool events = false})
      : super(synthizer, calloc<Uint64>()) {
    check(synthizer, synthizer.syz_createContext(handle));
    if (events) {
      enableEvents();
    }
  }

  /// Enable the streaming of context events.
  void enableEvents() => synthizer.syz_contextEnableEvents(handle.value);
}

/// A synthizer buffer.
class Buffer extends SynthizerObject {
  Buffer(Synthizer synthizer, Pointer<Uint64> handle)
      : super(synthizer, handle);

  /// Create a buffer from a stream.
  factory Buffer.fromStream(Context context, String protocol, String path,
      {String options = ''}) {
    final out = calloc<Uint64>();
    check(
        context.synthizer,
        context.synthizer.syz_createBufferFromStream(
            out,
            protocol.toNativeUtf8().cast<Int8>(),
            path.toNativeUtf8().cast<Int8>(),
            options.toNativeUtf8().cast<Int8>()));
    return Buffer(context.synthizer, out);
  }
}
