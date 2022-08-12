import 'dart:math';

import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/item.dart';

class LocalConfigAdapter implements ConfigAdapter {
  final Future<int> Function() _userSeed;
  final Map<String, dynamic> _values = {};

  LocalConfigAdapter(this._userSeed);

  @override
  String get name => 'local';

  @override
  Future<void> init(Iterable<ConfigItem> items) async {
    final matches = items.where((item) => item.a).toList();
    if (matches.isEmpty) return;

    final userSeed = await _userSeed();
    final userSegment = Random(userSeed).nextDouble();

    _values.addAll(Map.fromEntries(matches.where((item) {
      // check if the user falls into the sample size of the local test
      return (item.languages == null || item.languages!.contains(Environment.language)) &&
          userSegment < item.sampleSize;
    }).map((item) {
      if (item.paused) {
        return MapEntry(item.id, item.defaultValue is Enum ? (item.defaultValue as Enum).name : item.defaultValue);
      }

      final testSegments = item.testSegments;
      if (testSegments != null && testSegments.isNotEmpty) {
        // deterministically generate the test value by initializing the random
        // generator with a combination of the user seed and test id hashcode
        final random = Random(userSeed ^ item.id.hashCode);
        final weightSum = testSegments.values.reduce((l, r) => l + r);
        final instantWeight = random.nextInt(weightSum);

        int rollingSum = 0;
        for (final entry in testSegments.entries) {
          final test = entry.key;
          final weight = entry.value;

          rollingSum += weight;
          if (instantWeight < rollingSum) {
            return MapEntry(item.id, test is Enum ? test.name : test);
          }
        }
      }

      return MapEntry(item.id, null);
    })));
  }

  @override
  bool has(String id) => _values.containsKey(id);

  @override
  T? get<T>(String id) => _values[id] as T?;
}
