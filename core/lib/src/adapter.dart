abstract class ConfigAdapter {
  bool get local;
  Future<void> init(Iterable<ConfigItem> items);
  bool has(String id);
  T? get<T>(String id);
}

abstract class UpdatableConfigAdapter extends ConfigAdapter {
  Future<void> update({bool force = false});
}
