import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'api/api_helper.dart';
import 'api/cats_api.dart';
import 'api/network.dart';
import 'data/cat_data_manager.dart';
import 'my_app.dart';
import 'network/connectivity_monitor.dart';

Future<void> main({bool testing = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final network = Network();
  await network.init();

  // Uses the Provider package to set up dependency injection for the app.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectivityMonitor>(
          create: (_) => ConnectivityMonitor(Connectivity()),
        ),
        ChangeNotifierProvider<CatDataManager>(
          create: (context) {
            final networkInfo = context.read<ConnectivityMonitor>();
            return CatDataManager(
              catAPI: CatAPI(
                  apiHelper: ApiHelper(dio: network.dio, network: network)),
              networkInfo: networkInfo,
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
