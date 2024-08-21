import 'package:flutter/material.dart';

import 'screens/cat_breeds.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cats',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const CatBreedsPage(title: 'Cat Breeds'),
    );
  }
}
