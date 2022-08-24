import 'package:ab_testing_core/core.dart';

class ConsoleLogger implements TestingLogger {
  final String domain;

  ConsoleLogger(this.domain);

  @override
  void log(String entry) {
    print('[$domain] $entry'); // ignore: avoid_print
  }

  @override
  void logExperiments(List<Experiment> experiments) {
    print('[experiments] $experiments'); // ignore: avoid_print
  }
}
