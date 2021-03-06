import 'package:bonkfolio/bloc/wallet/wallet_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:bonkfolio/views/tracked_sources_screen.dart';
import 'package:bonkfolio/widgets/asset_tile.dart';
import 'package:bonkfolio/widgets/asset_tile_shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io' show Platform;

import '../bloc/asset/asset_bloc.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final nf = NumberFormat.compact();
  final String address =
      //'0xb60010fd99dc4fac1e3834ce20f623f3ede2df14';
      "0x0Ac876efFcde0C614bff9F7cAA1E6bE59668332F";

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      context.read<AssetBloc>().add(AssetsRequested(
          wallets:
              await context.read<WalletBloc>().walletRepository.getWallets()));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _drawer(),
        body: CustomScrollView(
            cacheExtent: 3500,
            physics: (kIsWeb
                ? const AlwaysScrollableScrollPhysics()
                : Platform.isIOS
                    ? const AlwaysScrollableScrollPhysics()
                    : const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics())),
            slivers: [
              SliverAppBar(
                  centerTitle: true,
                  title: const Image(
                    height: kToolbarHeight + 30,
                    image: AssetImage('assets/logo.png'),
                  ),
                  actions: [
                    PopupMenuButton<String>(onSelected: (string) {
                      if (string == "Force reload") {
                        //  reload();
                      } else {
                        //  hidezero = !hidezero;

                      }
                    }, itemBuilder: (BuildContext context) {
                      return [
                        const CheckedPopupMenuItem<String>(
                          value: "Hide zero-ish",
                          child: Text("Hide zero-ish"),
                          enabled: true,
                          //checked: hidezero,
                        ),
                        const PopupMenuItem(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Force reload")),
                          value: "Force reload",
                        )
                      ];
                    }),
                  ],
                  backgroundColor: Colors.black,
                  floating: false,
                  pinned: false,
                  snap: false,
                  expandedHeight: 250,
                  flexibleSpace:
                      FlexibleSpaceBar(background: _portfolioHeader())),
              CupertinoSliverRefreshControl(
                  refreshTriggerPullDistance: 150.0,
                  refreshIndicatorExtent: 60.0,
                  onRefresh: () async {
                    context
                        .read<AssetBloc>()
                        .add(const AssetRefreshRequested());
                    await Future.delayed(const Duration(milliseconds: 50));
                    while (
                        context.read<AssetBloc>().state is AssetsRefreshing) {
                      await Future.delayed(const Duration(milliseconds: 50));
                    }
                  }),
              BlocConsumer<WalletBloc, WalletState>(builder: ((context, state) {
                if (state is WalletInitial) {
                   context.read<WalletBloc>().add(const WalletsRequested());
                }

                if (state is WalletsLoaded) {
                  return _assetList();
                }

                if (state is WalletsEmpty) {
                  return _addWalletsPrompt();
                }

                return const SliverFillRemaining(
                    child: Center(child: Text("Wallets empty")));
              }), listener: (context, state) {
                if(kDebugMode)  print("WalletState: $state");
                
              }),
              const SliverPadding(padding: EdgeInsets.only(bottom: 40))
            ]));
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: const [
                Expanded(
                    child: Image(
                  image: AssetImage('assets/logo.png'),
                )),
                // Text("Powered by BscScan, EtherScan, Snowtrace & CoinGecko APIs", style: TextStyle(color: Colors.grey[400]),)
              ],
            ),
          ),
          ListTile(
              title: const Text("Tracked wallets"),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const TrackedSourcesScreen(),
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget _portfolioHeader() {
    return Stack(alignment: Alignment.bottomCenter, children: [
/*
        Align(
                        alignment: Alignment.bottomCenter,
                        child: PortfolioGraph(data: assets)) ,
                        */

      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        const SizedBox(
          height: 50,
        ),
        const Text('Total portfolio value'),
        BlocConsumer<AssetBloc, AssetState>(
            buildWhen: (previous, current) {
              return current is! AssetsRefreshing;
            },
            builder: ((context, state) {
              if (state is AssetsLoaded) {
                return Text(
                  '\$' + state.portfolioValue.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 38,
                  ),
                );
              }
              if (state is AssetsLoading) {
                return Shimmer.fromColors(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    baseColor: Colors.grey.shade700,
                    highlightColor: Colors.grey.shade400);
              }
              return const SizedBox();
            }),
            listener: (context, state) {}),
        const SizedBox(
          height: 30,
        ),
        const SizedBox(
          height: 10,
        ),

        /*
        ToggleButtons(
            borderRadius: BorderRadius.circular(25),
            borderWidth: 2.0,
            children: const [Text('1D'), Text('1W'), Text('1M'), Text('All')],
            onPressed: (int index) {
              setState(() {
                selectedFrame = [false, false, false, false];
                selectedFrame[index] = true;
              });
            },
            isSelected: selectedFrame),
            */
        const SizedBox(height: 50)
      ]),
    ]);
  }

  Widget _assetList() {
    return BlocConsumer<AssetBloc, AssetState>(
      buildWhen: (previous, current) {
        return current is! AssetsRefreshing;
      },
      listener: ((context, state) {}),
      builder: ((context, state) {
        if (state is AssetsLoading) {
          return SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return const AssetTileShimmer();
          }, childCount: 10));
        }

        if (state is AssetInitial || state is AssetsEmpty) {}

        if (state is AssetsLoaded) {
          return SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return AssetTile(
                asset: state.assets[index],
                pvalue: state.portfolioValue,
              );
            }, childCount: state.assets.length),
          );
        }
        return const SliverFillRemaining(child: SizedBox());
      }),
    );
  }

  Widget _addWalletsPrompt() {
    return SliverFillRemaining(
        child: Center(
      child: Column(
        children: [
          const Text("You haven't added any wallets yet"),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const TrackedSourcesScreen()));
              },
              child: const Text("Add wallets"))
        ],
      ),
    ));
  }
}
