import 'package:ab_testing_core/ab_testing_core.dart';

/// An A/B test experiment, that defines whether the user is part of the
/// experiment and what variant has been assigned to them.
abstract class Experiment<T> {
  /// The ID of this experiment.
  String get id;

  /// Whether this experiment is active.
  ///
  /// Inactive experiments will always return [defaultVariant] for [value].
  bool get active;

  /// The default value for users that are not part of this experiment.
  T get defaultVariant;

  /// The value of this experiment.
  T get value;

  /// The representation of the [value] that should be used for tracking in
  /// analytics tools.
  String get trackingValue;
}

/// An [Experiment] that is backed by an [ExperimentAdapter].
class AdaptedExperiment<T> implements Experiment<T> {
  final ExperimentAdapter _adapter;

  @override
  final String id;

  @override
  final T defaultVariant;

  /// All of the variants of this experiment and their weights.
  ///
  /// The weights might be used to determine the likelihood of a variant being
  /// chosen for a user.
  ///
  /// [LocalExperimentAdapter] uses the weights but not all [ExperimentAdapter]s
  /// do.
  final Map<T, int>? weightedVariants;

  /// The sample size of this experiment.
  ///
  /// The sample size is the percentage of users that should be part of this
  /// experiment.
  ///
  /// [LocalExperimentAdapter] uses the sample size but not all
  /// [ExperimentAdapter]s do.
  final double sampleSize;

  final bool _active;

  /// Creates a new [AdaptedExperiment].
  AdaptedExperiment(
    this._adapter,
    this.id,
    bool active,
    this.defaultVariant,
    this.weightedVariants,
    this.sampleSize,
  ) : _active = active;

  @override
  bool get active => _active ? _adapter.has(id) : false;

  @override
  T get value => _active ? _adapter.get<T>(id) ?? defaultVariant : defaultVariant;

  @override
  String get trackingValue => value.toString();

  @override
  String toString() => '$runtimeType(id: $id, value: $value)';
}

/// An [AdaptedExperiment] that uses [Enum] values to represent its [variants].
///
/// [Enum.name] is used for [trackingValue].
class EnumeratedExperiment<T extends Enum> extends AdaptedExperiment<T> {
  EnumeratedExperiment(
    super.adapter,
    super.id,
    super.active,
    super.defaultVariant,
    Map<T, int> super.weightedVariants,
    super.sampleSize,
  );

  /// All of the variants of this experiment.
  List<T> get variants => weightedVariants!.keys.toList();

  @override
  T get value {
    if (active) {
      final value = _adapter.get<String>(id);
      if (value != null) {
        return variants.byName(value);
      }
    }
    return defaultVariant;
  }

  @override
  String get trackingValue => value.name;
}

class FakeExperiment<T> implements Experiment<T> {
  @override
  final T value;
  @override
  final bool active;

  FakeExperiment(this.value, {this.active = true});

  @override
  String get id => 'fake';
  @override
  T get defaultVariant => value;
  @override
  String get trackingValue => value.toString();
}
