<img src="https://repository-images.githubusercontent.com/524068551/e6bf53a7-dcd0-4a86-9b73-2bbe2e115b2f" alt="AbTesting"
title="AB Testing" width="480" />

# AB Testing - Core

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

You can create your own configuration that extends the ExperimentConfig class with all the adapters and experiments you need. Directly during initialisation, you can select which adapter should be used for the respective experiment.


```dart
class LocalExperimentConfig extends ExperimentConfig {
  final Experiment<bool> booleanExperiment;
  final Experiment<int> numericExperiment;
  final Experiment<String> textExperiment;
  final Experiment<ExampleEnum> enumeratedExperiment;

  LocalExperimentConfig(ExperimentAdapter localExperiments)
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

After initialisation, you can pass your ExperimentAdapters to your ExperimentConfig.

```dart
final _localExperiments = LocalExperimentAdapter(_storage.userSeed);
final _experimentConfig = LocalExperimentConfig(_localExperiments);
```

Afterwards, you can easily access the experiments in your app via your Config.

```dart
bool get boolean => _experimentConfig.booleanExperiment.value;
int get numeric => _experimentConfig.numericExperiment.value;
String get text => _experimentConfig.textExperiment.value;
ExampleEnum get enumerated => _experimentConfig.enumeratedExperiment.value;
```