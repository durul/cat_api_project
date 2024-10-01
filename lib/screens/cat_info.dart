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

    // Use addPostFrameCallback to ensure the code runs after the first frame (build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catDataProvider =
          Provider.of<CatDataProvider>(context, listen: false);
      catDataProvider.getCatSpecificData(widget.catId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final catDataProvider = Provider.of<CatDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catBreed),
      ),
      body: _buildCatContent(catDataProvider),
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
