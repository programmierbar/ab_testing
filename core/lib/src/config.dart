import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/experiment.dart';

/// A logger that is used to log experiment information.
abstract class ExperimentLogger {
  void log(String message);
  void logExperiments(List<Experiment> experiments);
}

/// Base class for an application's experiment configuration.
class ExperimentConfig {
  final List<ExperimentAdapter> _adapters;
  final ExperimentLogger? _logger;
  final String? _inactiveStringValue;

  ExperimentConfig(
    this._adapters, {
    ExperimentLogger? logger,
    String? inactiveStringValue,
  })  : _logger = logger,
        _inactiveStringValue = inactiveStringValue;

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
  /// to this value.
  Map<String, String> asMap() => {
        for (final experiment in _allExperiments) //
          experiment.id: _experimentMapValue(experiment)
      };

  String _experimentMapValue(Experiment experiment) {
    final inactiveStringValue = _inactiveStringValue;
    if (inactiveStringValue == null) {
      return experiment.stringValue;
    }
    return experiment.active ? experiment.stringValue : inactiveStringValue;
  }
}
