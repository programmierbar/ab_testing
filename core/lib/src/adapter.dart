import 'package:ab_testing_core/src/experiment.dart';

abstract class ExperimentsAdapter {
  final List<AdaptedExperiment> experiments = [];

  Future<void> init();
  bool has(String id);
  T? get<T>(String id);

  Experiment<bool> boolean({
    required String id,
    bool defaultVariant = false,
    Map<bool, int>? weightedVariants,
    double sampleSize = 1,
    bool active = true,
  }) {
    return _add(AdaptedExperiment<bool>(
      this,
      id,
      active,
      defaultVariant,
      weightedVariants ?? {true: 1, false: 1},
      sampleSize,
    ));
  }

  Experiment<int> numeric<T>({
    required String id,
    int defaultVariant = 0,
    List<int>? variants,
    Map<int, int>? weightedVariants,
    double sampleSize = 1,
    bool active = true,
  }) {
    return _add(AdaptedExperiment<int>(
      this,
      id,
      active,
      defaultVariant,
      weightedVariants ?? variants?.asMap().map((_, value) => MapEntry(value, 1)),
      sampleSize,
    ));
  }

  Experiment<String> text<T>({
    required String id,
    String defaultVariant = '',
    List<String>? variants,
    Map<String, int>? weightedVariants,
    double sampleSize = 1,
    bool active = true,
  }) {
    return _add(AdaptedExperiment<String>(
      this,
      id,
      active,
      defaultVariant,
      weightedVariants ?? variants?.asMap().map((_, value) => MapEntry(value, 1)),
      sampleSize,
    ));
  }

  Experiment<T> enumerated<T extends Enum>({
    required String id,
    required T defaultVariant,
    List<T>? variants,
    Map<T, int>? weightedVariants,
    double sampleSize = 1,
    bool active = true,
  }) {
    assert(variants != null || weightedVariants != null, 'Either variants or weightedVariants must be provided');
    return _add(EnumeratedExperiment<T>(
      this,
      id,
      active,
      defaultVariant,
      weightedVariants ?? variants?.asMap().map((_, variant) => MapEntry(variant, 1)),
      sampleSize,
    ));
  }

  Experiment<T> _add<T>(AdaptedExperiment<T> experiment) {
    assert(!experiments.any((lookup) => lookup.id == experiment.id),
        'Another Experiment with id ${experiment.id} already defined');
    experiments.add(experiment);
    return experiment;
  }
}

abstract class UpdatableExperimentsAdapter extends ExperimentsAdapter {
  Future<void> update({bool force = false});
}
