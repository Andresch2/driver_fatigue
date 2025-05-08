import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailChart extends StatelessWidget {
  final double scoreFatiga;
  final double probOjos;
  final double inclinacion;
  final bool bostezos;

  const DetailChart({
    super.key,
    required this.scoreFatiga,
    required this.probOjos,
    required this.inclinacion,
    required this.bostezos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: BarChart(
        BarChartData(
          maxY: 100,
          barGroups: [
            BarChartGroupData(x: 0, barRods: [ BarChartRodData(toY: scoreFatiga * 100) ]),
            BarChartGroupData(x: 1, barRods: [ BarChartRodData(toY: probOjos * 100) ]),
            BarChartGroupData(x: 2, barRods: [ BarChartRodData(toY: inclinacion * 100) ]),
            BarChartGroupData(x: 3, barRods: [ BarChartRodData(toY: bostezos ? 100 : 0) ]),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const labels = ['Fatiga', 'Ojos', 'Cabeza', 'Bostezo'];
                  final idx = value.toInt();
                  return Text(idx < labels.length ? labels[idx] : '',
                              style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true, horizontalInterval: 20),
        ),
      ),
    );
  }
}
