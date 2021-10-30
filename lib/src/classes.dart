/// Provides various classes for use with Synthizer.
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

import 'enumerations.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';
import 'synthizer_property.dart';

/// The base class for all synthizer objects.
class SynthizerObject {
  /// Create an instance.
  SynthizerObject(this.synthizer, {int? pointer})
      : handle = calloc<syz_Handle>() {
    if (pointer != null) {
      handle.value = pointer;
    }
  }

  /// The synthizer instance.
  final Synthizer synthizer;

  /// The handle for this object.
  late final Pointer<syz_Handle> handle;

  /// The current Synthizer time.
  SynthizerDoubleProperty get currentTime =>
      SynthizerDoubleProperty(synthizer, handle, Properties.currentTime);

  /// The suggested automation time.
  SynthizerDoubleProperty get suggestedAutomationTime =>
      SynthizerDoubleProperty(
          synthizer, handle, Properties.suggestedAutomationTime);

  /// Returns `true` if this object is still valid.
  bool get isValid => handle.value != 0;

  /// Increase the reference count.
  void increaseReferenceCount() => synthizer.incRef(handle.value);

  /// Decrease the reference count.
  void decreaseReferenceCount() => synthizer.decRef(handle.value);

  /// Destroy this object.
  @mustCallSuper
  void destroy() {
    decreaseReferenceCount();
    calloc.free(handle);
    handle.value = 0;
  }

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

/// Add gain to any [SynthizerObject].
mixin GainMixin on SynthizerObject {
  /// The gain for this object.
  SynthizerDoubleProperty get gain =>
      SynthizerDoubleProperty(synthizer, handle, Properties.gain);
}

/// Base class for anything which can be paused. Adds pause and play methods.
mixin PausableMixin on SynthizerObject {
  /// Pause this object.
  void pause() => synthizer.check(synthizer.synthizer.syz_pause(handle.value));

  /// Play this object.
  void play() => synthizer.check(synthizer.synthizer.syz_play(handle.value));
}

/// Add playback position to any object.
mixin PlaybackPosition on SynthizerObject {
  /// The playback position for this object.
  SynthizerDoubleProperty get playbackPosition =>
      SynthizerDoubleProperty(synthizer, handle, Properties.playbackPosition);
}
