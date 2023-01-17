import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/experiment.dart';

/// A logger that is used to log experiment information.
abstract class ExperimentLogger {
  void log(String message);
  void logExperiments(List<Experiment> experiments);
}

/// Base class for an application's experiment configuration.
class ExperimentConfig {
  /// The tracking value that will be used for inactive experiments in [asMap].
  ///
  /// See also [Experiment.trackingValue].
  final String? inactiveTrackingValue;

  final List<ExperimentAdapter> _adapters;
  final ExperimentLogger? _logger;

  ExperimentConfig(
    this._adapters, {
    ExperimentLogger? logger,
    this.inactiveTrackingValue,
  }) : _logger = logger;

  /// All active experiments.
  List<Experiment> get experiments => _allExperiments.where((value) => value.active).toList();

  List<Experiment> get _allExperiments => _adapters.expand((adapter) => adapter.experiments).toList();

  /// Initializes all adapters.
  Future<void> init() async {
    await Future.wait(_adapters.map((adapter) => adapter.init()));
    update();
    _logger?.logExperiments(experiments);
  }

  /// Updates all updatable adapters.
  Future<void> update({bool force = false}) async {
    final adapters = _adapters.whereType<UpdatableExperimentAdapter>();
    if (adapters.isNotEmpty) {
      await Future.wait(adapters.map((adapter) => adapter.update(force: force)));
      if (force) {
        _logger?.logExperiments(experiments);
      }
    }
  }

  /// Returns a mapping of all experiments from their id to their tracking
  /// value.
  ///
  /// If [inactiveTrackingValue] is set, all inactive experiments will be mapped
  /// to this value. If [inactiveTrackingValue] is not set, inactive experiments
  /// will not be included in the mapping.
  Map<String, String> asMap() {
    return {
      for (final experiment in _allExperiments)
        if (experiment.active)
          experiment.id: experiment.trackingValue
        else if (inactiveTrackingValue != null)
          experiment.id: inactiveTrackingValue!
    };
  }
}
