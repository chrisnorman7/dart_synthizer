/// Provides the [AutomationPoint] class.
import 'enumerations.dart';

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
