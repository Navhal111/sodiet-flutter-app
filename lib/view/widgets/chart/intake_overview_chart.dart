import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sodiet/model/plan_model.dart' as models;
import 'package:sodiet/view/widgets/app_text.dart';

class IntakeOverviewChart extends StatelessWidget {
  final models.IntakeOverviewChart? intakeData;
  final String title;
  final Color titleColor;
  final double titleFontSize;

  const IntakeOverviewChart({
    Key? key,
    this.intakeData,
    this.title = 'Intake Overview',
    this.titleColor = const Color(0xFF091242),
    this.titleFontSize = 22,
  }) : super(key: key);

  // Centralized color map to ensure consistency between legend and chart
  static const Map<String, Color> mealColors = {
    'Breakfast': Color(0xFF5DADE2),
    'Lunch': Color(0xFF58D68D),
    'Dinner': Color(0xFFAB7FB0),
    'Snacks': Color(0xFFF7DC6F),
  };

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
          _buildTitleWithIcon(context),
          const SizedBox(height: 20),
          _buildLegend(),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: intakeData == null || intakeData!.dates.isEmpty
                ? Center(
                    child: RegularText(
                      'No intake data available',
                      textColor: Colors.grey,
                    ),
                  )
                : _buildScrollableChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleWithIcon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SemiBoldText(
          title,
          fontSize: titleFontSize,
          textColor: titleColor,
        ),
        GestureDetector(
          onTap: () => _showInfoPopup(context),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  void _showInfoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: titleColor),
              const SizedBox(width: 8),
              SemiBoldText(
                'Intake Overview Details',
                fontSize: 16,
                textColor: titleColor,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RegularText(
                  'This chart shows your daily calorie intake breakdown by meal type over time.',
                  fontSize: 14,
                  textColor: Colors.black87,
                ),
                const SizedBox(height: 12),
                SemiBoldText(
                  'Meal Categories:',
                  fontSize: 14,
                  textColor: titleColor,
                ),
                const SizedBox(height: 8),
                _buildInfoLegendItem('Breakfast', mealColors['Breakfast']!,
                    'Morning meal intake'),
                _buildInfoLegendItem(
                    'Lunch', mealColors['Lunch']!, 'Afternoon meal intake'),
                _buildInfoLegendItem(
                    'Dinner', mealColors['Dinner']!, 'Evening meal intake'),
                _buildInfoLegendItem(
                    'Snacks', mealColors['Snacks']!, 'Between-meal snacks'),
                const SizedBox(height: 12),
                RegularText(
                  'Tip: Swipe horizontally on the chart to view more data points.',
                  fontSize: 12,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: MediumText(
                'Got it',
                fontSize: 14,
                textColor: titleColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoLegendItem(String label, Color color, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediumText(
                  label,
                  fontSize: 13,
                  textColor: Colors.black87,
                ),
                RegularText(
                  description,
                  fontSize: 12,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    // Use Wrap to show all items and wrap to next line if needed
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem('Breakfast', mealColors['Breakfast']!),
        _buildLegendItem('Lunch', mealColors['Lunch']!),
        _buildLegendItem('Dinner', mealColors['Dinner']!),
        _buildLegendItem('Snacks', mealColors['Snacks']!),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        SemiBoldText(
          label,
          fontSize: 14,
          textColor: const Color(0xFF091242),
        ),
      ],
    );
  }

  Widget _buildScrollableChart() {
    // Calculate width based on number of data points
    final dataLength = intakeData!.dates.length;
    final minWidth = 350.0; // Minimum width for the chart
    final pointWidth = dataLength > 14 ? 40.0 : 50.0; // Responsive point width
    final chartWidth =
        (dataLength * pointWidth).clamp(minWidth, double.infinity);
    final needsScrolling = chartWidth > minWidth;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: chartWidth,
              height: 280,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 20.0), // Add padding for better scroll
                child: LineChart(
                  _buildLineChartData(),
                ),
              ),
            ),
          ),
        ),
        if (needsScrolling)
          Container(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swipe_left,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                RegularText(
                  'Swipe to see more data',
                  fontSize: 10,
                  textColor: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.swipe_right,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
      ],
    );
  }

  double _getOptimalInterval() {
    final dataLength = intakeData!.dates.length;

    // Calculate optimal interval to show 5-7 labels maximum
    if (dataLength <= 7) {
      return 1; // Show all dates if 7 or fewer
    } else if (dataLength <= 14) {
      return 2; // Show every 2nd date
    } else if (dataLength <= 21) {
      return 3; // Show every 3rd date
    } else if (dataLength <= 30) {
      return (dataLength / 6).ceil().toDouble(); // Show ~6 labels
    } else {
      return (dataLength / 5).ceil().toDouble(); // Show ~5 labels
    }
  }

  LineChartData _buildLineChartData() {
    if (intakeData == null || intakeData!.dates.isEmpty) {
      return LineChartData();
    }

    // Get max value for Y-axis
    double maxValue = 0;
    for (var series in intakeData!.series) {
      double seriesMax = series.data.isNotEmpty
          ? series.data.reduce((a, b) => a > b ? a : b)
          : 0;
      if (seriesMax > maxValue) maxValue = seriesMax;
    }

    // Calculate stacked max (sum of all series at each point) and ensure no negatives
    double stackedMax = 0;
    for (int i = 0; i < intakeData!.dates.length; i++) {
      double stackSum = 0;
      for (var series in intakeData!.series) {
        if (i < series.data.length) {
          // Clamp negative values to zero when calculating max
          double value = series.data[i] < 0 ? 0 : series.data[i];
          stackSum += value;
        }
      }
      if (stackSum > stackedMax) stackedMax = stackSum;
    }

    // Use stacked max instead of individual series max
    maxValue = stackedMax;

    print(
        'DEBUG: Max value calculated: $maxValue (from stacked max: $stackedMax)');

    // Round up to nearest 500 for clean scale, but handle very large values
    if (maxValue > 10000) {
      maxValue = ((maxValue / 2500).ceil() * 2500)
          .toDouble(); // Round to 2500s for large values
    } else {
      maxValue = ((maxValue / 500).ceil() * 500)
          .toDouble(); // Round to 500s for normal values
    }
    if (maxValue < 2500) maxValue = 2500; // Minimum scale

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxValue / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 0.8,
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
            reservedSize: 35,
            interval: _getOptimalInterval(),
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 &&
                  value.toInt() < intakeData!.dates.length) {
                final dateStr = intakeData!.dates[value.toInt()];
                // Parse date and format it nicely
                try {
                  final date = DateTime.parse(dateStr);
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RegularText(
                        '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                        fontSize: 10,
                        textColor: const Color(0xFF37474F),
                      ),
                    ),
                  );
                } catch (e) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RegularText(
                        dateStr.length > 5
                            ? dateStr.substring(dateStr.length - 5)
                            : dateStr,
                        fontSize: 10,
                        textColor: const Color(0xFF37474F),
                      ),
                    ),
                  );
                }
              }
              return RegularText('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxValue / 5,
            reservedSize: 40, // Reduced reserved space since no axis label
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8,
                child: RegularText(
                  value.toInt().toString(),
                  fontSize: 11,
                  textColor: const Color(0xFF37474F),
                ),
              );
            },
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
      minX: 0,
      maxX: (intakeData!.dates.length - 1).toDouble(),
      minY: 0, // Ensure chart never goes below zero
      maxY: maxValue,
      clipData: FlClipData.all(), // Clip any data outside bounds
      lineBarsData: _buildStackedAreaCharts(),
    );
  }

  List<LineChartBarData> _buildStackedAreaCharts() {
    if (intakeData == null || intakeData!.series.isEmpty) {
      return [];
    }

    print('DEBUG: Series data received:');
    for (var series in intakeData!.series) {
      print('  ${series.name}: ${series.data}');
      print('    Expected color: ${mealColors[series.name]}');
    }

    // Get series data organized by meal type and clamp negative values to zero
    Map<String, List<double>> seriesMap = {};
    for (var series in intakeData!.series) {
      seriesMap[series.name] =
          series.data.map((value) => value < 0 ? 0.0 : value).toList();
    }

    print('DEBUG: Available meals in API: ${seriesMap.keys.toList()}');
    print('DEBUG: Expected meal colors: ${mealColors.keys.toList()}');

    List<LineChartBarData> charts = [];

    // Create INDIVIDUAL line charts for each meal type (NOT STACKED)
    // Each meal will have its own line with its own color
    for (var entry in seriesMap.entries) {
      String mealType = entry.key;
      List<double> mealData = entry.value;

      Color mealColor = mealColors[mealType] ?? Colors.grey;
      print('DEBUG: Creating line for $mealType with color $mealColor');

      // Create individual line spots (not cumulative)
      List<FlSpot> spots = [];
      for (int i = 0; i < mealData.length; i++) {
        double value = mealData[i] < 0 ? 0.0 : mealData[i];
        spots.add(FlSpot(i.toDouble(), value));
      }

      charts.add(_buildIndividualLineChart(
        spots,
        mealColor,
        mealType,
      ));
    }

    return charts;
  }

  List<FlSpot> _getStackedSpots(String currentMeal, int stackLevel,
      Map<String, List<double>> seriesMap, List<String> mealOrder) {
    List<FlSpot> spots = [];

    print('DEBUG: Getting spots for $currentMeal at stack level $stackLevel');

    for (int i = 0; i < intakeData!.dates.length; i++) {
      double cumulativeValue = 0;

      // Add up all the values up to and including the current stack level
      for (int j = 0; j <= stackLevel; j++) {
        String meal = mealOrder[j];
        if (seriesMap.containsKey(meal) && i < seriesMap[meal]!.length) {
          // Ensure no negative values are added
          double value = seriesMap[meal]![i];
          double cleanValue = value < 0 ? 0 : value;
          cumulativeValue += cleanValue;

          if (i == 0 && cleanValue > 0) {
            // Debug first non-zero point
            print(
                '    $meal at index $i: $cleanValue (cumulative: $cumulativeValue)');
          }
        }
      }

      // Ensure cumulative value is never negative
      cumulativeValue = cumulativeValue < 0 ? 0 : cumulativeValue;
      spots.add(FlSpot(i.toDouble(), cumulativeValue));
    }

    return spots;
  }

  LineChartBarData _buildIndividualLineChart(
      List<FlSpot> spots, Color color, String mealName) {
    // Ensure all spots have Y >= 0
    List<FlSpot> cleanSpots =
        spots.map((spot) => FlSpot(spot.x, spot.y < 0 ? 0 : spot.y)).toList();

    print('DEBUG: Building individual line for $mealName with color: $color');

    return LineChartBarData(
      spots: cleanSpots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 3.0,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      // Add gradient fill area below each line
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.6), // More opaque at top
            color.withOpacity(0.1), // More transparent at bottom
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        cutOffY: 0, // Ensure area doesn't go below Y=0
        applyCutOffY: true,
      ),
    );
  }

  LineChartBarData _buildAreaChart(
      List<FlSpot> spots, Color color, double opacity) {
    // Ensure all spots have Y >= 0
    List<FlSpot> cleanSpots =
        spots.map((spot) => FlSpot(spot.x, spot.y < 0 ? 0 : spot.y)).toList();

    print('DEBUG: Building area chart with color: $color');

    return LineChartBarData(
      spots: cleanSpots,
      isCurved: true,
      curveSmoothness: 0.25,
      color: color,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        // Use solid color instead of gradient for better visibility
        color: color.withOpacity(opacity),
        cutOffY: 0, // Ensure area doesn't go below Y=0
        applyCutOffY: true,
      ),
    );
  }
}
