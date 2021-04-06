/// Provides utility classes and methods.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'error.dart';
import 'synthizer_bindings.dart';

/// A double3.
class Double3 {
  final double x;
  final double y;
  final double z;

  const Double3(this.x, this.y, this.z);
}

/// A double6.
class Double6 {
  final double x1;
  final double y1;
  final double z1;
  final double x2;
  final double y2;
  final double z2;

  const Double6(this.x1, this.y1, this.z1, this.x2, this.y2, this.z2);
}

/// Check if a returned value is an error.
void check(Synthizer syz, int value) {
  if (value != 0) {
    throw SynthizerError.fromLib(syz);
  }
}

/// A class for getting and setting the value of properties.
class PropertyStore {
  /// The handle used for all calls to [getDouble] and [setDouble].
  static final Pointer<Double> _doublePointer = calloc<Double>();

  /// The handles used by [getDouble3].
  static final Pointer<Double> x1 = calloc<Double>();
  static final Pointer<Double> y1 = calloc<Double>();
  static final Pointer<Double> z1 = calloc<Double>();

  /// The extra handles used by double6.
  static final Pointer<Double> x2 = calloc<Double>();
  static final Pointer<Double> y2 = calloc<Double>();
  static final Pointer<Double> z2 = calloc<Double>();

  /// Get a double property.
  static double getDouble(
      Synthizer synthizer, Pointer<Uint64> handle, int property) {
    check(
        synthizer, synthizer.syz_getD(_doublePointer, handle.value, property));
    return _doublePointer.value;
  }

  /// Set a double property.
  static void setDouble(Synthizer synthizer, Pointer<Uint64> handle,
          int property, double value) =>
      check(synthizer, synthizer.syz_setD(handle.value, property, value));

  /// Get a double3 property.
  static Double3 getDouble3(
      Synthizer synthizer, Pointer<Uint64> handle, int property) {
    check(synthizer, synthizer.syz_getD3(x1, y1, z1, handle.value, property));
    return Double3(x1.value, y1.value, z1.value);
  }

  /// Set a double3 property.
  static void setDouble3(Synthizer synthizer, Pointer<Uint64> handle,
          int property, Double3 value) =>
      check(
          synthizer,
          synthizer.syz_setD3(
              handle.value, property, value.x, value.y, value.z));

  /// Get a double6 property.
  static Double6 getDouble6(
      Synthizer synthizer, Pointer<Uint64> handle, int property) {
    check(synthizer,
        synthizer.syz_getD6(x1, y1, z1, x2, y2, z2, handle.value, property));
    return Double6(x1.value, y1.value, z1.value, x2.value, y2.value, z2.value);
  }

  /// Set a double6 property.
  static void setDouble6(Synthizer synthizer, Pointer<Uint64> handle,
          int property, Double6 value) =>
      check(
          synthizer,
          synthizer.syz_setD6(handle.value, property, value.x1, value.y1,
              value.z1, value.x2, value.y2, value.z2));
}
