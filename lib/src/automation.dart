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
///
/// Instances of this class - or any of its subclasses - should not be created
/// directly for most use cases. Instead use the functions available on
/// [AutomationBatch].
abstract class AutomationCommand {
  /// Create an instance.
  const AutomationCommand(this.targetHandle, this.time, this.type);

  /// The handle of the target this command should work with.
  final Pointer<syz_Handle> targetHandle;

  /// The time this command should run.
  final double time;

  /// The type of command.
  final AutomationCommands type;
}

/// syz_AutomationAppendPropertyCommand.
class AutomationAppendPropertyCommand extends AutomationCommand {
  /// Create an instance.
  const AutomationAppendPropertyCommand(
    final Pointer<syz_Handle> targetHandle,
    final double time,
    this.property,
    this.value, {
    this.interpolationType = InterpolationTypes.linear,
  }) : super(targetHandle, time, AutomationCommands.appendProperty);

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
class AutomationSendUserEventCommand extends AutomationCommand {
  /// Create an instance.
  const AutomationSendUserEventCommand(
    final Pointer<syz_Handle> targetHandle,
    final double time,
    this.param,
  ) : super(targetHandle, time, AutomationCommands.sendUserEvent);

  /// The param to use.
  final int param;
}

/// syz_AutomationClearPropertyCommand.
class AutomationClearPropertyCommand extends AutomationCommand {
  /// Create an instance.
  const AutomationClearPropertyCommand(
    final Pointer<syz_Handle> targetHandle,
    final double time,
    this.property,
  ) : super(targetHandle, time, AutomationCommands.clearProperty);

  /// The property to clear.
  final Properties property;
}

/// SYZ_AUTOMATION_COMMAND_CLEAR_EVENTS.
class AutomationClearEventsCommand extends AutomationCommand {
  /// Create an instance.
  const AutomationClearEventsCommand(
    final Pointer<syz_Handle> targetHandle,
    final double time,
  ) : super(targetHandle, time, AutomationCommands.clearEvents);
}

/// SYZ_AUTOMATION_COMMAND_CLEAR_ALL_PROPERTIES.
class AutomationClearAllPropertiesCommand extends AutomationCommand {
  /// Create an instance.
  const AutomationClearAllPropertiesCommand(
    final Pointer<syz_Handle> targetHandle,
    final double time,
  ) : super(targetHandle, time, AutomationCommands.clearAllProperties);
}

/// Automation batch.
class AutomationBatch extends SynthizerObject {
  /// Create an instance.
  AutomationBatch(final Context context)
      : _commands = [],
        super(context.synthizer) {
    synthizer.check(
      synthizer.synthizer.syz_createAutomationBatch(
        handle,
        context.handle.value,
        nullptr,
        synthizer.userdataFreeCallbackPointer,
      ),
    );
  }

  /// Create an instance from a handle.
  AutomationBatch.fromHandle(final Synthizer synthizer, final int pointer)
      : _commands = [],
        super(synthizer, pointer: pointer);

  /// The commands for this batch.
  final List<AutomationCommand> _commands;

  /// Append a double value.
  void appendDouble(
    final Pointer<syz_Handle> targetHandle,
    final double time,
    final Properties property,
    final double value, {
    final InterpolationTypes interpolationType = InterpolationTypes.linear,
  }) =>
      _commands.add(
        AutomationAppendPropertyCommand(
          targetHandle,
          time,
          property,
          value,
          interpolationType: interpolationType,
        ),
      );

  /// Append a double3 value.
  void appendDouble3(
    final Pointer<syz_Handle> targetHandle,
    final double time,
    final Properties property,
    final Double3 value, {
    final InterpolationTypes interpolationType = InterpolationTypes.linear,
  }) =>
      _commands.add(
        AutomationAppendPropertyCommand(
          targetHandle,
          time,
          property,
          value,
          interpolationType: interpolationType,
        ),
      );

  /// Append a double6 value.
  void appendDouble6(
    final Pointer<syz_Handle> targetHandle,
    final double time,
    final Properties property,
    final Double6 value, {
    final InterpolationTypes interpolationType = InterpolationTypes.linear,
  }) =>
      _commands.add(
        AutomationAppendPropertyCommand(
          targetHandle,
          time,
          property,
          value,
          interpolationType: interpolationType,
        ),
      );

  /// Clear a property.
  void clearProperty(
    final Pointer<syz_Handle> targetHandle,
    final double time,
    final Properties property,
  ) =>
      _commands
          .add(AutomationClearPropertyCommand(targetHandle, time, property));

  /// Clear all properties.
  void clearAllProperties(
    final Pointer<syz_Handle> targetHandle,
    final double time,
  ) =>
      _commands.add(AutomationClearAllPropertiesCommand(targetHandle, time));

  /// Send a user event.
  void sendUserEvent(
    final Pointer<syz_Handle> targetHandle,
    final double time,
    final int event,
  ) =>
      _commands.add(AutomationSendUserEventCommand(targetHandle, time, event));

  /// Clear all events.
  void clearEvents(final Pointer<syz_Handle> targetHandle, final double time) =>
      _commands.add(AutomationClearEventsCommand(targetHandle, time));

  /// Execute this batch.
  void execute() {
    final a = malloc<syz_AutomationCommand>(_commands.length);
    for (var i = 0; i < _commands.length; i++) {
      final command = _commands[i];
      final ref = a[i]
        ..time = command.time
        ..target = command.targetHandle.value
        ..type = command.type.toInt();
      if (command is AutomationAppendPropertyCommand) {
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
            'Invalid point type ${value.runtimeType}: $value.',
            -1,
          );
        }
      } else if (command is AutomationClearPropertyCommand) {
        ref.params.clear_property.property = command.property.toInt();
      } else if (command is AutomationSendUserEventCommand) {
        ref.params.send_user_event.param = command.param;
      }
    }
    synthizer.check(
      synthizer.synthizer
          .syz_automationBatchAddCommands(handle.value, _commands.length, a),
    );
    malloc.free(a);
    synthizer
        .check(synthizer.synthizer.syz_automationBatchExecute(handle.value));
  }
}
