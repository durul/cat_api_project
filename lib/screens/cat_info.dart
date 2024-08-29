import 'package:flutter/material.dart';

import '../api/cats_api.dart';
import '../components/cat_image_widget.dart';
import '../model/cats.dart';

class CatInfo extends StatefulWidget {
  final String catBreed;
  final String catId;

  const CatInfo({super.key, required this.catBreed, required this.catId});

  @override
  State<CatInfo> createState() => _CatInfoState();
}

class _CatInfoState extends State<CatInfo> {
  final CatAPI catAPI = CatAPI();
  CatBreed? catBreed;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    getCatSpecificData();
  }

  Future<void> getCatSpecificData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final catBreedResponse = await catAPI.getCatBreed(widget.catId);

    setState(() {
      if (catBreedResponse.isSuccess && catBreedResponse.data != null) {
        catBreed = catBreedResponse.data;
      } else {
        error = catBreedResponse.error ?? 'An unknown error occurred';
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catBreed),
      ),
      body: getCatContent(),
    );
  }

  Widget getCatContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      return Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)));
    } else if (catBreed != null) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CatImage(imageUrl: catBreed!.url, breed: widget.catBreed),
            const SizedBox(height: 10),
            Text('Height: ${catBreed!.height}'),
            const SizedBox(height: 10),
            Text('Width: ${catBreed!.width}'),
            const SizedBox(height: 10),
          ],
        ),
      );
    } else {
      return const Center(child: Text('No data available'));
    }
  }
}
