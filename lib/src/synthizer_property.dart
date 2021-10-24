/// Provides the [SynthizerProperty] class.
import 'dart:ffi';

import 'automation.dart';
import 'biquad.dart';
import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'properties.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// A way of getting, setting, and automating synthizer properties.
abstract class SynthizerProperty<T> {
  /// Create the property.
  const SynthizerProperty(this.synthizer, this.targetHandle, this.property);

  /// The synthizer instance this property works with.
  final Synthizer synthizer;

  /// The target of this property.
  final Pointer<syz_Handle> targetHandle;

  /// The property to get.
  final Properties property;

  /// Get the value of this property.
  T get value =>
      throw UnsupportedError('You cannot get the value of this property.');

  /// Set the value for this property.
  set value(T value) =>
      throw UnsupportedError('You cannot set the value of this property.');

  /// Clear this property.
  void clear(Context context, {double? time}) => AutomationBatch(context)
    ..clearProperty(targetHandle, time ?? context.currentTime.value, property)
    ..execute()
    ..destroy();

  /// Automate this property.
  void automate(Context context,
      {required double startTime,
      required T startValue,
      required double endTime,
      required T endValue}) {
    throw UnsupportedError('This property cannot be automated.');
  }

  @override
  String toString() => '$runtimeType<$property>';
}

/// An integer property.
class SynthizerIntProperty extends SynthizerProperty<int> {
  /// Create an instance.
  SynthizerIntProperty(Synthizer synthizer, Pointer<syz_Handle> targetHandle,
      Properties property)
      : super(synthizer, targetHandle, property);

  @override
  int get value {
    synthizer.check(synthizer.synthizer
        .syz_getI(synthizer.intPointer, targetHandle.value, property.toInt()));
    return synthizer.intPointer.value;
  }

  @override
  set value(int value) => synthizer.check(synthizer.synthizer
      .syz_setI(targetHandle.value, property.toInt(), value));
}

/// A boolean property.
class SynthizerBoolProperty extends SynthizerProperty<bool> {
  /// Create an instance.
  SynthizerBoolProperty(Synthizer synthizer, Pointer<syz_Handle> targetHandle,
      Properties property)
      : super(synthizer, targetHandle, property);

  @override
  bool get value {
    synthizer.check(synthizer.synthizer
        .syz_getI(synthizer.intPointer, targetHandle.value, property.toInt()));
    return synthizer.intPointer.value == 1;
  }

  @override
  set value(bool value) => synthizer.check(synthizer.synthizer
      .syz_setI(targetHandle.value, property.toInt(), value == true ? 1 : 0));
}

/// A double property.
class SynthizerDoubleProperty extends SynthizerProperty<double> {
  /// Create an instance.
  const SynthizerDoubleProperty(Synthizer synthizer,
      Pointer<syz_Handle> targetHandle, Properties property)
      : super(synthizer, targetHandle, property);

  @override
  double get value {
    synthizer.check(synthizer.synthizer.syz_getD(
        synthizer.doublePointer, targetHandle.value, property.toInt()));
    return synthizer.doublePointer.value;
  }

  @override
  set value(double value) => synthizer.check(synthizer.synthizer
      .syz_setD(targetHandle.value, property.toInt(), value));

