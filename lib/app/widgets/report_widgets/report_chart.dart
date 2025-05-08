import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportChart extends StatelessWidget {
  final double fatigueScore;

  const ReportChart({
    super.key,
    required this.fatigueScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: BarChart(
          BarChartData(
            maxY: 100,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(toY: fatigueScore * 100, width: 16),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (_, __) => const Text('Fatiga %', style: TextStyle(fontSize: 12)),
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
