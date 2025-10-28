import 'dart:async';

import 'package:ab_testing_core/ab_testing_core.dart';

class ChainedExperimentAdapter extends ExperimentAdapter {
  ChainedExperimentAdapter({
    required this.defaultAdapter,
    required this.overrideAdapter,
  });

  final ExperimentAdapter defaultAdapter;
  final ExperimentAdapter overrideAdapter;

  @override
  List<AdaptedExperiment<Object?>> get experiments =>
      defaultAdapter.experiments;

  @override
  T? get<T>(String id) {
    return overrideAdapter.get<T>(id) ?? defaultAdapter.get<T>(id);
  }

  @override
  bool has(String id) {
    return overrideAdapter.has(id) || defaultAdapter.has(id);
  }

  @override
  Future<void> init(ExperimentConfig config) async {
    await Future.wait([
      defaultAdapter.init(config),
      overrideAdapter.init(config),
    ]);
  }

  @override
  Future<void> update(ExperimentConfig config, {bool force = false}) async {
    await Future.wait([
      defaultAdapter.update(config, force: force),
      overrideAdapter.update(config, force: force),
    ]);
  }

  @override
  Experiment<T> add<T>(AdaptedExperiment<T> experiment) {
    defaultAdapter.add(experiment);
    overrideAdapter.add(experiment);
    return experiment;
  }
}
