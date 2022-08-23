import 'package:ab_testing_core/core.dart';
import 'package:ab_testing_firebase/src/firebase_adapter.dart';

class ExampleConfig extends TestingConfig {
  final Experiment<bool> localExperiment;
  final Experiment<bool> remoteExperiment;

  factory ExampleConfig() {
    return ExampleConfig._(
      LocalTestingAdapter(() async => 12345),
      FirebaseTestingAdapter(),
    );
  }

  ExampleConfig._(TestingAdapter localTests, TestingAdapter remoteTests)
      : localExperiment = localTests.boolean(id: 'localTest'),
        remoteExperiment = remoteTests.boolean(id: 'remoteTest'),
        super([localTests, remoteTests]);
}
