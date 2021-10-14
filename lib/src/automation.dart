/// Provides classes relating to automation.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'error.dart';
import 'properties.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// The base class for all automation commands.
abstract class _AutomationCommand {
  /// Create an instance.
  const _AutomationCommand(this.targetHandle, this.time, this.type);

  /// The handle of the target this command should work with.
  final Pointer<syz_Handle> targetHandle;

  /// The time this command should run.
  final double time;

  /// The type of command.
  final AutomationCommands type;
}

/// syz_AutomationAppendPropertyCommand.
class _AutomationAppendPropertyCommand extends _AutomationCommand {
  /// Create an instance.
  const _AutomationAppendPropertyCommand(
      Pointer<syz_Handle> targetHandle, double time, this.property, this.value,
      {this.interpolationType = InterpolationTypes.linear})
      : super(targetHandle, time, AutomationCommands.appendProperty);

  /// The property to change.
  final Properties property;

  /// The value of this point.
  ///
  /// Unfortunately, until such time as we have unions in Dart, we have to make
  /// this value dynamic.
  ///
  /// Values have the following meanings:
  ///
  /// * Double values work as you would expect.
  /// * [Double3] and [Double6] values will be broken up.
  final dynamic value;

  /// The interpolation type to use.
  final InterpolationTypes interpolationType;
}

/// syz_AutomationSendUserEventCommand
class _AutomationSendUserEventCommand extends _AutomationCommand {
  /// Create an instance.
  const _AutomationSendUserEventCommand(
      Pointer<syz_Handle> targetHandle, double time, this.param)
      : super(targetHandle, time, AutomationCommands.sendUserEvent);

  /// The param to use.
  final int param;
}

/// syz_AutomationClearPropertyCommand.
class _AutomationClearPropertyCommand extends _AutomationCommand {
  /// Create an instance.
  const _AutomationClearPropertyCommand(
      Pointer<syz_Handle> targetHandle, double time, this.property)
      : super(targetHandle, time, AutomationCommands.clearProperty);

  /// The property to clear.
  final Properties property;
}

/// SYZ_AUTOMATION_COMMAND_CLEAR_EVENTS.
class _AutomationClearEventsCommand extends _AutomationCommand {
  /// Create an instance.
  const _AutomationClearEventsCommand(
      Pointer<syz_Handle> targetHandle, double time)
      : super(targetHandle, time, AutomationCommands.clearEvents);
}

/// SYZ_AUTOMATION_COMMAND_CLEAR_ALL_PROPERTIES.
class _AutomationClearAllPropertiesCommand extends _AutomationCommand {
  /// Create an instance.
  const _AutomationClearAllPropertiesCommand(
      Pointer<syz_Handle> targetHandle, double time)
      : super(targetHandle, time, AutomationCommands.clearAllProperties);
}

/// Automation batch.
class AutomationBatch extends SynthizerObject {
  /// Create an instance.
  AutomationBatch(Context context)
      : _commands = [],
        super(context.synthizer) {
    synthizer.check(synthizer.synthizer.syz_createAutomationBatch(handle,
        context.handle.value, nullptr, synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle.
  AutomationBatch.fromHandle(Synthizer synthizer, int pointer)
      : _commands = [],
        super(synthizer, pointer: pointer);

  /// The commands for this batch.
  final List<_AutomationCommand> _commands;

  /// Append a double value.
  void appendDouble(Pointer<syz_Handle> targetHandle, double time,
          Properties property, double value,
          {InterpolationTypes interpolationType = InterpolationTypes.linear}) =>
      _commands.add(_AutomationAppendPropertyCommand(
          targetHandle, time, property, value,
          interpolationType: interpolationType));

  /// Append a double3 value.
  void appendDouble3(Pointer<syz_Handle> targetHandle, double time,
          Properties property, Double3 value,
          {InterpolationTypes interpolationType = InterpolationTypes.linear}) =>
      _commands.add(_AutomationAppendPropertyCommand(
          targetHandle, time, property, value,
          interpolationType: interpolationType));

  /// Append a double6 value.
  void appendDouble6(Pointer<syz_Handle> targetHandle, double time,
          Properties property, Double6 value,
          {InterpolationTypes interpolationType = InterpolationTypes.linear}) =>
      _commands.add(_AutomationAppendPropertyCommand(
          targetHandle, time, property, value,
          interpolationType: interpolationType));

  /// Clear a property.
  void clearProperty(
          Pointer<syz_Handle> targetHandle, double time, Properties property) =>
      _commands
          .add(_AutomationClearPropertyCommand(targetHandle, time, property));

  /// Clear all properties.
  void clearAllProperties(Pointer<syz_Handle> targetHandle, double time) =>
      _commands.add(_AutomationClearAllPropertiesCommand(targetHandle, time));

  /// Send a user event.
  void sendUserEvent(
          Pointer<syz_Handle> targetHandle, double time, int event) =>
      _commands.add(_AutomationSendUserEventCommand(targetHandle, time, event));

  /// Clear all events.
  void clearEvents(Pointer<syz_Handle> targetHandle, double time) =>
      _commands.add(_AutomationClearEventsCommand(targetHandle, time));

  /// Execute this batch.
  void execute() {
    final a = malloc<syz_AutomationCommand>(_commands.length);
    for (var i = 0; i < _commands.length; i++) {
      final command = _commands[i];
      final ref = a[i]
        ..time = command.time
        ..target = command.targetHandle.value
        ..type = command.type.toInt();
      if (command is _AutomationAppendPropertyCommand) {
        final append = ref.params.append_to_property
          ..property = command.property.toInt();
        append.point
          ..interpolation_type = command.interpolationType.toInt()
          ..flags = 0;
        final dynamic value = command.value;
        if (value is double) {
          append.point.values[0] = value;
        } else if (value is Double3) {
          append.point.values[0] = value.x;
          append.point.values[1] = value.y;
          append.point.values[2] = value.z;
        } else if (value is Double6) {
          append.point.values[0] = value.x1;
          append.point.values[1] = value.y1;
          append.point.values[2] = value.z1;
          append.point.values[3] = value.x2;
          append.point.values[4] = value.y2;
          append.point.values[5] = value.z2;
        } else {
          throw SynthizerError(
              'Invalid point type ${value.runtimeType}: $value.', -1);
        }
      } else if (command is _AutomationClearPropertyCommand) {
        ref.params.clear_property.property = command.property.toInt();
      } else if (command is _AutomationSendUserEventCommand) {
        ref.params.send_user_event.param = command.param;
      }
    }
    synthizer.check(synthizer.synthizer
        .syz_automationBatchAddCommands(handle.value, _commands.length, a));
    malloc.free(a);
    synthizer
        .check(synthizer.synthizer.syz_automationBatchExecute(handle.value));
  }
}
