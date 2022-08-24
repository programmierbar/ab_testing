import 'package:ab_testing_core/core.dart';
import 'package:ab_testing_example/app/storage/storage.dart';
import 'package:ab_testing_example/app/utility/console_logger.dart';
import 'package:ab_testing_example/app/viewmodel/home_model.dart';
import 'package:ab_testing_example/tests.dart';
import 'package:ab_testing_firebase/firebase.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final _storage = Storage();
final _localTests = LocalTestingAdapter(_storage.userSeed);
final _remoteTests = FirebaseTestingAdapter();
final _testConfig = TestConfig(_localTests, _remoteTests, ConsoleLogger('app'));
final _homeModel = HomeModel(_testConfig);

final List<SingleChildWidget> serviceProviders = [
  Provider<TestConfig>.value(value: _testConfig),
  Provider<HomeModel>.value(value: _homeModel),
];

Future<void> initServices() async {
  await _testConfig.init();
}
