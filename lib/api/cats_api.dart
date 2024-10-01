import '../model/cats.dart';
import '../network/model_response.dart';
import 'network.dart';

const String _breedsEndpoint = '/breeds';
const String _imagesEndpoint = '/images/search';

typedef CatResponse = Result<List<Breed>>;
typedef CatDetailsResponse = Result<CatBreed>;

/// This class is responsible for making requests to the Cat API.
class CatAPI {
  final Network network;

  CatAPI({Network? network}) : network = network ?? Network();

  /// Fetches a list of cat breeds from the API.
  Future<CatResponse> getCatBreeds() async {
    try {
      final breeds = await network.makeRequest<List<Breed>>(
        _breedsEndpoint,
        (json) => BreedList.fromJson(json).breeds,
      );

      return Result<List<Breed>>.success(breeds);
    } catch (error) {
      return Result<List<Breed>>.failure(error.toString());
    }
  }

  /// Fetches a specific cat breed by ID.
  Future<CatDetailsResponse> getCatBreed(String breedId) async {
    try {
      final breeds = await network.makeRequest<List<CatBreed>>(
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
}
