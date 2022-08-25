import 'package:ab_testing_core/core.dart';

enum ExampleEnum { control, test }

class Config extends ExperimentsConfig {
  /// local experiment
  final Experiment<bool> localExperiment;

  /// remote experiments
  final Experiment<bool> booleanExperiment;
  final Experiment<int> numericExperiment;
  final Experiment<String> textExperiment;
  final Experiment<ExampleEnum> enumeratedExperiment;

  Config(ExperimentsAdapter localExperiments, ExperimentsAdapter remoteExperiments, [ExperimentsLogger? logger])
      : localExperiment = localExperiments.boolean(id: 'localExperiment'),
        booleanExperiment = remoteExperiments.boolean(id: 'example_bool'),
        numericExperiment = remoteExperiments.numeric(id: 'example_int'),
        textExperiment = remoteExperiments.text(id: 'example_text'),
        enumeratedExperiment = remoteExperiments.enumerated(
          id: 'example_enum',
          defaultVariant: ExampleEnum.control,
          variants: ExampleEnum.values,
        ),
        super([localExperiments, remoteExperiments], logger);
}
