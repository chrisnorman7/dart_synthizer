// ignore_for_file: avoid_print
import 'dart:io';

import 'package:dart_style/dart_style.dart';

/// A member of a [SynthizerEnum].
class SynthizerEnumMember {
  /// Create an instance.
  SynthizerEnumMember({
    required this.dartName,
    required this.synthizerName,
    required this.value,
  });

  /// The Dart name for this member.
  final String dartName;

  /// The name of the Synthizer member.
  final String synthizerName;

  /// The Synthizer value for this member.
  final String value;

  /// Get the fully qualified synthizer member name.
  String getSynthizerMemberName(final SynthizerEnum e) =>
      '${e.synthizerName}.SYZ_$synthizerName';

  /// Get the fully qualified Dart member name.
  String getDartMemberName(final SynthizerEnum e) => '${e.dartName}.$dartName';
}

/// An enum to be written to disk.
class SynthizerEnum {
  /// Create an instance.
  SynthizerEnum(this.name) : members = <SynthizerEnumMember>[];

  /// The truncated name of this enum.
  final String name;

  /// The Synthizer name of this enum.
  String get synthizerName => 'SYZ_$name';

  /// The Dart name for this enum.
  String get dartName => getDartName(name, capitaliseFirst: true);

  /// All the members of this enum.
  final List<SynthizerEnumMember> members;
}

String getDartName(
  final String synthizerName, {
  final bool capitaliseFirst = false,
}) {
  final names = [
    for (final name in synthizerName.split('_'))
      name[0].toUpperCase() + name.substring(1).toLowerCase(),
  ];
  if (capitaliseFirst == false) {
    names[0] = names[0].toLowerCase();
  }
  return names.join();
}

/// Generate `enumerations.dart`.
Future<void> main() async {
  final prefixes = {
    'OBJECT_TYPE': 'OTYPE',
    'PROPERTIES': 'P',
    'EVENT_TYPES': 'EVENT_TYPE',
    'INTERPOLATION_TYPES': 'INTERPOLATION_TYPE',
    'AUTOMATION_COMMANDS': 'AUTOMATION_COMMAND',
  };
  final enums = <SynthizerEnum>[];
  final bindings = File('lib/src/synthizer_bindings.dart');
  final classNamePattern = RegExp(r'^abstract class SYZ_([^ ]+) [{]$');
  final classMemberPattern = RegExp(
    r'^  static const int SYZ_([^ ]+) = ([^;]+);$',
  );
  SynthizerEnum? currentEnum;
  for (final line in await bindings.readAsLines()) {
    if (currentEnum == null) {
      final match = classNamePattern.firstMatch(line);
      if (match != null) {
        currentEnum = SynthizerEnum(match.group(1)!);
        print('Found class ${currentEnum.synthizerName}.');
      }
    } else if (line.startsWith('}')) {
      enums.add(currentEnum);
      currentEnum = null;
    } else {
      final match = classMemberPattern.firstMatch(line);
      if (match != null) {
        final memberName = match.group(1)!;
        final memberValue = match.group(2)!;
        var dartMemberName = memberName;
        if (dartMemberName.startsWith(currentEnum.name)) {
          dartMemberName =
              dartMemberName.substring(currentEnum.name.length + 1);
        }
        final prefix = prefixes[currentEnum.name];
        if (prefix != null) {
          dartMemberName = dartMemberName.substring(prefix.length + 1);
        }
        currentEnum.members.add(
          SynthizerEnumMember(
            dartName: getDartName(dartMemberName),
            synthizerName: memberName,
            value: memberValue,
          ),
        );
      }
    }
  }
  final buffer = StringBuffer()
    ..writeln("import 'synthizer_bindings.dart';")
    ..writeln("import 'synthizer_error.dart';");
  for (final e in enums) {
    buffer
      ..writeln('/// ${e.synthizerName}.')
      ..writeln('enum ${e.dartName} {');
    for (final m in e.members) {
      buffer
        ..writeln('/// SYZ_${m.synthizerName} = ${m.value}')
        ..writeln('${m.dartName},');
    }
    buffer
      ..writeln('}')
      ..writeln('/// An extension for converting Dart to Synthizer values.')
      ..writeln('extension ${e.dartName}ToInt on ${e.dartName} {')
      ..writeln('/// Return an integer.')
      ..writeln('int toInt() {')
      ..writeln('switch (this) {');
    for (final m in e.members) {
      buffer
        ..writeln('case ${m.getDartMemberName(e)}: ')
        ..writeln('return ${m.getSynthizerMemberName(e)};');
    }
    buffer.writeln('}}}');
  }
  buffer
    ..writeln('/// An extension for converting integers to Dart values.')
    ..writeln('extension IntToSynthizer on int {');
  for (final e in enums) {
    buffer
      ..writeln('/// Convert from a [${e.synthizerName}] member.')
      ..writeln('${e.dartName} to${e.dartName}() {')
      ..writeln('switch(this) {');
    for (final m in e.members) {
      buffer
        ..writeln('case ${m.getSynthizerMemberName(e)}:')
        ..writeln('return ${m.getDartMemberName(e)};');
    }
    buffer
      ..writeln('default:')
      ..writeln('throw SynthizerError(')
      ..writeln("'Unrecognised `${e.synthizerName}` member.', this,);")
      ..writeln('}}');
  }
  buffer.writeln('}');
  final formatter = DartFormatter();
  File('lib/src/enumerations.dart')
      .writeAsStringSync(formatter.format(buffer.toString()));
  print('Done.');
}
