import 'network.dart';

const String apiKey =
    'live_vs9El4qaLPFml0kQ3aTvGGVsVjbg8Bb32bBLGLTkp5pQOwUEDeE0dW41CgJKUNl8';
const String catAPIURL = 'https://api.thecatapi.com/v1/breeds?';
const String catImageAPIURL = 'https://api.thecatapi.com/v1/images/search?';
const String breedString = 'breed_id=';
const String apiKeyString = 'x-api-key=$apiKey';

class CatAPI {
  Future<String> getCatBreeds() async {
    final network = Network('$catAPIURL$apiKeyString');
    final catData = await network.getData();
    return catData;
  }

  Future<String> getCatBreed(String breedName) async {
    final network =
        Network('$catImageAPIURL$breedString$breedName&$apiKeyString');
    final catData = await network.getData();
    return catData;
  }
}
