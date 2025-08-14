import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/home/homeController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/chart/weight_progress_chart.dart';
import 'package:sodiet/view/widgets/chart/intake_overview_chart.dart';
import 'package:sodiet/view/widgets/home/nutrient_progress_widget.dart';
import 'package:sodiet/view/widgets/home/welcome_title_widget.dart';
import 'package:sodiet/view/widgets/home/data_summary_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  _loadDashboardData() async {
    await homeController.getDashboardSummary();
    await homeController.getNutrientWeeklySummary();
  }

  // Method to build KPI widgets from dashboard summary data
  List<Widget> _buildKpiWidgets() {
    if (!homeController.hasDashboardSummary ||
        homeController.dashboardKpi == null) {
      return [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: DataSummaryWidget(
            title: 'Loading...',
            startValue: '--',
            endValue: '--',
            onClick: () {},
          ),
        ),
      ];
    }

    final kpiData = homeController.dashboardKpi!;

    return [
      // Plan transformation (start weight -> target weight)
      Container(
        margin: const EdgeInsets.only(right: 8),
        child: DataSummaryWidget(
          title: 'Plan Transformation',
          startValue: '${kpiData.startWeightKg.toStringAsFixed(1)}kg',
          endValue: '${kpiData.targetWeightKg.toStringAsFixed(1)}kg',
          onClick: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Plan transformation details clicked'),
                backgroundColor: Color(0xFFE57373),
              ),
            );
          },
        ),
      ),
      // Current progress
      Container(
        margin: const EdgeInsets.only(right: 8),
        child: DataSummaryWidget(
          title: 'Current Weight',
          startValue: '${kpiData.mostRecentWeightKg.toStringAsFixed(1)}kg',
          endValue: '',
          onClick: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Current progress details clicked'),
                backgroundColor: Color(0xFFE57373),
              ),
            );
          },
        ),
      ),
      // Plan duration
      Container(
        margin: const EdgeInsets.only(right: 8),
        child: DataSummaryWidget(
          title: 'Plan Duration',
          startValue: 'Day ${kpiData.currentPlanDay}',
          endValue: '${kpiData.totalPlanDurationDays} days',
          onClick: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Plan duration details clicked'),
                backgroundColor: Color(0xFFE57373),
              ),
            );
          },
        ),
      ),
      // Plan start date
      Container(
        margin: const EdgeInsets.only(right: 8),
        child: DataSummaryWidget(
          title: 'Target Progress',
          startValue: kpiData.planStartDate,
          endValue: '',
          onClick: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Plan start date details clicked'),
                backgroundColor: Color(0xFFE57373),
              ),
            );
          },
        ),
      ),
    ];
  }

  // Variable to track selected week
  RxInt selectedWeek = 1.obs;

  // Method to build week tabs
  Widget _buildWeekTabs() {
    if (!homeController.hasNutrientWeeklySummary) {
      return const SizedBox.shrink();
    }

    // Get available weeks and filter out 999 (since it's used for Average)
    final availableWeeks =
        homeController.availableWeeks.where((week) => week != 999).toList();

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableWeeks.length + 1, // +1 for Average tab
        itemBuilder: (context, index) {
          if (index == availableWeeks.length) {
            // Average tab (using week 999 from API)
            return Obx(
                () => _buildWeekTab('Average', 999, selectedWeek.value == 999));
          } else {
            final week = availableWeeks[index];
            return Obx(() =>
                _buildWeekTab('Week $week', week, selectedWeek.value == week));
          }
        },
      ),
    );
  }

  Widget _buildWeekTab(String title, int weekValue, bool isSelected) {
    return GestureDetector(
      onTap: () {
        selectedWeek.value = weekValue;
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007BFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF007BFF) : Colors.grey.shade400,
            width: 1,
          ),
        ),
        child: Center(
          child: MediumText(
            title,
            fontSize: 14,
            textColor: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  // Method to get color based on percentage
  Color _getColorForPercentage(double percentage) {
    if (percentage >= 80) {
      return const Color(0xFF8BC34A); // Green for good
    } else if (percentage >= 50) {
      return const Color(0xFFFFA500); // Orange for moderate
    } else {
      return const Color(0xFFC82333); // Red for low
    }
  }

  // Method to build nutrient widgets from API data
  List<Widget> _buildNutrientWidgets() {
    if (!homeController.hasNutrientWeeklySummary) {
      return [
        const Center(
          child: CircularProgressIndicator(),
        ),
      ];
    }

    final nutrients = homeController.getNutrientsForWeek(selectedWeek.value);

    if (nutrients.isEmpty) {
      return [
        Center(
          child: MediumText(
            'No data available for this week',
            fontSize: 14,
            textColor: Colors.grey.shade600,
          ),
        ),
      ];
    }

    return nutrients.map((nutrient) {
      return NutrientProgressWidget(
        nutrientName: '${nutrient.nutrient} (${nutrient.unit})',
        percentage: nutrient.percentMet,
        inputValue: nutrient.actualAverageIntake,
        requiredValue: nutrient.requiredAverageIntake,
        progressColor: _getColorForPercentage(nutrient.percentMet),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${nutrient.nutrient}: ${nutrient.percentMet.toStringAsFixed(2)}% met'),
              backgroundColor: _getColorForPercentage(nutrient.percentMet),
            ),
          );
        },
      );
    }).toList();
  }

  // Sample data for the intake overview chart - matching the design screenshot
  List<IntakeData> sampleIntakeData = [
    IntakeData(
      date: DateTime(2025, 1, 28),
      breakfast: 200,
      lunch: 0,
      dinner: 0,
      snacks: 150,
    ),
    IntakeData(
      date: DateTime(2025, 1, 29),
      breakfast: 850,
      lunch: 200,
      dinner: 350,
      snacks: 100,
    ),
    IntakeData(
      date: DateTime(2025, 1, 30),
      breakfast: 500,
      lunch: 0,
      dinner: 0,
      snacks: 0,
    ),
    IntakeData(
      date: DateTime(2025, 2, 6),
      breakfast: 0,
      lunch: 0,
      dinner: 0,
      snacks: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.homeScreen,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeTitleWidget(userName: 'Light User', onLogWeightTap: () {}),
              const SizedBox(height: 14),
              SizedBox(
                height: 80,
                child: Obx(() {
                  if (homeController.isLoadingDashboardSummary.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final kpiWidgets = _buildKpiWidgets();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: kpiWidgets.length,
                    itemBuilder: (context, index) {
                      return kpiWidgets[index];
                    },
                  );
                }),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Obx(() {
                  if (homeController.isLoadingDashboardSummary.value) {
                    return Container(
                      height: 300,
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
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final chartData = homeController.getChartWeightData();
                  final dataRanges = homeController.getChartDataRanges();

                  return WeightProgressChart(
                    weightDataList: chartData,
                    title: 'Plan Progress',
                    titleColor: const Color(0xFF091242),
                    titleFontSize: 22,
                    showRightAxisLabels: true,
                    minIntake: dataRanges['minIntake']!,
                    maxIntake: dataRanges['maxIntake']!,
                    minWeight: dataRanges['minWeight']!,
                    maxWeight: dataRanges['maxWeight']!,
                  );
                }),
              ),
              const SizedBox(height: 10),

              // Nutrient Analysis Section
              Container(
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
                      'Nutrient Analysis',
                      fontSize: 16,
                      textColor: const Color(0xFF091242), // Dark blue
                    ),
                    const SizedBox(height: 16),
                    // Week Tabs

                    // Nutrient Progress List
                    Obx(() {
                      if (homeController.isLoadingNutrientWeeklySummary.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final nutrientWidgets = _buildNutrientWidgets();

                      return Column(
                        children: [_buildWeekTabs(), ...nutrientWidgets],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Intake Overview Chart
              IntakeOverviewChart(
                intakeDataList: sampleIntakeData,
                title: 'Intake Overview',
                titleColor: const Color(0xFF091242),
                titleFontSize: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
