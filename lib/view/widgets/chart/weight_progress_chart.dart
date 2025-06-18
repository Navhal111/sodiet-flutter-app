import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sodiet/model/weight_data.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class WeightProgressChart extends StatelessWidget {
  final List<WeightData> weightDataList;
  final String title;
  final Color titleColor;
  final double titleFontSize;
  final Color loggedWeightColor;
  final Color plannedWeightColor;
  final bool showRightAxisLabels;

  // Y-axis ranges
  final double minKcal;
  final double maxKcal;
  final double minWeight;
  final double maxWeight;

  const WeightProgressChart({
    Key? key,
    required this.weightDataList,
    this.title = 'Plan Progress',
    this.titleColor = Colors.black87,
    this.titleFontSize = 20,
    this.loggedWeightColor = const Color.fromRGBO(48, 0, 129, 1), // Deep purple
    this.plannedWeightColor = const Color.fromRGBO(255, 99, 132, 1), // Pink
    this.showRightAxisLabels = true,
    this.minKcal = 0.0,
    this.maxKcal = 1.0,
    this.minWeight = 96.0,
    this.maxWeight = 100.0,
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
          SemiBoldText(
            title,
            fontSize: titleFontSize,
            textColor: titleColor,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: LineChart(
              _createChartData(context),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                context,
                'Logged KCal',
                loggedWeightColor,
              ),
              const SizedBox(width: 32),
              _buildLegendItem(
                context,
                'Planned weight',
                plannedWeightColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        RegularText(
          label,
          fontSize: 14,
        ),
      ],
    );
  }

  LineChartData _createChartData(BuildContext context) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: 0.1, // For KCal 0.0-1.0 range with 0.1 increments
        verticalInterval: 2, // Every 2 days, more grid lines like in the design
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: showRightAxisLabels,
            reservedSize: 40,
            interval: 0.25, // Show fewer weight labels for clarity
            getTitlesWidget: (value, meta) {
              // Convert normalized y-value back to weight value (96-100 range)
              double weightValue = ((value - minKcal) / (maxKcal - minKcal)) *
                      (maxWeight - minWeight) +
                  minWeight;

              // Round to nearest whole number for cleaner display
              int weightInt = weightValue.round();

              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 5,
                child: Text(
                  '$weightInt', // Show as integer (96, 97, 98, 99, 100)
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
          ),
          axisNameWidget: Transform.rotate(
            angle: 0, // 90 degrees in radians
            child: const Text(
              'Weight',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: const Text(
            'Day',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              // Show more day markers to match design
              if (value % 2 != 0 && value != 1 && value != 30) {
                return const SizedBox();
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Transform.rotate(
            angle: 0, // 90 degrees in radians
            child: const Text(
              'KCal',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              // Only show certain values for better readability
              if ((value * 10).round() % 2 != 0 &&
                  value != 0.0 &&
                  value != 1.0) {
                return const SizedBox();
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
            interval: 0.1, // 0.1 increments for KCal
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          left: BorderSide(color: Colors.grey.shade300, width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      minX: 1,
      maxX: 30, // Full month view
      minY: minKcal,
      maxY: maxKcal, // KCal range (left Y-axis)
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black.withOpacity(0.8),
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              // Determine data type and text color based on bar index
              String dataType = flSpot.barIndex == 0 ? 'KCal' : 'Weight';
              Color textColor =
                  flSpot.barIndex == 0 ? loggedWeightColor : plannedWeightColor;

              // Get the original data for this point
              int day = flSpot.x.toInt();
              WeightData? originalData = weightDataList.firstWhere(
                  (data) => data.day == day,
                  orElse: () =>
                      WeightData(day: day, loggedWeight: -1, plannedWeight: 0));

              // Use original weight value for planned weight (not the normalized displayed value)
              String yValue = flSpot.barIndex == 0
                  ? flSpot.y
                      .toStringAsFixed(1) // KCal format - decimal precision
                  : originalData.plannedWeight.toStringAsFixed(
                      1); // Original weight value with decimal precision

              return LineTooltipItem(
                '${dataType}: $yValue\nDay: ${flSpot.x.toInt()}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: '\n${flSpot.barIndex == 0 ? 'Logged' : 'Planned'}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          // Custom touch callback can be implemented here
        },
      ),
      lineBarsData: [
        // Logged Weight Line
        LineChartBarData(
          spots: _getLoggedWeightSpots(),
          isCurved: true,
          color: loggedWeightColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: loggedWeightColor,
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // Planned Weight Line
        LineChartBarData(
          spots: _getPlannedWeightSpots(),
          isCurved: true,
          color: plannedWeightColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: plannedWeightColor,
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  } // KCal values are already in the correct scale (0.0-1.0)

  List<FlSpot> _getLoggedWeightSpots() {
    List<FlSpot> spots = [];
    for (var data in weightDataList) {
      // Only add spots for days that have logged weight data
      if (data.loggedWeight >= 0) {
        spots.add(FlSpot(data.day.toDouble(), data.loggedWeight));
      }
    }

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  // Normalize weight values (96.0-100.0) to KCal scale (0.0-1.0) for display
  List<FlSpot> _getPlannedWeightSpots() {
    // Get all valid planned weight spots and sort them
    List<FlSpot> spots = weightDataList.map((data) {
      // Normalize the weight to the KCal scale for visualization
      double normalizedWeight =
          ((data.plannedWeight - minWeight) / (maxWeight - minWeight)) *
                  (maxKcal - minKcal) +
              minKcal;

      return FlSpot(data.day.toDouble(), normalizedWeight);
    }).toList();

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }
}
