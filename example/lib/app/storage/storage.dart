import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<int> userSeed() async {
    final preferences = await SharedPreferences.getInstance();
    int? seed = preferences.getInt('userSeed');
    if (seed == null) {
      seed = Random().nextInt(1 << 31);
      await preferences.setInt('userSeed', seed);
    }
    return seed;
  }
}
