import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  String selectedOption = 'All';
  bool viewTwoDays = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> options = [
    'All',
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              showBackButton: true,
              title: 'Meal Plan',
              onBackTap: () => Get.back(),
              onNotificationTap: () {},
              onProfileTap: () {},
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    TitleSectionWidget(
                      imagePath: 'assets/images/plan.png',
                      title: 'Weekly Meal Plan',
                      description:
                          'Plan your meals for the week to maintain a balanced diet and achieve your fitness goals.',
                    ),

                    // Day Selection Section
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Option Selection (All, Saturday, Sunday, etc.)
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options[index];
                                final isSelected = option == selectedOption;

                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = option;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2)
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: SemiBoldText(
                                          option,
                                          fontSize: 14,
                                          textColor: isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // View 2 days checkbox
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    viewTwoDays = !viewTwoDays;
                                  });
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: viewTwoDays
                                        ? const Color(0xFFA8D8A8)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: viewTwoDays
                                          ? const Color(0xFFA8D8A8)
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: viewTwoDays
                                      ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.black,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              RegularText(
                                'View 2 days',
                                fontSize: 14,
                                textColor: Colors.grey.shade600,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Search recipe field
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search recipe',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Meal Plan Content - Simple day format
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                          // Saturday
                          _buildDaySection('Saturday'),
                          const SizedBox(height: 18),
                          // Sunday
                          _buildDaySection('Sunday'),
                          const SizedBox(height: 18),
                          // Monday
                          _buildDaySection('Monday'),
                          const SizedBox(height: 18),
                          // Tuesday
                          _buildDaySection('Tuesday'),
                          const SizedBox(height: 18),
                          // Wednesday
                          _buildDaySection('Wednesday'),
                          const SizedBox(height: 18),
                          // Thursday
                          _buildDaySection('Thursday'),
                          const SizedBox(height: 18),
                          // Friday
                          _buildDaySection('Friday'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySection(String day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day title
        SemiBoldText(
          day,
          fontSize: 18,
          textColor: const Color(0xFF091242),
        ),
        const SizedBox(height: 12),

        // Meal items for the day
        _buildMealItem(
          'assets/images/food/food1.png', // You can use your existing food images
          'Masala Karela',
          '1 Tbsp',
          '15.2gms',
        ),
        _buildMealItem(
          'assets/images/food/food2.png',
          'Biryani',
          '2.0 Number',
          '39.3gms',
        ),
      ],
    );
  }

  Widget _buildMealItem(
      String imagePath, String foodName, String quantity, String weight) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF8F8F8), // Light gray background like in screenshot
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Food image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey.shade400,
                      size: 25,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Food details
          Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SemiBoldText(
                      foodName,
                      fontSize: 16,
                      textColor: const Color(0xFF091242),
                    ),
                    const SizedBox(height: 15),
                    RegularText(
                      quantity,
                      fontSize: 14,
                      textColor: Colors.grey.shade600,
                    ),
                  ],
                )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle remove item
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                RegularText(
                  weight,
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
            // Weight and remove button
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(
    String mealType,
    String time,
    List<String> items,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: backgroundColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SemiBoldText(
                mealType,
                fontSize: 16,
                textColor: const Color(0xFF091242),
              ),
              RegularText(
                time,
                fontSize: 12,
                textColor: Colors.grey.shade600,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RegularText(
                        item,
                        fontSize: 14,
                        textColor: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
