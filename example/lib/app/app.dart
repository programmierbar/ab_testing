import 'package:example/app/page/home_page.dart';
import 'package:flutter/material.dart';

enum ButtonColor { red, blue, green }

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'A/B Testing',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xff21022C)),
        builder: (context, child) {
          return const HomePage();
        });
  }
}
