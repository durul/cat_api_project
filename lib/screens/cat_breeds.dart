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
  List<Breed> breeds = [];

  // This method calls the Cat API to get the cat breeds.
  void getCatData() async {
    try {
      final catResponse = await CatAPI().getCatBreeds();

      setState(() {
        breeds = catResponse;
      });
    } catch (e) {
      print('Error fetching cat breeds: $e');
      // Handle the error appropriately, maybe show a snackbar or dialog to the user
    }
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
          itemCount: breeds.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push<void>(context,
                    MaterialPageRoute(builder: (context) {
                  return CatInfo(catId: breeds[index].id,
                      catBreed: breeds[index].name);
                }));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(breeds[index].name),
                    subtitle: Text(breeds[index].description),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
