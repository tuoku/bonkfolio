import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycryptos/models/asset.dart';
import 'package:mycryptos/models/crypto.dart';
import 'package:mycryptos/models/crypto_tx.dart';
import 'package:mycryptos/models/pricepoint.dart';
import 'package:mycryptos/repositories/xscan_repo.dart';
import 'package:mycryptos/widgets/asset_graph.dart';
import 'package:mycryptos/widgets/portfolio_graph.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class AssetDetailsScreen extends StatefulWidget {
  final Asset asset;
  List<CryptoTX> txs = [];

  AssetDetailsScreen({
    Key? key,
    required this.asset,
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      enableGraph();
    });
  }

  Widget graph = Center(child: CircularProgressIndicator());

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
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
          SliverAppBar(
            stretch: true,
            title: Text(widget.asset.name),
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              background: InteractiveViewer(
                  child: graph),
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
                              SizedBox(height: 10),
                              Text(
                                'Amount holding',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                nf.format(widget.asset.amount),
                                style: TextStyle(fontSize: 30),
                              ),
                              SizedBox(
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
                              SizedBox(height: 10),
                              Text(
                                'Reflections earned',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                nf.format(widget.asset.amount -
                                    widget.asset.amountBought),
                                style: TextStyle(fontSize: 30),
                              ),
                              SizedBox(
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
                              SizedBox(height: 10),
                              Text(
                                'Unrealized PnL',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '\$${(widget.asset.amount * widget.asset.price - widget.asset.amount * widget.asset.avgBuyPrice).toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 30),
                              ),
                              SizedBox(
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
                              SizedBox(height: 10),
                              Text(
                                'Cash value',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '\$' +
                                    (widget.asset.amount * widget.asset.price)
                                        .toStringAsFixed(2),
                                style: TextStyle(fontSize: 30),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${(((widget.asset.amount * widget.asset.price) / 500) * 100).toStringAsFixed(1)}% of portfolio'),
                              SizedBox(
                                height: 20,
                              ),
                              PieChart(
                                
                                gradientList: [
                                  [
                                    const Color(0xff23b6e6),
                                    const Color(0xff02d39a),
                                  ],
                                 
                                ],
                                chartRadius:
                                    MediaQuery.of(context).size.width * 0.3,
                                dataMap: {
                                  
                                  'other': 100 -
                                      ((widget.asset.amount *
                                                  widget.asset.price) /
                                              500) *
                                          100,
                                          'this': ((widget.asset.amount *
                                              widget.asset.price) /
                                          500) *
                                      100,
                                },
                                chartType: ChartType.ring,
                                legendOptions:
                                    LegendOptions(showLegends: false),
                                chartValuesOptions:
                                    ChartValuesOptions(showChartValues: false),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    borderOnForeground: false,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Weighted average buy price',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.asset.avgBuyPrice.toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    borderOnForeground: false,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Current price',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.asset.price.toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(
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
