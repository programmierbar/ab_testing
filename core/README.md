A Dart package that helps to implement multiple a/b tests.

## Features

This package simplifies the creation and management of multiple a/b tests. It comes with a local adapter for local a/b tests and can be extended with further adapters. It supports test values of the types bool, int and enum.

The package `ab_testing_firebase` provides an additional firebase adapter that simplifies remote a/b tests.


## Getting started

You need to do add `ab_testing_core` to the dependencies of the pubspec.yaml

```dart
dependencies:
ab_testing_core: ^1.0.0
```

## Usage

You can create your own testing config with all the test values you need. Directly during initialisation, you can select which adapter is to be used for the respective test value.

```dart
class ExampleConfig extends TestingConfig {
  final TestValue<bool> boolTestValue;
  final TestValue<int> intTestValue;
  final TestValue<ExampleEnum> enumTestValue;

  factory ExampleConfig() {
    return ExampleConfig._(
      LocalTestingAdapter(() async => 12345),
    );
  }

  ExampleConfig._(TestingAdapter localTests)
      : boolTestValue = localTests.boolTestValue(id: 'boolTest'),
        intTestValue = localTests.intTestValue(id: 'intTest'),
        enumTestValue = localTests.enumTestValue(
            id: 'enumTest',
            defaultValue: ExampleEnum.control,
            validValues: ExampleEnum.values,
            weightedValues: {ExampleEnum.control: 1, ExampleEnum.test: 1}),
        super([localTests]);
}
```
