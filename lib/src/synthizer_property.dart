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
class _SynthizerPropertyBase<T> {
  /// Create the property.
  const _SynthizerPropertyBase({
    required this.synthizer,
    required this.targetHandle,
    required this.property,
  });

  /// The synthizer instance to work with.
  final Synthizer synthizer;

  /// The target of this property.
  final Pointer<syz_Handle> targetHandle;

  /// The property to get.
  final Properties property;

  @override
  String toString() => '$runtimeType<$property>';
}

/// A synthizer property.
abstract class SynthizerProperty<T> extends _SynthizerPropertyBase<T> {
  /// Create an instance.
  const SynthizerProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  /// Get the value of this property.
  T get value;

  /// Set the value for this property.
  set value(final T value);
}

/// A property that can be automated.
abstract class AutomatableSynthizerProperty<T> extends SynthizerProperty<T> {
  /// Create an instance.
  AutomatableSynthizerProperty({
    required this.context,
    required super.targetHandle,
    required super.property,
  }) : super(synthizer: context.synthizer);

  /// The context to use.
  final Context context;

  /// Clear this property.
  void clear({final double? time}) => AutomationBatch(context)
    ..clearProperty(
      targetHandle,
      time ?? context.currentTime.value,
      property,
    )
    ..execute()
    ..destroy();

  /// Automate this property.
  void automate({
    required final double startTime,
    required final T startValue,
    required final double endTime,
    required final T endValue,
  });
}

