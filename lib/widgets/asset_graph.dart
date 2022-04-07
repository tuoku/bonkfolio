import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bonkfolio/models/crypto_tx.dart';
import 'package:bonkfolio/models/pricepoint.dart';

class AssetGraph extends StatefulWidget {
  const AssetGraph({Key? key, required this.data, required this.charts})
      : super(key: key);
  final List<CryptoTX> data;
  final List<PricePoint> charts;

  @override
  _AssetGraphState createState() => _AssetGraphState();
}

class _AssetGraphState extends State<AssetGraph> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;
  double resultsLength = 0;
/*
  List<FlSpot> makeData() {

  }
*/
  @override
  void initState() {
    super.initState();
    widget.charts.asMap().entries.map((e) {
      int i = e.key;
      if (e.value.time.day == widget.charts[i - 1].time.day) {
        widget.charts.removeAt(i);
      }
    });
    final top = widget.charts.fold(
        widget.charts[0].price,
        (previousValue, element) => previousValue as double > element.price
            ? previousValue
            : element.price);

    final bottom = widget.charts.fold(
        widget.charts[0].price,
        (previousValue, element) => previousValue as double < element.price
            ? previousValue
            : element.price);

    final range = top - bottom;

    minX = widget.charts.first.time.millisecondsSinceEpoch.toDouble();
    maxX = widget.charts.last.time.millisecondsSinceEpoch.toDouble();
    maxY = range + top;
    minY = max(range - bottom, 0);

    if (kDebugMode) print("BOTTOM: $bottom");
    if (kDebugMode) print("TOP: $top");
    if (kDebugMode) print("minY: $minY, maxY: $maxY");

    resultsLength = widget.charts.last.time.millisecondsSinceEpoch.toDouble();
  }

  List<FlSpot> spotss = [];

  List<PricePoint> reducedChart = [];

  Future<Widget> graph() async {
    Map map = {};
    map['data'] = widget.data;
    map['charts'] = widget.charts;
    spotss = await compute(calcSpots, map);
    for (var i = 0; i <= widget.charts.length; i++) {
      if (i % 10 == 0) {
        reducedChart.add(widget.charts[i]);
      }
    }
    return LineChart(
      mainData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: graph(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = snapshot.data;
        } else if (snapshot.hasError) {
          child = const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
          child = const Center(
            child: CircularProgressIndicator(),
          );
        }
        return child;
      },
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          enabled: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              List<LineTooltipItem> items = [];
              for (var spot in touchedSpots) {
                items.add(LineTooltipItem(
                    DateTime.fromMillisecondsSinceEpoch(spot.x.toInt())
                        .toString(),
                    const TextStyle()));
              }
              return items;
            },
          )),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
              reducedChart.length,
              (index) => FlSpot(
                  reducedChart[index].time.millisecondsSinceEpoch.toDouble(),
                  reducedChart[index].price)),
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors.map((color) => color.withOpacity(1.0)).toList(),),
          
              
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(colors:  gradientColors.map((color) => color.withOpacity(0.2)).toList(),),
            
               
          ),
        ),
        LineChartBarData(
          spots: spotss,
          isCurved: true,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }
}

Future<List<FlSpot>> calcSpots(map) async {
  final data = map['data'];
  final charts = map['charts'];
  return List.generate(
      data.length,
      (i) => FlSpot(
          data[i].time.millisecondsSinceEpoch.toDouble(),
          charts
              .firstWhere((e) =>
                  e.time.millisecondsSinceEpoch.toDouble() ==
                  (charts.fold(
                      charts[0].time.millisecondsSinceEpoch.toDouble(),
                      (previousValue, element) =>
                          (element.time.millisecondsSinceEpoch.toDouble() -
                                          data[i]
                                              .time
                                              .millisecondsSinceEpoch
                                              .toDouble())
                                      .abs() <
                                  ((previousValue as double) -
                                          data[i]
                                              .time
                                              .millisecondsSinceEpoch
                                              .toDouble())
                                      .abs()
                              ? element.time.millisecondsSinceEpoch.toDouble()
                              : previousValue)))
              .price));
}
