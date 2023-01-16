import 'package:ab_testing_core/ab_testing_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// An [ExperimentAdapter] that uses the Firebase Remote Config SDK to fetch
/// experiment values.
class FirebaseExperimentAdapter extends UpdatableExperimentAdapter {
  /// The Firebase Remote Config instance that will be used to fetch values.
  ///
  /// If no value is provided, [FirebaseRemoteConfig.instance] will be used.
  final FirebaseRemoteConfig? remoteConfig;

  /// The expiration time of the fetched values after which they will be
  /// refreshed.
  final Duration expiration;

  /// The logger that will be used by this adapter.
  final ExperimentLogger? logger;

  final _fetchTimeout = const Duration(minutes: 1); // SDK default
  Map<String, RemoteConfigValue> _values = {};

  FirebaseRemoteConfig get _remoteConfig => remoteConfig ?? FirebaseRemoteConfig.instance;

  FirebaseExperimentAdapter({
    this.remoteConfig,
    this.expiration = const Duration(hours: 4),
    this.logger,
  });

  /// If no experiments are provided the adapter will stay uninitialized.
  @override
  Future<void> init() async {
    if (experiments.isEmpty) return;

    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: _fetchTimeout,
      minimumFetchInterval: expiration,
    ));

    await _remoteConfig.activate();
    await _remoteConfig.ensureInitialized();

    _values = _remoteConfig.getAll();
  }

  /// The update method will fetch the config values from the remote node.
  @override
  Future<void> update({bool force = false}) async {
    if (force) {
      await _setFetchInterval(Duration.zero);
    }
    try {
      await _remoteConfig.fetch();
      if (force) {
        await _remoteConfig.activate();
      }
    } catch (error) {
      logger?.log('Failed to fetch remote config');
    }
    _values = _remoteConfig.getAll();
    if (force) {
      await _setFetchInterval(expiration);
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
    return _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: _fetchTimeout,
        minimumFetchInterval: duration,
      ),
    );
  }
}
