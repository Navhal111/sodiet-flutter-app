import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sodiet/model/fat_log.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class FatLogChart extends StatelessWidget {
  final List<FatLog> fatLogs;
  final String title;
  final Color titleColor;
  final double titleFontSize;

  const FatLogChart({
    Key? key,
    required this.fatLogs,
    this.title = 'Body Fat Trend',
    this.titleColor = Colors.black87,
    this.titleFontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fatLogs.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SemiBoldText(
              title,
              fontSize: titleFontSize,
              textColor: titleColor,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    RegularText(
                      'No body fat data available',
                      fontSize: 14,
                      textColor: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SemiBoldText(
                title,
                fontSize: titleFontSize,
                textColor: titleColor,
              ),
              // Legend
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BCD4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  RegularText(
                    'Body Fat %',
                    fontSize: 12,
                    textColor: Colors.grey.shade600,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Chart
          Expanded(
            child: LineChart(
              _buildChartData(),
              duration: const Duration(milliseconds: 250),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    final sortedLogs = List<FatLog>.from(fatLogs);
    sortedLogs.sort((a, b) =>
        DateTime.parse(a.logDate).compareTo(DateTime.parse(b.logDate)));

    final spots = <FlSpot>[];
    double minFat = double.infinity;
    double maxFat = double.negativeInfinity;

    for (int i = 0; i < sortedLogs.length; i++) {
      final fatPct = sortedLogs[i].bodyFatPct;
      spots.add(FlSpot(i.toDouble(), fatPct));

      if (fatPct < minFat) minFat = fatPct;
      if (fatPct > maxFat) maxFat = fatPct;
    }

    // Add padding to the Y-axis range
    final fatRange = maxFat - minFat;
    final padding = fatRange * 0.1;
    final chartMinY = (minFat - padding).clamp(0.0, double.infinity);
    final chartMaxY = maxFat + padding;

    return LineChartData(
      minY: chartMinY.toDouble(),
      maxY: chartMaxY.toDouble(),
      minX: 0,
      maxX: (sortedLogs.length - 1).toDouble(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: (chartMaxY - chartMinY) / 5,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 0.5,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: _calculateXAxisInterval(sortedLogs.length),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < sortedLogs.length) {
                final date = DateTime.parse(sortedLogs[index].logDate);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.month}/${date.day}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: (chartMaxY - chartMinY) / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          left: BorderSide(color: Colors.grey.shade300, width: 1),
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: const Color(0xFF00BCD4),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: const Color(0xFF00BCD4),
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF00BCD4).withOpacity(0.3),
                const Color(0xFF00BCD4).withOpacity(0.1),
                const Color(0xFF00BCD4).withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final index = barSpot.x.toInt();
              if (index >= 0 && index < sortedLogs.length) {
                final log = sortedLogs[index];
                final date = DateTime.parse(log.logDate);
                return LineTooltipItem(
                  '${date.month}/${date.day}/${date.year}\n${log.bodyFatPct.toStringAsFixed(1)}%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }
              return null;
            }).toList();
          },
        ),
      ),
    );
  }

  double _calculateXAxisInterval(int dataLength) {
    if (dataLength <= 5) return 1;
    if (dataLength <= 10) return 2;
    if (dataLength <= 20) return 4;
    return (dataLength / 5).ceil().toDouble();
  }
}
