import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/searchable_bottom_sheet.dart';

class CombinationFormWidget extends StatefulWidget {
  final String selectedFood;
  final String quantity;
  final ValueChanged<String?> onFoodChanged;
  final ValueChanged<String> onQuantityChanged;
  final VoidCallback onAddCombination;
  final List<Map<String, String>> combinations;
  final ValueChanged<int> onDeleteCombination;
  final List<String>? availableFoods;
  final bool isApiCombination;
  final String? combinationTitle;

  const CombinationFormWidget({
    Key? key,
    required this.selectedFood,
    required this.quantity,
    required this.onFoodChanged,
    required this.onQuantityChanged,
    required this.onAddCombination,
    required this.combinations,
    required this.onDeleteCombination,
    this.availableFoods,
    this.isApiCombination = false,
    this.combinationTitle,
  }) : super(key: key);

  @override
  State<CombinationFormWidget> createState() => _CombinationFormWidgetState();
}

class _CombinationFormWidgetState extends State<CombinationFormWidget> {
  late TextEditingController _quantityController;
  String _selectedFood = '';
  List<Map<String, String>> _userAddedFoods = [];

  List<String> get foodOptions {
    return widget.availableFoods ?? [];
  }

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.quantity);
  }

  @override
  void didUpdateWidget(CombinationFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _quantityController.text = widget.quantity;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          SemiBoldText(
            widget.combinationTitle ?? 'Combination 1',
            fontSize: 18,
            textColor: const Color(0xFF091242),
          ),
          const SizedBox(height: 12),

          // Only show form fields for user combinations, not API combinations
          if (!widget.isApiCombination) ...[
            // Food name dropdown/selector
            GestureDetector(
              onTap: () {
                if (foodOptions.isNotEmpty) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => SearchableBottomSheet(
                      title: 'Select Food',
                      items: foodOptions,
                      selectedValue:
                          _selectedFood.isNotEmpty ? _selectedFood : null,
                      onSelected: (String? selectedValue) {
                        setState(() {
                          _selectedFood = selectedValue ?? '';
                        });
                        widget.onFoodChanged(selectedValue);
                      },
                      searchHint: 'Search foods...',
                    ),
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedFood.isNotEmpty
                            ? _selectedFood
                            : 'Select food name',
                        style: TextStyle(
                          fontSize: 14,
                          color: _selectedFood.isNotEmpty
                              ? const Color(0xFF091242)
                              : Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Quantity field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _quantityController,
                onChanged: widget.onQuantityChanged,
                decoration: const InputDecoration(
                  hintText: 'Quantity',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Add combination button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedFood.isNotEmpty &&
                      _quantityController.text.isNotEmpty) {
                    setState(() {
                      _userAddedFoods.add({
                        'mealType':
                            'Current', // You can get this from parent if needed
                        'food': _selectedFood,
                        'quantity': _quantityController.text,
                      });
                      _selectedFood = '';
                      _quantityController.clear();
                    });
                    widget.onAddCombination(); // Call parent callback if needed
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: SemiBoldText(
                  'Add Food',
                  fontSize: 16,
                  textColor: Colors.white,
                ),
              ),
            ),
          ],

          // Foods List (API foods + user added foods)
          Builder(builder: (context) {
            final allFoods = [...widget.combinations, ..._userAddedFoods];
            if (allFoods.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SemiBoldText(
                    'Foods',
                    fontSize: 18,
                    textColor: const Color(0xFF091242),
                  ),
                  const SizedBox(height: 8),
                  ...allFoods.asMap().entries.map((entry) {
                    final index = entry.key;
                    final combination = entry.value;
                    final isUserAdded = index >= widget.combinations.length;
                    return _buildCombinationItem(
                        index, combination, isUserAdded);
                  }).toList(),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildCombinationItem(int index, Map<String, String> combination,
      [bool isUserAdded = false]) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            children: [
              // Index number
              SemiBoldText(
                '${index + 1}',
                fontSize: 16,
                textColor: const Color(0xFF091242),
              ),
              const SizedBox(width: 8),
              Text(
                '-',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              // Food and quantity
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${combination['food']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF091242),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      if (combination['quantity']?.isNotEmpty == true)
                        TextSpan(
                          text: ' (${combination['quantity']})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Delete button - show for user-added foods or non-API combinations
              if (isUserAdded || !widget.isApiCombination)
                GestureDetector(
                  onTap: () {
                    if (isUserAdded) {
                      // Delete from local user-added foods
                      setState(() {
                        final userIndex = index - widget.combinations.length;
                        if (userIndex >= 0 &&
                            userIndex < _userAddedFoods.length) {
                          _userAddedFoods.removeAt(userIndex);
                        }
                      });
                    } else {
                      // Call parent callback for API combinations
                      widget.onDeleteCombination(index);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade400,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Separator line (except for last item)
        if (index < widget.combinations.length - 1)
          Container(
            height: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
      ],
    );
  }
}
