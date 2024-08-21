import 'package:flutter/material.dart';

import '../api/cats_api.dart';
import 'cat_info.dart';

class CatBreedsPage extends StatefulWidget {
  const CatBreedsPage({super.key, required this.title});

  final String title;

  @override
  State<CatBreedsPage> createState() => _CatBreedsPageState();
}

class _CatBreedsPageState extends State<CatBreedsPage> {
  // This method calls the Cat API to get the cat breeds.
  void getCatData() async {
    final catJson = await CatAPI().getCatBreeds();
    print(catJson);
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
          itemCount: 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push<void>(context,
                    MaterialPageRoute(builder: (context) {
                  return const CatInfo(catId: 'id', catBreed: 'Name');
                }));
              },
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  // 7
                  child: ListTile(
                    title: Text('Breed Name'),
                    subtitle: Text('Breed Description'),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
