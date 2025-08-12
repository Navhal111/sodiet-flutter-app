import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/weight_log/weight_log_controller.dart';
import 'package:sodiet/model/weight_log.dart';
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
  late WeightLogController controller;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<WeightLogController>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreData();
    }
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
      controller.dateController.text = controller.formatDate(picked);
    }
  }

  void _showDeleteConfirmation(int logId) {
    Get.defaultDialog(
      title: 'Delete Weight Log',
      middleText:
          'Are you sure you want to delete this weight log entry? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.grey.shade700,
      onConfirm: () {
        Get.back();
        controller.deleteWeightLog(logId);
      },
    );
  }

  void _showEditWeightLogDialog(WeightLog log) {
    // Populate the fields for editing
    controller.editWeightLog(log);

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
                      'Edit Weight Log',
                      fontSize: 20,
                      textColor: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.cancelEdit();
                      Get.back();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Date Field
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: controller.dateController,
                    hintText: 'Select Date',
                    labelText: 'Date',
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.calendar_today, color: Colors.grey),
                      onPressed: _selectDate,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Weight Field
              CustomTextField(
                controller: controller.weightController,
                hintText: 'Enter weight in kg',
                labelText: 'Weight (kg)',
                textInputType: TextInputType.numberWithOptions(decimal: true),
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
                          controller.cancelEdit();
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
                            text: controller.isSubmitting.value
                                ? 'Updating...'
                                : 'Update',
                            onPressed: controller.isSubmitting.value
                                ? null
                                : () async {
                                    await controller.submitWeightLog();
                                    // Check if edit was successful and close dialog
                                    if (!controller.isEditing.value &&
                                        !controller.isSubmitting.value) {
                                      Get.back();
                                    }
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
        currentRoute: AppRoutes.weightLogManagerScreen,
        title: 'Weight Log Manager',
        child: RefreshIndicator(
          onRefresh: () => controller.getWeightLogs(isRefresh: true),
          child: SingleChildScrollView(
            controller: _scrollController,
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
                            controller: controller.dateController,
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
                        controller: controller.weightController,
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
                        child: Obx(() => CustomButton(
                              text: controller.isSubmitting.value
                                  ? 'Adding...'
                                  : 'Add Weight Log',
                              onPressed: controller.isSubmitting.value
                                  ? null
                                  : controller.submitWeightLog,
                              backgroundColor: const Color(0xFFFF9800),
                              textColor: Colors.white,
                            )),
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
                                            children:
                                                List.generate(10, (index) {
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
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
                                'Actions',
                                fontSize: 14,
                                textColor: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Table Rows
                      Obx(() {
                        if (controller.isLoading.value &&
                            controller.weightLogs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (controller.weightLogs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: RegularText(
                                'No weight entries found',
                                fontSize: 14,
                                textColor: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            ...List.generate(controller.weightLogs.length,
                                (index) {
                              final log = controller.weightLogs[index];

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
                                        controller
                                            .formatDisplayDate(log.logDate),
                                        fontSize: 14,
                                        textColor: Colors.black87,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: RegularText(
                                        '${log.weightKg.toStringAsFixed(1)} kg',
                                        fontSize: 14,
                                        textColor: Colors.black87,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                _showEditWeightLogDialog(log),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: Colors.blue,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          InkWell(
                                            onTap: () =>
                                                _showDeleteConfirmation(
                                                    log.logId),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            // Loading more indicator
                            if (controller.isLoadingMore.value)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),

                            // Load more data info
                            if (!controller.hasMoreData.value &&
                                controller.weightLogs.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: RegularText(
                                    'All ${controller.totalCount.value} entries loaded',
                                    fontSize: 12,
                                    textColor: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ), // closing SingleChildScrollView
          ), // closing RefreshIndicator
        )); // closing BaseScreenLayout
  }
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
