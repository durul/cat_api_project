import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../model/cats.dart';

class MockService {
  Future loadCats() async {
    final jsonString = await rootBundle.loadString('assets/cats.json');
    final catsResults = BreedList.fromJson(jsonDecode(jsonString));

    return catsResults;
  }
}
