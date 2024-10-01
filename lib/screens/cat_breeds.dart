import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cat_breed_card.dart';
import '../model/cats.dart';
import '../provider/cat_data_provider.dart';
import 'cat_info.dart';

class CatBreedsPage extends StatefulWidget {
  const CatBreedsPage({super.key, required this.title});

  final String title;

  @override
  State<CatBreedsPage> createState() => _CatBreedsPageState();
}

class _CatBreedsPageState extends State<CatBreedsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final catDataProvider =
        Provider.of<CatDataProvider>(context, listen: false);
    catDataProvider.getCatData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !catDataProvider.isLoading) {
        catDataProvider.getCatData(isLoadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<CatDataProvider>(context, listen: false).reloadBreeds(),
        child: Consumer<CatDataProvider>(
          builder: (context, catDataProvider, child) {
            if (catDataProvider.isLoading && catDataProvider.breeds.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (catDataProvider.errorMessage != null) {
              return _buildErrorMessage(catDataProvider);
            } else {
              return ListView.builder(
                controller: _scrollController,
                itemCount: catDataProvider.isLastPage
                    ? catDataProvider.breeds.length
                    : catDataProvider.breeds.length + 1,
                itemBuilder: (context, index) {
                  if (index == catDataProvider.breeds.length) {
                    // The loading indicator is shown at the end when more data is being fetched
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return BreedCard(
                      breed: catDataProvider.breeds[index],
                      onTap: _navigateToCatInfo,
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorMessage(CatDataProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(provider.errorMessage!,
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: provider.reloadBreeds,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Define your navigation logic here
  void _navigateToCatInfo(Breed breed) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => CatInfo(
          catBreed: breed.name,
          catId: breed.id,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