  /// Automate this property.
  @override
  void automate(Context context,
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
  const SynthizerDouble3Property(Synthizer synthizer,
      Pointer<syz_Handle> targetHandle, Properties property)
      : super(synthizer, targetHandle, property);

  @override
  Double3 get value {
    synthizer.check(synthizer.synthizer.syz_getD3(synthizer.x1, synthizer.y1,
        synthizer.z1, targetHandle.value, property.toInt()));
    return Double3(synthizer.x1.value, synthizer.y1.value, synthizer.z1.value);
  }

  @override
  set value(Double3 value) => synthizer.check(synthizer.synthizer.syz_setD3(
      targetHandle.value, property.toInt(), value.x, value.y, value.z));

  /// Automate this property.
  @override
  void automate(Context context,
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
  const SynthizerDouble6Property(Synthizer synthizer,
      Pointer<syz_Handle> targetHandle, Properties property)
      : super(synthizer, targetHandle, property);

  @override
  Double6 get value {
    synthizer.check(synthizer.synthizer.syz_getD6(
        synthizer.x1,
        synthizer.y1,
        synthizer.z1,
        synthizer.x2,
        synthizer.y2,
        synthizer.z2,
        targetHandle.value,
        property.toInt()));
    return Double6(synthizer.x1.value, synthizer.y1.value, synthizer.z1.value,
        synthizer.x2.value, synthizer.y2.value, synthizer.z2.value);
  }

  @override
  set value(Double6 value) => synthizer.check(synthizer.synthizer.syz_setD6(
      targetHandle.value,
      property.toInt(),
      value.x1,
      value.y1,
      value.z1,
      value.x2,
      value.y2,
      value.z2));

  /// Automate this property.
  @override
  void automate(Context context,
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

/// A panner strategy property.
class SynthizerPannerStrategyProperty
    extends SynthizerProperty<PannerStrategy> {
  /// Create an instance.
  SynthizerPannerStrategyProperty(Synthizer synthizer,
      Pointer<syz_Handle> targetHandle, Properties property)
      : super(synthizer, targetHandle, property);

  @override
  PannerStrategy get value {
    synthizer.check(synthizer.synthizer
        .syz_getI(synthizer.intPointer, targetHandle.value, property.toInt()));
    return synthizer.intPointer.value.toPannerStrategy();
  }

  @override
  set value(PannerStrategy value) => synthizer.check(synthizer.synthizer
      .syz_setI(targetHandle.value, property.toInt(), value.toInt()));
}

/// A distance model property.
class SynthizerDistanceModelProperty extends SynthizerProperty<DistanceModel> {
  /// Create an instance.
  SynthizerDistanceModelProperty(Synthizer synthizer,
      Pointer<syz_Handle> targetHandle, Properties property)
      : super(synthizer, targetHandle, property);

  @override
  DistanceModel get value {
    synthizer.check(synthizer.synthizer
        .syz_getI(synthizer.intPointer, targetHandle.value, property.toInt()));
    return synthizer.intPointer.value.toDistanceModel();
  }

  @override
  set value(DistanceModel value) => synthizer.check(synthizer.synthizer
      .syz_setI(targetHandle.value, property.toInt(), value.toInt()));
}

/// A noise type property.
class SynthizerNoiseTypeProperty extends SynthizerProperty<NoiseType> {
  /// Create an instance.
  SynthizerNoiseTypeProperty(Synthizer synthizer,
      Pointer<syz_Handle> targetHandle, Properties property)
      : super(synthizer, targetHandle, property);

  @override
  NoiseType get value {
    synthizer.check(synthizer.synthizer
        .syz_getI(synthizer.intPointer, targetHandle.value, property.toInt()));
    return synthizer.intPointer.value.toNoiseType();
  }

  @override
  set value(NoiseType value) => synthizer.check(synthizer.synthizer
      .syz_setI(targetHandle.value, property.toInt(), value.toInt()));
}

/// A biquad config property.
class SynthizerBiquadConfigProperty extends SynthizerProperty<BiquadConfig> {
  /// Create an instance.
  SynthizerBiquadConfigProperty(Synthizer synthizer,
      Pointer<syz_Handle> targetHandle, Properties property)
      : super(synthizer, targetHandle, property);

  @override
  set value(BiquadConfig value) => synthizer.check(synthizer.synthizer
      .syz_setBiquad(targetHandle.value, property.toInt(), value.config));
}

/// An object property.
class SynthizerObjectProperty extends SynthizerProperty<SynthizerObject> {
  /// Create an instance.
  SynthizerObjectProperty(Synthizer synthizer, Pointer<syz_Handle> targetHandle,
      Properties property)
      : super(synthizer, targetHandle, property);

  @override
  set value(SynthizerObject? value) =>
      synthizer.check(synthizer.synthizer.syz_setO(
          targetHandle.value, property.toInt(), value?.handle.value ?? 0));
}
