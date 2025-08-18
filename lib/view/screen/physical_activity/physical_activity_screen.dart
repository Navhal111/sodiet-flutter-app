import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/staticData.dart';
import 'package:sodiet/controller/physicalActivity/physicalController.dart';
import 'package:sodiet/controller/plan/planController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/chart/activity_overview_chart.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';
import 'package:sodiet/view/widgets/common/shimmer_loading.dart';
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
  final ScrollController _scrollController = ScrollController();
  final PhysicalActivityController controller =
      Get.find<PhysicalActivityController>();
  final PlanController planController = Get.find<PlanController>();

  String selectedActivity = StaticData.PHYSICAL_ACTIVITIES.keys.first;
  String selectedTime = 'Morning';

  // Use activities from StaticData
  List<String> get activities => StaticData.PHYSICAL_ACTIVITIES.keys.toList();

  final List<String> timeOptions = ['Morning', 'Afternoon', 'Evening', 'Night'];

  // Generate suggestions from first 3 records from API data
  List<Map<String, dynamic>> get suggestions {
    if (controller.paRecallList.isEmpty) {
      return [];
    }

    final first3Records = controller.paRecallList.take(3);
    return first3Records.map((recall) {
      return {
        'activity': recall.activityName,
        'duration': recall.durationMinutes.toString(),
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Set today's date as default
    _dateController.text = _formatDate(DateTime.now());
    // Load PA recall data
    controller.getPaRecallList();
    // Load Activity Overview data
    planController.getActivityOverview();

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _durationController.dispose();
    _scrollController.dispose();
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
      // Show loading toast
      CustomToast.showLoading('Adding physical activity...');

      // Create JSON for API
      Map<String, dynamic> activityData = {
        "entry_date": _formatDateForAPI(_dateController.text),
        "activity_name": selectedActivity,
        "duration_minutes": int.tryParse(_durationController.text) ?? 0,
        "time_of_day": selectedTime.toLowerCase()
      };

      // Call API to add activity
      final result = await controller.addPaRecall(activityData);

      // Show result toast
      if (result['success']) {
        CustomToast.showSuccess(result['message']);

        // Clear form on success
        _durationController.clear();
        // Keep date and reset to defaults
        selectedActivity = StaticData.PHYSICAL_ACTIVITIES.keys.first;
        selectedTime = 'Morning';
        setState(() {}); // Refresh UI
      } else {
        CustomToast.showError(result['message']);
      }
    } else {
      CustomToast.showWarning('Please fill in all fields');
    }
  }

  void _addSuggestedActivity(String activity, String duration) {
    // Auto-fill the form instead of adding to local list
    setState(() {
      selectedActivity = activity;
      _durationController.text = duration;
    });

    CustomToast.showInfo('$activity selected with $duration minutes duration');
  }

  // Pagination scroll listener
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !controller.isLoadingMore.value &&
        controller.hasMoreData.value) {
      controller.loadMorePaRecalls();
    }
  }

  // Custom delete confirmation dialog
  void _showDeleteConfirmation(String recallId, String activityName) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: const Color(0xFFF44336),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Delete Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this activity entry?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: Theme.of(context).primaryColorDark,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activityName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        Get.back(); // Close dialog first

                        // Show loading toast
                        CustomToast.showLoading('Deleting activity...');

                        // Call delete API
                        final result =
                            await controller.deletePaRecall(recallId);

                        // Show result toast
                        if (result['success']) {
                          CustomToast.showSuccess(result['message']);
                        } else {
                          CustomToast.showError(result['message']);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isLoading.value
                      ? Colors.grey
                      : const Color(0xFFF44336),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              )),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.physicalActivityScreen,
      title: 'Physical Activity',
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          // Handle pagination when reaching near bottom
          if (scrollNotification is ScrollUpdateNotification) {
            _onScroll();
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
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
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Activity',
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
                                suffixIcon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                    size: 20),
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

                    // Add Button - Updated to use Obx pattern like DietRecallScreen
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: Obx(() => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : _addActivity,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isLoading.value
                                  ? Colors.grey
                                  : const Color(0xFFFF9800),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isLoading.value
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Adding...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SemiBoldText(
                          'Suggestions',
                          fontSize: 18,
                          textColor: Colors.black87,
                        ),
                        const SizedBox(height: 16),
                        if (suggestions.isNotEmpty) ...[
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
                                  flex: 3,
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
                                    'Select',
                                    fontSize: 14,
                                    textColor: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Suggestions Rows - Show first 3 from API data
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
                                    flex: 3,
                                    child: RegularText(
                                      suggestion['activity'],
                                      fontSize: 14,
                                      textColor: Colors.black87,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: RegularText(
                                      '${suggestion['duration']} Mins',
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
                                        color:
                                            Theme.of(context).primaryColorDark,
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

                          // Show hint text
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade600,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: RegularText(
                                    'Click + to auto-fill the form with suggested activity from your recent activities',
                                    fontSize: 12,
                                    textColor: Colors.blue.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (controller.isLoadingList.value) ...[
                          // Loading state
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RegularText(
                                    'Loading suggestions...',
                                    fontSize: 12,
                                    textColor: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          // Empty state
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.grey.shade400,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  RegularText(
                                    'No suggestions available',
                                    fontSize: 14,
                                    textColor: Colors.grey.shade600,
                                  ),
                                  const SizedBox(height: 4),
                                  RegularText(
                                    'Add some activities to see suggestions here',
                                    fontSize: 12,
                                    textColor: Colors.grey.shade500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    )),
              ),

              const SizedBox(height: 10),

              // Activity Overview Chart
              Obx(() {
                if (planController.isLoadingActivityOverview.value) {
                  return Container(
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
                    child: ShimmerChart(
                      width: double.infinity,
                      height: 300,
                      title: 'Activity Overview',
                    ),
                  );
                }

                return Container(
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
                  child: ActivityOverviewChart(
                    activityData: planController.activityOverviewChart,
                    title: 'Activity Overview',
                    titleColor: const Color(0xFF091242),
                    titleFontSize: 22,
                  ),
                );
              }),

              const SizedBox(height: 10),

              // PA Recall List Section - Updated with pagination
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
                              'Recall Records (${controller.totalCount.value})',
                              fontSize: 18,
                              textColor: Colors.black87,
                            ),
                            if (controller.isLoadingList.value)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (controller.paRecallList.isNotEmpty) ...[
                          // Table Header - Updated with Energy column
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
                                        fontSize: 10,
                                        textColor: Colors.black87)),
                                Expanded(
                                    flex: 2,
                                    child: SemiBoldText('Activity',
                                        fontSize: 10,
                                        textColor: Colors.black87)),
                                Expanded(
                                    flex: 2,
                                    child: SemiBoldText('Duration',
                                        fontSize: 10,
                                        textColor: Colors.black87)),
                                Expanded(
                                    flex: 2,
                                    child: SemiBoldText('Energy',
                                        fontSize: 10,
                                        textColor: Colors.black87)),
                                Expanded(
                                    flex: 2,
                                    child: SemiBoldText('Time',
                                        fontSize: 10,
                                        textColor: Colors.black87)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Activity List - Updated with pagination support
                          ...List.generate(
                            controller.paRecallList.length +
                                (controller.hasMoreData.value ? 1 : 0),
                            (index) {
                              // Show loading indicator at the bottom when loading more
                              if (index == controller.paRecallList.length) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: controller.isLoadingMore.value
                                        ? Column(
                                            children: [
                                              CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              RegularText(
                                                'Loading more activities...',
                                                fontSize: 12,
                                                textColor: Colors.grey.shade600,
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                );
                              }

                              final recall = controller.paRecallList[index];
                              return Dismissible(
                                key: ValueKey('pa_recall_${recall.recallId}'),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade400,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  // Show confirmation dialog instead of directly deleting
                                  _showDeleteConfirmation(
                                    recall.recallId,
                                    recall.activityName,
                                  );
                                  return false; // Don't dismiss automatically
                                },
                                child: Container(
                                  key: ValueKey('pa_recall_content_$index'),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
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
                                              fontSize: 10,
                                              textColor: Colors.black87)),
                                      Expanded(
                                          flex: 2,
                                          child: RegularText(
                                              recall.activityName,
                                              fontSize: 10,
                                              textColor: Colors.black87)),
                                      Expanded(
                                          flex: 2,
                                          child: RegularText(
                                              '${recall.durationMinutes}m',
                                              fontSize: 10,
                                              textColor: Colors.black87)),
                                      Expanded(
                                          flex: 2,
                                          child: RegularText(
                                              '${recall.energy.toStringAsFixed(1)} kcal',
                                              fontSize: 10,
                                              textColor:
                                                  Colors.green.shade700)),
                                      Expanded(
                                          flex: 2,
                                          child: RegularText(
                                              recall.timeOfDay.capitalizeFirst!,
                                              fontSize: 10,
                                              textColor: Colors.black87)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

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

              const SizedBox(height: 100), // Extra padding for scrolling
            ],
          ),
        ),
      ),
    );
  }
}
