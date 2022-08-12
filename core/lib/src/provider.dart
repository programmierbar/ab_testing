import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/item.dart';
import 'package:ab_testing_core/src/value.dart';

abstract class ConfigLogger {
  void log(List<ConfigValueImpl> values);
}

class ConfigProvider {
  final List<ConfigValueImpl> values = [];
  final List<ConfigAdapter> _adapters;
  final ConfigLogger? _logger;

  ConfigProvider(this._adapters, this._logger);

  List<ConfigItem> get items => values.map((value) => value.item).toList();

  List<ConfigValueImpl> get activeValues => values.where((value) => !value.enabled).toList();

  Future<void> init() async {
    await Future.wait(_adapters.map((adapter) => adapter.init(items)));
    update();
    _logger?.log(activeValues);
  }

  Future<void> update({bool force = false}) async {
    final adapters = _adapters.whereType<UpdatableConfigAdapter>();
    if (adapters.isNotEmpty) {
      await Future.wait(adapters.map((adapter) => adapter.update(force: force)));
    }
  }

  ConfigValue<bool> boolValue({
    required String id,
    bool defaultValue = false,
    Map<bool, int>? weightedValues,
    double sampleSize = 1,
    bool enabled = false,
    String? adapter,
  }) {
    return _add(
      BoolConfigValue(
        ConfigItem(
          id,
          defaultValue,
          weightedValues ?? {true: 1, false: 1},
          sampleSize,
          enabled: enabled,
        ),
        getAdapter(adapter),
      ),
    );
  }

  ConfigValue<int> intValue<T>(
      {required String id,
      int defaultValue = 0,
      List<int> validValues = const [],
      Map<int, int>? weightedValues,
      double sampleSize = 1,
      bool enabled = false,
      String? adapter}) {
    return _add(IntConfigValue(
      ConfigItem(
        id,
        defaultValue,
        weightedValues ?? {for (final value in validValues) value: 1},
        sampleSize,
        enabled: enabled,
      ),
      getAdapter(adapter),
    ));
  }

  ConfigValue<T> enumValue<T extends Enum>({
    required String id,
    required T defaultValue,
    required List<T> validValues,
    Map<T, int>? weightedValues,
    double sampleSize = 1,
    bool enabled = false,
    String? adapter,
  }) {
    return _add(EnumConfigValue<T>(
      ConfigItem(
        id,
        defaultValue,
        weightedValues ?? {for (final value in validValues) value: 1},
        sampleSize,
        enabled: enabled,
      ),
      getAdapter(adapter),
    ));
  }

  ConfigValue<T> _add<T>(ConfigValueImpl<T> value) {
    values.add(value);
    return value;
  }

  ConfigAdapter getAdapter(String? name) {
    return _adapters.firstWhere((adapter) => adapter.name == name);
  }

  Map<String, String> asMap() => {for (var item in values) item.id: item.stringValue};
}
