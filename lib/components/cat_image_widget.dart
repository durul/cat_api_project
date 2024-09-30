import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CatImage extends StatelessWidget {
  final String imageUrl;
  final String breed;

  const CatImage({
    super.key,
    required this.imageUrl,
    required this.breed,
  });

  @override
  Widget build(BuildContext context) {
    print('Cat image URL: ${imageUrl}');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        const SizedBox(height: 16),
        Text(
          breed,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
