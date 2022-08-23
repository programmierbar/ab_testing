import 'dart:math';

import 'package:ab_testing_core/core.dart';

class LocalTestingAdapter extends TestingAdapter {
  final Future<int> Function() _userSeed;
  final Map<String, dynamic> _values = {};

  LocalTestingAdapter(this._userSeed);

  @override
  Future<void> init() async {
    if (experiments.isEmpty) return;

    final userSeed = await _userSeed();
    final userSegment = Random(userSeed).nextDouble();

    _values.addAll(Map.fromEntries(experiments.where((test) {
      /// check if the user falls into the sample size of the local test
      return userSegment < test.sampleSize;
    }).map((test) {
      if (!test.active) {
        return MapEntry(
          test.id,
          test.defaultVariant is Enum ? (test.defaultVariant as Enum).name : test.defaultVariant,
        );
      }

      final testSegments = test.weightedVariants;
      if (testSegments != null && testSegments.isNotEmpty) {
        /// deterministically generate the test value by initializing the random
        /// generator with a combination of the user seed and test id hashcode
        final random = Random(userSeed ^ test.id.hashCode);
        final weightSum = testSegments.values.reduce((l, r) => l + r);
        final instantWeight = random.nextInt(weightSum);

        int rollingSum = 0;
        for (final entry in testSegments.entries) {
          final variant = entry.key;
          final weight = entry.value;

          rollingSum += weight;
          if (instantWeight < rollingSum) {
            return MapEntry(test.id, variant is Enum ? variant.name : variant);
          }
        }
      }

      return MapEntry(test.id, null);
    })));
  }

  @override
  bool has(String id) => _values.containsKey(id);

  @override
  T? get<T>(String id) => _values[id] as T?;
}
