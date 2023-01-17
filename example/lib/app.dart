import 'package:ab_testing_example/experiments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'A/B Testing',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xff21022C)),
        builder: (context, child) {
          return const _ExperimentPage();
        });
  }
}

class _ExperimentPage extends StatefulWidget {
  const _ExperimentPage();

  @override
  State<_ExperimentPage> createState() => _ExperimentPageState();
}

class _ExperimentPageState extends State<_ExperimentPage> {
  @override
  Widget build(BuildContext context) {
    final experiments = Provider.of<ExampleExperimentConfig>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff3C0A87), Color(0xff32044F), Color(0xff21022C), Color(0xff050007)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50, bottom: 25),
                child: Center(
                  child: Text(
                    'A/B Testing',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ExperimentContainer(
                      name: 'boolean',
                      value: experiments.booleanExperiment,
                    ),
                    _ExperimentContainer(
                      name: 'numeric',
                      value: experiments.numericExperiment,
                    ),
                    _ExperimentContainer(
                      name: 'text',
                      value: experiments.textExperiment,
                    ),
                    _ExperimentContainer(
                      name: 'enumerated',
                      value: experiments.enumeratedExperiment.name,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.3)),
                onPressed: () async {
                  await experiments.update(force: true);
                  setState(() {});
                },
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('FETCH CONFIG',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperimentContainer extends StatelessWidget {
  final String name;
  final Object? value;

  const _ExperimentContainer({
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 35,
        width: 325,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SizedBox(width: 175, child: Text(name, style: textStyle.copyWith(color: Colors.purpleAccent))),
              Text(value.toString(), style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
