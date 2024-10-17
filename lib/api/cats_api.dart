import '../model/cats.dart';
import '../network/model_response.dart';
import 'api_exception.dart';
import 'api_helper.dart';

const String _breedsEndpoint = '/breeds';
const String _imagesEndpoint = '/images/search';

typedef CatResponse = Result<List<Breed>>;
typedef CatDetailsResponse = Result<CatBreed>;

/// This class is responsible for making requests to the Cat API.
class CatAPI {
  final ApiHelper apiHelper;

  CatAPI({required this.apiHelper});

  /// Fetches a list of cat breeds from the API.
  Future<CatResponse> getCatBreeds({int page = 0, int limit = 10}) async {
    try {
      final breeds = await apiHelper.makeRequest<List<Breed>>(
        _breedsEndpoint,
        (json) => BreedList.fromJson(json).breeds,
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      return Result<List<Breed>>.success(breeds);
    } catch (error) {
      if (error is ApiException) {
        return Result<List<Breed>>.failure(error.message, error.statusCode);
      }
      return Result<List<Breed>>.failure(error.toString());
    }
  }

  /// Fetches a specific cat breed by ID.
  Future<CatDetailsResponse> getCatBreed(String breedId) async {
    try {
      final breeds = await apiHelper.makeRequest<List<CatBreed>>(
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
      if (error is ApiException) {
        return Result<CatBreed>.failure(error.message, error.statusCode);
      }
      return Result<CatBreed>.failure(error.toString());
    }
  }
}
