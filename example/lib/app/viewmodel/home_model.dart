import 'package:example/app/utility/console_logger.dart';
import 'package:example/tests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _logger = ConsoleLogger('home model');

class HomeModel {
  static HomeModel of(BuildContext context) => Provider.of<HomeModel>(context, listen: false);

  final TestConfig _tests;

  HomeModel(this._tests);

  bool get localExperiment => _tests.localExperiment.value;
  bool get booleanExperiment => _tests.booleanExperiment.value;
  int get numericExperiment => _tests.numericExperiment.value;
  String get textExperiment => _tests.textExperiment.value;
  ExampleEnum get enumeratedExperiment => _tests.enumeratedExperiment.value;

  Future<void> fetchNewConfigValues() async {
    await _tests.update();
    _logger.log('fetch new config values');
  }
}
