/// Provides Synthizer events.
import 'classes.dart';
import 'context.dart';
import 'enumerations.dart';
import 'generators/base.dart';
import 'source.dart';

/// The base class for all Synthizer events.
class SynthizerEvent {
  /// Create an instance.
  const SynthizerEvent(this.context, this.type);

  /// The context of this event.
  final Context context;

  /// The type of this event.
  final EventTypes type;
}

/// The [generator] finished a loop.
class LoopedEvent extends SynthizerEvent {
  /// Create an instance.
  const LoopedEvent(final Context context, this.generator)
      : super(context, EventTypes.looped);

  /// The generator that finished the loop.
  final Generator generator;
}

/// An event that signals something has finished.
class FinishedEvent extends SynthizerEvent {
  /// Create an instance.
  const FinishedEvent(final Context context, this.source)
      : super(context, EventTypes.finished);

  /// The thing that has finished.
  ///
  /// As per the
  /// [Synthizer manual](https://synthizer.github.io/concepts/events.html),
  /// this does not automatically mean a [Source] instance.
  final SynthizerObject source;
}

/// The user finished event.
class UserAutomationEvent extends SynthizerEvent {
  /// Create an instance.
  const UserAutomationEvent(final Context context, this.target, this.param)
      : super(context, EventTypes.userAutomation);

  /// The target of the vent.
  final SynthizerObject target;

  /// The event parameter.
  final int param;
}
