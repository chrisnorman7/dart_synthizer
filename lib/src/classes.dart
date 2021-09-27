/// Provides various classes for use with Synthizer.
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

import 'enumerations.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// The base class for all synthizer objects.
class SynthizerObject {
  /// Create an instance.
  SynthizerObject(this.synthizer, {int? pointer}) : handle = calloc<Uint64>() {
    if (pointer != null) {
      handle.value = pointer;
    }
  }

  /// The synthizer instance.
  final Synthizer synthizer;

  /// The handle for this object.
  final Pointer<syz_Handle> handle;

  /// Destroy this object.
  @mustCallSuper
  void destroy() {
    synthizer.check(synthizer.synthizer.syz_handleDecRef(handle.value));
    calloc.free(handle);
    handle.value = 0;
  }

  /// Returns `true` if this object is still valid.
  bool get isValid => handle.value != 0;

  /// Configure delete behaviour for this object.
  void configDeleteBehavior({bool? linger, double? timeout}) {
    synthizer.synthizer
        .syz_initDeleteBehaviorConfig(synthizer.deleteBehaviorConfigPointer);
    if (linger != null) {
      synthizer.deleteBehaviorConfigPointer.ref.linger = linger == true ? 1 : 0;
    }
    if (timeout != null) {
      synthizer.deleteBehaviorConfigPointer.ref.linger_timeout = timeout;
    }
    synthizer.check(synthizer.synthizer.syz_configDeleteBehavior(
        handle.value, synthizer.deleteBehaviorConfigPointer));
  }

  /// Used to compare two objects.
  @override
  bool operator ==(Object other) {
    if (other is! SynthizerObject) {
      return false;
    }
    return other.handle.value == handle.value;
  }

  @override
  int get hashCode => handle.value.hashCode;
}

/// Provides a [gain] property.
mixin GainMixin on SynthizerObject {
  /// Get the gain of this object.
  double get gain => synthizer.getDouble(handle, Properties.gain);

  /// Set the gain of this object.
  set gain(double value) => synthizer.setDouble(handle, Properties.gain, value);
}

/// Base class for anything which can be paused. Adds pause and play methods.
mixin PausableMixin on SynthizerObject {
  /// Pause this object.
  void pause() => synthizer.check(synthizer.synthizer.syz_pause(handle.value));

  /// Play this object.
  void play() => synthizer.check(synthizer.synthizer.syz_play(handle.value));
}