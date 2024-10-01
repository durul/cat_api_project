import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/cats_api.dart';
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
  @override
  Widget build(BuildContext context) {
    final catDataProvider = CatDataProvider(catAPI: CatAPI());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => catDataProvider..getCatData(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: RefreshIndicator(
          onRefresh: catDataProvider.getCatData,
          child: _buildBody(catDataProvider),
        ),
      ),
    );
  }

  /// This method will build the body of the page based on the state of the app.
  Widget _buildBody(CatDataProvider catDataProvider) {
    return Consumer<CatDataProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingIndicator();
        } else if (provider.errorMessage != null) {
          return _buildErrorMessage(provider);
        } else if (provider.breeds.isEmpty) {
          return const Center(child: Text('No cat breeds available'));
        } else {
          return _buildBreedList(provider.breeds);
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading cat breeds...'),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(CatDataProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'NotoSansSymbols',
                )),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: provider.getCatData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreedList(List<Breed> breeds) {
    return ListView.builder(
      itemCount: breeds.length,
      itemBuilder: (context, index) {
        return BreedCard(
          breed: breeds[index],
          onTap: _navigateToCatInfo,
        );
      },
    );
  }

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
}
