import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/home/homeController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/chart/weight_progress_chart.dart';
import 'package:sodiet/view/widgets/chart/intake_overview_chart.dart';
import 'package:sodiet/view/widgets/chart/activity_overview_chart.dart';
import 'package:sodiet/view/widgets/home/nutrient_progress_widget.dart';
import 'package:sodiet/view/widgets/home/welcome_title_widget.dart';
import 'package:sodiet/view/widgets/home/data_summary_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';
import 'package:sodiet/view/widgets/custom_button.dart';

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
    await homeController.getIntakeOverview();
    await homeController.getActivityOverview();
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

  // Weight Log Methods
  Future<void> _selectDateForWeightLog() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      homeController.weightLogDateController.text =
          homeController.formatDate(picked);
    }
  }

  void _showAddWeightLogDialog() {
    // Initialize the form
    homeController.initializeWeightLogForm();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Title
              Row(
                children: [
                  Expanded(
                    child: SemiBoldText(
                      'Add Weight Log',
                      fontSize: 20,
                      textColor: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Date Field
              GestureDetector(
                onTap: _selectDateForWeightLog,
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: homeController.weightLogDateController,
                    hintText: 'Select Date',
                    labelText: 'Date',
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.calendar_today, color: Colors.grey),
                      onPressed: _selectDateForWeightLog,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Weight Field
              CustomTextField(
                controller: homeController.weightLogWeightController,
                hintText: 'Enter weight in kg',
                labelText: 'Weight (kg)',
                textInputType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: () {
                          Get.back();
                        },
                        backgroundColor: Colors.grey.shade400,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: Obx(() => CustomButton(
                            text: homeController.isSubmittingWeightLog.value
                                ? 'Adding...'
                                : 'Add Weight',
                            onPressed: homeController
                                    .isSubmittingWeightLog.value
                                ? null
                                : () async {
                                    await homeController.addWeightLogFromHome();
                                  },
                            backgroundColor: const Color(0xFFFF9800),
                            textColor: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

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
              WelcomeTitleWidget(
                  userName: 'Testlight User',
                  onLogWeightTap: _showAddWeightLogDialog),
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
              Obx(() {
                if (homeController.isLoadingIntakeOverview.value) {
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

                return IntakeOverviewChart(
                  intakeData: homeController.intakeOverviewChart,
                  title: 'Intake Overview',
                  titleColor: const Color(0xFF091242),
                  titleFontSize: 22,
                );
              }),
              const SizedBox(height: 10),
              // Activity Overview Chart
              Obx(() {
                if (homeController.isLoadingActivityOverview.value) {
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

                return ActivityOverviewChart(
                  activityData: homeController.activityOverviewChart,
                  title: 'Activity Overview',
                  titleColor: const Color(0xFF091242),
                  titleFontSize: 22,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
