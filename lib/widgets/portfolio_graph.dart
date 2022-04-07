import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:bonkfolio/models/asset.dart';

class PortfolioGraph extends StatefulWidget {
  const PortfolioGraph({Key? key, required this.data}) : super(key: key);
  final List<Asset> data;

  @override
  _PortfolioGraphState createState() => _PortfolioGraphState();
}

class _PortfolioGraphState extends State<PortfolioGraph> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
/*
  List<FlSpot> makeData() {

  }
*/
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),

      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0, //widget.data[0].boughtAt.millisecondsSinceEpoch.toDouble(),
      maxX: DateTime.now().millisecondsSinceEpoch.toDouble(),
      minY: 0,
      maxY: widget.data[0].price,
      lineBarsData: [
        LineChartBarData(
          spots: [
            /*
            FlSpot(widget.data[0].boughtAt.millisecondsSinceEpoch.toDouble(),
                widget.data[0].priceAtBuy),
            FlSpot(
                widget.data[0].boughtAt.millisecondsSinceEpoch.toDouble() +
                    1000 * 60 * 60 * 24,
                0.00000002),
            FlSpot(
                widget.data[0].boughtAt.millisecondsSinceEpoch.toDouble() +
                    1000 * 60 * 60 * 24 * 2,
                0.00000003),
            FlSpot(
                widget.data[0].boughtAt.millisecondsSinceEpoch.toDouble() +
                    1000 * 60 * 60 * 24 * 3,
                0.00000004),
            FlSpot(
                widget.data[0].boughtAt.millisecondsSinceEpoch.toDouble() +
                    1000 * 60 * 60 * 24 * 9,
                0.00000005),
            FlSpot(
                widget.data[0].boughtAt.millisecondsSinceEpoch.toDouble() +
                    1000 * 60 * 60 * 24 * 16,
                0.00000006),
            FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(),
                this.widget.data[0].price),
                */
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors:
                gradientColors.map((color) => color.withOpacity(0.5)).toList(),
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.05))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
