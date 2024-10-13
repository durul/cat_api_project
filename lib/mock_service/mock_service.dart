import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../api/cats_api.dart';
import '../model/cats.dart';
import '../network/model_response.dart';

class MockService {
  Future<CatResponse> mockGetCatBreeds({int page = 0, int limit = 10}) async {
    final jsonString = await rootBundle.loadString('assets/cats.json');
    final catsResults = BreedList.fromJson(jsonDecode(jsonString));

    return Result<List<Breed>>.success(catsResults.breeds);
  }
}
