A Dart package that simplifies the implementation of remote a/b tests with the Firebase Remote Config.

## Features

This package extends the `ab_testing_core` package with an additional firebase adapter and thus enables remote a/b tests with the Firebase Remote Config.

## Getting started

You need to do add `ab_testing_core` and `ab_testing_firebase` to the dependencies of the pubspec.yaml

```dart
dependencies:
ab_testing_core: ^1.0.0
ab_testing_firebase: ^1.0.0
```

## Usage

You can create your own testing config with all the test values you need. Directly during initialisation, you can select which adapter is to be used for the respective test value.

```dart
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
```
