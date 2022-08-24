Two Dart packages that help to implement multiple a/b tests.

## Features

The `ab_testing` packages simplify the creation and management of multiple a/b tests. 

The `ab_testing_core` package comes with a local adapter for local a/b tests, 
while you can find an additional firebase adapter in the `ab_testing_firebase` package 
that enables remote a/b tests with the Firebase Remote Config. 

You can also extend the package with further adapters. It supports test values of the types `bool`, `int`, `String` and `Enum`.

## Getting started

You need to add `ab_testing_core` and `ab_testing_firebase` to the dependencies of the pubspec.yaml.

```
dependencies:
ab_testing_core: ^1.0.0
ab_testing_firebase: ^1.0.0
```

## Usage

You can find more information on how to use the packages in the respective readme files.