import 'package:ab_testing_core/ab_testing_core.dart';
import 'package:ab_testing_example/app.dart';
import 'package:ab_testing_example/experiments.dart';
import 'package:ab_testing_firebase/ab_testing_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Initialize the local experiments adapter with an consistent seed for each user.
final _localExperiments = LocalExperimentAdapter(resolveUserSeed: () => 1234);
final _remoteExperiments = FirebaseExperimentAdapter();
final _experimentConfig =
    ExampleExperimentConfig(_localExperiments, _remoteExperiments);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _experimentConfig.init();

  runApp(
    Provider.value(
      value: _experimentConfig,
      child: const App(),
    ),
  );
}
