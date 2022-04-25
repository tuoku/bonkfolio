import 'dart:io';

import 'package:bonkfolio/bloc/asset/asset_bloc.dart';
import 'package:bonkfolio/bloc/wallet/wallet_bloc.dart';
import 'package:bonkfolio/repositories/asset_repository.dart';
import 'package:bonkfolio/repositories/wallet_repository.dart';
import 'package:bonkfolio/services/asset_service.dart';
import 'package:bonkfolio/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bonkfolio/misc/global_keys.dart';
import 'package:bonkfolio/views/portfolio_screen.dart';
import 'package:flutter/services.dart';

import 'package:worker_manager/worker_manager.dart';

Future main() async {
  await Executor().warmUp(
      log: kDebugMode,
      isolatesCount: kIsWeb ? 1 : (Platform.numberOfProcessors / 2).floor());
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AssetService assetService = AssetService();
  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AssetRepository>(
              create: (context) => AssetRepository(assetService: assetService)),
          RepositoryProvider<WalletRepository>(
              create: (context) =>
                  WalletRepository(databaseService: databaseService))
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<WalletBloc>(
                  create: (context) => WalletBloc(
                      walletRepository: context.read<WalletRepository>())..add(WalletsRequested())),
              BlocProvider<AssetBloc>(
                  create: (context) => AssetBloc(
                      assetRepository: context.read<AssetRepository>())),
              
            ],
            child: MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Colors.black,
                  canvasColor: Colors.black,
                  cardColor: Colors.black,
                  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
                ),
                home: LayoutBuilder(
                  builder: ((context, constraints) {
                    bool useVerticalLayout = constraints.maxWidth < 600.0;

                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return useVerticalLayout
                            ? PortfolioScreen(
                                title: 'Bonkfolio',
                                key: GlobalKeys.portfolioKey,
                              )
                            : Row(
                                children: [
                                  Flexible(
                                      flex: 7,
                                      child: PortfolioScreen(
                                        title: 'Bonkfolio',
                                        key: GlobalKeys.portfolioKey,
                                      )),
                                  Flexible(
                                      flex: 3,
                                      child: Container(
                                        color: Colors.red,
                                      ))
                                ],
                              );
                      },
                    );
                  }),
                ))));
  }
}
