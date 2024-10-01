import 'package:flutter/material.dart';

import '../api/cats_api.dart';
import '../model/cats.dart';

class CatDataProvider extends ChangeNotifier {
  final CatAPI catAPI;
  List<Breed> breeds = [];
  String? errorMessage;
  bool isLoading = false;
  bool isLoadMoreLoading = false;
  bool isLastPage = false;
  int currentPage = 0;
  final int limit = 10; // Number of items per page
  CatBreed? catBreed;

  CatDataProvider({required this.catAPI});

  Future<void> getCatData({bool isLoadMore = false}) async {
    if (isLoadMore && isLastPage) return;

    try {
      // Loading state management
      if (isLoadMore) {
        isLoadMoreLoading = true;
      } else {
        isLoading = true;
      }

      notifyListeners();

      final catResponse =
          await catAPI.getCatBreeds(page: currentPage, limit: limit);
      if (catResponse.isSuccess && catResponse.data != null) {
        final newBreeds = catResponse.data ?? [];
        if (newBreeds.isEmpty) {
          isLastPage = true;
        }

        if (isLoadMore) {
          breeds.addAll(newBreeds);
        } else {
          breeds = newBreeds;
        }

        currentPage++;
      } else {
        errorMessage = catResponse.error ?? 'An unknown error occurred';
      }
    } catch (e) {
      errorMessage = e.toString();
      print('Error fetching cat breeds: $errorMessage');
    } finally {
      if (isLoadMore) {
        isLoadMoreLoading = false;
      } else {
        isLoading = false;
      }
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

  Future<void> reloadBreeds() async {
    // Reset the pagination data for a fresh load
    currentPage = 1;
    isLastPage = false;
    breeds.clear();
    await getCatData();
  }
}
