import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/config.dart';
import 'package:ab_testing_core/src/experiment.dart';

/// An [ExperimentAdapter] that caches the values of experiments to provide
/// faster access to experiment values in production setups.
class CachingExperimentAdapter extends ExperimentAdapter {
  final ExperimentAdapter _adapter;
  final Map<String, dynamic> _values = {};

  CachingExperimentAdapter(this._adapter);

  @override
  List<AdaptedExperiment> get experiments => _adapter.experiments;

  @override
  Future<void> init(ExperimentConfig config) => _adapter.init(config);

  @override
  bool has(String id) => _values.containsKey(id) || _adapter.has(id);

  @override
  T? get<T>(String id) => _values.putIfAbsent(id, () => _adapter.get<T>(id));
}
