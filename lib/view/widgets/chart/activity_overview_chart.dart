import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sodiet/model/plan_model.dart' as models;

class ActivityOverviewChart extends StatelessWidget {
  final models.ActivityOverviewChart? activityData;
  final String title;
  final Color titleColor;
  final double titleFontSize;

  const ActivityOverviewChart({
    Key? key,
    this.activityData,
    this.title = 'Activity Overview',
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
          _buildTitleWithIcon(),
          const SizedBox(height: 20),
          _buildLegend(),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: activityData == null || activityData!.dates.isEmpty
                ? const Center(
                    child: Text(
                      'No activity data available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : _buildScrollableChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleWithIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        Container(
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
      ],
    );
  }

  Widget _buildLegend() {
    // Filter only activities that have data (not all zeros)
    List<String> activitiesWithData = _getActivitiesWithData();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: activitiesWithData.map((activity) {
        return _buildLegendItem(
          _getDisplayName(activity),
          _getActivityColor(activity),
        );
      }).toList(),
    );
  }

  List<String> _getActivitiesWithData() {
    if (activityData == null) return [];

    List<String> activitiesWithData = [];
    for (var series in activityData!.series) {
      // Check if this activity has any non-zero data
      bool hasData = series.data.any((value) => value > 0);
      if (hasData) {
        activitiesWithData.add(series.name);
      }
    }
    return activitiesWithData;
  }

  String _getDisplayName(String activityName) {
    // Map internal names to display names based on the image
    switch (activityName.toLowerCase()) {
      case 'dancing':
        return 'Aerobic dancing- low intensity';
      case 'walking around/ strolling':
        return 'Walking around/ strolling';
      case 'walking/strolling':
        return 'Walking around/ strolling';
      case 'walking quickly':
        return 'Walking quickly';
      case 'walking slowly':
        return 'Walking slowly';
      default:
        return activityName;
    }
  }

  Color _getActivityColor(String activityName) {
    // Colors based on the image shown
    switch (activityName.toLowerCase()) {
      case 'dancing':
        return const Color(0xFFE57373); // Red
      case 'walking around/ strolling':
        return const Color(0xFF4FC3F7); // Light Blue
      case 'walking/strolling':
        return const Color(0xFF4FC3F7); // Light Blue
      case 'walking quickly':
        return const Color(0xFF2196F3); // Blue
      case 'walking slowly':
        return const Color(0xFF9C27B0); // Purple
      default:
        return Colors.grey.shade400;
    }
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF37474F),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableChart() {
    // Calculate width based on number of data points
    final dataLength = activityData!.dates.length;
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
                Text(
                  'Swipe to see more data',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
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
    final dataLength = activityData!.dates.length;

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
    if (activityData == null || activityData!.dates.isEmpty) {
      return LineChartData();
    }

    // Calculate stacked max (sum of all series at each point)
    double stackedMax = 0;
    for (int i = 0; i < activityData!.dates.length; i++) {
      double stackSum = 0;
      for (var series in activityData!.series) {
        if (i < series.data.length && series.data[i] > 0) {
          stackSum += series.data[i];
        }
      }
      if (stackSum > stackedMax) stackedMax = stackSum;
    }

    // Use stacked max
    double maxValue = stackedMax;

    // Round up to nearest 50 for clean scale (energy is typically lower than intake)
    maxValue = ((maxValue / 50).ceil() * 50).toDouble();
    if (maxValue < 300) maxValue = 300; // Minimum scale based on the image

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
                  value.toInt() < activityData!.dates.length) {
                final dateStr = activityData!.dates[value.toInt()];
                // Parse date and format it nicely
                try {
                  final date = DateTime.parse(dateStr);
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF37474F),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                } catch (e) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        dateStr.length > 5
                            ? dateStr.substring(dateStr.length - 5)
                            : dateStr,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF37474F),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Text(
            'Energy in Kcal',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF37474F),
              fontWeight: FontWeight.w500,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxValue / 5,
            reservedSize: 60,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8,
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF37474F),
                    fontWeight: FontWeight.w400,
                  ),
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
      maxX: (activityData!.dates.length - 1).toDouble(),
      minY: 0,
      maxY: maxValue,
      lineBarsData: _buildStackedAreaCharts(),
    );
  }

  List<LineChartBarData> _buildStackedAreaCharts() {
    if (activityData == null || activityData!.series.isEmpty) {
      return [];
    }

    // Get series data organized by activity type, only include activities with data
    Map<String, List<double>> seriesMap = {};
    List<String> activitiesWithData = [];

    for (var series in activityData!.series) {
      // Check if this activity has any non-zero data
      bool hasData = series.data.any((value) => value > 0);
      if (hasData) {
        seriesMap[series.name] = series.data;
        activitiesWithData.add(series.name);
      }
    }

    List<LineChartBarData> charts = [];

    // Create stacked area charts for activities with data
    for (int i = 0; i < activitiesWithData.length; i++) {
      String activityType = activitiesWithData[i];
      charts.add(_buildAreaChart(
        _getStackedSpots(activityType, i, seriesMap, activitiesWithData),
        _getActivityColor(activityType),
        0.8,
      ));
    }

    return charts;
  }

  List<FlSpot> _getStackedSpots(String currentActivity, int stackLevel,
      Map<String, List<double>> seriesMap, List<String> activitiesWithData) {
    List<FlSpot> spots = [];

    for (int i = 0; i < activityData!.dates.length; i++) {
      double cumulativeValue = 0;

      // Add up all the values up to and including the current stack level
      for (int j = 0; j <= stackLevel; j++) {
        String activity = activitiesWithData[j];
        if (seriesMap.containsKey(activity) &&
            i < seriesMap[activity]!.length) {
          cumulativeValue += seriesMap[activity]![i];
        }
      }

      spots.add(FlSpot(i.toDouble(), cumulativeValue));
    }

    return spots;
  }

  LineChartBarData _buildAreaChart(
      List<FlSpot> spots, Color color, double opacity) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.2,
      color: color,
      barWidth: 1.5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(opacity),
      ),
    );
  }
}
