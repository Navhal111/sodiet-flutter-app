import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';
import 'package:sodiet/view/widgets/custom_button.dart';
import 'package:sodiet/route/app_routes.dart';

class WeightLogManagerScreen extends StatefulWidget {
  const WeightLogManagerScreen({Key? key}) : super(key: key);

  @override
  State<WeightLogManagerScreen> createState() => _WeightLogManagerScreenState();
}

class _WeightLogManagerScreenState extends State<WeightLogManagerScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final List<WeightEntry> _weightEntries = [];

  @override
  void initState() {
    super.initState();
    // Set today's date as default
    _dateController.text = _formatDate(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate() async {
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
      setState(() {
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _addWeightLog() {
    if (_dateController.text.isNotEmpty && _weightController.text.isNotEmpty) {
      setState(() {
        _weightEntries.add(WeightEntry(
          date: _dateController.text,
          weight: double.tryParse(_weightController.text) ?? 0.0,
        ));
        _weightController.clear();
      });

      // Show success message
      Get.snackbar(
        'Success',
        'Weight log added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } else {
      // Show error message
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  void _deleteEntry(int index) {
    setState(() {
      _weightEntries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.weightLogManagerScreen,
      title: 'Weight Log Manager',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SemiBoldText(
                    'Weight Log Manager',
                    fontSize: 20,
                    textColor: Colors.black87,
                  ),
                  RegularText(
                    'Manage your weight logs and track your progress',
                    fontSize: 12,
                    textColor: Colors.grey.shade600,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Weight Entry Form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Field
                  GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: _dateController,
                        hintText: 'Select Date',
                        labelText: 'Date',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.grey),
                          onPressed: _selectDate,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Weight Field
                  CustomTextField(
                    controller: _weightController,
                    hintText: 'Enter weight in kg',
                    labelText: 'Weight',
                    textInputType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),

                  const SizedBox(height: 10),

                  // Add Weight Log Button
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Add Weight Log',
                      onPressed: _addWeightLog,
                      backgroundColor: const Color(0xFFFF9800),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Weight Trend Chart Section
            // Weight Entry Form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SemiBoldText(
                    'Weight Trend',
                    fontSize: 18,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 16),

                  // Chart Container (simplified grid)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // Grid lines
                        Positioned.fill(
                          child: CustomPaint(
                            painter: GridPainter(),
                          ),
                        ),
                        // Chart content
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    // Y-axis labels
                                    SizedBox(
                                      width: 30,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: List.generate(10, (index) {
                                          return RegularText(
                                            '${25 - (index * 2)}',
                                            fontSize: 10,
                                            textColor: Colors.grey.shade600,
                                          );
                                        }),
                                      ),
                                    ),
                                    // Chart area
                                    Expanded(
                                      child: Container(),
                                    ),
                                  ],
                                ),
                              ),
                              // X-axis labels
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(13, (index) {
                                  return RegularText(
                                    '${16 + index}',
                                    fontSize: 10,
                                    textColor: Colors.grey.shade600,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Weight Log Entries Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SemiBoldText(
                    'Weight Log Entries',
                    fontSize: 18,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 16),

                  // Table Header
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SemiBoldText(
                            'Date',
                            fontSize: 14,
                            textColor: Colors.black87,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SemiBoldText(
                            'Weight',
                            fontSize: 14,
                            textColor: Colors.black87,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SemiBoldText(
                            'Action',
                            fontSize: 14,
                            textColor: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Table Rows
                  if (_weightEntries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: RegularText(
                          'No weight entries added yet',
                          fontSize: 14,
                          textColor: Colors.grey.shade600,
                        ),
                      ),
                    )
                  else
                    ...List.generate(_weightEntries.length, (index) {
                      final entry = _weightEntries[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: RegularText(
                                entry.date,
                                fontSize: 14,
                                textColor: Colors.black87,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: RegularText(
                                '${entry.weight.toStringAsFixed(1)} kg',
                                fontSize: 14,
                                textColor: Colors.black87,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => _deleteEntry(index),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeightEntry {
  final String date;
  final double weight;

  WeightEntry({
    required this.date,
    required this.weight,
  });
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    // Draw horizontal lines
    for (int i = 0; i <= 8; i++) {
      final y = (size.height / 8) * i;
      canvas.drawLine(
        Offset(30, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw vertical lines
    for (int i = 0; i <= 12; i++) {
      final x = 30 + ((size.width - 30) / 12) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
