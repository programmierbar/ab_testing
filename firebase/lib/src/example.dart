import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/experiment.dart';
import 'package:ab_testing_core/src/local_adapter.dart';
import 'package:ab_testing_core/src/testing.dart';
import 'package:ab_testing_firebase/src/firebase_adapter.dart';

class ExampleConfig extends TestingConfig {
  final Experiment<bool> localTest;
  final Experiment<bool> remoteTest;

  factory ExampleConfig() {
    return ExampleConfig._(
      LocalTestingAdapter(() async => 12345),
      FirebaseTestingAdapter(),
    );
  }

  ExampleConfig._(TestingAdapter localTests, TestingAdapter remoteTests)
      : localTest = localTests.boolExperiment(id: 'localTest'),
        remoteTest = remoteTests.boolExperiment(id: 'remoteTest'),
        super([localTests, remoteTests]);
}
