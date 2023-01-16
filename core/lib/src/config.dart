import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/experiment.dart';

/// A logger that is used to log experiment information.
abstract class ExperimentLogger {
  void log(String message);
  void logExperiments(List<Experiment> experiments);
}

/// Base class for an application's experiment configuration.
class ExperimentConfig {
  /// The string value that will be used for inactive experiments in [asMap].
  final String? inactiveStringValue;

  final List<ExperimentAdapter> _adapters;
  final ExperimentLogger? _logger;

  ExperimentConfig(
    this._adapters, {
    ExperimentLogger? logger,
    this.inactiveStringValue,
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

  /// Returns a mapping of all experiments from their id to their string
  /// value.
  ///
  /// If [inactiveStringValue] is set, all inactive experiments will be mapped
  /// to this value. If [inactiveStringValue] is not set, inactive experiments
  /// will not be included in the mapping.
  Map<String, String> asMap() {
    final inactiveStringValue = this.inactiveStringValue;
    final result = <String, String>{};
    for (final experiment in _allExperiments) {
      if (experiment.active) {
        result[experiment.id] = experiment.stringValue;
      } else if (inactiveStringValue != null) {
        result[experiment.id] = inactiveStringValue;
      }
    }
    return result;
  }
}
