import 'package:ab_testing_example/app/utility/console_logger.dart';
import 'package:ab_testing_example/tests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _logger = ConsoleLogger('home model');

class HomeModel {
  static HomeModel of(BuildContext context) => Provider.of<HomeModel>(context, listen: false);

  final Config _experiments;

  HomeModel(this._experiments);

  bool get localExperiment => _experiments.localExperiment.value;
  bool get booleanExperiment => _experiments.booleanExperiment.value;
  int get numericExperiment => _experiments.numericExperiment.value;
  String get textExperiment => _experiments.textExperiment.value;
  ExampleEnum get enumeratedExperiment => _experiments.enumeratedExperiment.value;

  Future<void> fetchNewConfigValues() async {
    await _experiments.update();
    _logger.log('fetch new config values');
  }
}
