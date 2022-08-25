import 'package:ab_testing_core/src/adapter.dart';

abstract class Experiment<T> {
  String get id;
  T get value;
  String get stringValue;
  bool get active;
}

class AdaptedExperiment<T> implements Experiment<T> {
  final ExperimentsAdapter _adapter;

  @override
  final String id;
  @override
  final bool active;
  final T defaultVariant;
  final Map<T, int>? weightedVariants;
  final double sampleSize;

  AdaptedExperiment(
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

  @override
  String toString() => '$runtimeType(id: $id, value: $value)';
}

class EnumeratedExperiment<T extends Enum> extends AdaptedExperiment<T> {
  EnumeratedExperiment(
    ExperimentsAdapter adapter,
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

class FakeExperiment<T> implements Experiment<T> {
  @override
  final T value;
  @override
  final bool active;

  FakeExperiment(this.value, {this.active = true});

  @override
  String get id => 'fake';
  @override
  String get stringValue => value.toString();
}
