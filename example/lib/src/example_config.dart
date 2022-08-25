import 'package:ab_testing_core/core.dart';
import 'package:ab_testing_firebase/firebase.dart';

enum ExampleEnum { control, test }

class LocalExperimentsConfig extends ExperimentsConfig {
  final Experiment<bool> booleanExperiment;
  final Experiment<int> numericExperiment;
  final Experiment<String> textExperiment;
  final Experiment<ExampleEnum> enumeratedExperiment;

  factory LocalExperimentsConfig() {
    return LocalExperimentsConfig._(
      LocalExperimentsAdapter(() async => 12345),
    );
  }

  LocalExperimentsConfig._(ExperimentsAdapter localExperiments)
      : booleanExperiment = localExperiments.boolean(id: 'boolExperiment'),
        numericExperiment = localExperiments.numeric(id: 'intExperiment'),
        textExperiment = localExperiments.text(id: 'textExperiment'),
        enumeratedExperiment = localExperiments.enumerated(
          id: 'enumExperiment',
          defaultVariant: ExampleEnum.control,
          weightedVariants: {ExampleEnum.control: 1, ExampleEnum.test: 1},
        ),
        super([localExperiments]);
}

class ExampleExperimentsConfig extends ExperimentsConfig {
  final Experiment<bool> localExperiment;
  final Experiment<bool> remoteExperiment;

  factory ExampleExperimentsConfig() {
    return ExampleExperimentsConfig._(
      LocalExperimentsAdapter(() async => 12345),
      FirebaseExperimentsAdapter(),
    );
  }

  ExampleExperimentsConfig._(ExperimentsAdapter localExperiments, ExperimentsAdapter remoteExperiments)
      : localExperiment = localExperiments.boolean(id: 'localExperiment'),
        remoteExperiment = remoteExperiments.boolean(id: 'remoteExperiment'),
        super([localExperiments, remoteExperiments]);
}
