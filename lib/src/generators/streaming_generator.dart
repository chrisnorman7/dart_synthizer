/// Provides the [StreamingGenerator] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../classes.dart';
import '../context.dart';
import 'base.dart';

/// A streaming generator.
///
/// [Synthizer docs](https://synthizer.github.io/object_reference/streaming_generator.html)
///
/// Streaming generators can be created with [Context.createStreamingGenerator].
///
/// The `options` argument is as yet undocumented.
class StreamingGenerator extends Generator with PlaybackPosition {
  /// Create a generator.
  StreamingGenerator(
    final Context context,
    final String protocol,
    final String path, {
    final String options = '',
  }) : super(context) {
    final protocolPointer = protocol.toNativeUtf8().cast<Char>();
    final pathPointer = path.toNativeUtf8().cast<Char>();
    final optionsPointer = options.toNativeUtf8().cast<Void>();
    synthizer.check(
      synthizer.synthizer.syz_createStreamingGeneratorFromStreamParams(
        handle,
        context.handle.value,
        protocolPointer,
        pathPointer,
        optionsPointer,
        nullptr,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
    [protocolPointer, pathPointer, optionsPointer].forEach(malloc.free);
  }
}
