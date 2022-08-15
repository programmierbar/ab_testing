import 'package:ab_testing_core/src/adapter.dart';

abstract class Experiment<T> {
  String get id;
  T get value;
  String get stringValue;
  bool get active;
}

class ExperimentImpl<T> implements Experiment<T> {
  final TestingAdapter _adapter;

  final String id;
  final T defaultValue;
  final Map<T, int>? testSegments;
  final double sampleSize;
  final bool active;

  ExperimentImpl(this._adapter, this.id, this.defaultValue, this.testSegments, this.sampleSize, this.active);

  @override
  T get value => active ? _adapter.get<T>(id) ?? defaultValue : defaultValue;
  @override
  String get stringValue => value.toString();

  bool get tracked => !active && _adapter.has(id);

  @override
  String toString() => '$runtimeType(id: $id, value: $value)';
}

class EnumExperiment<T extends Enum> extends ExperimentImpl<T> {
  EnumExperiment(
      TestingAdapter adapter, String id, T defaultValue, Map<T, int>? testSegments, double sampleSize, bool enabled)
      : assert(testSegments != null),
        super(adapter, id, defaultValue, testSegments, sampleSize, enabled);

  @override
  T get value {
    if (!active) {
      return defaultValue;
    }
    try {
      return validValues.byName(_adapter.get<String>(id)!);
    } catch (_) {
      return defaultValue;
    }
  }

  List<T> get validValues => testSegments!.keys.toList();
  @override
  String get stringValue => value.name;
}

class ExperimentFake<T> implements Experiment<T> {
  @override
  final T value;
  @override
  final bool active;

  ExperimentFake(this.value, {this.active = true});

  @override
  String get id => 'fake';
  @override
  String get stringValue => value.toString();
}
