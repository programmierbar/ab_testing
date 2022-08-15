import 'dart:math';

import 'package:ab_testing_core/src/adapter.dart';

class LocalTestingAdapter extends TestingAdapter {
  final Future<int> Function() _userSeed;
  final Map<String, dynamic> _values = {};

  LocalTestingAdapter(this._userSeed);

  @override
  String get name => 'local';

  @override
  Future<void> init() async {
    if (experiments.isEmpty) return;

    final userSeed = await _userSeed();
    final userSegment = Random(userSeed).nextDouble();

    _values.addAll(Map.fromEntries(experiments.where((experiment) {
      /// check if the user falls into the sample size of the local test
      return userSegment < experiment.sampleSize;
    }).map((experiment) {
      if (!experiment.active) {
        return MapEntry(
          experiment.id,
          experiment.defaultValue is Enum ? (experiment.defaultValue as Enum).name : experiment.defaultValue,
        );
      }

      final testSegments = experiment.testSegments;
      if (testSegments != null && testSegments.isNotEmpty) {
        // deterministically generate the test value by initializing the random
        // generator with a combination of the user seed and test id hashcode
        final random = Random(userSeed ^ experiment.id.hashCode);
        final weightSum = testSegments.values.reduce((l, r) => l + r);
        final instantWeight = random.nextInt(weightSum);

        int rollingSum = 0;
        for (final entry in testSegments.entries) {
          final test = entry.key;
          final weight = entry.value;

          rollingSum += weight;
          if (instantWeight < rollingSum) {
            return MapEntry(experiment.id, test is Enum ? test.name : test);
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
