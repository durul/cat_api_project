// filename: cat_info.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/cats_api.dart';
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CatDataProvider(catAPI: CatAPI())..getCatSpecificData(widget.catId),
      child: Consumer<CatDataProvider>(
        builder: (context, catDataProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.catBreed),
            ),
            body: _buildCatContent(catDataProvider),
          );
        },
      ),
    );
  }

  Widget _buildCatContent(CatDataProvider catDataProvider) {
    if (catDataProvider.isLoading) {
      return _buildLoadingIndicator();
    } else if (catDataProvider.errorMessage != null) {
      return _buildErrorMessage(catDataProvider);
    } else if (catDataProvider.catBreed != null) {
      return _buildCatDetails(catDataProvider.catBreed!);
    } else {
      return const Center(child: Text('No data available'));
    }
  }

  Widget _buildLoadingIndicator() {
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
  }

  Widget _buildErrorMessage(CatDataProvider catDataProvider) {
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
  }

  Widget _buildCatDetails(CatBreed catBreed) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildCatImage(catBreed),
            const SizedBox(height: 10),
            Text('Height: ${catBreed.height ?? 'Unknown'}'),
            const SizedBox(height: 10),
            Text('Width: ${catBreed.width ?? 'Unknown'}'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCatImage(CatBreed catBreed) {
    return CatImage(imageUrl: catBreed.url, breed: widget.catBreed);
  }
}
