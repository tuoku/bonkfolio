import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bonkfolio/misc/global_keys.dart';
import 'package:bonkfolio/repositories/coingecko_repo.dart';
import 'package:bonkfolio/repositories/database_repo.dart';
import 'package:bonkfolio/views/portfolio_screen.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:worker_manager/worker_manager.dart';

Future main() async {
  await Executor().warmUp(
      log: kDebugMode,
      isolatesCount: kIsWeb ? 1 : (Platform.numberOfProcessors / 2).floor());
  await dotenv.load(fileName: ".env");
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).then((_) {
    DatabaseRepo().init().then((_) {
      runApp(const MyApp());
    });

    // CoinGeckoRepo().refreshLookupTable();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      home: const PortfolioScreen(
        title: 'Bonkfolio',
        key: GlobalKeys.portfolioKey,
      ),
    );
  }
}
