import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bonkfolio/models/asset.dart';
import 'package:bonkfolio/models/crypto.dart';
import 'package:bonkfolio/models/crypto_tx.dart';
import 'package:bonkfolio/repositories/xscan_repo.dart';
import 'package:bonkfolio/widgets/asset_graph.dart';
import 'package:pie_chart/pie_chart.dart';

class AssetDetailsScreen extends StatefulWidget {
  final Asset asset;
  final List<CryptoTX> txs = [];
  final double pValue;

  AssetDetailsScreen({
    Key? key,
    required this.asset,
    required this.pValue,
  }) : super(
          key: key,
        );
  @override
  State<AssetDetailsScreen> createState() => AssetDetailsScreenState();
}

class AssetDetailsScreenState extends State<AssetDetailsScreen> {
  final nf = NumberFormat.compact();
  List<CryptoTX> txs = [];

  AssetDetailsScreenState({Key? key});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      enableGraph();
    });
  }

  Widget graph = const Center(child: CircularProgressIndicator());

  void enableGraph() {
    setState(() {
      graph = AssetGraph(
        data: XScanRepo()
            .txCache
            .where((element) =>
                element.contractAddress.toLowerCase() ==
                (widget.asset as Crypto).contractAddress.toLowerCase())
            .toList(),
        charts: widget.asset.chart!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
          SliverAppBar(
            stretch: true,
            title: Text(widget.asset.name),
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(children: [
              graph,
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: 
                    LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter)), ),
              bottom: 0, )
              ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Card(
                          borderOnForeground: false,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Amount holding',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                nf.format(widget.asset.amount),
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Card(
                          borderOnForeground: false,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Reflections earned',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                nf.format(widget.asset.amount -
                                    widget.asset.amountBought),
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Card(
                          borderOnForeground: false,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Unrealized PnL',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '\$${(widget.asset.amount * widget.asset.price - widget.asset.amount * widget.asset.avgBuyPrice).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Card(
                          borderOnForeground: false,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Cash value',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '\$' +
                                    (widget.asset.amount * widget.asset.price)
                                        .toStringAsFixed(2),
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${(((widget.asset.amount * widget.asset.price) / widget.pValue) * 100).toStringAsFixed(1)}% of portfolio'),
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
                                chartRadius:
                                    MediaQuery.of(context).size.width * 0.3,
                                dataMap: {
                                  'other': 100 -
                                      ((widget.asset.amount *
                                                  widget.asset.price) /
                                              widget.pValue) *
                                          100,
                                  'this': ((widget.asset.amount *
                                              widget.asset.price) /
                                          widget.pValue) *
                                      100,
                                },
                                chartType: ChartType.ring,
                                legendOptions:
                                    const LegendOptions(showLegends: false),
                                chartValuesOptions: const ChartValuesOptions(
                                    showChartValues: false),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    borderOnForeground: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Weighted average buy price',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.asset.avgBuyPrice.toString(),
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    borderOnForeground: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Current price',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.asset.price.toString(),
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
            ]),
          ]))
        ]));
  }
}
