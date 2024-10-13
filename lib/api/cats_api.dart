import 'package:dio/dio.dart';

import '../model/cats.dart';
import '../network/model_response.dart';

const String _breedsEndpoint = '/breeds';
const String _imagesEndpoint = '/images/search';

typedef CatResponse = Result<List<Breed>>;
typedef CatDetailsResponse = Result<CatBreed>;

/// This class is responsible for making requests to the Cat API.
class CatAPI {
  final Dio dio;

  CatAPI({
    required this.dio,
  });

  /// Fetches a list of cat breeds from the API.
  Future<CatResponse> getCatBreeds({int page = 0, int limit = 10}) async {
    try {
      final breeds = await makeRequest<List<Breed>>(
        _breedsEndpoint,
        (json) => BreedList.fromJson(json).breeds,
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      return Result<List<Breed>>.success(breeds);
    } catch (error) {
      return Result<List<Breed>>.failure(error.toString());
    }
  }

  /// Fetches a specific cat breed by ID.
  Future<CatDetailsResponse> getCatBreed(String breedId) async {
    try {
      final breeds = await makeRequest<List<CatBreed>>(
        _imagesEndpoint,
        (json) => CatList.fromJson(json).breeds,
        queryParameters: {
          'breed_id': breedId
        }, // passing query parameters for breed_id
      );
      if (breeds.isEmpty) {
        throw Exception('No breed found with the given ID');
      }
      return Result<CatBreed>.success(breeds.first);
    } catch (error) {
      return Result<CatBreed>.failure(error.toString());
    }
  }

  /// Using dio to make GET requests now.
  Future<T> makeRequest<T>(
    String endpoint,
    T Function(dynamic json) parseJson, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final json = response.data;
        return parseJson(json);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error occurred: ${e.message}');
    }
  }
}
