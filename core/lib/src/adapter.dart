import 'package:ab_testing_core/src/config.dart';
import 'package:ab_testing_core/src/experiment.dart';

/// Provides the backing values for experiments and serves as a registry for
/// experiments.
///
/// An adapter must be initialized before it can be used by calling [init].
abstract class ExperimentAdapter {
  /// The experiments that are registered with this adapter.
  List<AdaptedExperiment> get experiments;

  /// Initializes this adapter.
  Future<void> init(ExperimentConfig config);

  /// Updates the values for all experiments, if appropriate.
  ///
  /// If [force] is true, the values will be updated regardless of whether they are stale.
  Future<void> update(ExperimentConfig config, {bool force = false});

  /// Returns whether this adapter has a value for the experiment with the given
  /// [id].
  bool has(String id);

  /// Returns the value for the experiment with the given [id].
  T? get<T>(String id);

  /// Registers and returns a new boolean experiment.
  Experiment<bool> boolean({
    required String id,
    bool defaultVariant = false,
    Map<bool, int>? weightedVariants,
    double sampleSize = 1,
    bool enabled = true,
  }) {
    return add(AdaptedExperiment<bool>(
      this,
      id,
      enabled,
      defaultVariant,
      weightedVariants ?? {true: 1, false: 1},
      sampleSize,
    ));
  }

  /// Registers and returns a new numeric experiment.
  Experiment<int> numeric({
    required String id,
    int defaultVariant = 0,
    List<int>? variants,
    Map<int, int>? weightedVariants,
    double sampleSize = 1,
    bool enabled = true,
  }) {
    return add(AdaptedExperiment<int>(
      this,
      id,
      enabled,
      defaultVariant,
      weightedVariants ?? variants?.defaultWeightedVariants,
      sampleSize,
    ));
  }

  /// Registers and returns a new text experiment.
  Experiment<String> text({
    required String id,
    String defaultVariant = '',
    List<String>? variants,
    Map<String, int>? weightedVariants,
    double sampleSize = 1,
    bool enabled = true,
  }) {
    return add(AdaptedExperiment<String>(
      this,
      id,
      enabled,
      defaultVariant,
      weightedVariants ?? variants?.defaultWeightedVariants,
      sampleSize,
    ));
  }

  /// Registers and returns a new [Enum] based experiment.
  Experiment<T> enumerated<T extends Enum>({
    required String id,
    required T defaultVariant,
    List<T>? variants,
    Map<T, int>? weightedVariants,
    double sampleSize = 1,
    bool enabled = true,
  }) {
    assert(
      variants != null || weightedVariants != null,
      'Either variants or weightedVariants must be provided.',
    );
    return add(EnumeratedExperiment<T>(
      this,
      id,
      enabled,
      defaultVariant,
      weightedVariants ?? variants!.defaultWeightedVariants,
      sampleSize,
    ));
  }

  Experiment<T> add<T>(AdaptedExperiment<T> experiment) {
    assert(
      !experiments.any((lookup) => lookup.id == experiment.id),
      'Another Experiment with id ${experiment.id} is already defined.',
    );
    experiments.add(experiment);
    return experiment;
  }
}

extension _DefaultWeightedVariants<T> on List<T> {
  Map<T, int> get defaultWeightedVariants => asMap().map((_, variant) => MapEntry(variant, 1));
}
