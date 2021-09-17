/// Provides the [AutomationPoint] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'enumerations.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// A point in an automation timeline.
class AutomationPoint {
  /// Create an instance.
  AutomationPoint(this.time, this.value,
      {this.interpolationType = InterpolationTypes.linear});

  /// The interpolation type to use.
  final InterpolationTypes interpolationType;

  /// The time at which this point sits on the timeline.
  final double time;

  /// The value of this point.
  final double value;
}

/// An automation timeline.
class AutomationTimeline extends SynthizerObject {
  /// Create an instance.
  AutomationTimeline(Synthizer synthizer, List<AutomationPoint> points)
      : super(synthizer) {
    final a = malloc<syz_AutomationPoint>(points.length);
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final int interpolationType;
      switch (point.interpolationType) {
        case InterpolationTypes.none:
          interpolationType =
              SYZ_INTERPOLATION_TYPES.SYZ_INTERPOLATION_TYPE_NONE;
          break;
        case InterpolationTypes.linear:
          interpolationType =
              SYZ_INTERPOLATION_TYPES.SYZ_INTERPOLATION_TYPE_LINEAR;
          break;
      }
      a[i]
        ..automation_time = point.time
        ..interpolation_type = interpolationType
        ..values[0] = point.value;
    }
    synthizer.check(synthizer.synthizer.syz_createAutomationTimeline(handle,
        points.length, a, 0, nullptr, synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle.
  AutomationTimeline.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);
}
