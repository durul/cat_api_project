import 'package:flutter/material.dart';
import '../api/cats_api.dart';
import '../components/cat_image_widget.dart';
import '../model/cats.dart';

class CatInfo extends StatefulWidget {
  final String catBreed;
  final String catId;

  const CatInfo({Key? key, required this.catBreed, required this.catId}) : super(key: key);

  @override
  State<CatInfo> createState() => _CatInfoState();
}

class _CatInfoState extends State<CatInfo> {
  List<CatBreed> catBreeds = [];
  bool isLoading = true;
  String? error;

  void getCatSpecificData() async {
    try {
      final catBreedResponse = await CatAPI().getCatBreed(widget.catId);

      setState(() {
        catBreeds = catBreedResponse;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error fetching cat breed data: $e';
        isLoading = false;
      });
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getCatSpecificData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catBreed),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      return Center(child: Text(error!));
    } else if (catBreeds.isEmpty) {
      return const Center(child: Text('No images found for this breed.'));
    } else {
      return ListView.builder(
        itemCount: catBreeds.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CatImage(
                  imageUrl: catBreeds[index].url,
                  breed: widget.catBreed,
                ),
                ListTile(
                  title: Text('Image ID: ${catBreeds[index].id}'),
                  subtitle: Text('Size: ${catBreeds[index].width}x${catBreeds[index].height}'),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}