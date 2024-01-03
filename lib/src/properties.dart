import 'package:quiver/core.dart';

import 'context.dart';
import 'source.dart';

/// A double3 property.
///
/// Instances of this class are currently used by [Context.position], and
/// [Source3D.position].
class Double3 {
  /// Create an instance.
  const Double3(this.x, this.y, this.z);

  /// The values of this property.
  final double x, y, z;

  /// Compare two objects.
  @override
  bool operator ==(final Object other) =>
      other is Double3 && other.x == x && other.y == y && other.z == z;

  /// Return a hash of this object.
  @override
  int get hashCode => hash3(x, y, z);
}

/// A double6 property.
///
/// Currently only used by [Context.orientation].
class Double6 {
  /// Create an instance.
  const Double6(this.x1, this.y1, this.z1, this.x2, this.y2, this.z2);

  /// The values for this property.
  final double x1, y1, z1, x2, y2, z2;

  /// Compare two objects.
  @override
  bool operator ==(final Object other) =>
      other is Double6 &&
      other.x1 == x1 &&
      other.y1 == y1 &&
      other.z1 == z1 &&
      other.x2 == x2 &&
      other.y2 == y2 &&
      other.z2 == z2;

  /// Return a hash of this object.
  @override
  int get hashCode => hashObjects(<double>[x1, y1, z1, x2, y2, z2]);
}
