import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mycryptos/misc/global_keys.dart';
import 'package:mycryptos/repositories/coingecko_repo.dart';
import 'package:mycryptos/repositories/database_repo.dart';
import 'package:mycryptos/views/portfolio_screen.dart';
import 'package:flutter/services.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).then((_) {
    DatabaseRepo().init().then((_) {
      runApp(const MyApp());
    });

    CoinGeckoRepo().refreshLookupTable();
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
