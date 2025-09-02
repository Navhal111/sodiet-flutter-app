import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sodiet/model/weight_data.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class WeightProgressChart extends StatelessWidget {
  final List<WeightData> weightDataList;
  final String title;
  final Color titleColor;
  final double titleFontSize;
  final bool showRightAxisLabels;

  // Y-axis ranges
  final double minIntake;
  final double maxIntake;
  final double minWeight;
  final double maxWeight;

  const WeightProgressChart({
    Key? key,
    required this.weightDataList,
    this.title = 'Plan Progress',
    this.titleColor = Colors.black87,
    this.titleFontSize = 20,
    this.showRightAxisLabels = true,
    this.minIntake = 0.0,
    this.maxIntake = 5000.0,
    this.minWeight = 70.0,
    this.maxWeight = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate chart width based on data points for horizontal scrolling
    final chartWidth =
        (weightDataList.length * 25.0).clamp(300.0, double.infinity);

    return Container(
      padding:
          const EdgeInsets.all(20), // Increased padding to prevent cropping
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
          const SizedBox(height: 24),
          SizedBox(
            height: 450, // Increased from 300 to 400 for better readability
            child: weightDataList.isEmpty
                ? Center(
                    child: RegularText(
                      'No chart data available',
                      textColor: Colors.grey,
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: chartWidth,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8), // Added margin to prevent cropping
                      child: LineChart(
                        _createChartData(context),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          // Professional Legend Design
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildLegendItem(context, 'Weight', const Color(0xFFFF6B9D)),
              _buildLegendItem(
                  context, 'Logged Weight', const Color(0xFF1E3A8A)),
              _buildLegendItem(
                  context, 'Target Intake', const Color(0xFF06B6D4)),
              _buildLegendItem(
                  context, 'Target Expenditure', const Color(0xFF10B981)),
              _buildLegendItem(
                  context, 'Actual Intake', const Color(0xFF8B5CF6)),
              _buildLegendItem(
                  context, 'Actual Expenditure', const Color(0xFFF97316)),
              _buildLegendItem(context, 'CC Intake', const Color(0xFF1E40AF)),
              _buildLegendItem(
                  context, 'CC Expenditure', const Color(0xFF059669)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // This makes the width fit the content
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          MediumText(
            label,
            fontSize: 11,
            textColor: color.computeLuminance() > 0.5 ? Colors.black87 : color,
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
                'Plan Progress Details',
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
                  'This comprehensive chart tracks your weight loss/gain progress alongside intake and expenditure data.',
                  fontSize: 14,
                  textColor: Colors.black87,
                ),
                const SizedBox(height: 12),
                SemiBoldText(
                  'Chart Legend:',
                  fontSize: 14,
                  textColor: titleColor,
                ),
                const SizedBox(height: 8),
                _buildPopupLegendItem('Weight', const Color(0xFFFF6B9D),
                    'Projected weight progression'),
                _buildPopupLegendItem('Logged Weight', const Color(0xFF1E3A8A),
                    'Actual recorded weight'),
                _buildPopupLegendItem('Target Intake', const Color(0xFF06B6D4),
                    'Recommended daily calories'),
                _buildPopupLegendItem('Target Expenditure',
                    const Color(0xFF10B981), 'Recommended calories burned'),
                _buildPopupLegendItem('Actual Intake', const Color(0xFF8B5CF6),
                    'Actual calories consumed'),
                _buildPopupLegendItem('Actual Expenditure',
                    const Color(0xFFF97316), 'Actual calories burned'),
                _buildPopupLegendItem('CC Intake', const Color(0xFF1E40AF),
                    'Calorie cycling intake'),
                _buildPopupLegendItem('CC Expenditure', const Color(0xFF059669),
                    'Calorie cycling expenditure'),
                const SizedBox(height: 12),
                RegularText(
                  'Tip: Swipe horizontally to view your complete progress timeline.',
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

  Widget _buildPopupLegendItem(String label, Color color, String description) {
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

  LineChartData _createChartData(BuildContext context) {
    // Find the max day for x-axis
    final maxDay = weightDataList.isNotEmpty
        ? weightDataList
            .map((e) => e.day)
            .reduce((a, b) => a > b ? a : b)
            .toDouble()
        : 30.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: (maxIntake - minIntake) /
            3, // Reduced to 3 horizontal grid lines for cleaner look
        verticalInterval: maxDay > 20
            ? 10
            : 5, // Fewer vertical lines for better mobile experience
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade200, // Lighter grid lines
            strokeWidth: 0.5, // Thinner grid lines
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.shade200, // Lighter grid lines
            strokeWidth: 0.5, // Thinner grid lines
          );
        },
      ),
      titlesData: FlTitlesData(
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: showRightAxisLabels,
            reservedSize: 60, // Increased reserved space to prevent cropping
            interval: (maxIntake - minIntake) / 5, // Use intake intervals
            getTitlesWidget: (value, meta) {
              // Map intake position to weight position
              double position = (value - minIntake) / (maxIntake - minIntake);
              double weightValue =
                  minWeight + (position * (maxWeight - minWeight));

              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8, // Increased space from axis line
                child: MediumText(
                  '${weightValue.toStringAsFixed(0)}kg',
                  fontSize: 10,
                  textColor: Colors.black87,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30, // Slightly increased reserved space
            interval: maxDay > 15 ? 5 : 2,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 6, // Increased space from axis line
                child: MediumText(
                  '${value.toInt()}',
                  fontSize: 10,
                  textColor: Colors.black87,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35, // Increased reserved space to prevent cropping
            interval: (maxIntake - minIntake) /
                5, // Show exactly 5 intervals = 6 labels
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8, // Increased space from axis line
                child: MediumText(
                  '${(value / 1000).toStringAsFixed(1)}k',
                  fontSize: 10,
                  textColor: Colors.black87,
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
      minX: 1,
      maxX: maxDay,
      minY: minIntake,
      maxY: maxIntake,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black.withOpacity(0.9),
          tooltipRoundedRadius: 8,
          tooltipPadding: const EdgeInsets.all(8),
          maxContentWidth: 180, // Set max width to prevent cropping
          fitInsideHorizontally: true, // Keep tooltip within chart bounds
          fitInsideVertically: true, // Keep tooltip within chart bounds
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              int day = flSpot.x.toInt();

              // Find the original data for this day
              WeightData? originalData =
                  weightDataList.firstWhere((data) => data.day == day,
                      orElse: () => WeightData(
                            day: day,
                            projectedWeightKg: 0,
                            targetIntakeKcal: 0,
                            targetExpenditureKcal: 0,
                            actualIntakeKcal: 0,
                            actualExpenditureKcal: 0,
                            ccIntakeKcal: 0,
                            ccExpenditureKcal: 0,
                          ));

              String tooltipText = '';

              // Determine which line was touched based on barIndex
              switch (flSpot.barIndex) {
                case 0:
                  tooltipText =
                      'Weight: ${originalData.projectedWeightKg.toStringAsFixed(1)}kg\nDay: $day';
                  break;
                case 1:
                  if (originalData.loggedWeightKg != null) {
                    tooltipText =
                        'Logged: ${originalData.loggedWeightKg!.toStringAsFixed(1)}kg\nDay: $day';
                  }
                  break;
                case 2:
                  tooltipText =
                      'Target: ${(originalData.targetIntakeKcal / 1000).toStringAsFixed(1)}k\nDay: $day';
                  break;
                case 3:
                  tooltipText =
                      'T.Expend: ${(originalData.targetExpenditureKcal / 1000).toStringAsFixed(1)}k\nDay: $day';
                  break;
                case 4:
                  tooltipText =
                      'Intake: ${(originalData.actualIntakeKcal / 1000).toStringAsFixed(1)}k\nDay: $day';
                  break;
                case 5:
                  tooltipText =
                      'Expend: ${(originalData.actualExpenditureKcal / 1000).toStringAsFixed(1)}k\nDay: $day';
                  break;
                case 6:
                  tooltipText =
                      'CC In: ${(originalData.ccIntakeKcal / 1000).toStringAsFixed(1)}k\nDay: $day';
                  break;
                case 7:
                  tooltipText =
                      'CC Out: ${(originalData.ccExpenditureKcal / 1000).toStringAsFixed(1)}k\nDay: $day';
                  break;
                default:
                  tooltipText = 'Day: $day';
              }

              return LineTooltipItem(
                tooltipText,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        // 1. Projected Weight (Pink)
        LineChartBarData(
          spots: _getProjectedWeightSpots(),
          isCurved: true,
          color: const Color(0xFFFF6B9D), // Pink
          barWidth: 3, // Increased from 2 to 3 for better visibility
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4, // Increased from 3 to 4 for weight line
                color: const Color(0xFFFF6B9D),
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // 2. Logged Weight (Dark Blue) - only show if data exists
        if (_getLoggedWeightSpots().isNotEmpty)
          LineChartBarData(
            spots: _getLoggedWeightSpots(),
            isCurved: true,
            color: const Color(0xFF1E3A8A), // Dark blue
            barWidth: 3, // Increased from 2 to 3 for better visibility
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4, // Increased from 3 to 4 for weight line
                  color: const Color(0xFF1E3A8A),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        // 3. Target Intake (Light Blue)
        LineChartBarData(
          spots: _getTargetIntakeSpots(),
          isCurved: true,
          color: const Color(0xFF06B6D4), // Light blue
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: const Color(0xFF06B6D4),
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // 4. Target Expenditure (Teal)
        LineChartBarData(
          spots: _getTargetExpenditureSpots(),
          isCurved: true,
          color: const Color(0xFF10B981), // Teal
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: const Color(0xFF10B981),
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // 5. Actual Intake (Purple)
        LineChartBarData(
          spots: _getActualIntakeSpots(),
          isCurved: true,
          color: const Color(0xFF8B5CF6), // Purple
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: const Color(0xFF8B5CF6),
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // 6. Actual Expenditure (Orange)
        LineChartBarData(
          spots: _getActualExpenditureSpots(),
          isCurved: true,
          color: const Color(0xFFF97316), // Orange
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: const Color(0xFFF97316),
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // 7. CC Intake (Dark Blue)
        LineChartBarData(
          spots: _getCCIntakeSpots(),
          isCurved: true,
          color: const Color(0xFF1E40AF), // Dark blue
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: const Color(0xFF1E40AF),
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // 8. CC Expenditure (Green)
        LineChartBarData(
          spots: _getCCExpenditureSpots(),
          isCurved: true,
          color: const Color(0xFF059669), // Green
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: const Color(0xFF059669),
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  List<FlSpot> _getActualIntakeSpots() {
    List<FlSpot> spots = [];
    for (var data in weightDataList) {
      // Only add spots for days that have actual intake data > 0
      if (data.actualIntakeKcal > 0) {
        spots.add(FlSpot(data.day.toDouble(), data.actualIntakeKcal));
      }
    }

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  // Normalize weight values to intake scale for display on same chart
  List<FlSpot> _getProjectedWeightSpots() {
    List<FlSpot> spots = weightDataList.map((data) {
      // Normalize the weight to the intake scale for visualization
      double normalizedWeight =
          ((data.projectedWeightKg - minWeight) / (maxWeight - minWeight)) *
                  (maxIntake - minIntake) +
              minIntake;

      return FlSpot(data.day.toDouble(), normalizedWeight);
    }).toList();

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  List<FlSpot> _getLoggedWeightSpots() {
    List<FlSpot> spots = [];
    for (var data in weightDataList) {
      // Only add spots for days that have logged weight data
      if (data.loggedWeightKg != null) {
        // Normalize the weight to the intake scale for visualization
        double normalizedWeight =
            ((data.loggedWeightKg! - minWeight) / (maxWeight - minWeight)) *
                    (maxIntake - minIntake) +
                minIntake;
        spots.add(FlSpot(data.day.toDouble(), normalizedWeight));
      }
    }

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  List<FlSpot> _getTargetIntakeSpots() {
    List<FlSpot> spots = weightDataList.map((data) {
      return FlSpot(data.day.toDouble(), data.targetIntakeKcal);
    }).toList();

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  List<FlSpot> _getTargetExpenditureSpots() {
    List<FlSpot> spots = weightDataList.map((data) {
      return FlSpot(data.day.toDouble(), data.targetExpenditureKcal);
    }).toList();

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  List<FlSpot> _getActualExpenditureSpots() {
    List<FlSpot> spots = weightDataList.map((data) {
      return FlSpot(data.day.toDouble(), data.actualExpenditureKcal);
    }).toList();

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  List<FlSpot> _getCCIntakeSpots() {
    List<FlSpot> spots = weightDataList.map((data) {
      return FlSpot(data.day.toDouble(), data.ccIntakeKcal);
    }).toList();

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  List<FlSpot> _getCCExpenditureSpots() {
    List<FlSpot> spots = weightDataList.map((data) {
      return FlSpot(data.day.toDouble(), data.ccExpenditureKcal);
    }).toList();

    // Sort spots by x value to ensure the line is drawn correctly
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }
}
