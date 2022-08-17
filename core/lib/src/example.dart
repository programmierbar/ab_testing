import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/config.dart';
import 'package:ab_testing_core/src/local_adapter.dart';
import 'package:ab_testing_core/src/test.dart';

enum ExampleEnum { control, test }

class ExampleConfig extends TestingConfig {
  final Test<bool> booleanTest;
  final Test<int> numericTest;
  final Test<ExampleEnum> enumeratedTest;

  factory ExampleConfig() {
    return ExampleConfig._(
      LocalTestingAdapter(() async => 12345),
    );
  }

  ExampleConfig._(TestingAdapter localTests)
      : booleanTest = localTests.boolean(id: 'boolTest'),
        numericTest = localTests.numeric(id: 'intTest'),
        enumeratedTest = localTests.enumerated(
          id: 'enumTest',
          defaultVariant: ExampleEnum.control,
          weightedVariants: {ExampleEnum.control: 1, ExampleEnum.test: 1},
        ),
        super([localTests]);
}
