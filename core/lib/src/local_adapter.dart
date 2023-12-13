import 'dart:async';
import 'dart:math';

import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/config.dart';
import 'package:ab_testing_core/src/experiment.dart';

/// An [ExperimentAdapter] that uses [AdaptedExperiment.sampleSize] and
/// [AdaptedExperiment.weightedVariants] to locally determine the value of an
/// experiment.
class LocalExperimentAdapter extends ExperimentAdapter {
  /// Function that resolves a seed for the current user that will be used
  /// to deterministically select active experiments and experiment values.
  final FutureOr<int> Function() resolveUserSeed;

  @override
  final List<AdaptedExperiment> experiments = [];

  final Map<String, Object> _values = {};

  LocalExperimentAdapter({required this.resolveUserSeed});

  @override
  Future<void> init(ExperimentConfig config) async {
    if (experiments.isEmpty) return;

    final userSeed = await resolveUserSeed();

    final activeExperiments = experiments.where((experiment) {
      if (!experiment.enabled) {
        return false;
      } else if (experiment.sampleSize == 1) {
        return true;
      }

      // Build unique seed for each experiment by combining user seed and experiment id
      // to ensure different user segments for each experiment.
      final seed = experiment.id.hashCode ^ userSeed;
      final userSegment = Random(seed).nextDouble();

      // Check if the user falls into the sample size of the local experiment.
      return userSegment < experiment.sampleSize;
    });

    for (final experiment in activeExperiments) {
      _values[experiment.id] = _determineExperimentValue(experiment, userSeed);
    }
  }

  @override
  Future<void> update(ExperimentConfig config, {bool force = false}) async {}

  @override
  bool has(String id) => _values.containsKey(id);

  @override
  T? get<T>(String id) => _values[id] as T?;

  Object _determineExperimentValue(AdaptedExperiment experiment, int userSeed) {
    final experimentSegments = experiment.weightedVariants;
    if (experimentSegments == null || experimentSegments.isEmpty) {
      throw ArgumentError.value(experimentSegments, 'weightedVariants', 'must not be empty');
    }

    // Deterministically generate the experiment value by initializing the random
    // generator with a combination of the user seed and experiment id hash code.
    final random = Random(userSeed ^ experiment.id.hashCode);
    final weightSum = experimentSegments.values.reduce((l, r) => l + r);
    final instantWeight = random.nextInt(weightSum);

    int rollingSum = 0;
    for (final entry in experimentSegments.entries) {
      final variant = entry.key;
      final weight = entry.value;

      rollingSum += weight;
      if (instantWeight < rollingSum) {
        return variant is Enum ? variant.name : variant;
      }
    }

    throw StateError('Failed to determine experiment value.');
  }
}
