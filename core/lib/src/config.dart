import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/test.dart';

abstract class TestingLogger {
  void log(List<Test> experiments);
}

class TestingConfig {
  final List<TestingAdapter> _adapters;
  final TestingLogger? _logger;

  TestingConfig(this._adapters, [this._logger]);

  List<Test> get tests => _adapters.expand((adapter) => adapter.tests).toList();
  List<Test> get activeTests => tests.where((value) => value.active).toList();

  Future<void> init() async {
    await Future.wait(_adapters.map((adapter) => adapter.init()));
    update();
    _logger?.log(activeTests);
  }

  Future<void> update({bool force = false}) async {
    final adapters = _adapters.whereType<UpdatableTestingAdapter>();
    if (adapters.isNotEmpty) {
      await Future.wait(adapters.map((adapter) => adapter.update(force: force)));
    }
  }

  Map<String, String> asMap() => {for (var item in tests) item.id: item.stringValue};
}
