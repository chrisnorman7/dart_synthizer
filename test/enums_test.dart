import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:dart_synthizer/enumerations.dart';
import 'package:test/test.dart';

void main() {
  group('Initialise enums', () {
    test('LogLevel', () {
      expect(logLevelFromSynthizerValue(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR),
          equals(LogLevel.error));
      expect(logLevelFromSynthizerValue(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN),
          equals(LogLevel.warn));
      expect(logLevelFromSynthizerValue(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO),
          equals(LogLevel.info));
      expect(logLevelFromSynthizerValue(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG),
          equals(LogLevel.debug));
      expect(() => logLevelFromSynthizerValue(1234),
          throwsA(TypeMatcher<Exception>()));
    });
  });

  group('Convert enums to integers', () {
    test('LogLevel enum', () {
      expect(LogLevel.debug.synthizerValue,
          equals(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_DEBUG));
      expect(LogLevel.error.synthizerValue,
          equals(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_ERROR));
      expect(LogLevel.info.synthizerValue,
          equals(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_INFO));
      expect(LogLevel.warn.synthizerValue,
          equals(SYZ_LOG_LEVEL.SYZ_LOG_LEVEL_WARN));
    });
  });
}
