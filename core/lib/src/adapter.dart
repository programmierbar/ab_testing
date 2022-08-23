import 'package:ab_testing_core/src/test.dart';

abstract class TestingAdapter {
  final List<AdaptedTest> tests = [];

  Future<void> init();
  bool has(String id);
  T? get<T>(String id);

  Test<bool> boolean({
    required String id,
    bool defaultVariant = false,
    Map<bool, int>? weightedVariants,
    double sampleSize = 1,
    bool active = true,
  }) {
    return _add(AdaptedTest<bool>(
      this,
      id,
      active,
      defaultVariant,
      weightedVariants ?? {true: 1, false: 1},
      sampleSize,
    ));
  }

  Test<int> numeric<T>({
    required String id,
    int defaultVariant = 0,
    List<int>? variants,
    Map<int, int>? weightedVariants,
    double sampleSize = 1,
    bool active = true,
  }) {
    return _add(AdaptedTest<int>(
      this,
      id,
      active,
      defaultVariant,
      weightedVariants ?? variants?.asMap().map((_, value) => MapEntry(value, 1)),
      sampleSize,
    ));
  }

  Test<T> enumerated<T extends Enum>({
    required String id,
    required T defaultVariant,
    List<T>? variants,
    Map<T, int>? weightedVariants,
    double sampleSize = 1,
    bool active = true,
  }) {
    assert(variants != null || weightedVariants != null, 'Either variants or weightedVariants must be provided');
    return _add(EnumeratedTest<T>(
      this,
      id,
      active,
      defaultVariant,
      weightedVariants ?? variants?.asMap().map((_, variant) => MapEntry(variant, 1)),
      sampleSize,
    ));
  }

  Test<T> _add<T>(AdaptedTest<T> test) {
    assert(!tests.any((lookup) => lookup.id == test.id), 'Another Test with id ${test.id} already defined');
    tests.add(test);
    return test;
  }
}

abstract class UpdatableTestingAdapter extends TestingAdapter {
  Future<void> update({bool force = false});
}
