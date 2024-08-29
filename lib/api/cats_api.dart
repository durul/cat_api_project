import '../model/cats.dart';
import '../network/model_response.dart';
import 'network.dart';

const String _baseUrl = 'https://api.thecatapi.com/v1';
const String _breedsEndpoint = '/breeds';
const String _imagesEndpoint = '/images/search';

typedef CatResponse = Result<List<Breed>>;
typedef CatDetailsResponse = Result<CatBreed>;

// CatAPI class now uses dependency injection for the HTTP client.
class CatAPI {
  final Network network;

  CatAPI({Network? network}) : network = network ?? Network();

  Future<CatResponse> getCatBreeds() async {
    final uri = Uri.parse('$_baseUrl$_breedsEndpoint');
    try {
      final breeds = await network.makeRequest<List<Breed>>(
        uri,
            (json) => BreedList.fromJson(json).breeds,
      );
      return Result<List<Breed>>.success(breeds);
    } catch (error) {
      return Result<List<Breed>>.failure(error.toString());
    }
  }

  Future<CatDetailsResponse> getCatBreed(String breedId) async {
    final uri = Uri.parse('$_baseUrl$_imagesEndpoint')
        .replace(queryParameters: {'breed_id': breedId});
    try {
      final breeds = await network.makeRequest<List<CatBreed>>(
        uri,
            (json) => CatList.fromJson(json).breeds,
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