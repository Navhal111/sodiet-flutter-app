import 'package:flutter/material.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/home/data_summary_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/plan/plan_status_widget.dart';
import 'package:sodiet/view/widgets/plan/plan_table_widget.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // Sample plan data for the table
  List<PlanData> samplePlanData = [
    PlanData(
      day: 1,
      date: '2025-02-28',
      weight: 100.00,
      intake: 2127.00,
      expenditure: 2827.00,
    ),
    PlanData(
      day: 2,
      date: '2025-03-01',
      weight: 99.68,
      intake: 2127.00,
      expenditure: 2827.00,
    ),
    PlanData(
      day: 3,
      date: '2025-03-02',
      weight: 56.00,
      intake: 2127.00,
      expenditure: 2827.00,
    ),
    PlanData(
      day: 4,
      date: '2025-03-03',
      weight: 78.00,
      intake: 2127.00,
      expenditure: 2827.00,
    ),
    PlanData(
      day: 5,
      date: '2025-03-04',
      weight: 92.50,
      intake: 2127.00,
      expenditure: 2827.00,
    ),
    PlanData(
      day: 6,
      date: '2025-03-05',
      weight: 112.22,
      intake: 2127.00,
      expenditure: 2827.00,
    ),
  ];

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: RegularText(
                              'Reset plan functionality will be implemented soon'),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  )),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
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
                          onClick: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Plan transformation details clicked'),
                                backgroundColor: Color(0xFFE57373),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Plan Table Widget
              PlanTableWidget(
                planDataList: samplePlanData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
