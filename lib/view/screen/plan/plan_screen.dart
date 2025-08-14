import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/plan/planController.dart';
import 'package:sodiet/model/plan_model.dart';
import 'package:sodiet/model/weight_data.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/home/data_summary_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/plan/plan_status_widget.dart';
import 'package:sodiet/view/widgets/plan/plan_table_widget.dart' as table;
import 'package:sodiet/view/widgets/chart/weight_progress_chart.dart';
import 'package:sodiet/view/widgets/common/shimmer_loading.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final PlanController planController = Get.find<PlanController>();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  _loadDashboardData() async {
    await planController.getActivePlanDetails();
  }

  // Method to show reset plan confirmation dialog
  void _showResetPlanConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Reset Plan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            'Are you sure you want to reset your current plan? This action cannot be undone and will deactivate your current plan.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            // Reset button
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                await _resetPlan();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to handle plan reset
  Future<void> _resetPlan() async {
    if (planController.planId.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active plan found to reset'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resetting plan...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Call delete plan API
      final result =
          await planController.deletePlan(planController.planId.value);

      if (result['success']) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Refresh the screen data
        setState(() {});
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Method to build KPI widgets from dashboard summary data
  List<Widget> _buildKpiWidgets() {
    if (!planController.hasDashboardSummary ||
        planController.dashboardKpi == null) {
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

    final kpiData = planController.dashboardKpi!;

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
          title: 'Start Date',
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

  // Method to convert DailyData to PlanData for table display
  List<table.PlanData> _convertDailyDataToTableData(
      List<DailyData> dailyDataList) {
    return dailyDataList.map((dailyData) {
      return table.PlanData(
        day: int.tryParse(dailyData.day) ?? 0,
        date: dailyData.date,
        weight: dailyData.loggedWeight ?? dailyData.projectedWeight,
        intake: dailyData.targetIntake,
        expenditure: dailyData.targetExpenditure,
      );
    }).toList();
  }

  // Method to get table data from API or fallback to empty list
  List<table.PlanData> _getTableData() {
    if (planController.hasDashboardSummary &&
        planController.dailyDataList.isNotEmpty) {
      return _convertDailyDataToTableData(planController.dailyDataList);
    }
    return [];
  }

  // Method to get chart weight data (copied from home controller logic)
  List<WeightData> _getChartWeightData() {
    if (!planController.hasDashboardSummary ||
        planController.dailyDataList.isEmpty) {
      return [];
    }

    return planController.dailyDataList.map((dailyData) {
      return WeightData(
        day: int.tryParse(dailyData.day) ?? 0,
        projectedWeightKg: dailyData.projectedWeight,
        loggedWeightKg: dailyData.loggedWeight,
        targetIntakeKcal: dailyData.targetIntake,
        targetExpenditureKcal: dailyData.targetExpenditure,
        actualIntakeKcal: dailyData.actualIntake,
        actualExpenditureKcal: dailyData.actualExpenditure,
        ccIntakeKcal: dailyData.ccIntake,
        ccExpenditureKcal: dailyData.ccExpenditure,
      );
    }).toList();
  }

  // Method to get chart data ranges (copied from home controller logic)
  Map<String, double> _getChartDataRanges() {
    if (!planController.hasDashboardSummary ||
        planController.dailyDataList.isEmpty) {
      return {
        'minIntake': 1500.0,
        'maxIntake': 2500.0,
        'minWeight': 60.0,
        'maxWeight': 80.0,
      };
    }

    final intakeValues = planController.dailyDataList
        .where((data) => data.targetIntake > 0)
        .map((data) => data.targetIntake)
        .toList();

    final weightValues = <double>[];
    for (var data in planController.dailyDataList) {
      if (data.loggedWeight != null && data.loggedWeight! > 0) {
        weightValues.add(data.loggedWeight!);
      }
      if (data.projectedWeight > 0) {
        weightValues.add(data.projectedWeight);
      }
    }

    double minIntake = intakeValues.isNotEmpty
        ? intakeValues.reduce((a, b) => a < b ? a : b)
        : 1500.0;
    double maxIntake = intakeValues.isNotEmpty
        ? intakeValues.reduce((a, b) => a > b ? a : b)
        : 2500.0;
    double minWeight = weightValues.isNotEmpty
        ? weightValues.reduce((a, b) => a < b ? a : b)
        : 60.0;
    double maxWeight = weightValues.isNotEmpty
        ? weightValues.reduce((a, b) => a > b ? a : b)
        : 80.0;

    // Add some padding to the ranges
    double intakeRange = maxIntake - minIntake;
    double weightRange = maxWeight - minWeight;

    return {
      'minIntake': minIntake - (intakeRange * 0.1),
      'maxIntake': maxIntake + (intakeRange * 0.1),
      'minWeight': minWeight - (weightRange * 0.1),
      'maxWeight': maxWeight + (weightRange * 0.1),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.planScreen,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  child: PlanStatusWidget(
                    onResetTap: () {
                      _showResetPlanConfirmationDialog();
                    },
                  )),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 80,
                  child: Obx(() {
                    if (planController.isLoadingDashboardSummary.value) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: ShimmerLoading(
                              width: 120,
                              height: 80,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        },
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
              ),
              const SizedBox(height: 10),
              // Weight Progress Chart
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Obx(() {
                  if (planController.isLoadingDashboardSummary.value) {
                    return ShimmerChart(
                      width: double.infinity,
                      height: 300,
                      title: 'Plan Progress',
                    );
                  }

                  final chartData = _getChartWeightData();
                  final dataRanges = _getChartDataRanges();

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
              // Plan Table Widget
              Obx(() {
                final tableData = _getTableData();
                return table.PlanTableWidget(
                  planDataList: tableData,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
