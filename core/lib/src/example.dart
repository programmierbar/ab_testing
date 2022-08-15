import 'package:ab_testing_core/src/adapter.dart';
import 'package:ab_testing_core/src/config.dart';
import 'package:ab_testing_core/src/local_adapter.dart';
import 'package:ab_testing_core/src/test_value.dart';

enum ExampleEnum { control, test }

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
