import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:sodiet/model/plan_model.dart' as models;

class NutrientTimeSeriesChart extends StatefulWidget {
  final models.NutrientTimeSeriesResponse? nutrientTimeSeriesData;
  final String title;
  final Color titleColor;
  final double titleFontSize;

  const NutrientTimeSeriesChart({
    Key? key,
    this.nutrientTimeSeriesData,
    this.title = 'Nutrient Time Series',
    this.titleColor = const Color(0xFF091242),
    this.titleFontSize = 22,
  }) : super(key: key);

  @override
  State<NutrientTimeSeriesChart> createState() =>
      _NutrientTimeSeriesChartState();
}

class _NutrientTimeSeriesChartState extends State<NutrientTimeSeriesChart> {
  // Observable variable for selected nutrient
  RxString selectedNutrient = ''.obs;

  // Centralized color map to ensure consistency between legend and chart
  static const Map<String, Color> mealColors = {
    'Breakfast': Color(0xFFFF6B6B), // Red
    'Lunch': Color(0xFF4ECDC4), // Teal
    'Dinner': Color(0xFF45B7D1), // Blue
    'Snacks': Color(0xFF9B59B6), // Purple
    'Total': Color(0xFF27AE60), // Green
  };

  @override
  void initState() {
    super.initState();
    // Set default selected nutrient if data is available
    if (widget.nutrientTimeSeriesData?.nutrientTimeSeries.isNotEmpty == true) {
      selectedNutrient.value =
          widget.nutrientTimeSeriesData!.nutrientTimeSeries.keys.first;
    }
  }

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
          const SizedBox(height: 16), // Reduced spacing
          _buildNutrientDropdown(),
          const SizedBox(height: 12), // Reduced spacing
          _buildLegend(),
          const SizedBox(height: 16), // Reduced spacing
          SizedBox(
            height: 380, // Increased height for better label spacing
            child: widget.nutrientTimeSeriesData == null ||
                    widget.nutrientTimeSeriesData!.nutrientTimeSeries.isEmpty
                ? const Center(
                    child: Text(
                      'No nutrient time series data available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Obx(() => _buildScrollableChart()),
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
          widget.title,
          style: TextStyle(
            fontSize: widget.titleFontSize,
            fontWeight: FontWeight.w600,
            color: widget.titleColor,
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

  Widget _buildNutrientDropdown() {
    if (widget.nutrientTimeSeriesData == null ||
        widget.nutrientTimeSeriesData!.nutrientTimeSeries.isEmpty) {
      return const SizedBox.shrink();
    }

    final nutrients =
        widget.nutrientTimeSeriesData!.nutrientTimeSeries.keys.toList();

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 4), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius:
            BorderRadius.circular(6), // Slightly smaller border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08), // Reduced shadow opacity
            spreadRadius: 0.5,
            blurRadius: 1.5,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedNutrient.value.isEmpty
                  ? nutrients.first
                  : selectedNutrient.value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600, size: 20), // Reduced icon size
              items: nutrients.map((String nutrient) {
                return DropdownMenuItem<String>(
                  value: nutrient,
                  child: Text(
                    nutrient,
                    style: const TextStyle(
                      fontSize: 14, // Reduced font size
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  selectedNutrient.value = newValue;
                }
              },
            ),
          )),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          _buildLegendItem('Breakfast', mealColors['Breakfast']!),
          _buildLegendItem('Lunch', mealColors['Lunch']!),
          _buildLegendItem('Dinner', mealColors['Dinner']!),
          _buildLegendItem('Snacks', mealColors['Snacks']!),
          _buildLegendItem('Total', mealColors['Total']!),
        ],
      ),
    );
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
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableChart() {
    if (selectedNutrient.value.isEmpty) return const SizedBox.shrink();

    final nutrientData = widget
        .nutrientTimeSeriesData!.nutrientTimeSeries[selectedNutrient.value];
    if (nutrientData == null || nutrientData.dates.isEmpty) {
      return const Center(
        child: Text(
          'No data available for selected nutrient',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Calculate width based on number of data points
    final dataLength = nutrientData.dates.length;
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
              height:
                  340, // Increased chart area height for better label spacing
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 30.0,
                    top: 10.0,
                    bottom: 20.0,
                    left: 20.0), // Increased left padding for rotated label
                child: LineChart(
                  _buildLineChartData(nutrientData),
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

  double _getOptimalInterval(int dataLength) {
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

  LineChartData _buildLineChartData(
      models.NutrientTimeSeriesData nutrientData) {
    // Get max value for Y-axis
    double maxValue = 0;
    final allValues = [
      ...nutrientData.datasets.breakfast,
      ...nutrientData.datasets.lunch,
      ...nutrientData.datasets.dinner,
      ...nutrientData.datasets.snacks,
      ...nutrientData.datasets.total,
    ];

    // Filter positive values for max calculation
    final positiveValues = allValues.where((value) => value > 0).toList();
    if (positiveValues.isNotEmpty) {
      maxValue = positiveValues.reduce((a, b) => a > b ? a : b);
    }

    // Round up to nearest reasonable value
    maxValue = ((maxValue / 100).ceil() * 100).toDouble();
    if (maxValue < 100) maxValue = 100; // Minimum scale

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: maxValue / 5,
        verticalInterval: _getOptimalInterval(nutrientData.dates.length),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 0.5,
          );
        },
      ),
      clipData: FlClipData.all(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          axisNameWidget: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              'Date',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7F8C8D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40, // Increased reserved space for bottom labels
            interval: _getOptimalInterval(nutrientData.dates.length),
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 &&
                  value.toInt() < nutrientData.dates.length) {
                final dateStr = nutrientData.dates[value.toInt()];
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
                          color: Color(0xFF7F8C8D),
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
                          color: Color(0xFF7F8C8D),
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
          axisNameWidget: Padding(
            padding: const EdgeInsets.only(right: 15.0, bottom: 10.0),
            child: RotatedBox(
              quarterTurns:
                  1, // Changed from 3 to 1 for proper vertical orientation
              child: Text(
                'Nutrient Value',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7F8C8D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxValue / 5,
            reservedSize: 65, // Increased reserved space for rotated label
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 12, // Increased space
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7F8C8D),
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
          bottom: BorderSide(color: Colors.grey.shade400, width: 1),
          left: BorderSide(color: Colors.grey.shade400, width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      minX: 0,
      maxX: (nutrientData.dates.length - 1).toDouble(),
      minY: 0,
      maxY: maxValue,
      lineBarsData: _buildLineCharts(nutrientData),
    );
  }

  List<LineChartBarData> _buildLineCharts(
      models.NutrientTimeSeriesData nutrientData) {
    List<LineChartBarData> charts = [];

    // Create line charts for each meal type
    final mealData = {
      'Breakfast': nutrientData.datasets.breakfast,
      'Lunch': nutrientData.datasets.lunch,
      'Dinner': nutrientData.datasets.dinner,
      'Snacks': nutrientData.datasets.snacks,
      'Total': nutrientData.datasets.total,
    };

    mealData.forEach((mealType, data) {
      // Only show meals that have data
      if (data.any((value) => value > 0)) {
        charts.add(_buildIndividualLineChart(
          mealType,
          data,
          mealColors[mealType]!,
        ));
      }
    });

    return charts;
  }

  LineChartBarData _buildIndividualLineChart(
      String mealType, List<double> data, Color color) {
    List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
      // Ensure no negative values are plotted
      double value = data[i] < 0 ? 0.0 : data[i];
      spots.add(FlSpot(i.toDouble(), value));
    }

    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: mealType == 'Total' ? 3.0 : 2.5, // Make lines slightly thicker
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false), // Remove dots for cleaner look
      belowBarData: BarAreaData(show: false),
      preventCurveOverShooting: true,
    );
  }
}
