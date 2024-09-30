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
  String? errorMessage;
  bool isLoading = false;

  final CatAPI catAPI = CatAPI();

  @override
  void initState() {
    super.initState();
    getCatData();
  }

  Future<void> getCatData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final catResponse = await catAPI.getCatBreeds();
      if (catResponse.isSuccess && catResponse.data != null) {
        setState(() {
          breeds = catResponse.data!;
        });
      } else {
        throw Exception(catResponse.error ?? 'An unknown error occurred');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        print('Error fetching cat breeds: $errorMessage');
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: getCatData,
        child: _buildBody(),
      ),
    );
  }

  /// This method will build the body of the page based on the state of the app.
  Widget _buildBody() {
    if (isLoading) {
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
    } else if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'NotoSansSymbols',
                  )),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: getCatData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else if (breeds.isEmpty) {
      return const Center(child: Text('No cat breeds available'));
    } else {
      return ListView.builder(
        itemCount: breeds.length,
        itemBuilder: (context, index) {
          return _buildBreedCard(breeds[index]);
        },
      );
    }
  }

  Widget _buildBreedCard(Breed breed) {
    return Semantics(
      label: 'Cat breed: ${breed.name}',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          onTap: () => _navigateToCatInfo(breed),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  breed.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  breed.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCatInfo(Breed breed) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => CatInfo(
          catId: breed.id,
          catBreed: breed.name,
        ),
      ),
    );
  }
}
