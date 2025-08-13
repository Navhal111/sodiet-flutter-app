import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class PlanData {
  final int day;
  final String date;
  final double weight;
  final double intake;
  final double expenditure;

  PlanData({
    required this.day,
    required this.date,
    required this.weight,
    required this.intake,
    required this.expenditure,
  });
}

class PlanTableWidget extends StatelessWidget {
  final List<PlanData> planDataList;

  const PlanTableWidget({
    Key? key,
    required this.planDataList,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
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
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SemiBoldText(
                    'Day',
                    fontSize: 14,
                    textColor: Color(0xffA2A2A2),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SemiBoldText(
                    'Date',
                    fontSize: 14,
                    textColor: Color(0xffA2A2A2),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SemiBoldText(
                    'Weight',
                    fontSize: 14,
                    textColor: Color(0xffA2A2A2),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SemiBoldText(
                    'Intake (Kcal)',
                    fontSize: 14,
                    textColor: Color(0xffA2A2A2),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SemiBoldText(
                    'Expenditure',
                    fontSize: 14,
                    textColor: Color(0xffA2A2A2),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Table Rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: planDataList.length,
            itemBuilder: (context, index) {
              final data = planDataList[index];
              final isEvenRow = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isEvenRow ? Colors.white : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: MediumText(
                        data.day.toString(),
                        fontSize: 14,
                        textColor: const Color(0xffA2A2A2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: MediumText(
                        data.date,
                        fontSize: 14,
                        textColor: Colors.grey.shade600,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: MediumText(
                        '${data.weight.toStringAsFixed(2)}',
                        fontSize: 14,
                        textColor: const Color(0xffA2A2A2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: MediumText(
                        '${data.intake.toStringAsFixed(2)}',
                        fontSize: 14,
                        textColor: const Color(0xffA2A2A2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: MediumText(
                        '${data.expenditure.toStringAsFixed(2)}',
                        fontSize: 14,
                        textColor: const Color(0xffA2A2A2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
