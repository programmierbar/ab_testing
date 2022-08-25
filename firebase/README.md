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

You can create your own configuration that extends the ExperimentConfig class with all the adapters and experiments you need. Directly during initialisation, you can select which adapter should be used for the respective experiment.

```dart
class ExampleExperimentConfig extends ExperimentConfig {
  final Experiment<bool> localExperiment;
  final Experiment<bool> remoteExperiment;

  ExampleExperimentConfig(ExperimentAdapter localExperiments, ExperimentAdapter remoteExperiments)
      : localExperiment = localExperiments.boolean(id: 'localExperiment'),
        remoteExperiment = remoteExperiments.boolean(id: 'remoteExperiment'),
        super([localExperiments, remoteExperiments]);
}
```

After initialisation, you can pass your ExperimentAdapters to your ExperimentConfig.

```dart
final _localExperiments = LocalExperimentAdapter(_storage.userSeed);
final _remoteExperiments = FirebaseExperimentAdapter();
final _experimentConfig = ExampleExperimentConfig(_localExperiments, _remoteExperiments);
```

Afterwards, you can easily access the experiments in your app via your Config.

```dart
bool get local => _experimentConfig.localExperiment.value;
bool get remote => _experimentConfig.remoteExperiment.value;
```