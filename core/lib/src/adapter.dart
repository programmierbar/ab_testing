import 'package:ab_testing_core/src/item.dart';

abstract class ConfigAdapter {
  String get name;

  Future<void> init(Iterable<ConfigItem> items);
  bool has(String id);
  T? get<T>(String id);
}

abstract class UpdatableConfigAdapter extends ConfigAdapter {
  Future<void> update({bool force = false});
}
