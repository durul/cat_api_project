import 'package:flutter/material.dart';

import '../api/cats_api.dart';
import '../components/cat_breed_card.dart';
import '../model/cats.dart';
import 'cat_info.dart';

class CatBreedsPage extends StatefulWidget {
  const CatBreedsPage({super.key, required this.title});

  final String title;

  @override
  State<CatBreedsPage> createState() => _CatBreedsPageState();
}

class _CatBreedsPageState extends State<CatBreedsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<Breed> breeds = [];
  int currentPage = 0;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    _fetchCatBreeds();

    // Listen to scroll changes
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore &&
          !isLastPage) {
        _loadMoreBreeds();
      }
    });
  }

  Future<void> _fetchCatBreeds({bool isLoadMore = false}) async {
    setState(() {
      _isLoadingMore = true;
    });

    try {
      final catResponse = await CatAPI().getCatBreeds(page: currentPage);
      if (catResponse.isSuccess && catResponse.data != null) {
        final newBreeds = catResponse.data!;
        if (newBreeds.isEmpty) {
          isLastPage = true;
        }
        setState(() {
          if (isLoadMore) {
            breeds.addAll(newBreeds);
          } else {
            breeds = newBreeds;
          }
          currentPage++;
        });
      } else {
        throw Exception(catResponse.error ?? 'An unknown error occurred');
      }
    } catch (e) {
      print('Error fetching cat breeds: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMoreBreeds() async {
    if (!_isLoadingMore) {
      await _fetchCatBreeds(isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: RefreshIndicator(
        onRefresh: () => _fetchCatBreeds(),
        child: breeds.isEmpty && _isLoadingMore
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                itemCount: isLastPage ? breeds.length : breeds.length + 1,
                itemBuilder: (context, index) {
                  if (index == breeds.length) {
                    // This builds the loading indicator at the end of the list
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return BreedCard(
                      breed: breeds[index],
                      onTap: _navigateToCatInfo,
                    );
                  }
                },
              ),
      ),
    );
  }

  // Add your navigation to the breed details screen etc.

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
