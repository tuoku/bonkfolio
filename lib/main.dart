import 'dart:io';

import 'package:bonkfolio/bloc/asset/asset_bloc.dart';
import 'package:bonkfolio/bloc/wallet/wallet_bloc.dart';
import 'package:bonkfolio/cache/asset_cache.dart';
import 'package:bonkfolio/cache/crypto_tx_cache.dart';
import 'package:bonkfolio/repositories/asset_repository.dart';
import 'package:bonkfolio/repositories/wallet_repository.dart';
import 'package:bonkfolio/services/asset_service.dart';
import 'package:bonkfolio/services/database_service.dart';
import 'package:bonkfolio/views/crypto_details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bonkfolio/views/portfolio_screen.dart';
import 'package:flutter/services.dart';

import 'package:worker_manager/worker_manager.dart';

import 'bloc/asset_detail/asset_detail_bloc.dart';
import 'misc/globals.dart' as globals;
import 'models/crypto.dart';

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
    runApp(App());
  });
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final AssetService assetService = AssetService();
  final DatabaseService databaseService = DatabaseService();
  final AssetCache assetCache = AssetCache();
  final CryptoTXCache transactionCache = CryptoTXCache();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AssetRepository>(
              create: (context) => AssetRepository(
                  assetService: assetService,
                  assetCache: assetCache,
                  databaseService: databaseService,
                  transactionCache: transactionCache)),
          RepositoryProvider<WalletRepository>(
              create: (context) =>
                  WalletRepository(databaseService: databaseService))
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<WalletBloc>(
                  create: (context) => WalletBloc(
                      walletRepository: context.read<WalletRepository>())),
              BlocProvider<AssetBloc>(
                  create: (context) => AssetBloc(
                      assetRepository: context.read<AssetRepository>())),
              BlocProvider<AssetDetailBloc>(
                  create: ((context) => AssetDetailBloc()))
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
                    globals.useVerticalLayout = useVerticalLayout;
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return useVerticalLayout
                            ? const PortfolioScreen(
                                title: 'Bonkfolio',
                              )
                            : Row(
                                children: [
                                  const Flexible(
                                      flex: 7,
                                      child: PortfolioScreen(
                                        title: 'Bonkfolio',
                                      )),
                                  Flexible(
                                      flex: 7,
                                      child: BlocConsumer<AssetDetailBloc,
                                          AssetDetailState>(
                                        listener: (context, state) {},
                                        builder: ((context, state) {
                                          if (state is AssetActive) {
                                            return
                                            FutureBuilder(
                                              future: Future.delayed(Duration(milliseconds: 0)),
                                              
                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                if(snapshot.connectionState == ConnectionState.done) {
                                                  return AssetDetailsScreen(
                                              asset: (state).asset,
                                              pValue: (context.read<AssetBloc>().state as AssetsLoaded).portfolioValue,
                                              txs: context
                                                  .read<AssetRepository>()
                                                  .transactionCache
                                                  .get()
                                                  .where((e) =>
                                                      e.contractAddress ==
                                                      ((state).asset as Crypto)
                                                          .contractAddress)
                                                  .toList(),
                                            );
                                                } else return Container(color: Colors.black,);
                                              },
                                            );
                                             
                                          }

                                          return Container(
                                            color: Colors.red,
                                          );
                                        }),
                                      ))
                                ],
                              );
                      },
                    );
                  }),
                ))));
  }
}
