import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/plan/planController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';
import 'package:sodiet/view/widgets/common/searchable_bottom_sheet.dart';

import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';

class GeneratePlanScreen extends StatefulWidget {
  const GeneratePlanScreen({Key? key}) : super(key: key);

  @override
  State<GeneratePlanScreen> createState() => _GeneratePlanScreenState();
}

class _GeneratePlanScreenState extends State<GeneratePlanScreen>
    with AutomaticKeepAliveClientMixin {
  late PlanController planController;

  @override
  bool get wantKeepAlive => true;

  // // Method to preserve scroll position during state updates
  // void _preserveScrollAndSetState(VoidCallback fn) {
  //   final scrollPosition =
  //       _scrollController.hasClients ? _scrollController.offset : 0.0;

  //   setState(fn);

  //   // // Restore scroll position after rebuild
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   //   if (_scrollController.hasClients) {
  //   //     _scrollController.animateTo(
  //   //       scrollPosition,
  //   //       duration: const Duration(milliseconds: 100),
  //   //       curve: Curves.easeOut,
  //   //     );
  //   //   }
  //   // });
  // }

  // Form controllers
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    planController = Get.find<PlanController>();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _durationController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return BaseScreenLayout(
      currentRoute: AppRoutes.generatePlanScreen,
      title: 'Generate Plan',
      child: Container(
        color: Colors.grey.shade50,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              // Header Section
              _buildHeaderSection(),

              const SizedBox(height: 10),

              // Plan Details Section
              _buildPlanDetailsSection(),

              const SizedBox(height: 10),

              // Submit Button
              _buildSubmitButton(),

              // Add bottom padding for keyboard
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(width: 16),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SemiBoldText(
                  'Generate Your Plan',
                  fontSize: 20,
                  textColor: const Color(0xFF091242),
                ),
                const SizedBox(height: 4),
                RegularText(
                  'View and manage your weekly optimization plans to track your progress and stay on top of your diet and fitness goals.',
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetailsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          // Section Title
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              SemiBoldText(
                'Please enter the details below',
                fontSize: 16,
                textColor: const Color(0xFF091242),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Age Field
          _buildInputField(
            controller: _ageController,
            labelText: 'Age',
            hintText: 'Enter your age',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // Sex Radio Buttons
          _buildSexRadioField(),

          const SizedBox(height: 16),

          // Height Field
          _buildInputField(
            controller: _heightController,
            labelText: 'Height (in cm)',
            hintText: 'Enter your height in centimeters',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),

          const SizedBox(height: 16),

          // Weight Field
          _buildInputField(
            controller: _weightController,
            labelText: 'Weight (in kg)',
            hintText: 'Enter your weight in kilograms',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),

          const SizedBox(height: 24),

          // Transformation Plan Section
          _buildTransformationPlanSection(),

          const SizedBox(height: 16),

          // Conditional Fields based on plan selection (always present to prevent layout jumping)
          _buildConditionalFields(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RegularText(
            labelText,
            fontSize: 14,
            textColor: const Color(0xFF091242),
          ),
        ),

        // Input field
        Container(
          decoration: BoxDecoration(
            color: enabled ? const Color(0xffF2F2F2) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(
              fontSize: 14,
              color: enabled ? const Color(0xFF091242) : Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSexRadioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RegularText(
            'Sex',
            fontSize: 14,
            textColor: const Color(0xFF091242),
          ),
        ),

        // Radio Button Container
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(() => Row(
                  children: [
                    // Male Radio Button
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            groupValue: planController.selectedSex.value.isEmpty
                                ? null
                                : planController.selectedSex.value,
                            onChanged: (String? value) {
                              if (value != null) {
                                planController.selectedSex.value = value;
                              }
                            },
                            activeColor: Theme.of(context).primaryColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          GestureDetector(
                            onTap: () {
                              planController.selectedSex.value = 'Male';
                            },
                            child: Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF091242),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Female Radio Button
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Female',
                            groupValue: planController.selectedSex.value.isEmpty
                                ? null
                                : planController.selectedSex.value,
                            onChanged: (String? value) {
                              if (value != null) {
                                planController.selectedSex.value = value;
                              }
                            },
                            activeColor: Theme.of(context).primaryColor,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          GestureDetector(
                            onTap: () {
                              planController.selectedSex.value = 'Female';
                            },
                            child: Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF091242),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildTransformationPlanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RegularText(
            'Transformation Plan',
            fontSize: 14,
            textColor: const Color(0xFF091242),
          ),
        ),

        // Plan Cards Row
        Obx(() => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rapid Plan
                Expanded(
                  child: _buildPlanCard(
                    title: 'Rapid Weight Transformation',
                    subtitle: 'Quickly transform with a focused 2-week plan.',
                    planType: 'Rapid',
                    isSelected: planController.selectedPlan.value == 'Rapid',
                  ),
                ),
                const SizedBox(width: 8),
                // Relaxed Plan
                Expanded(
                  child: _buildPlanCard(
                    title: 'Relaxed Weight Transformation',
                    subtitle:
                        'Comprehensive transformation spread over two months.',
                    planType: 'Relaxed',
                    isSelected: planController.selectedPlan.value == 'Relaxed',
                  ),
                ),
                const SizedBox(width: 8),
                // Custom Plan
                Expanded(
                  child: _buildPlanCard(
                    title: 'Custom',
                    subtitle: 'Set your own pace with a custom duration.',
                    planType: 'Custom',
                    isSelected: planController.selectedPlan.value == 'Custom',
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String planType,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        planController.selectedPlan.value = planType;
        // Set default values based on plan type
        if (planType == 'Rapid') {
          _durationController.text = '14';
          _targetWeightController.clear();
        } else if (planType == 'Relaxed') {
          _durationController.text = '60';
          _targetWeightController.clear();
        } else if (planType == 'Custom') {
          _durationController.clear();
          _targetWeightController.clear();
        }
        // Set default start date to today
        _startDateController.text = '18/08/2025';
      },
      child: Container(
        height: 100, // Fixed height for all cards
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A86B) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00A86B).withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF091242),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey.shade600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionalFields() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Obx(() => planController.selectedPlan.value.isNotEmpty
          ? Column(
              key: ValueKey(planController.selectedPlan
                  .value), // Key to help AnimatedSwitcher track changes
              children: [
                // Target Weight Field (editable for Custom, disabled for Rapid/Relaxed)
                _buildInputField(
                  controller: _targetWeightController,
                  labelText: 'Target Weight (in kg)',
                  hintText: planController.selectedPlan.value == 'Custom'
                      ? 'Enter your target weight'
                      : 'Will be calculated automatically',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  enabled: planController.selectedPlan.value == 'Custom',
                ),

                const SizedBox(height: 16),

                // Physical Activity Estimation Button
                _buildPhysicalActivityButton(),

                const SizedBox(height: 16),

                // Duration Field (editable for Custom, disabled for Rapid/Relaxed)
                _buildInputField(
                  controller: _durationController,
                  labelText: 'Duration (in days)',
                  hintText: planController.selectedPlan.value == 'Custom'
                      ? 'Enter duration in days'
                      : '${planController.selectedPlan.value == 'Rapid' ? '14' : '60'} days',
                  keyboardType: TextInputType.number,
                  enabled: planController.selectedPlan.value == 'Custom',
                ),

                const SizedBox(height: 16),

                // Start Date Field (always editable)
                _buildDateField(),
              ],
            )
          : const SizedBox.shrink(key: ValueKey('empty'))),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RegularText(
            'Start Date',
            fontSize: 14,
            textColor: const Color(0xFF091242),
          ),
        ),

        // Date field
        GestureDetector(
          onTap: () => _selectDate(),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDateController.text.isEmpty
                        ? 'Select start date'
                        : _startDateController.text,
                    style: TextStyle(
                      color: _startDateController.text.isEmpty
                          ? Colors.grey.shade500
                          : const Color(0xFF091242),
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey.shade600,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _startDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Obx(() {
        bool isLoading = planController.isGeneratingPlan.value;
        return ElevatedButton(
          onPressed: isLoading ? null : _generatePlan,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8C00),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    RegularText(
                      'Generating...',
                      fontSize: 16,
                      textColor: Colors.white,
                    ),
                  ],
                )
              : RegularText(
                  'Generate Plan',
                  fontSize: 14,
                  textColor: Colors.white,
                ),
        );
      }),
    );
  }

  void _generatePlan() async {
    // Validate required fields
    if (_ageController.text.trim().isEmpty) {
      CustomToast.showError('Please enter your age');
      return;
    }

    if (planController.selectedSex.value.isEmpty) {
      CustomToast.showError('Please select your sex');
      return;
    }

    if (_heightController.text.trim().isEmpty) {
      CustomToast.showError('Please enter your height');
      return;
    }

    if (_weightController.text.trim().isEmpty) {
      CustomToast.showError('Please enter your weight');
      return;
    }

    if (planController.selectedPlan.value.isEmpty) {
      CustomToast.showError('Please select a transformation plan');
      return;
    }

    if (_startDateController.text.trim().isEmpty) {
      CustomToast.showError('Please select a start date');
      return;
    }

    // Validate numeric values
    final age = int.tryParse(_ageController.text.trim());
    if (age == null || age < 1 || age > 120) {
      CustomToast.showError('Please enter a valid age (1-120)');
      return;
    }

    final height = double.tryParse(_heightController.text.trim());
    if (height == null || height < 50 || height > 300) {
      CustomToast.showError('Please enter a valid height (50-300 cm)');
      return;
    }

    final weight = double.tryParse(_weightController.text.trim());
    if (weight == null || weight < 20 || weight > 500) {
      CustomToast.showError('Please enter a valid weight (20-500 kg)');
      return;
    }

    // Validate plan-specific fields
    if (planController.selectedPlan.value == 'Custom') {
      if (_targetWeightController.text.trim().isEmpty) {
        CustomToast.showError(
            'Please enter your target weight for custom plan');
        return;
      }

      if (_durationController.text.trim().isEmpty) {
        CustomToast.showError('Please enter duration for custom plan');
        return;
      }

      final targetWeight = double.tryParse(_targetWeightController.text.trim());
      if (targetWeight == null || targetWeight < 20 || targetWeight > 500) {
        CustomToast.showError('Please enter a valid target weight (20-500 kg)');
        return;
      }

      final duration = int.tryParse(_durationController.text.trim());
      if (duration == null || duration < 7 || duration > 365) {
        CustomToast.showError('Please enter a valid duration (7-365 days)');
        return;
      }
    }

    try {
      // Determine target weight and duration based on plan type
      double targetWeight;
      int duration;

      if (planController.selectedPlan.value == 'Custom') {
        targetWeight = double.parse(_targetWeightController.text.trim());
        duration = int.parse(_durationController.text.trim());
      } else if (planController.selectedPlan.value == 'Rapid') {
        duration = 14;
        // For non-custom plans, we'll use current weight as target weight
        // The backend will calculate the actual target weight
        targetWeight = weight;
      } else {
        // Relaxed
        duration = 60;
        // For non-custom plans, we'll use current weight as target weight
        // The backend will calculate the actual target weight
        targetWeight = weight;
      }

      // Convert date from DD/MM/YYYY to YYYY-MM-DD format
      String formattedDate = _startDateController.text.trim();
      List<String> dateParts = formattedDate.split('/');
      if (dateParts.length == 3) {
        formattedDate =
            '${dateParts[2]}-${dateParts[1].padLeft(2, '0')}-${dateParts[0].padLeft(2, '0')}';
      }

      print('Calling generatePlan API with:');
      print(
          'Age: $age, Sex: ${planController.selectedSex.value.toLowerCase()}');
      print('Height: $height, Weight: $weight');
      print('Target Weight: $targetWeight, Duration: $duration');
      print('Start Date: $formattedDate');

      // Call the actual API
      final result = await planController.generatePlan(
        age: age,
        sex: planController.selectedSex.value.toLowerCase(),
        height: height,
        weight: weight,
        targetWeight: targetWeight,
        duration: duration,
        startDate: formattedDate,
      );

      if (result['success']) {
        CustomToast.showSuccess(result['message']);

        // Clear form on success
        _clearForm();

        // Navigate back to plan screen
        if (mounted) {
          Get.offNamed(AppRoutes.planScreen);
        }
      } else {
        CustomToast.showError(result['message']);
      }
    } catch (e) {
      print('Error generating plan: $e');
      CustomToast.showError('Failed to generate plan: $e');
    }
  }

  void _clearForm() {
    _ageController.clear();
    _heightController.clear();
    _weightController.clear();
    _targetWeightController.clear();
    _durationController.clear();
    _startDateController.clear();
    planController.clearFormFields();
  }

  Widget _buildPhysicalActivityButton() {
    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showPhysicalActivityDialog(),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          side: const BorderSide(color: Color(0xFF3F51B5), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: const Icon(
          Icons.fitness_center,
          color: Color(0xFF3F51B5),
          size: 20,
        ),
        label: const Text(
          'Current Physical Activities (Estimate)',
          style: TextStyle(
            color: Color(0xFF3F51B5),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showPhysicalActivityDialog() {
    // Load physical activities when dialog opens
    planController.getPhysicalActivitiesList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const PhysicalActivityEstimationForm(),
        );
      },
    );
  }
}

class PhysicalActivityEstimationForm extends StatefulWidget {
  const PhysicalActivityEstimationForm({Key? key}) : super(key: key);

  @override
  State<PhysicalActivityEstimationForm> createState() =>
      _PhysicalActivityEstimationFormState();
}

class _PhysicalActivityEstimationFormState
    extends State<PhysicalActivityEstimationForm> {
  late PlanController planController;

  // Form controllers
  final TextEditingController _durationController = TextEditingController();

  // Selected values
  String? selectedActivity;
  Set<String> selectedDays = {};

  // Activity level options
  final List<String> activityLevels = [
    'Sedentary (little or no exercise)',
    'Lightly Active (light exercise/sports 1-3 days/week)',
    'Moderately Active (moderate exercise/sports 3-5 days/week)',
    'Very Active (hard exercise/sports 6-7 days a week)',
    'Extra Active (very hard exercise/sports & physical job or 2x training)',
  ];

  // Day abbreviations
  final Map<String, String> dayMap = {
    'S': 'SU',
    'M': 'MO',
    'T': 'TU',
    'W': 'WE',
    'T2': 'TH',
    'F': 'FR',
    'S2': 'SA',
  };

  final List<String> dayLabels = ['S', 'M', 'T', 'W', 'T2', 'F', 'S2'];

  @override
  void initState() {
    super.initState();
    planController = Get.find<PlanController>();
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        maxWidth: MediaQuery.of(context).size.width * 0.98,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Estimate your Physical Activity Level',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Form content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sleep hours
                  _buildTextFormField(
                    label: 'Sleep (in hours)',
                    value: planController.sleepHours,
                    hintText: '8',
                  ),

                  const SizedBox(height: 24),

                  // Work/School hours
                  _buildTextFormField(
                    label: 'Work/School (in hours)',
                    value: planController.workSchoolHours,
                    hintText: '8',
                  ),

                  const SizedBox(height: 24),

                  // Work/School activity level
                  _buildActivityLevelField(),

                  const SizedBox(height: 24),

                  // Other physical activities section
                  _buildOtherActivitiesSection(),

                  const SizedBox(height: 24),

                  // Added activities table
                  _buildAddedActivitiesTable(),

                  const SizedBox(height: 24),

                  // Action buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required RxString value,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF091242),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: Obx(() => TextField(
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  value.value = newValue;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                controller: TextEditingController(text: value.value)
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: value.value.length)),
              )),
        ),
      ],
    );
  }

  Widget _buildActivityLevelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How would you describe your Physical Activity at Work/School',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF091242),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showActivityLevelBottomSheet(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                        planController.workSchoolActivityLevel.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF091242),
                        ),
                      )),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showActivityLevelBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchableBottomSheet(
        title: 'Activity Level',
        items: activityLevels,
        selectedValue: planController.workSchoolActivityLevel.value,
        onSelected: (value) {
          if (value != null) {
            planController.workSchoolActivityLevel.value = value;
          }
        },
        searchHint: 'Search activity level...',
      ),
    );
  }

  Widget _buildOtherActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Other Physical Activity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF091242),
          ),
        ),
        const SizedBox(height: 16),

        // Activity dropdown
        _buildActivityDropdown(),

        const SizedBox(height: 16),

        // Duration input
        _buildDurationField(),

        const SizedBox(height: 16),

        // Days selection
        _buildDaysSelection(),

        const SizedBox(height: 16),

        // Add button
        _buildAddActivityButton(),
      ],
    );
  }

  Widget _buildActivityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF091242),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPhysicalActivitiesBottomSheet(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              if (planController.isLoadingPhysicalActivities.value) {
                return const Row(
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Loading activities...'),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedActivity ?? 'Select an activity',
                      style: TextStyle(
                        fontSize: 14,
                        color: selectedActivity != null
                            ? const Color(0xFF091242)
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  void _showPhysicalActivitiesBottomSheet() {
    List<String> activityNames = planController.physicalActivitiesList
        .map((activity) => activity.paName)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchableBottomSheet(
        title: 'Physical Activities',
        items: activityNames,
        selectedValue: selectedActivity,
        onSelected: (value) {
          setState(() {
            selectedActivity = value;
          });
        },
        searchHint: 'Search activities...',
      ),
    );
  }

  Widget _buildDurationField() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Duration (in minutes)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF091242),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '5',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaysSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Times a',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF091242),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: dayLabels.map((day) {
            String displayDay = day == 'T2' ? 'T' : (day == 'S2' ? 'S' : day);
            String dayValue = dayMap[day]!;
            bool isSelected = selectedDays.contains(dayValue);

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedDays.remove(dayValue);
                    } else {
                      selectedDays.add(dayValue);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF3F51B5)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3F51B5)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    displayDay,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF091242),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddActivityButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _addActivity,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAddedActivitiesTable() {
    return Obx(() {
      if (planController.otherActivities.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Added Activities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF091242),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Activity',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF091242),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Duration',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF091242),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Frequency',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF091242),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Action',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF091242),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rows
                ...planController.otherActivities.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> activity = entry.value;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              index == planController.otherActivities.length - 1
                                  ? Colors.transparent
                                  : Colors.grey.shade200,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            activity['activity'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF091242),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${activity['duration']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF091242),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            (activity['days'] as List<String>).join(', '),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF091242),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextButton(
                            onPressed: () =>
                                planController.removeOtherActivity(index),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFE53E3E),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              planController.clearPhysicalActivityForm();
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              CustomToast.showSuccess(
                  'Physical activity data saved successfully!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Save changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _addActivity() {
    if (selectedActivity == null || selectedActivity!.isEmpty) {
      CustomToast.showError('Please select an activity');
      return;
    }

    if (_durationController.text.trim().isEmpty) {
      CustomToast.showError('Please enter duration');
      return;
    }

    if (selectedDays.isEmpty) {
      CustomToast.showError('Please select at least one day');
      return;
    }

    final duration = int.tryParse(_durationController.text.trim());
    if (duration == null || duration <= 0) {
      CustomToast.showError('Please enter a valid duration');
      return;
    }

    planController.addOtherActivity(
      selectedActivity!,
      duration,
      selectedDays.toList(),
    );

    // Clear form
    setState(() {
      selectedActivity = null;
      selectedDays.clear();
    });
    _durationController.clear();

    CustomToast.showSuccess('Activity added successfully!');
  }
}
