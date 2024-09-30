import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cat_image_widget.dart';
import '../model/cats.dart';
import '../provider/cat_data_provider.dart';

class CatInfo extends StatefulWidget {
  final String catBreed;
  final String catId;

  const CatInfo({super.key, required this.catBreed, required this.catId});

  @override
  State<CatInfo> createState() => _CatInfoState();
}

class _CatInfoState extends State<CatInfo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatDataProvider>().getCatSpecificData(widget.catId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catBreed),
      ),
      body: Consumer<CatDataProvider>(
        builder: (context, catDataProvider, child) {
          return getCatContent(catDataProvider);
        },
      ),
    );
  }

  Widget getCatContent(CatDataProvider catDataProvider) {
    if (catDataProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading cat information...'),
          ],
        ),
      );
    } else if (catDataProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(catDataProvider.errorMessage!,
                style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () => catDataProvider.getCatSpecificData(widget.catId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (catDataProvider.catBreed != null) {
      return SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildCatImage(catDataProvider.catBreed!),
              const SizedBox(height: 10),
              Text('Height: ${catDataProvider.catBreed?.height ?? 'Unknown'}'),
              const SizedBox(height: 10),
              Text('Width: ${catDataProvider.catBreed?.width ?? 'Unknown'}'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: Text('No data available'));
    }
  }

  Widget buildCatImage(CatBreed catBreed) {
    return CatImage(imageUrl: catBreed.url, breed: widget.catBreed);
  }
}
