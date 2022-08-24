import 'package:ab_testing_core/core.dart';
import 'package:ab_testing_firebase/firebase.dart';

enum ExampleEnum { control, test }

class ExampleConfigLocal extends TestingConfig {
  final Experiment<bool> booleanExperiment;
  final Experiment<int> numericExperiment;
  final Experiment<String> textExperiment;
  final Experiment<ExampleEnum> enumeratedExperiment;

  factory ExampleConfigLocal() {
    return ExampleConfigLocal._(
      LocalTestingAdapter(() async => 12345),
    );
  }

  ExampleConfigLocal._(TestingAdapter localTests)
      : booleanExperiment = localTests.boolean(id: 'boolExperiment'),
        numericExperiment = localTests.numeric(id: 'intExperiment'),
        textExperiment = localTests.text(id: 'textExperiment'),
        enumeratedExperiment = localTests.enumerated(
          id: 'enumExperiment',
          defaultVariant: ExampleEnum.control,
          weightedVariants: {ExampleEnum.control: 1, ExampleEnum.test: 1},
        ),
        super([localTests]);
}

class ExampleConfigLocalAndRemote extends TestingConfig {
  final Experiment<bool> localExperiment;
  final Experiment<bool> remoteExperiment;

  factory ExampleConfigLocalAndRemote() {
    return ExampleConfigLocalAndRemote._(
      LocalTestingAdapter(() async => 12345),
      FirebaseTestingAdapter(),
    );
  }

  ExampleConfigLocalAndRemote._(TestingAdapter localTests, TestingAdapter remoteTests)
      : localExperiment = localTests.boolean(id: 'localExperiment'),
        remoteExperiment = remoteTests.boolean(id: 'remoteExperiment'),
        super([localTests, remoteTests]);
}
