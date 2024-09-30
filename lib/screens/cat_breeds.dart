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
  @override
  void initState() {
    super.initState();
    // Fetch cat data when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatDataProvider>().getCatData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<CatDataProvider>().getCatData(),
        child: _buildBody(),
      ),
    );
  }

  /// This method will build the body of the page based on the state of the app.
  Widget _buildBody() {
    return Consumer<CatDataProvider>(
      builder: (context, catDataProvider, child) {
        if (catDataProvider.isLoading) {
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
        } else if (catDataProvider.errorMessage != null) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(catDataProvider.errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'NotoSansSymbols',
                      )),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () => catDataProvider.getCatData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (catDataProvider.breeds.isEmpty) {
          return const Center(child: Text('No cat breeds available'));
        } else {
          return ListView.builder(
            itemCount: catDataProvider.breeds.length,
            itemBuilder: (context, index) {
              return BreedCard(
                breed: catDataProvider.breeds[index],
                onTap: _navigateToCatInfo,
              );
            },
          );
        }
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
