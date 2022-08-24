import 'package:example/app/viewmodel/home_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeModel _homeModel;

  @override
  void initState() {
    super.initState();
    _homeModel = HomeModel.of(context);
  }

  @override
  Widget build(BuildContext context) {
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
                      name: 'local',
                      value: _homeModel.localExperiment.toString(),
                    ),
                    _ExperimentContainer(
                      name: 'boolean',
                      value: _homeModel.booleanExperiment.toString(),
                    ),
                    _ExperimentContainer(
                      name: 'numeric',
                      value: _homeModel.numericExperiment.toString(),
                    ),
                    _ExperimentContainer(
                      name: 'text',
                      value: _homeModel.textExperiment,
                    ),
                    _ExperimentContainer(
                      name: 'enumerated',
                      value: _homeModel.enumeratedExperiment.name,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white.withOpacity(0.3)),
                onPressed: () async {
                  await _homeModel.fetchNewConfigValues();
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
  final String value;

  const _ExperimentContainer({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

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
              Text(value, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
