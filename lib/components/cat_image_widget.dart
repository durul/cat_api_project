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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            print('Error loading image: $error');
            return Column(
              children: [
                Icon(Icons.error, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text('Failed to load image',
                    style: TextStyle(color: Colors.red,
                    fontFamily: 'NotoSansSymbols',)),
              ],
            );
          },
          imageBuilder: (context, imageProvider) => Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          breed,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
