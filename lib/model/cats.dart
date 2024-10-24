import 'package:json_annotation/json_annotation.dart';

part 'cats.g.dart';

// tryCast is a simple method that tries to cast an object into a given type,
// and if it’s unsuccessful, it returns null.
T? tryCast<T>(object) => object is T ? object : null;

// json_annotation library to parse the JSON data into objects of
// my model classes.
// The part statement imports a file and allows me to use its private variables.
// The g.dart file is generated by the build runner plugin.
// The build runner plugin is a Dart package that generates code for you.

@JsonSerializable()
class Breed {
  String id;
  String name;
  String description;
  String temperament;

  Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
  });

  // build runner plugin will use these methods to create a Dart file to do
  // all the hard work of parsing the JSON data for you.
  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);

  Map<String, dynamic> toJson() => _$BreedToJson(this);
}

class BreedList {
  List<Breed> breeds;

  BreedList({required this.breeds});

  // This is the fromJson method
  // I need to parse the JSON array to a list of breeds.
  factory BreedList.fromJson(json) {
    if (json is List) {
      return BreedList(
        breeds:
            json.map((e) => Breed.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } else {
      throw const FormatException('Unexpected JSON structure for BreedList');
    }
  }
}

// For the image search, you need to describe the cat,
// the cat breed and the list of cat breeds.
@JsonSerializable()
class Cat {
  String name;
  String description;
  String life_span;

  Cat({required this.name, required this.description, required this.life_span});

  factory Cat.fromJson(Map<String, dynamic> json) => _$CatFromJson(json);

  Map<String, dynamic> toJson() => _$CatToJson(this);
}

@JsonSerializable()
class CatBreed {
  String id;
  String url;
  int width;
  int height;

  CatBreed({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      id: tryCast<String>(json['id']) ?? '',
      url: tryCast<String>(json['url']) ?? '',
      width: tryCast<int>(json['width']) ?? 0,
      height: tryCast<int>(json['height']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$CatBreedToJson(this);
}

class CatList {
  List<CatBreed> breeds;

  CatList({required this.breeds});

  factory CatList.fromJson(json) {
    if (json is List) {
      return CatList(
        breeds: json
            .map((e) => CatBreed.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      throw const FormatException('Unexpected JSON structure for CatList');
    }
  }
}
