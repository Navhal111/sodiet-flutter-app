import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:sodiet/model/plan_model.dart' as models;
import 'package:sodiet/view/widgets/app_text.dart';

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
          _buildTitleWithIcon(context),
          const SizedBox(height: 16), // Reduced spacing
          _buildNutrientDropdown(),
          const SizedBox(height: 12), // Reduced spacing
          _buildLegend(),
          const SizedBox(height: 16), // Reduced spacing
          SizedBox(
            height: 380, // Increased height for better label spacing
            child: widget.nutrientTimeSeriesData == null ||
                    widget.nutrientTimeSeriesData!.nutrientTimeSeries.isEmpty
                ? Center(
                    child: RegularText(
                      'No nutrient time series data available',
                      textColor: Colors.grey,
                    ),
                  )
                : Obx(() => _buildScrollableChart()),
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
          widget.title,
          fontSize: widget.titleFontSize,
          textColor: widget.titleColor,
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
              Icon(Icons.info_outline, color: widget.titleColor),
              const SizedBox(width: 8),
              SemiBoldText(
                'Nutrient Time Series Details',
                fontSize: 16,
                textColor: widget.titleColor,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RegularText(
                  'This chart shows the nutrient intake over time for different meal categories.',
                  fontSize: 14,
                  textColor: Colors.black87,
                ),
                const SizedBox(height: 12),
                SemiBoldText(
                  'Features:',
                  fontSize: 14,
                  textColor: widget.titleColor,
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                    '📊', 'Select different nutrients from the dropdown'),
                _buildInfoItem('🍽️',
                    'View breakdown by meal type (Breakfast, Lunch, Dinner, Snacks)'),
                _buildInfoItem('📈', 'Track total nutrient intake progression'),
                _buildInfoItem(
                    '👆', 'Swipe horizontally to see more data points'),
                const SizedBox(height: 12),
                SemiBoldText(
                  'Meal Legend:',
                  fontSize: 14,
                  textColor: widget.titleColor,
                ),
                const SizedBox(height: 8),
                _buildInfoLegendItem('Breakfast', mealColors['Breakfast']!),
                _buildInfoLegendItem('Lunch', mealColors['Lunch']!),
                _buildInfoLegendItem('Dinner', mealColors['Dinner']!),
                _buildInfoLegendItem('Snacks', mealColors['Snacks']!),
                _buildInfoLegendItem('Total', mealColors['Total']!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: MediumText(
                'Got it',
                fontSize: 14,
                textColor: widget.titleColor,
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

  Widget _buildInfoLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          MediumText(
            label,
            fontSize: 12,
            textColor: Colors.black87,
          ),
        ],
      ),
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
                  child: MediumText(
                    nutrient,
                    fontSize: 14,
                    textColor: const Color(0xFF2C3E50),
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
        MediumText(
          label,
          fontSize: 12,
          textColor: const Color(0xFF2C3E50),
        ),
      ],
    );
  }

  Widget _buildScrollableChart() {
    if (selectedNutrient.value.isEmpty) return const SizedBox.shrink();

    final nutrientData = widget
        .nutrientTimeSeriesData!.nutrientTimeSeries[selectedNutrient.value];
    if (nutrientData == null || nutrientData.dates.isEmpty) {
      return Center(
        child: RegularText(
          'No data available for selected nutrient',
          textColor: Colors.grey,
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
                    left: 0.0), // Increased left padding for rotated label
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
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25, // Reduced reserved space since no axis label
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
                      child: RegularText(
                        '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                        fontSize: 10,
                        textColor: const Color(0xFF7F8C8D),
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
                        textColor: const Color(0xFF7F8C8D),
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
            reservedSize: 45, // Reduced reserved space since no axis label
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 12, // Increased space
                child: RegularText(
                  value.toInt().toString(),
                  fontSize: 11,
                  textColor: const Color(0xFF7F8C8D),
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
