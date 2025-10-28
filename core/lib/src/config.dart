import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/experiment.dart';

/// A logger that is used to log experiment information.
abstract class ExperimentLogger {
  void log(String message);
  void logExperiments(ExperimentConfig config);
}

/// Base class for an application's experiment configuration.
class ExperimentConfig {
  /// The variant string value that will be used for inactive experiments in [trackingValues].
  ///
  /// See also [Experiment.trackingValue].
  final String? inactiveVariantValue;

  final List<ExperimentAdapter> _adapters;
  final ExperimentLogger? _logger;

  ExperimentConfig(
    this._adapters, {
    ExperimentLogger? logger,
    this.inactiveVariantValue,
  }) : _logger = logger;

  Iterable<AdaptedExperiment> get experiments =>
      _adapters.expand((adapter) => adapter.experiments);

  /// All enabled experiments
  List<Experiment> get enabledExperiments =>
      experiments.where((experiment) => experiment.enabled).toList();

  /// All active experiments.
  List<Experiment> get activeExperiments =>
      experiments.where((experiment) => experiment.active).toList();

  /// Returns a mapping of all experiments from their id to their tracking
  /// value.
  ///
  /// If [inactiveVariantValue] is set, all inactive experiments will be mapped
  /// to this value. If [inactiveVariantValue] is not set, inactive experiments
  /// will not be included in the mapping.
  Map<String, String> get trackingValues {
    return {
      for (final experiment in enabledExperiments)
        if (experiment.active)
          experiment.id: experiment.trackingValue
        else if (inactiveVariantValue != null)
          experiment.id: inactiveVariantValue!
    };
  }

  /// Initializes all adapters.
  Future<void> init() async {
    await Future.wait(_adapters.map((adapter) => adapter.init(this)));
    await Future.wait(experiments
        .whereType<CustomExperiment>()
        .map((experiment) => experiment.init()));
    _logger?.logExperiments(this);
  }

  /// Updates all updatable adapters.
  Future<void> update({bool force = false}) async {
    await Future.wait(
        _adapters.map((adapter) => adapter.update(this, force: force)));
    if (force) {
      _logger?.logExperiments(this);
    }
  }
}
