part 'cats.g.dart';

// json_annotation library to parse the JSON data into objects of my model classes.
// The part statement imports a file and allows me to use its private variables.

@JsonSerializable()
class BreedList {
  List<Breed> breeds;

  BreedList({required this.breeds});
}

@JsonSerializable()
class Breed {
  String id;
  String name;
  String description;
  String temperament;

  Breed(
      {required this.id,
      required this.name,
      required this.description,
      required this.temperament});
}

// For the image search, you need to describe the cat, the cat breed and the list of cat breeds.
@JsonSerializable()
class Cat {
  String name;
  String description;
  String life_span;

  Cat({required this.name, required this.description, required this.life_span});
}

@JsonSerializable()
class CatBreed {
  String id;
  String url;
  int width;
  int height;

  CatBreed(
      {required this.id,
      required this.url,
      required this.width,
      required this.height});
}

@JsonSerializable()
class CatList {
  List<CatBreed> breeds;

  CatList({required this.breeds});
}
