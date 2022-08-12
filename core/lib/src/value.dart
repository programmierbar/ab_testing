import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/item.dart';

abstract class ConfigValue<T> {
  String get id;
  T get value;
  String get stringValue;
}

abstract class ConfigValueImpl<T> implements ConfigValue<T> {
  final ConfigItem<T> item;
  final ConfigAdapter _adapter;

  ConfigValueImpl._(this.item, this._adapter);

  @override
  String get id => item.id;
  @override
  T get value => !item.enabled ? _adapter.get<T>(item.id) ?? item.defaultValue : item.defaultValue;
  @override
  String get stringValue => value.toString();

  bool get enabled => item.enabled;
  bool get tracked => !enabled && _adapter.has(item.id);

  @override
  String toString() => '$runtimeType(id: $id, value: $value)';
}

class BoolConfigValue extends ConfigValueImpl<bool> {
  BoolConfigValue(ConfigItem<bool> item, ConfigAdapter adapter) : super._(item, adapter);
}

class IntConfigValue extends ConfigValueImpl<int> {
  IntConfigValue(ConfigItem<int> item, ConfigAdapter adapter) : super._(item, adapter);
}

class EnumConfigValue<T extends Enum> extends ConfigValueImpl<T> {
  EnumConfigValue(ConfigItem<T> item, ConfigAdapter adapter)
      : assert(item.testSegments != null),
        super._(item, adapter);

  @override
  T get value {
    if (!item.enabled) {
      return item.defaultValue;
    }
    try {
      return validValues.byName(_adapter.get<String>(item.id)!);
    } catch (_) {
      return item.defaultValue;
    }
  }

  List<T> get validValues => item.values!;
  @override
  String get stringValue => value.name;
}

class ConfigValueFake<T> implements ConfigValue<T> {
  @override
  final T value;

  ConfigValueFake(this.value);

  @override
  String get id => 'fake';
  @override
  String get stringValue => value.toString();
}
