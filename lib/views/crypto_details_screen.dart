import 'package:bonkfolio/repositories/asset_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bonkfolio/models/asset.dart';
import 'package:bonkfolio/models/crypto_tx.dart';

import 'package:pie_chart/pie_chart.dart';

import '../models/crypto.dart';
import '../widgets/asset_graph.dart';
import '../misc/globals.dart' as globals;


class AssetDetailsScreen extends StatelessWidget {
  final Asset asset;
  final List<CryptoTX> txs;
  final double pValue;
  final controller = ScrollController();
  final nf = NumberFormat.compact();

  AssetDetailsScreen({
    Key? key,
    required this.asset,
    required this.pValue,
    required this.txs,
  }) : super(
          key: key,
        );

  Widget _infoTile({required String title, required Widget child, double? height, double? width}) {
    return SizedBox(
        width: width,
        height: height,
        child: Card(
          
          borderOnForeground: false,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              child,
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
            shrinkWrap: false,
            //controller: controller,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
          SliverAppBar(
            stretch: true,
            title: Text(asset.name),
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                children: [
                  AssetGraph(data: txs, charts: asset.chart!),
                  Positioned(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter)),
                    ),
                    bottom: 0,
                  )
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Column(
                  children: [
                    _infoTile(
                      width: globals.useVerticalLayout ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.25,
                        title: 'Amount holding',
                        child: Text(
                          nf.format(asset.amount),
                          style: const TextStyle(fontSize: 30),
                        )),
                    _infoTile(
                      width: globals.useVerticalLayout ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.25,
                        title: 'Reflections earned',
                        child: Text(
                          nf.format(asset.amount - asset.amountBought),
                          style: const TextStyle(fontSize: 30),
                        )),
                    _infoTile(
                      width: globals.useVerticalLayout ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.25,
                        title: 'Unrealized PnL',
                        child: Text(
                          '\$${(asset.amount * asset.price - asset.amount * asset.avgBuyPrice).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 30),
                        )),
                  ],
                ),
                _infoTile(
                  width: globals.useVerticalLayout ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.25,
                    title: 'Cash value',
                    child: Column(children: [
                      Text(
                        '\$' + (asset.amount * asset.price).toStringAsFixed(2),
                        style: const TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          '${(((asset.amount * asset.price) / pValue) * 100).toStringAsFixed(1)}% of portfolio'),
                      const SizedBox(
                        height: 20,
                      ),
                      PieChart(
                        gradientList: const [
                          [
                            Color(0xff23b6e6),
                            Color(0xff02d39a),
                          ],
                        ],
                        chartRadius: globals.useVerticalLayout ? MediaQuery.of(context).size.width * 0.3 : MediaQuery.of(context).size.width * 0.1,
                        dataMap: {
                          'this': ((asset.amount * asset.price)),
                        },
                        totalValue: pValue,
                        baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                        chartType: ChartType.ring,
                        legendOptions: const LegendOptions(showLegends: false),
                        chartValuesOptions:
                            const ChartValuesOptions(showChartValues: false),
                      )
                    ])),
                _infoTile(
                  width: MediaQuery.of(context).size.width,
                  title: 'Weighted average buy price',
                  child: Text(
                    asset.avgBuyPrice.toString(),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                _infoTile(
                  width: MediaQuery.of(context).size.width,
                 title: 'Current price',
                 child: Text(
                    asset.price.toString(),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ]))
        ]));
  }
}
