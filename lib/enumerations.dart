/// Provides Synthizer enumerations.
import 'synthizer_bindings.dart';

/// The log level enum.
enum LogLevel { error, warn, info, debug }

/// Get an enum value from the provided int.
LogLevel logLevelFromSynthizerValue(int value) {
  switch (value) {
    case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR:
      return LogLevel.error;
    case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN:
      return LogLevel.warn;
    case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO:
      return LogLevel.info;
    case SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG:
      return LogLevel.debug;
    default:
      throw Exception('Value not found.');
  }
}

extension CValues on LogLevel {
  /// Get a c-friendly value.
  int get synthizerValue {
    switch (this) {
      case LogLevel.error:
        return SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR;
      case LogLevel.warn:
        return SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN;
      case LogLevel.info:
        return SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO;
      case LogLevel.debug:
        return SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG;
    }
  }
}
