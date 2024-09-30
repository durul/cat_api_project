import 'package:flutter/foundation.dart';

import '../api/cats_api.dart';
import '../model/cats.dart';

class CatDataProvider extends ChangeNotifier {
  final CatAPI catAPI;
  List<Breed> breeds = [];
  String? errorMessage;
  bool isLoading = false;
  CatBreed? catBreed;

  CatDataProvider({required this.catAPI});

  Future<void> getCatData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final catResponse = await catAPI.getCatBreeds();
      if (catResponse.isSuccess && catResponse.data != null) {
        breeds = catResponse.data ?? [];
      } else {
        throw Exception(catResponse.error ?? 'An unknown error occurred');
      }
    } catch (e) {
      errorMessage = e.toString();
      print('Error fetching cat breeds: $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCatSpecificData(String catId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final catBreedResponse = await catAPI.getCatBreed(catId);

      if (catBreedResponse.isSuccess && catBreedResponse.data != null) {
        catBreed = catBreedResponse.data;
      } else {
        throw Exception(catBreedResponse.error ?? 'An unknown error occurred');
      }
    } catch (e) {
      errorMessage = e.toString();
      print('Error fetching cat breed: $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
