import 'package:ab_testing_core/core.dart';
import 'package:ab_testing_example/app.dart';
import 'package:ab_testing_example/experiments.dart';
import 'package:ab_testing_example/firebase_options.dart';
import 'package:ab_testing_firebase/firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Initialize the local experiments adapter with an consistent seed for each user.
final _localExperiments = LocalExperimentAdapter(() async => 1234);
final _remoteExperiments = FirebaseExperimentAdapter();
final _experimentConfig = ExampleExperimentConfig(_localExperiments, _remoteExperiments);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _experimentConfig.init();

  runApp(
    Provider(
      create: (_) => _experimentConfig,
      child: const App(),
    ),
  );
}
