import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bonkfolio/models/asset.dart';
import 'package:bonkfolio/models/crypto.dart';
//import 'package:bonkfolio/models/wallet.dart';
import 'package:bonkfolio/repositories/xscan_repo.dart';
import 'package:bonkfolio/repositories/coingecko_repo.dart';
import 'package:bonkfolio/repositories/database_repo.dart';
import 'package:bonkfolio/views/tracked_sources_screen.dart';
import 'package:bonkfolio/widgets/asset_tile.dart';
import 'package:bonkfolio/widgets/asset_tile_shimmer.dart';
import 'dart:io' show Platform;

import '../models/database.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  double dobos = 0;
  double profits = 0;
  double dobobuyprice = 0.000000077442;
  double dobobuyamount = 0;
  double doboprice = 0;
  double portfolioValue = 0.0;
  List<bool> selectedFrame = [false, false, false, true];
  List<Asset> assets = [];
  bool hidezero = false;
  final nf = NumberFormat.compact();
  final String address =
      //'0xb60010fd99dc4fac1e3834ce20f623f3ede2df14';
      "0x0Ac876efFcde0C614bff9F7cAA1E6bE59668332F";
  final cgRepo = CoinGeckoRepo();
  List<Wallet> wallets = [];
  bool isReloading = false;

  void updateWallets() {
    DatabaseRepo().getWallets().then((value) {
      setState(() {
        wallets = value;
      });
    });
  }

  Future reload() async {
    setState(() {
      isReloading = true;
    });
    final start = DateTime.now().millisecondsSinceEpoch;
    bool txsLoading = true;

    final List<Asset> ls = [];
    final addresses = wallets.map((e) => e.address).toList();
    XScanRepo().getAssets(addresses).then((value) {
      ls.addAll(value);
      txsLoading = false;
    });

    while (txsLoading) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
    double v = 0.0;
    for (var e in ls) {
      v += (e.amount * e.price);
    }
    ls.sort((a, b) => (a.amount * a.price).compareTo((b.amount * b.price)));
    if (kDebugMode) {
      ("RELOADED IN ${DateTime.now().millisecondsSinceEpoch - start}ms");
    }
    setState(() {
      assets = ls.reversed.toList();
      portfolioValue = v;
      isReloading = false;
    });
  }

  Future refresh() async {
    List<String> contracts = [];
    for (var asset in assets.where((e) => e.isSupported)) {
      contracts.add((asset as Crypto).contractAddress);
    }
    List<String> cgIds = [];
    for (var contract in contracts) {
      try {
        cgIds.add(
            CoinGeckoRepo().metas.firstWhere((e) => e.id == contract).cgId);
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }

    final map = await CoinGeckoRepo().getPricesByIDs(cgIds);
    final supported = assets.where((element) => element.isSupported).toList();
    for (var i = 0; i <= supported.length - 1; i++) {
      Crypto c = (supported[i] as Crypto);
      c.price = map[CoinGeckoRepo()
          .metas
          .firstWhere((element) => element.id == c.contractAddress)
          .cgId];
      supported[i] = c;
    }
    assets.removeWhere((element) => element.isSupported);
    assets.addAll(supported);
    assets.sort((a, b) => (a.amount * a.price).compareTo(b.amount * b.price));
    double v = 0.0;
    for (var e in assets) {
      v += (e.amount * e.price);
    }
    setState(() {
      assets = assets.reversed.toList();
      portfolioValue = v;
    });
  }

  void changeTimeFrame(String frame) {
    switch (frame) {
      case 'day':
        break;
      case 'week':
        break;
      case 'month':
        break;
      case 'all':
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    updateWallets();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      updateWallets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _drawer(),
        body: CustomScrollView(
            cacheExtent: 3500,
            physics: (Platform.isIOS
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
                        reload();
                      } else {
                        setState(() {
                          hidezero = !hidezero;
                        });
                      }
                    }, itemBuilder: (BuildContext context) {
                      return [
                        CheckedPopupMenuItem<String>(
                          value: "Hide zero-ish",
                          child: const Text("Hide zero-ish"),
                          enabled: true,
                          checked: hidezero,
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
                  onRefresh: refresh),
              wallets.isEmpty ? _addWalletsPrompt() : _assetList(),
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
        Text(
          '\$' + portfolioValue.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 38,
          ),
        ),
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
    if (!isReloading) {
      if (assets.isEmpty) {
        WidgetsBinding.instance!.addPostFrameCallback((timestamp) {
          reload();
        });
        return const SliverFillRemaining(child: SizedBox());
      }
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (!isReloading) {
          if (hidezero) {
            if (assets[index].amount * assets[index].price > 1) {
              return AssetTile(
                asset: assets[index],
                pvalue: portfolioValue,
              );
            }
          } else {
            return AssetTile(
              asset: assets[index],
              pvalue: portfolioValue,
            );
          }
        } else {
          return const AssetTileShimmer();
        }
        return null;
      }, childCount: (assets.isEmpty ? 10 : assets.length)),
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
