import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/staticData.dart';
import 'package:sodiet/controller/physicalActivity/physicalController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/chart/intake_overview_chart.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';

class PhysicalActivityScreen extends StatefulWidget {
  const PhysicalActivityScreen({Key? key}) : super(key: key);

  @override
  State<PhysicalActivityScreen> createState() => _PhysicalActivityScreenState();
}

class _PhysicalActivityScreenState extends State<PhysicalActivityScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final PhysicalActivityController controller =
      Get.find<PhysicalActivityController>();

  String selectedActivity = StaticData.PHYSICAL_ACTIVITIES.keys.first;
  String selectedTime = 'Morning';

  // Use activities from StaticData
  List<String> get activities => StaticData.PHYSICAL_ACTIVITIES.keys.toList();

  final List<String> timeOptions = ['Morning', 'Afternoon', 'Evening', 'Night'];

  final List<ActivityEntry> _activityEntries = [];

  final List<Map<String, dynamic>> suggestions = [
    {
      'activity': 'Tennis',
      'duration': '60 Mins',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set today's date as default
    _dateController.text = _formatDate(DateTime.now());
    // Load PA recall data
    controller.getPaRecallList();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateForAPI(String displayDate) {
    // Convert DD/MM/YYYY to YYYY-MM-DD
    List<String> parts = displayDate.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
    }
    return displayDate;
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

  void _addActivity() async {
    if (_dateController.text.isNotEmpty &&
        _durationController.text.isNotEmpty &&
        selectedActivity.isNotEmpty) {
      // Create JSON for API
      Map<String, dynamic> activityData = {
        "entry_date": _formatDateForAPI(_dateController.text),
        "activity_name": selectedActivity,
        "duration_minutes": int.tryParse(_durationController.text) ?? 0,
        "time_of_day": selectedTime.toLowerCase()
      };

      // Call API to add activity
      await controller.addPaRecall(activityData);

      controller.getPaRecallList();

      // Show success message
      Get.snackbar(
        'Success',
        'Activity added successfully!',
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

  void _addSuggestedActivity(String activity, String duration) {
    setState(() {
      _activityEntries.add(ActivityEntry(
        date: _formatDate(DateTime.now()),
        activity: activity,
        duration: int.tryParse(duration.replaceAll(' Mins', '')) ?? 0,
        time: 'Morning',
      ));
    });

    Get.snackbar(
      'Added',
      '$activity for $duration added to your activities!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
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
      currentRoute: AppRoutes.physicalActivityScreen,
      title: 'Physical Activity',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with icon
            TitleSectionWidget(
              imagePath:
                  'assets/images/plan.png', // Using plan icon as placeholder
              title: 'Physical Activity Recall',
              description: 'Recall your Physical Activity',
              imageWidth: 60,
              imageHeight: 60,
            ),

            // Manual Entry Section

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
                    'Manual',
                    fontSize: 18,
                    textColor: Colors.black87,
                  ),
                  const SizedBox(height: 16),

                  // Date Field
                  GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          controller: _dateController,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Date',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            suffixIcon: const Icon(Icons.calendar_today,
                                color: Colors.grey, size: 20),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Activity Dropdown - Updated to use StaticData
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: DropdownButtonFormField<String>(
                      value: selectedActivity,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Activity',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        suffixIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey, size: 20),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade400, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: activities.map((String activity) {
                        return DropdownMenuItem<String>(
                          value: activity,
                          child: Text(activity,
                              style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedActivity = newValue ?? activities.first;
                        });
                      },
                    ),
                  ),

                  // Duration and Time Row
                  Row(
                    children: [
                      // Duration Field
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: TextFormField(
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Duration (min)',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Time Dropdown
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: DropdownButtonFormField<String>(
                            value: selectedTime,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Time',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              suffixIcon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey, size: 20),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: timeOptions.map((String time) {
                              return DropdownMenuItem<String>(
                                value: time,
                                child: Text(time,
                                    style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTime = newValue ?? timeOptions.first;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Add Button - Updated to be loading aware
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Obx(() => ElevatedButton(
                          onPressed:
                              controller.isLoading.value ? null : _addActivity,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9800),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        )),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Suggestions Section
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
                    'Suggestions',
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
                            'Activity',
                            fontSize: 14,
                            textColor: Colors.black87,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SemiBoldText(
                            'Duration',
                            fontSize: 14,
                            textColor: Colors.black87,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SemiBoldText(
                            'Add',
                            fontSize: 14,
                            textColor: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Suggestions Rows
                  ...List.generate(suggestions.length, (index) {
                    final suggestion = suggestions[index];
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
                              suggestion['activity'],
                              fontSize: 14,
                              textColor: Colors.black87,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: RegularText(
                              suggestion['duration'],
                              fontSize: 14,
                              textColor: Colors.black87,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: () => _addSuggestedActivity(
                                  suggestion['activity'],
                                  suggestion['duration'],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // PA Recall List Section
            Obx(() => Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SemiBoldText(
                            'Activity History',
                            fontSize: 18,
                            textColor: Colors.black87,
                          ),
                          if (controller.isLoadingList.value)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (controller.paRecallList.isNotEmpty) ...[
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
                                  child: SemiBoldText('Date',
                                      fontSize: 12, textColor: Colors.black87)),
                              Expanded(
                                  flex: 2,
                                  child: SemiBoldText('Activity',
                                      fontSize: 12, textColor: Colors.black87)),
                              Expanded(
                                  flex: 2,
                                  child: SemiBoldText('Duration',
                                      fontSize: 12, textColor: Colors.black87)),
                              Expanded(
                                  flex: 2,
                                  child: SemiBoldText('Time',
                                      fontSize: 12, textColor: Colors.black87)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Activity List
                        ...controller.paRecallList
                            .map((recall) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: RegularText(recall.entryDate,
                                              fontSize: 12,
                                              textColor: Colors.black87)),
                                      Expanded(
                                          flex: 2,
                                          child: RegularText(
                                              recall.activityName,
                                              fontSize: 12,
                                              textColor: Colors.black87)),
                                      Expanded(
                                          flex: 2,
                                          child: RegularText(
                                              '${recall.durationMinutes}m',
                                              fontSize: 12,
                                              textColor: Colors.black87)),
                                      Expanded(
                                          flex: 2,
                                          child: RegularText(
                                              recall.timeOfDay.capitalizeFirst!,
                                              fontSize: 12,
                                              textColor: Colors.black87)),
                                    ],
                                  ),
                                ))
                            .toList(),

                        const SizedBox(height: 16),
                        RegularText(
                          'Total: ${controller.totalCount.value} activities',
                          fontSize: 12,
                          textColor: Colors.grey.shade600,
                        ),
                      ] else if (!controller.isLoadingList.value) ...[
                        Center(
                          child: RegularText(
                            'No activity records found',
                            fontSize: 14,
                            textColor: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                )),

            const SizedBox(height: 10),

            // Activity Chart Section (using IntakeOverviewChart)
            IntakeOverviewChart(
              intakeDataList: sampleIntakeData,
              title: 'Activity Overview',
              titleColor: const Color(0xFF091242),
              titleFontSize: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityEntry {
  final String date;
  final String activity;
  final int duration;
  final String time;

  ActivityEntry({
    required this.date,
    required this.activity,
    required this.duration,
    required this.time,
  });
}
