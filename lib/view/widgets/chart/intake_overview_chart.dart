import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class IntakeData {
  final DateTime date;
  final double breakfast;
  final double lunch;
  final double dinner;
  final double snacks;

  IntakeData({
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });
}

class IntakeOverviewChart extends StatelessWidget {
  final List<IntakeData> intakeDataList;
  final String title;
  final Color titleColor;
  final double titleFontSize;

  const IntakeOverviewChart({
    Key? key,
    required this.intakeDataList,
    this.title = 'Intake Overview',
    this.titleColor = const Color(0xFF091242),
    this.titleFontSize = 22,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          SemiBoldText(title, fontSize: 22, textColor: titleColor),
          const SizedBox(height: 16),
          _buildLegend(),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: LineChart(
              _buildLineChartData(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Breakfast', const Color(0xFF64B5F6)),
        const SizedBox(width: 16),
        _buildLegendItem('Lunch', const Color(0xFF4CAF50)),
        const SizedBox(width: 16),
        _buildLegendItem('Dinner', const Color(0xFF9C27B0)),
        const SizedBox(width: 16),
        _buildLegendItem('Snacks', const Color(0xFFFFD54F)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        MediumText(
          label,
          fontSize: 12,
        ),
      ],
    );
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 500,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < intakeDataList.length) {
                final date = intakeDataList[value.toInt()].date;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Text(
            'Energy in kCal',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 500,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: (intakeDataList.length - 1).toDouble(),
      minY: 0,
      maxY: 2000,
      lineBarsData: [
        // Snacks (bottom layer)
        _buildAreaChart(
          _getSpots((data) => data.snacks),
          const Color(0xFFFFD54F),
          0.6,
        ),
        // Dinner (second layer)
        _buildAreaChart(
          _getSpots((data) => data.snacks + data.dinner),
          const Color(0xFF9C27B0),
          0.6,
        ),
        // Lunch (third layer)
        _buildAreaChart(
          _getSpots((data) => data.snacks + data.dinner + data.lunch),
          const Color(0xFF4CAF50),
          0.6,
        ),
        // Breakfast (top layer)
        _buildAreaChart(
          _getSpots((data) =>
              data.snacks + data.dinner + data.lunch + data.breakfast),
          const Color(0xFF64B5F6),
          0.6,
        ),
      ],
    );
  }

  LineChartBarData _buildAreaChart(
      List<FlSpot> spots, Color color, double opacity) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(opacity),
      ),
    );
  }

  List<FlSpot> _getSpots(double Function(IntakeData) valueExtractor) {
    return intakeDataList.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), valueExtractor(entry.value));
    }).toList();
  }
}
