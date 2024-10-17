import 'package:flutter/material.dart';

import '../api/cats_api.dart';
import '../mock_service/mock_service.dart';
import '../model/cats.dart';
import '../network/connectivity_monitor.dart';

class CatDataManager extends ChangeNotifier {
  final CatAPI catAPI;
  final MockService mockService = MockService();
  List<Breed> breeds = [];
  String? errorMessage;
  bool isLoading = false;
  bool isLoadMoreLoading = false;
  bool isLastPage = false;
  int currentPage = 0;
  final int limit = 10; // Number of items per page
  CatBreed? catBreed;

  // we read the NetworkInfo from the context and pass it to the CatDataManager.
  final ConnectivityMonitor networkInfo;

  CatDataManager({required this.catAPI, required this.networkInfo}) {
    networkInfo.addListener(_onNetworkChanged);
  }

  void _onNetworkChanged() {
    if (networkInfo.isConnected && breeds.isEmpty) {
      getCatData();
    }
    notifyListeners();
  }

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

      final mockCatResponse =
          await mockService.mockGetCatBreeds(page: currentPage, limit: limit);

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
        errorMessage =
            catResponse.statusCode.toString() ?? 'An unknown error occurred';
      }
    } catch (e) {
      errorMessage = e.toString();
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
        errorMessage = catBreedResponse.error ?? 'An unknown error occurred';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reloadBreeds() async {
    // Reset the pagination data for a fresh load
    currentPage = 0;
    isLastPage = false;
    breeds.clear();
    await getCatData();
  }

  @override
  void dispose() {
    networkInfo.removeListener(_onNetworkChanged);
    super.dispose();
  }
}
