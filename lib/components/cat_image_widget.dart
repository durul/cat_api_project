import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CatImage extends StatelessWidget {
  final String imageUrl;
  final String breed;

  const CatImage({super.key, required this.imageUrl, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          label: 'Image of $breed cat',
          image: true,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Breed name',
          child: Text(
            breed,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
