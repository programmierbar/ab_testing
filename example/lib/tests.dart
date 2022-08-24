import 'package:ab_testing_core/core.dart';

enum ExampleEnum { control, test }

class TestConfig extends TestingConfig {
  /// local experiment
  final Experiment<bool> localExperiment;

  /// remote experiments
  final Experiment<bool> booleanExperiment;
  final Experiment<int> numericExperiment;
  final Experiment<String> textExperiment;
  final Experiment<ExampleEnum> enumeratedExperiment;

  TestConfig(TestingAdapter localTests, TestingAdapter remoteTests, [TestingLogger? logger])
      : localExperiment = localTests.boolean(id: 'localExperiment'),
        booleanExperiment = remoteTests.boolean(id: 'example_bool'),
        numericExperiment = remoteTests.numeric(id: 'example_int'),
        textExperiment = remoteTests.text(id: 'example_text'),
        enumeratedExperiment = remoteTests.enumerated(
          id: 'example_enum',
          defaultVariant: ExampleEnum.control,
          variants: ExampleEnum.values,
        ),
        super([localTests, remoteTests], logger);
}
