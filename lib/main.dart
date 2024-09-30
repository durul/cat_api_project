import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'api/cats_api.dart';
import 'provider/cat_data_provider.dart';
import 'screens/cat_breeds.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final catAPI = CatAPI();
    final catDataProvider = CatDataProvider(catAPI: catAPI);

    return ChangeNotifierProvider(
      create: (_) => catDataProvider,
      child: MaterialApp(
        title: 'Cats',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        home: const CatBreedsPage(title: 'Cat Breeds'),
      ),
    );
  }
}
