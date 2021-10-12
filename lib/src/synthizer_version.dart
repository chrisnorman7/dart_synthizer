/// Provides the [SynthizerVersion] class.

/// A class which represents the version of Synthizer being used.
class SynthizerVersion {
  /// Create an instance.
  const SynthizerVersion(this.major, this.minor, this.patch);

  /// The major version number.
  final int major;

  /// The minor version number.
  final int minor;

  /// The patch level.
  final int patch;

  /// Return [major].[minor].[patch].
  @override
  String toString() => '$major.$minor.$patch';
}
