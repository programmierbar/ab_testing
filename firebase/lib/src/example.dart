import 'package:ab_testing_core/core.dart';
import 'package:ab_testing_firebase/src/firebase_adapter.dart';

class ExampleConfig extends TestingConfig {
  final Test<bool> localTest;
  final Test<bool> remoteTest;

  factory ExampleConfig() {
    return ExampleConfig._(
      LocalTestingAdapter(() async => 12345),
      FirebaseTestingAdapter(),
    );
  }

  ExampleConfig._(TestingAdapter localTests, TestingAdapter remoteTests)
      : localTest = localTests.boolean(id: 'localTest'),
        remoteTest = remoteTests.boolean(id: 'remoteTest'),
        super([localTests, remoteTests]);
}
