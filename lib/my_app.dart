import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'network/network_info.dart';
import 'network/screens/no_internet_screen.dart';
import 'screens/cat_breeds.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final networkInfo = context.watch<NetworkInfo>();

    return MaterialApp(
      title: 'Cats',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: StreamBuilder<bool>(
        stream: networkInfo.onConnectivityChanged,
        initialData: networkInfo.isConnected,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return snapshot.data == true
                ? const CatBreedsPage(title: 'Cat Breeds')
                : const NoInternetScreen();
          } else {
            return const Scaffold(
              body:
                  Center(child: Text('An unexpected error occurred in MyApp')),
            );
          }
        },
      ),
    );
  }
}
