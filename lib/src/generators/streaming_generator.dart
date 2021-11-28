/// Provides the [StreamingGenerator] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../classes.dart';
import '../context.dart';
import '../synthizer.dart';
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
  StreamingGenerator(Context context, String protocol, String path,
      {String options = ''})
      : super(context) {
    final protocolPointer = protocol.toNativeUtf8().cast<Int8>();
    final pathPointer = path.toNativeUtf8().cast<Int8>();
    final optionsPointer = options.toNativeUtf8().cast<Void>();
    synthizer.check(synthizer.synthizer
        .syz_createStreamingGeneratorFromStreamParams(
            handle,
            context.handle.value,
            protocolPointer,
            pathPointer,
            optionsPointer,
            nullptr,
            nullptr,
            synthizer.userdataFreeCallbackPointer));
    [protocolPointer, pathPointer, optionsPointer].forEach(calloc.free);
  }

  /// Return an instance from a handle.
  StreamingGenerator.fromHandle(Synthizer synthizer, int pointer)
      : super.fromHandle(synthizer, pointer);
}
