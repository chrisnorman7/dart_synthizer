import 'context.dart';
import 'enumerations.dart';
import 'source.dart';

/// The base class for all Synthizer events.
class SynthizerEvent {
  /// Create an instance.
  const SynthizerEvent({
    required this.context,
    required this.type,
  });

  /// The context of this event.
  final Context context;

  /// The type of this event.
  final EventTypes type;
}

/// The [generatorHandle] finished a loop.
class LoopedEvent extends SynthizerEvent {
  /// Create an instance.
  const LoopedEvent({
    required super.context,
    required this.generatorHandle,
  }) : super(type: EventTypes.looped);

  /// The generator that finished the loop.
  final int generatorHandle;
}

/// An event that signals something has finished.
class FinishedEvent extends SynthizerEvent {
  /// Create an instance.
  const FinishedEvent({
    required super.context,
    required this.sourceHandle,
  }) : super(type: EventTypes.finished);

  /// The thing that has finished.
  ///
  /// As per the
  /// [Synthizer manual](https://synthizer.github.io/concepts/events.html),
  /// this does not automatically mean a [Source] instance.
  final int sourceHandle;
}

/// The user finished event.
class UserAutomationEvent extends SynthizerEvent {
  /// Create an instance.
  const UserAutomationEvent({
    required super.context,
    required this.targetHandle,
    required this.param,
  }) : super(type: EventTypes.userAutomation);

  /// The target of the vent.
  final int targetHandle;

  /// The event parameter.
  final int param;
}
