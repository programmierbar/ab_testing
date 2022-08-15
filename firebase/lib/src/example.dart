import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/config.dart';
import 'package:ab_testing_core/src/local_adapter.dart';
import 'package:ab_testing_core/src/test_value.dart';
import 'package:ab_testing_firebase/src/firebase_adapter.dart';

class ExampleConfig extends TestingConfig {
  final TestValue<bool> localTest;
  final TestValue<bool> remoteTest;

  factory ExampleConfig() {
    return ExampleConfig._(
      LocalTestingAdapter(() async => 12345),
      FirebaseTestingAdapter(),
    );
  }

  ExampleConfig._(TestingAdapter localTests, TestingAdapter remoteTests)
      : localTest = localTests.boolTestValue(id: 'localTest'),
        remoteTest = remoteTests.boolTestValue(id: 'remoteTest'),
        super([localTests, remoteTests]);
}
