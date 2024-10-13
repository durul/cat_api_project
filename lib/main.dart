import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'api/cats_api.dart';
import 'api/network.dart';
import 'data/cat_data_manager.dart';
import 'my_app.dart';
import 'network/network_info.dart';

Future<void> main({bool testing = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final network = Network();
  await network.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NetworkInfo>(
          create: (_) => NetworkInfo(Connectivity()),
        ),
        ChangeNotifierProvider<CatDataManager>(
          create: (context) {
            final networkInfo = context.read<NetworkInfo>();
            return CatDataManager(
              catAPI: CatAPI(dio: network.dio),
              networkInfo: networkInfo,
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
