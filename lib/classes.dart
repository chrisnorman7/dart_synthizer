/// Provides various classes for use with Synthizer.
import 'dart:ffi';
import 'dart:io';

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

  /// Destroy this object.
  void destroy() => check(synthizer, synthizer.syz_handleFree(handle.value));
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

  /// Create a buffer from a file object.
  factory Buffer.fromFile(Context context, File file) {
    return Buffer.fromStream(context, 'file', file.absolute.path);
  }

  /// Get the number of channels for this buffer.
  int get channels {
    final out = calloc<Uint32>();
    check(synthizer, synthizer.syz_bufferGetChannels(out, handle.value));
    return out.value;
  }

  /// Get the length of this buffer in samples.
  int get lengthInSamples {
    final out = calloc<Uint32>();
    check(synthizer, synthizer.syz_bufferGetLengthInSamples(out, handle.value));
    return out.value;
  }

  /// Get the length of this buffer in seconds.
  double get lengthInSeconds {
    final out = calloc<Double>();
    check(synthizer, synthizer.syz_bufferGetLengthInSeconds(out, handle.value));
    return out.value;
  }
}

/// The base class for all generators.
class Generator extends Pausable {
  Generator(Context context) : super(context.synthizer, calloc<Uint64>());
}

/// A streaming generator.
class StreamingGenerator extends Generator {
  /// Create a generator.
  StreamingGenerator(Context context, String protocol, String path,
      {String options = ''})
      : super(context) {
    check(
        synthizer,
        synthizer.syz_createStreamingGenerator(
            handle,
            context.handle.value,
            protocol.toNativeUtf8().cast<Int8>(),
            path.toNativeUtf8().cast<Int8>(),
            options.toNativeUtf8().cast<Int8>()));
  }
}

/// The base class for all sources.
class Source extends Pausable {
  Source(Context context) : super(context.synthizer, calloc<Uint64>());

  /// Add a generator to this source.
  void addGenerator(Generator generator) => check(synthizer,
      synthizer.syz_sourceAddGenerator(handle.value, generator.handle.value));

  /// Remove a generator from this source.
  void removeGenerator(Generator generator) => check(
      synthizer,
      synthizer.syz_sourceRemoveGenerator(
          handle.value, generator.handle.value));
}

/// A direct source.
class DirectSource extends Source {
  DirectSource(Context context) : super(context) {
    check(synthizer,
        synthizer.syz_createDirectSource(handle, context.handle.value));
  }
}
