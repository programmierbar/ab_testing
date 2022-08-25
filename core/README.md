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

You can create your own configuration that extends the ExperimentsConfig class with all the adapters and experiments you need. Directly during initialisation, you can select which adapter should be used for the respective experiment.


```dart
class LocalExperimentsConfig extends ExperimentsConfig {
  final Experiment<bool> booleanExperiment;
  final Experiment<int> numericExperiment;
  final Experiment<String> textExperiment;
  final Experiment<ExampleEnum> enumeratedExperiment;

  LocalExperimentsConfig(ExperimentsAdapter localExperiments)
      : booleanExperiment = localExperiments.boolean(id: 'boolExperiment'),
        numericExperiment = localExperiments.numeric(id: 'intExperiment'),
        textExperiment = localExperiments.text(id: 'textExperiment'),
        enumeratedExperiment = localExperiments.enumerated(
          id: 'enumExperiment',
          defaultVariant: ExampleEnum.control,
          weightedVariants: {ExampleEnum.control: 1, ExampleEnum.test: 1},
        ),
        super([localExperiments]);
}
```

After initialisation, you can pass your ExperimentAdapters to your ExperimentsConfig.

```dart
final _localExperiments = LocalExperimentsAdapter(_storage.userSeed);
final _experimentsConfig = LocalExperimentsConfig(_localExperiments);
```

Afterwards, you can easily access the experiments in your app via your Config.

```dart
bool get boolean => _experimentsConfig.booleanExperiment.value;
int get numeric => _experimentsConfig.numericExperiment.value;
String get text => _experimentsConfig.textExperiment.value;
ExampleEnum get enumerated => _experimentsConfig.enumeratedExperiment.value;
```