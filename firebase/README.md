A Dart package that simplifies the implementation of remote a/b tests with the Firebase Remote Config.

## Features

This package extends the `ab_testing_core` package with an additional firebase adapter and thus enables remote a/b tests with the Firebase Remote Config.

## Getting started

You need to add `ab_testing_core` and `ab_testing_firebase` to the dependencies of the pubspec.yaml.

```
dependencies:
ab_testing_core: ^1.0.0
ab_testing_firebase: ^1.0.0
```

## Usage

You can create your own configuration that extends the TestingConfig class with all the adapters and experiments you need. Directly during initialisation, you can select which adapter should be used for the respective experiment.

```dart
class ExampleConfig extends TestingConfig {
  final Experiment<bool> localExperiment;
  final Experiment<bool> remoteExperiment;

  ExampleConfig(TestingAdapter localTests, TestingAdapter remoteTests)
      : localExperiment = localTests.boolean(id: 'localExperiment'),
        remoteExperiment = remoteTests.boolean(id: 'remoteExperiment'),
        super([localTests, remoteTests]);
}
```

After initialisation, you can pass your Testing Adapters to your Config.

```dart
final _localTests = LocalTestingAdapter(_storage.userSeed);
final _testConfig = ExampleConfig(_localTests);
```

Afterwards, you can easily access the experiments in your app via your Config.

```dart
bool get local => _testConfig.localExperiment.value;
bool get remote => _testConfig.remoteExperiment.value;
```