/// An integer property.
class SynthizerIntProperty extends SynthizerProperty<int> {
  /// Create an instance.
  const SynthizerIntProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  @override
  int get value {
    synthizer.check(
      synthizer.synthizer.syz_getI(
        synthizer.intPointer,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return synthizer.intPointer.value;
  }

  @override
  set value(final int value) => synthizer.check(
        synthizer.synthizer
            .syz_setI(targetHandle.value, property.toInt(), value),
      );
}

/// A boolean property.
class SynthizerBoolProperty extends SynthizerProperty<bool> {
  /// Create an instance.
  const SynthizerBoolProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  @override
  bool get value {
    synthizer.check(
      synthizer.synthizer.syz_getI(
        synthizer.intPointer,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return synthizer.intPointer.value == 1;
  }

  @override
  set value(final bool value) => synthizer.check(
        synthizer.synthizer.syz_setI(
          targetHandle.value,
          property.toInt(),
          value == true ? 1 : 0,
        ),
      );
}

/// A double property that cannot be automated.
class SynthizerDoubleProperty extends SynthizerProperty<double> {
  /// Create an instance.
  const SynthizerDoubleProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  @override
  double get value {
    synthizer.check(
      synthizer.synthizer.syz_getD(
        synthizer.doublePointer,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return synthizer.doublePointer.value;
  }

  @override
  set value(final double value) => synthizer.check(
        synthizer.synthizer
            .syz_setD(targetHandle.value, property.toInt(), value),
      );
}

/// A double property that can be automated.
class SynthizerAutomatableDoubleProperty
    extends AutomatableSynthizerProperty<double> {
  /// Create an instance.
  SynthizerAutomatableDoubleProperty({
    required super.context,
    required super.targetHandle,
    required super.property,
  });

  @override
  double get value {
    synthizer.check(
      synthizer.synthizer.syz_getD(
        synthizer.doublePointer,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return synthizer.doublePointer.value;
  }

  @override
  set value(final double value) => synthizer.check(
        synthizer.synthizer
            .syz_setD(targetHandle.value, property.toInt(), value),
      );

  /// Automate this property.
  @override
  void automate({
    required final double startTime,
    required final double startValue,
    required final double endTime,
    required final double endValue,
  }) =>
      AutomationBatch(context)
        ..appendDouble(
          targetHandle,
          startTime,
          property,
          startValue,
          interpolationType: InterpolationTypes.none,
        )
        ..appendDouble(targetHandle, endTime, property, endValue)
        ..execute()
        ..destroy();
}

/// A double3 property.
class SynthizerDouble3Property extends AutomatableSynthizerProperty<Double3> {
  /// Create an instance.
  SynthizerDouble3Property({
    required super.context,
    required super.targetHandle,
    required super.property,
  });

  @override
  Double3 get value {
    synthizer.check(
      synthizer.synthizer.syz_getD3(
        synthizer.x1,
        synthizer.y1,
        synthizer.z1,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return Double3(synthizer.x1.value, synthizer.y1.value, synthizer.z1.value);
  }

  @override
  set value(final Double3 value) => synthizer.check(
        synthizer.synthizer.syz_setD3(
          targetHandle.value,
          property.toInt(),
          value.x,
          value.y,
          value.z,
        ),
      );

  /// Automate this property.
  @override
  void automate({
    required final double startTime,
    required final Double3 startValue,
    required final double endTime,
    required final Double3 endValue,
  }) =>
      AutomationBatch(context)
        ..appendDouble3(
          targetHandle,
          startTime,
          property,
          startValue,
          interpolationType: InterpolationTypes.none,
        )
        ..appendDouble3(targetHandle, endTime, property, endValue)
        ..execute()
        ..destroy();
}

/// A double6 property.
class SynthizerDouble6Property extends AutomatableSynthizerProperty<Double6> {
  /// Create an instance.
  SynthizerDouble6Property({
    required super.context,
    required super.targetHandle,
    required super.property,
  });

  @override
  Double6 get value {
    synthizer.check(
      synthizer.synthizer.syz_getD6(
        synthizer.x1,
        synthizer.y1,
        synthizer.z1,
        synthizer.x2,
        synthizer.y2,
        synthizer.z2,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return Double6(
      synthizer.x1.value,
      synthizer.y1.value,
      synthizer.z1.value,
      synthizer.x2.value,
      synthizer.y2.value,
      synthizer.z2.value,
    );
  }

  @override
  set value(final Double6 value) => synthizer.check(
        synthizer.synthizer.syz_setD6(
          targetHandle.value,
          property.toInt(),
          value.x1,
          value.y1,
          value.z1,
          value.x2,
          value.y2,
          value.z2,
        ),
      );

  /// Automate this property.
  @override
  void automate({
    required final double startTime,
    required final Double6 startValue,
    required final double endTime,
    required final Double6 endValue,
  }) =>
      AutomationBatch(context)
        ..appendDouble6(
          targetHandle,
          startTime,
          property,
          startValue,
          interpolationType: InterpolationTypes.none,
        )
        ..appendDouble6(targetHandle, endTime, property, endValue)
        ..execute()
        ..destroy();
}

/// A panner strategy property.
class SynthizerPannerStrategyProperty
    extends SynthizerProperty<PannerStrategy> {
  /// Create an instance.
  SynthizerPannerStrategyProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  @override
  PannerStrategy get value {
    synthizer.check(
      synthizer.synthizer.syz_getI(
        synthizer.intPointer,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return synthizer.intPointer.value.toPannerStrategy();
  }

  @override
  set value(final PannerStrategy value) => synthizer.check(
        synthizer.synthizer.syz_setI(
          targetHandle.value,
          property.toInt(),
          value.toInt(),
        ),
      );
}

/// A distance model property.
class SynthizerDistanceModelProperty extends SynthizerProperty<DistanceModel> {
  /// Create an instance.
  SynthizerDistanceModelProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  @override
  DistanceModel get value {
    synthizer.check(
      synthizer.synthizer.syz_getI(
        synthizer.intPointer,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return synthizer.intPointer.value.toDistanceModel();
  }

  @override
  set value(final DistanceModel value) => synthizer.check(
        synthizer.synthizer.syz_setI(
          targetHandle.value,
          property.toInt(),
          value.toInt(),
        ),
      );
}

/// A noise type property.
class SynthizerNoiseTypeProperty extends SynthizerProperty<NoiseType> {
  /// Create an instance.
  SynthizerNoiseTypeProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  @override
  NoiseType get value {
    synthizer.check(
      synthizer.synthizer.syz_getI(
        synthizer.intPointer,
        targetHandle.value,
        property.toInt(),
      ),
    );
    return synthizer.intPointer.value.toNoiseType();
  }

  @override
  set value(final NoiseType value) => synthizer.check(
        synthizer.synthizer.syz_setI(
          targetHandle.value,
          property.toInt(),
          value.toInt(),
        ),
      );
}

/// A biquad config property.
class SynthizerBiquadConfigProperty extends SynthizerProperty<BiquadConfig> {
  /// Create an instance.
  const SynthizerBiquadConfigProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  @override
  set value(final BiquadConfig value) => synthizer.check(
        synthizer.synthizer.syz_setBiquad(
          targetHandle.value,
          property.toInt(),
          value.config,
        ),
      );

  @override
  BiquadConfig get value =>
      throw UnsupportedError('You cannot get biquad values.');
}

/// An object property.
class SynthizerObjectProperty extends SynthizerProperty<SynthizerObject> {
  /// Create an instance.
  SynthizerObjectProperty({
    required super.synthizer,
    required super.targetHandle,
    required super.property,
  });

  @override
  set value(final SynthizerObject? value) => synthizer.check(
        synthizer.synthizer.syz_setO(
          targetHandle.value,
          property.toInt(),
          value?.handle.value ?? 0,
        ),
      );

  @override
  SynthizerObject get value =>
      throw UnsupportedError('You cannot get synthizer objects.');
}
