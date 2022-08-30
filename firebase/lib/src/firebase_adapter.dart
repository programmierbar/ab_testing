import 'package:ab_testing_core/ab_testing_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseExperimentAdapter extends UpdatableExperimentAdapter {
  final Duration _expiration;
  final ExperimentLogger? _logger;
  final _fetchTimeout = const Duration(minutes: 1); // SDK default
  late final FirebaseRemoteConfig _config;
  Map<String, RemoteConfigValue> _values = {};

  FirebaseExperimentAdapter([this._expiration = const Duration(hours: 4), this._logger]);

  /// If no experiments are provided the adapter will stay uninitialized.
  @override
  Future<void> init() async {
    if (experiments.isEmpty) return;

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
      _logger?.log('Failed to fetch remote config');
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
