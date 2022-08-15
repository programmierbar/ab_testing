import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/experiment.dart';

abstract class TestingLogger {
  void log(List<Experiment> experiments);
}

class TestingConfig {
  final List<TestingAdapter> _adapters;
  final TestingLogger? _logger;

  TestingConfig(this._adapters, [this._logger]);

  List<Experiment> get values => _adapters.expand((adapter) => adapter.experiments).toList();
  List<Experiment> get activeValues => values.where((value) => value.active).toList();

  Future<void> init() async {
    await Future.wait(_adapters.map((adapter) => adapter.init()));
    update();
    _logger?.log(activeValues);
  }

  Future<void> update({bool force = false}) async {
    final adapters = _adapters.whereType<UpdatableTestingAdapter>();
    if (adapters.isNotEmpty) {
      await Future.wait(adapters.map((adapter) => adapter.update(force: force)));
    }
  }

  Map<String, String> asMap() => {for (var item in values) item.id: item.stringValue};
}
