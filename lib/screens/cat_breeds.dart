import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/cats_api.dart';
import '../model/cats.dart';
import 'cat_info.dart';

class CatBreedsPage extends StatefulWidget {
  const CatBreedsPage({super.key, required this.title});

  final String title;

  @override
  State<CatBreedsPage> createState() => _CatBreedsPageState();
}

class _CatBreedsPageState extends State<CatBreedsPage> {
  BreedList breedList = BreedList(breeds: List.empty());

  // This method calls the Cat API to get the cat breeds.
  void getCatData() async {
    final catJson = await CatAPI().getCatBreeds();
    // print(catJson);

    //  turn the JSON string into a map.
    final dynamic catMap = json.decode(catJson);

    setState(() {
      // to convert the map into a list of breeds.
      breedList = BreedList.fromJson(catMap);
    });
  }

  @override
  void initState() {
    super.initState();
    getCatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: breedList.breeds.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push<void>(context,
                    MaterialPageRoute(builder: (context) {
                  return CatInfo(catId: breedList.breeds[index].id,
                      catBreed: breedList.breeds[index].name);
                }));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(breedList.breeds[index].name),
                    subtitle: Text(breedList.breeds[index].description),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
