A Dart package that helps to implement multiple a/b tests.

## Features

This package simplifies the creation and management of multiple a/b tests. It comes with a local adapter for local a/b tests and can be extended with further adapters. It supports test values of the types `bool`, `int`, `String` and `Enum`.

The package `ab_testing_firebase` provides an additional firebase adapter that simplifies remote a/b tests.


## Getting started

You need to add `ab_testing_core` to the dependencies of the pubspec.yaml.

```
dependencies:
ab_testing_core: ^1.0.0
```

## Usage

You can create your own configuration that extends the TestingConfig class with all the adapters and experiments you need. Directly during initialisation, you can select which adapter should be used for the respective experiment.


```dart
class ExampleConfig extends TestingConfig {
  final Experiment<bool> booleanExperiment;
  final Experiment<int> numericExperiment;
  final Experiment<String> textExperiment;
  final Experiment<ExampleEnum> enumeratedExperiment;

  ExampleConfig(TestingAdapter localTests)
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
```

After initialisation, you can pass your Testing Adapters to your Config.

```dart
final _localTests = LocalTestingAdapter(_storage.userSeed);
final _testConfig = ExampleConfig(_localTests);
```

Afterwards, you can easily access the experiments in your app via your Config.

```dart
bool get boolean => _testConfig.booleanExperiment.value;
int get numeric => _testConfig.numericExperiment.value;
String get text => _testConfig.textExperiment.value;
ExampleEnum get enumerated => _testConfig.enumeratedExperiment.value;
```