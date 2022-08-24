import 'package:ab_testing_example/app/app.dart';
import 'package:ab_testing_example/firebase_options.dart';
import 'package:ab_testing_example/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initServices();

  runApp(MultiProvider(
    providers: serviceProviders,
    child: const App(),
  ));
}
