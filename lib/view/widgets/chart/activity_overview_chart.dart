import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sodiet/model/plan_model.dart' as models;
import 'package:sodiet/view/widgets/app_text.dart';

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
          _buildTitleWithIcon(context),
          const SizedBox(height: 20),
          _buildLegend(),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: activityData == null || activityData!.dates.isEmpty
                ? Center(
                    child: RegularText(
                      'No activity data available',
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
                'Activity Overview Details',
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
                  'This chart tracks your daily energy expenditure from different physical activities.',
                  fontSize: 14,
                  textColor: Colors.black87,
                ),
                const SizedBox(height: 12),
                SemiBoldText(
                  'Features:',
                  fontSize: 14,
                  textColor: titleColor,
                ),
                const SizedBox(height: 8),
                _buildInfoItem('🏃‍♀️', 'Track various physical activities'),
                _buildInfoItem('⚡', 'Monitor energy expenditure over time'),
                _buildInfoItem('🎯', 'Each activity has its own colored line'),
                _buildInfoItem('📊', 'View individual activity trends'),
                _buildInfoItem('👆', 'Swipe horizontally for more data'),
                const SizedBox(height: 12),
                RegularText(
                  'Note: Only activities with recorded data are displayed in the chart.',
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

  Widget _buildInfoItem(String emoji, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RegularText(emoji, fontSize: 14),
          const SizedBox(width: 8),
          Expanded(
            child: RegularText(
              description,
              fontSize: 12,
              textColor: Colors.grey.shade700,
            ),
          ),
        ],
      ),
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

  // Predefined color palette for dynamic assignment with distinct, darker colors
  static const List<Color> _colorPalette = [
    Color(0xFFD32F2F), // Dark Red
    Color(0xFF1976D2), // Dark Blue
    Color(0xFF388E3C), // Dark Green
    Color(0xFF7B1FA2), // Dark Purple
    Color(0xFFE65100), // Dark Orange
    Color(0xFF5D4037), // Dark Brown
    Color(0xFF0097A7), // Dark Cyan
    Color(0xFFAF52DE), // Medium Purple
    Color(0xFF558B2F), // Olive Green
    Color(0xFF8E24AA), // Medium Purple
    Color(0xFF00695C), // Dark Teal
    Color(0xFF6A1B9A), // Deep Purple
    Color(0xFF4527A0), // Deep Purple Blue
    Color(0xFF283593), // Indigo
    Color(0xFF1565C0), // Blue
    Color(0xFF0277BD), // Light Blue
    Color(0xFF00838F), // Cyan
    Color(0xFF00695C), // Teal
    Color(0xFF2E7D32), // Green
    Color(0xFF689F38), // Light Green
    Color(0xFF9E9D24), // Lime
    Color(0xFFF57F17), // Yellow
    Color(0xFFFF8F00), // Amber
    Color(0xFFEF6C00), // Orange
    Color(0xFFD84315), // Deep Orange
    Color(0xFFBF360C), // Red Orange
    Color(0xFF3E2723), // Brown
    Color(0xFF424242), // Grey
    Color(0xFF37474F), // Blue Grey
    Color(0xFF263238), // Dark Blue Grey
  ];

  // Cache for assigned colors to maintain consistency
  static final Map<String, Color> _assignedColors = {};

  // Method to clear color cache if needed (call when activity data changes significantly)
  static void clearColorCache() {
    _assignedColors.clear();
  }

  Color _getActivityColor(String activityName) {
    final normalizedName = activityName.toLowerCase();

    // Return already assigned color if exists
    if (_assignedColors.containsKey(normalizedName)) {
      return _assignedColors[normalizedName]!;
    }

    // Get all unique activity names from current data
    List<String> allActivities = [];
    if (activityData != null) {
      allActivities =
          activityData!.series.map((s) => s.name.toLowerCase()).toList();
      allActivities.sort(); // Sort for consistent assignment
    }

    // Find index of current activity in sorted list
    int activityIndex = allActivities.indexOf(normalizedName);
    if (activityIndex == -1) {
      // Fallback: use hash-based color selection
      activityIndex = normalizedName.hashCode.abs();
    }

    // Assign color from palette using modulo to cycle through colors
    Color assignedColor = _colorPalette[activityIndex % _colorPalette.length];

    // If we have more activities than colors, create variations
    if (activityIndex >= _colorPalette.length) {
      // Create color variations by adjusting opacity and brightness
      int variation = (activityIndex / _colorPalette.length).floor();
      double opacity =
          1.0 - (variation * 0.15).clamp(0.0, 0.4); // Max 40% transparency
      assignedColor = assignedColor.withOpacity(opacity);

      // For even more variations, slightly adjust hue
      if (variation > 2) {
        HSLColor hsl = HSLColor.fromColor(assignedColor);
        double hueShift =
            (variation * 30.0) % 360.0; // Shift hue by 30 degrees per variation
        assignedColor = hsl.withHue((hsl.hue + hueShift) % 360.0).toColor();
      }
    }

    // Cache the assigned color
    _assignedColors[normalizedName] = assignedColor;

    return assignedColor;
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
        MediumText(
          label,
          fontSize: 12,
          textColor: const Color(0xFF37474F),
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

    // Calculate individual max (highest single value, not stacked)
    double maxValue = 0;
    for (var series in activityData!.series) {
      for (int i = 0; i < series.data.length; i++) {
        // Extra safety: prevent negative values from affecting max calculation
        double rawValue = series.data[i];
        double value = rawValue < 0 ? 0.0 : rawValue;
        if (value > maxValue) maxValue = value;
      }
    }

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
      clipData: FlClipData.all(), // Ensure clipping at chart boundaries
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

    List<LineChartBarData> charts = [];

    // Create individual line charts for each activity with data
    for (var series in activityData!.series) {
      // Check if this activity has any non-zero data
      bool hasData = series.data.any((value) => value > 0);
      if (hasData) {
        final color = _getActivityColor(series.name);

        charts.add(_buildIndividualLineChart(series, color));
      }
    }

    return charts;
  }

  LineChartBarData _buildIndividualLineChart(
      models.ActivitySeriesData series, Color color) {
    List<FlSpot> spots = [];

    for (int i = 0; i < activityData!.dates.length; i++) {
      // Extra safety: prevent negative values - clamp to zero
      double value = 0.0;
      if (i < series.data.length) {
        double rawValue = series.data[i];
        // Double-check: ensure no negative values can pass through
        value = rawValue < 0 ? 0.0 : rawValue;
      }
      spots.add(FlSpot(i.toDouble(), value));
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.2,
      color: color,
      barWidth: 2.0,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.6), // 60% opacity at top
            color.withOpacity(0.1), // 10% opacity at bottom
          ],
        ),
        // Ensure the gradient area respects the minimum Y boundary
        cutOffY: 0.0,
        applyCutOffY: true,
      ),
    );
  }
}
