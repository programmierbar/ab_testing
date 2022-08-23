import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/config.dart';
import 'package:ab_testing_core/src/experiment.dart';
import 'package:ab_testing_core/src/local_adapter.dart';

enum ExampleEnum { control, test }

class ExampleConfig extends TestingConfig {
  final Experiment<bool> booleanExperiment;
  final Experiment<int> numericExperiment;
  final Experiment<ExampleEnum> enumeratedExperiment;

  factory ExampleConfig() {
    return ExampleConfig._(
      LocalTestingAdapter(() async => 12345),
    );
  }

  ExampleConfig._(TestingAdapter localTests)
      : booleanExperiment = localTests.boolean(id: 'boolTest'),
        numericExperiment = localTests.numeric(id: 'intTest'),
        enumeratedExperiment = localTests.enumerated(
          id: 'enumTest',
          defaultVariant: ExampleEnum.control,
          weightedVariants: {ExampleEnum.control: 1, ExampleEnum.test: 1},
        ),
        super([localTests]);
}
