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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
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
