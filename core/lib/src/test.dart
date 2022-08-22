import 'package:ab_testing_core/src/adapter.dart';

abstract class Test<T> {
  String get id;
  T get value;
  String get stringValue;
  bool get active;
}

class AdaptedTest<T> implements Test<T> {
  final TestingAdapter _adapter;

  final String id;
  final bool active;
  final T defaultVariant;
  final Map<T, int>? weightedVariants;
  final double sampleSize;

  AdaptedTest(
    this._adapter,
    this.id,
    this.active,
    this.defaultVariant,
    this.weightedVariants,
    this.sampleSize,
  );

  @override
  T get value => active ? _adapter.get<T>(id) ?? defaultVariant : defaultVariant;

  @override
  String get stringValue => value.toString();

  bool get tracked => !active && _adapter.has(id);

  @override
  String toString() => '$runtimeType(id: $id, value: $value)';
}

class EnumeratedTest<T extends Enum> extends AdaptedTest<T> {
  EnumeratedTest(
    TestingAdapter adapter,
    String id,
    bool active,
    T defaultVariant,
    Map<T, int>? weightedVariants,
    double sampleSize,
  )   : assert(weightedVariants != null),
        super(adapter, id, active, defaultVariant, weightedVariants, sampleSize);

  @override
  T get value {
    if (!active) {
      return defaultVariant;
    }
    try {
      return variants.byName(_adapter.get<String>(id)!);
    } catch (_) {
      return defaultVariant;
    }
  }

  List<T> get variants => weightedVariants!.keys.toList();
  @override
  String get stringValue => value.name;
}

class FakeTest<T> implements Test<T> {
  @override
  final T value;
  @override
  final bool active;

  FakeTest(this.value, {this.active = true});

  @override
  String get id => 'fake';
  @override
  String get stringValue => value.toString();
}
