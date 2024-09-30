import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../model/cats.dart';

class MockService {
  Future loadCats() async {
    var jsonString = await rootBundle.loadString('assets/cats.json');
    var catsResults = BreedList.fromJson(jsonDecode(jsonString));

    return catsResults;
  }
}
