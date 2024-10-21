import 'package:flutter/material.dart';

import '../model/cats.dart';

class BreedCard extends StatelessWidget {
  final Breed breed;
  final Function(Breed) onTap;

  const BreedCard({super.key, required this.breed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cat breed card for ${breed.name}',
      hint: 'Tap to view more details about ${breed.name}',
      button: true,
      child: InkWell(
        onTap: () => onTap(breed),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: 'Breed name',
                  child: Text(
                    breed.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: 'Breed description',
                  child: Text(
                    breed.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
