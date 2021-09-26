/// Provides classes relating to automation.
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'synthizer.dart';
import 'synthizer_bindings.dart';

/// The base class for all automation commands.
class AutomationCommand {
  /// Create an instance.
  const AutomationCommand(this.time, this.type);

  /// The time this command should run.
  final double time;

  /// The type of command.
  final AutomationCommands type;
}

/// syz_AutomationAppendPropertyCommand.
class AutomationAppendPropertyCommand extends AutomationCommand {
  /// Create an instance.
  const AutomationAppendPropertyCommand(double time, this.property, this.value,
      {this.interpolationType = InterpolationTypes.linear})
      : super(time, AutomationCommands.appendProperty);

  /// The property to change.
  final Properties property;

  /// The value of this point.
  final double value;

  /// The interpolation type to use.
  final InterpolationTypes interpolationType;
}

/// syz_AutomationSendUserEventCommand
class AutomationSendUserEventCommand extends AutomationCommand {
  /// Create an instance.
  const AutomationSendUserEventCommand(double time, this.param)
      : super(time, AutomationCommands.sendUserEvent);

  /// The param to use.
  final int param;
}

/// syz_AutomationClearPropertyCommand.
class AutomationClearPropertyCommand extends AutomationCommand {
  /// Create an instance.
  const AutomationClearPropertyCommand(double time, this.property)
      : super(time, AutomationCommands.clearProperty);

  /// The property to clear.
  final Properties property;
}

/// SYZ_AUTOMATION_COMMAND_CLEAR_EVENTS.
class AutomationClearEventsCommand extends AutomationCommand {
  /// Create an instance.
  AutomationClearEventsCommand(double time)
      : super(time, AutomationCommands.clearEvents);
}

/// SYZ_AUTOMATION_COMMAND_CLEAR_ALL_PROPERTIES.
class AutomationClearAllPropertiesCommand extends AutomationCommand {
  /// Create an instance.
  AutomationClearAllPropertiesCommand(double time)
      : super(time, AutomationCommands.clearAllProperties);
}

/// Automation batch.
class AutomationBatch extends SynthizerObject {
  /// Create an instance.
  AutomationBatch(Context context) : super(context.synthizer) {
    synthizer.check(synthizer.synthizer.syz_createAutomationBatch(handle,
        context.handle.value, nullptr, synthizer.userdataFreeCallbackPointer));
  }

  /// Create an instance from a handle.
  AutomationBatch.fromHandle(Synthizer synthizer, int pointer)
      : super(synthizer, pointer: pointer);

  /// Add commands to this batch.
  void addCommands(SynthizerObject target, List<AutomationCommand> commands) {
    final a = malloc<syz_AutomationCommand>(commands.length);
    for (var i = 0; i < commands.length; i++) {
      final command = commands[i];
      final ref = a[i]
        ..time = command.time
        ..target = target.handle.value
        ..type = command.type.toInt();
      if (command is AutomationAppendPropertyCommand) {
        final append = ref.params.append_to_property
          ..property = command.property.toInt();
        append.point
          ..interpolation_type = command.interpolationType.toInt()
          ..values[0] = command.value;
      } else if (command is AutomationClearPropertyCommand) {
        ref.params.clear_property.property = command.property.toInt();
      } else if (command is AutomationSendUserEventCommand) {
        ref.params.send_user_event.param = command.param;
      }
    }
    synthizer.check(synthizer.synthizer
        .syz_automationBatchAddCommands(handle.value, commands.length, a));
    malloc.free(a);
  }

  /// Execute this batch.
  void execute() => synthizer
      .check(synthizer.synthizer.syz_automationBatchExecute(handle.value));
}
