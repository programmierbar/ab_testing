import 'package:ab_testing_core/core.dart';
import 'package:ab_testing_example/app/storage/storage.dart';
import 'package:ab_testing_example/app/utility/console_logger.dart';
import 'package:ab_testing_example/app/viewmodel/home_model.dart';
import 'package:ab_testing_example/tests.dart';
import 'package:ab_testing_firebase/firebase.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final _storage = Storage();
final _localExperiments = LocalExperimentsAdapter(_storage.userSeed);
final _remoteExperiments = FirebaseExperimentsAdapter();
final _experimentsConfig = Config(_localExperiments, _remoteExperiments, ConsoleLogger('app'));
final _homeModel = HomeModel(_experimentsConfig);

final List<SingleChildWidget> serviceProviders = [
  Provider<Config>.value(value: _experimentsConfig),
  Provider<HomeModel>.value(value: _homeModel),
];

Future<void> initServices() async {
  await _experimentsConfig.init();
}
