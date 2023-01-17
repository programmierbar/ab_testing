import 'package:ab_testing_core/ab_testing_core.dart';

enum ExampleEnum { control, test }

class ExampleExperimentConfig extends ExperimentConfig {
  /// local experiments
  final Experiment<bool> _booleanExperiment;
  final Experiment<int> _numericExperiment;

  /// remote experiments
  final Experiment<String> _textExperiment;
  final Experiment<ExampleEnum> _enumeratedExperiment;

  ExampleExperimentConfig(
    ExperimentAdapter localExperiments,
    ExperimentAdapter remoteExperiments, [
    ExperimentLogger? logger,
  ])  : _booleanExperiment = localExperiments.boolean(id: 'local_bool'),
        _numericExperiment = localExperiments.numeric(id: 'local_int'),
        _textExperiment = remoteExperiments.text(id: 'remote_text'),
        _enumeratedExperiment = remoteExperiments.enumerated(
          id: 'remote_enum',
          defaultVariant: ExampleEnum.control,
          variants: ExampleEnum.values,
        ),
        super([localExperiments, remoteExperiments], logger: logger);

  bool get booleanExperiment => _booleanExperiment.value;
  int get numericExperiment => _numericExperiment.value;
  String get textExperiment => _textExperiment.value;
  ExampleEnum get enumeratedExperiment => _enumeratedExperiment.value;
}
