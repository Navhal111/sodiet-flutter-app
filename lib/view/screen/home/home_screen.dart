import 'package:flutter/material.dart';
import 'package:sodiet/model/weight_data.dart';
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
  // Sample data for nutrient progress
  List<Map<String, dynamic>> poritinelist = [
    {
      "title": "Protein",
      "value": 75.0,
      "requiredValue": 100.0,
      "color": const Color(0xFF8BC34A)
    },
    {
      "title": "Zinc (mg)",
      "value": 50.09,
      "requiredValue": 100.0,
      "color": const Color(0xFFC82333)
    },
    {
      "title": "Folate (µg)",
      "value": 50.0,
      "requiredValue": 100.0,
      "color": const Color(0xFFC82333)
    },
    {
      "title": "Vitamin B3 (mg)",
      "value": 108.4,
      "requiredValue": 100.0,
      "color": const Color(0xFF8BC34A)
    },
    {
      "title": "Iron (mg)",
      "value": 82.3,
      "requiredValue": 100.0,
      "color": const Color(0xFFFFA500)
    },
  ];

  // Sample data for the weight progress chart - matching the design screenshot
  List<WeightData> sampleWeightData = [
    // Logged weight data (purple line) with some fluctuation
    WeightData(day: 1, loggedWeight: 1.0, plannedWeight: 100.0),
    WeightData(day: 3, loggedWeight: 0.79, plannedWeight: 99.5),
    WeightData(day: 5, loggedWeight: 0.5, plannedWeight: 99.0),
    WeightData(day: 6, loggedWeight: 0.77, plannedWeight: 98.5),
    WeightData(day: 7, loggedWeight: 0.6, plannedWeight: 98.0),
    WeightData(day: 8, loggedWeight: 0.9, plannedWeight: 97.5),

    // Planned weight data with steady decline (pink line)
    WeightData(day: 10, loggedWeight: -1, plannedWeight: 97.3),
    WeightData(day: 12, loggedWeight: -1, plannedWeight: 97.0),
    WeightData(day: 14, loggedWeight: -1, plannedWeight: 96.8),
    WeightData(day: 16, loggedWeight: -1, plannedWeight: 96.5),
    WeightData(day: 18, loggedWeight: -1, plannedWeight: 96.3),
    WeightData(day: 20, loggedWeight: -1, plannedWeight: 97.0),
    WeightData(day: 22, loggedWeight: -1, plannedWeight: 96.8),
    WeightData(day: 24, loggedWeight: -1, plannedWeight: 96.5),
    WeightData(day: 26, loggedWeight: -1, plannedWeight: 96.3),
    WeightData(day: 28, loggedWeight: -1, plannedWeight: 96.1),
    WeightData(day: 30, loggedWeight: -1, plannedWeight: 96.0),
  ];

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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: DataSummaryWidget(
                        title: 'Plan transformation',
                        startValue: '100kg',
                        endValue: '96Kg',
                        onClick: () {},
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: WeightProgressChart(
                  weightDataList: sampleWeightData,
                  title: 'Plan Progress',
                  titleColor:
                      const Color(0xFF091242), // Dark blue from the design
                  titleFontSize: 22,
                  loggedWeightColor:
                      const Color.fromRGBO(48, 0, 129, 1), // Deep purple
                  plannedWeightColor:
                      const Color.fromRGBO(255, 99, 132, 1), // Pink
                  showRightAxisLabels: true,
                  minKcal: 0.0,
                  maxKcal: 1.0, // KCal scale 0.0-1.0
                  minWeight: 96.0,
                  maxWeight: 100.0, // Weight scale 96.0-100.0 kg
                ),
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
                    const SizedBox(height: 10),
                    ...List.generate(poritinelist.length, (index) {
                      return NutrientProgressWidget(
                        nutrientName: poritinelist[index]['title'],
                        percentage: poritinelist[index]['value'],
                        inputValue: poritinelist[index]['value'],
                        requiredValue: poritinelist[index]['requiredValue'],
                        progressColor: poritinelist[index]['color'],
                        onTap: () {},
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
