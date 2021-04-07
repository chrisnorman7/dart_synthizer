/// Provides the [Context] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'buffer.dart';
import 'classes.dart';
import 'enumerations.dart';
import 'generator.dart';
import 'properties.dart';
import 'source.dart';
import 'synthizer.dart';

/// A synthizer context.
///
/// Synthizer docs: [https://synthizer.github.io/object_reference/context.html]
///
/// Contexts can be created with [Synthizer.createContext] function.
class Context extends Pausable {
  /// Create a context.
  @override
  Context(Synthizer synthizer, {bool events = false})
      : super(synthizer, calloc<Uint64>()) {
    synthizer.check(synthizer.synthizer.syz_createContext(handle));
    if (events) {
      enableEvents();
    }
  }

  /// Enable the streaming of context events.
  void enableEvents() => synthizer
      .check(synthizer.synthizer.syz_contextEnableEvents(handle.value));

  /// Get the position of this context.
  Double3 get position => synthizer.getDouble3(handle, Properties.position);

  /// Set the position of this context.
  set position(Double3 value) =>
      synthizer.setDouble3(handle, Properties.position, value);

  /// Get the orientation of this context.
  Double6 get orientation =>
      synthizer.getDouble6(handle, Properties.orientation);

  /// Set the orientation of this context.
  set orientation(Double6 value) =>
      synthizer.setDouble6(handle, Properties.orientation, value);

  /// Create a buffer generator.
  BufferGenerator createBufferGenerator({Buffer? buffer}) =>
      BufferGenerator(this, buffer: buffer);

  /// Create a streaming generator.
  StreamingGenerator createStreamingGenerator(String protocol, String path,
          {String options = ''}) =>
      StreamingGenerator(this, protocol, path, options: options);

  /// Create a direct source.
  DirectSource createDirectSource() => DirectSource(this);

  /// Create a noise generator.
  NoiseGenerator createNoiseGenerator({int channels = 1}) =>
      NoiseGenerator(this, channels: channels);
}