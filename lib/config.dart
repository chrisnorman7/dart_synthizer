/// Provides the [SynthizerConfig] class.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'enumerations.dart';
import 'error.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// Synthizer config.
class SynthizerConfig {
  /// Create an instance.
  SynthizerConfig(this.synthizer) : pointer = calloc<syz_LibraryConfig>();

  /// Load defaults from Synthizer.
  void loadDefaults() =>
      synthizer.synthizer.syz_libraryConfigSetDefaults(pointer);

  /// The synthizer object to use.
  final Synthizer synthizer;

  /// The pointer to the config object.
  final Pointer<syz_LibraryConfig> pointer;

  /// Get the log level.
  LogLevel get logLevel {
    switch (pointer.ref.log_level) {
      case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR:
        return LogLevel.error;
      case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN:
        return LogLevel.warn;
      case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO:
        return LogLevel.info;
      case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG:
        return LogLevel.debug;
      default:
        throw SynthizerError('Unhandled log level.', pointer.ref.log_level);
    }
  }

  /// Set the log level.
  set logLevel(LogLevel value) {
    final int level;
    switch (value) {
      case LogLevel.error:
        level = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR;
        break;
      case LogLevel.warn:
        level = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN;
        break;
      case LogLevel.info:
        level = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO;
        break;
      case LogLevel.debug:
        level = SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG;
        break;
    }
    pointer.ref.log_level = level;
  }

  /// Get the logging backend.
  LoggingBackend get loggingBackend {
    switch (pointer.ref.logging_backend) {
      case SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_NONE:
        return LoggingBackend.none;
      case SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_STDERR:
        return LoggingBackend.stderr;
      default:
        throw SynthizerError(
            'Unknown logging backend.', pointer.ref.logging_backend);
    }
  }

  /// Set the logging backend.
  set loggingBackend(LoggingBackend value) {
    final int backend;
    switch (value) {
      case LoggingBackend.none:
        backend = SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_NONE;
        break;
      case LoggingBackend.stderr:
        backend = SYZ_LOGGING_BACKEND.SYZ_LOGGING_BACKEND_STDERR;
        break;
    }
    pointer.ref.logging_backend = backend;
  }

  /// Get the library path for libsndfile (if any).
  String? get libsndfilePath =>
      pointer.ref.libsndfile_path.cast<Utf8>().toDartString();

  /// Set the path for libsndfile.
  ///
  /// If [value] is `null`, then libsndfile will not be loaded.
  set libsndfilePath(String? value) {
    {
      if (value == null) {
        pointer.ref.libsndfile_path = nullptr;
      } else {
        pointer.ref.libsndfile_path = value.toNativeUtf8().cast<Int8>();
      }
    }
  }
}
