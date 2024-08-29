import '../model/cats.dart';
import 'network.dart';

const String _baseUrl = 'https://api.thecatapi.com/v1';
const String _breedsEndpoint = '/breeds';
const String _imagesEndpoint = '/images/search';

typedef CatResponse = List<Breed>;
typedef CatDetailsResponse = CatBreed;

// CatAPI class now uses dependency injection for the HTTP client.
class CatAPI {
  final network = Network();

  Future<CatResponse> getCatBreeds() async {
    final uri = Uri.parse('$_baseUrl$_breedsEndpoint');
    return network.makeRequest<CatResponse>(
      uri,
      (json) => BreedList.fromJson(json).breeds,
    );
  }

  Future<List<CatDetailsResponse>> getCatBreed(String breedId) async {
    final uri = Uri.parse('$_baseUrl$_imagesEndpoint')
        .replace(queryParameters: {'breed_id': breedId});
    return network.makeRequest<List<CatDetailsResponse>>(
      uri,
      (json) => CatList.fromJson(json).breeds,
    );
  }
}
