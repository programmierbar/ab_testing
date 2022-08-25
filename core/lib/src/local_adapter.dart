import 'dart:math';

import 'package:ab_testing_core/core.dart';

class LocalExperimentsAdapter extends ExperimentsAdapter {
  final Future<int> Function() _userSeed;
  final Map<String, dynamic> _values = {};

  LocalExperimentsAdapter(this._userSeed);

  @override
  Future<void> init() async {
    if (experiments.isEmpty) return;

    final userSeed = await _userSeed();
    final userSegment = Random(userSeed).nextDouble();

    _values.addAll(Map.fromEntries(experiments.where((experiment) {
      /// check if the user falls into the sample size of the local experiment
      return userSegment < experiment.sampleSize;
    }).map((experiment) {
      if (!experiment.active) {
        return MapEntry(
          experiment.id,
          experiment.defaultVariant is Enum ? (experiment.defaultVariant as Enum).name : experiment.defaultVariant,
        );
      }

      final experimentSegments = experiment.weightedVariants;
      if (experimentSegments != null && experimentSegments.isNotEmpty) {
        /// deterministically generate the experiment value by initializing the random
        /// generator with a combination of the user seed and experiment id hashcode
        final random = Random(userSeed ^ experiment.id.hashCode);
        final weightSum = experimentSegments.values.reduce((l, r) => l + r);
        final instantWeight = random.nextInt(weightSum);

        int rollingSum = 0;
        for (final entry in experimentSegments.entries) {
          final variant = entry.key;
          final weight = entry.value;

          rollingSum += weight;
          if (instantWeight < rollingSum) {
            return MapEntry(experiment.id, variant is Enum ? variant.name : variant);
          }
        }
      }

      return MapEntry(experiment.id, null);
    })));
  }

  @override
  bool has(String id) => _values.containsKey(id);

  @override
  T? get<T>(String id) => _values[id] as T?;
}
