import 'package:ab_testing_core/src/experiment.dart';

abstract class TestingAdapter {
  final List<ExperimentImpl> experiments = [];

  String get name;

  Future<void> init();
  bool has(String id);
  T? get<T>(String id);

  Experiment<bool> boolExperiment({
    required String id,
    bool defaultValue = false,
    Map<bool, int>? weightedValues,
    double sampleSize = 1,
    bool active = true,
  }) {
    return ExperimentImpl<bool>(this, id, defaultValue, weightedValues ?? {true: 1, false: 1}, sampleSize, active);
  }

  Experiment<int> intExperiment<T>({
    required String id,
    int defaultValue = 0,
    List<int> validValues = const [],
    Map<int, int>? weightedValues,
    double sampleSize = 1,
    bool active = true,
  }) {
    return ExperimentImpl<int>(
      this,
      id,
      defaultValue,
      weightedValues ?? {for (final value in validValues) value: 1},
      sampleSize,
      active,
    );
  }

  Experiment<T> enumExperiment<T extends Enum>({
    required String id,
    required T defaultValue,
    required List<T> validValues,
    Map<T, int>? weightedValues,
    double sampleSize = 1,
    bool active = true,
  }) {
    return EnumExperiment<T>(
      this,
      id,
      defaultValue,
      weightedValues ?? {for (final value in validValues) value: 1},
      sampleSize,
      active,
    );
  }
}

abstract class UpdatableTestingAdapter extends TestingAdapter {
  Future<void> update({bool force = false});
}
