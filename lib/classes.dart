/// Provides various classes for use with Synthizer.
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

import 'automation_point.dart';
import 'enumerations.dart';
import 'synthizer.dart';

/// The base class for all synthizer objects.
class SynthizerObject {
  /// Create an instance.
  SynthizerObject(this.synthizer, {Pointer<Uint64>? pointer})
      : handle = pointer ?? calloc<Uint64>();

  /// The synthizer instance.
  final Synthizer synthizer;

  /// The handle for this object.
  final Pointer<Uint64> handle;

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

  /// Set an automation timeline.
  void setAutomation(Properties property, List<AutomationPoint> points) {
    final timeline = synthizer.createAutomationTimeline(points);
    synthizer.check(synthizer.synthizer.syz_automationSetTimeline(
        handle.value, synthizer.propertyToInt(property), timeline));
  }

  /// Clear automation timeline.
  void clearAutomation(Properties property) => synthizer.check(synthizer
      .synthizer
      .syz_automationClear(handle.value, synthizer.propertyToInt(property)));
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
