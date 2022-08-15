import 'package:ab_testing_core/src/adapter.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseTestingAdapter extends UpdatableTestingAdapter {
  final Duration _expiration;
  final _fetchTimeout = const Duration(minutes: 1); // SDK default
  late final FirebaseRemoteConfig _config;
  Map<String, RemoteConfigValue> _values = {};

  FirebaseTestingAdapter([this._expiration = const Duration(hours: 4)]);

  @override
  String get name => 'remote';

  /// The init method will only initialize the previously loaded values
  /// of the remote config. If the specified value parameter is empty,
  /// the RemoteConfigAdapter will stay uninitialized.
  @override
  Future<void> init() async {
    if (tests.isEmpty) return;

    _config = FirebaseRemoteConfig.instance;
    await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: _fetchTimeout,
      minimumFetchInterval: _expiration,
    ));

    await _config.activate();
    await _config.ensureInitialized();

    _values = _config.getAll();
  }

  /// The update method will fetch the config values from the remote node.
  @override
  Future<void> update({bool force = false}) async {
    if (force) {
      await _setFetchInterval(Duration.zero);
    }
    try {
      await _config.fetch();
      if (force) {
        await _config.activate();
      }
    } catch (error) {
      // Failed to fetch remote config
    }
    _values = _config.getAll();
    if (force) {
      await _setFetchInterval(_expiration);
    }
  }

  @override
  bool has(String id) => _values.containsKey(id);

  @override
  T? get<T>(String id) {
    final value = _values[id];
    if (value == null) {
      return null;
    } else if (T == bool) {
      return value.asBool() as T;
    } else if (T == int) {
      return value.asInt() as T;
    } else {
      return value.asString() as T;
    }
  }

  Future<void> _setFetchInterval(Duration duration) {
    return _config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: _fetchTimeout,
        minimumFetchInterval: duration,
      ),
    );
  }
}
