/// Provides Synthizer events.
import 'classes.dart';
import 'context.dart';
import 'generator.dart';
import 'source.dart';

/// The base class for all Synthizer events.
class SynthizerEvent {
  /// Create an instance.
  SynthizerEvent(this.context);

  /// The context of this event.
  final Context context;
}

/// The [generator] finished a loop.
class LoopedEvent extends SynthizerEvent {
  /// Create an instance.
  LoopedEvent(Context context, this.generator) : super(context);

  /// The generator that finished the loop.
  ///
  /// You cannot rely on this generator being equal to one you have lying
  /// around.
  final Generator generator;
}

/// An event that signals something has finished.
class FinishedEvent extends SynthizerEvent {
  /// Create an instance.
  FinishedEvent(Context context, this.source) : super(context);

  /// The thing that has finished.
  ///
  /// As per the
  /// [Synthizer manual](https://synthizer.github.io/concepts/events.html),
  /// this does not automatically mean a [Source] instance.
  final SynthizerObject source;
}
