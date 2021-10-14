/// Provides the [SynthizerProperty] class.
import 'dart:ffi';

import '../dart_synthizer.dart';
import 'context.dart';
import 'enumerations.dart';
import 'synthizer_bindings.dart';

/// A way of getting, setting, and automating synthizer properties.
abstract class SynthizerProperty<T> {
  /// Create the property.
  const SynthizerProperty(this.context, this.targetHandle, this.property);

  /// The context to work with.
  final Context context;

  /// The target of this property.
  final Pointer<syz_Handle> targetHandle;

  /// The property to get.
  final Properties property;

  /// Get the value of this property.
  T get value;

  /// Set the value for this property.
  set value(T value);

  /// Clear this property.
  void clear(Context context, {double? time}) => AutomationBatch(context)
    ..clearProperty(targetHandle, time ?? context.currentTime, property)
    ..execute()
    ..destroy();

  @override
  String toString() => '$runtimeType<$property>';
}

/// A double property.
class SynthizerDoubleProperty extends SynthizerProperty<double> {
  /// Create an instance.
  const SynthizerDoubleProperty(
      Context context, Pointer<syz_Handle> targetHandle, Properties property)
      : super(context, targetHandle, property);

  @override
  double get value => context.synthizer.getDouble(targetHandle, property);

  @override
  set value(double value) =>
      context.synthizer.setDouble(targetHandle, property, value);

  /// Automate this property.
  void automate(
          {required double startTime,
          required double startValue,
          required double endTime,
          required double endValue}) =>
      AutomationBatch(context)
        ..appendDouble(targetHandle, startTime, property, startValue,
            interpolationType: InterpolationTypes.none)
        ..appendDouble(targetHandle, endTime, property, endValue)
        ..execute()
        ..destroy();
}

/// A double3 property.
class SynthizerDouble3Property extends SynthizerProperty<Double3> {
  /// Create an instance.
  const SynthizerDouble3Property(
      Context context, Pointer<syz_Handle> targetHandle, Properties property)
      : super(context, targetHandle, property);

  @override
  Double3 get value => context.synthizer.getDouble3(targetHandle, property);

  @override
  set value(Double3 value) =>
      context.synthizer.setDouble3(targetHandle, property, value);

  /// Automate this property.
  void automate(
          {required double startTime,
          required Double3 startValue,
          required double endTime,
          required Double3 endValue}) =>
      AutomationBatch(context)
        ..appendDouble3(targetHandle, startTime, property, startValue,
            interpolationType: InterpolationTypes.none)
        ..appendDouble3(targetHandle, endTime, property, endValue)
        ..execute()
        ..destroy();
}

/// A double6 property.
class SynthizerDouble6Property extends SynthizerProperty<Double6> {
  /// Create an instance.
  const SynthizerDouble6Property(
      Context context, Pointer<syz_Handle> targetHandle, Properties property)
      : super(context, targetHandle, property);

  @override
  Double6 get value => context.synthizer.getDouble6(targetHandle, property);

  @override
  set value(Double6 value) =>
      context.synthizer.setDouble6(targetHandle, property, value);

  /// Automate this property.
  void automate(
          {required double startTime,
          required Double6 startValue,
          required double endTime,
          required Double6 endValue}) =>
      AutomationBatch(context)
        ..appendDouble6(targetHandle, startTime, property, startValue,
            interpolationType: InterpolationTypes.none)
        ..appendDouble6(targetHandle, endTime, property, endValue)
        ..execute()
        ..destroy();
}
