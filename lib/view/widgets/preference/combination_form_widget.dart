import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class CombinationFormWidget extends StatefulWidget {
  final String selectedFood;
  final String quantity;
  final ValueChanged<String?> onFoodChanged;
  final ValueChanged<String> onQuantityChanged;
  final VoidCallback onAddCombination;
  final List<Map<String, String>> combinations;
  final ValueChanged<int> onDeleteCombination;

  static const List<String> foodOptions = [
    'Masala Karela with vegetable filling recipe',
    'Biryani',
    'Rice Cooked',
    'Tomatoes',
    'Bele bhat powder'
  ];

  const CombinationFormWidget({
    Key? key,
    required this.selectedFood,
    required this.quantity,
    required this.onFoodChanged,
    required this.onQuantityChanged,
    required this.onAddCombination,
    required this.combinations,
    required this.onDeleteCombination,
  }) : super(key: key);

  @override
  State<CombinationFormWidget> createState() => _CombinationFormWidgetState();
}

class _CombinationFormWidgetState extends State<CombinationFormWidget> {
  late TextEditingController _quantityController;

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
            'Combination 1',
            fontSize: 18,
            textColor: const Color(0xFF091242),
          ),
          const SizedBox(height: 12),

          // Food name dropdown
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<String>(
              value: CombinationFormWidget.foodOptions
                      .contains(widget.selectedFood)
                  ? widget.selectedFood
                  : null,
              decoration: const InputDecoration(
                hintText: 'Food name',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              items: CombinationFormWidget.foodOptions.map((String food) {
                return DropdownMenuItem<String>(
                  value: food,
                  child: Text(
                    food,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: widget.onFoodChanged,
              icon:
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
              dropdownColor: Colors.white,
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
              onPressed: widget.onAddCombination,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: SemiBoldText(
                'Add combination',
                fontSize: 16,
                textColor: Colors.white,
              ),
            ),
          ),

          // Combinations List
          if (widget.combinations.isNotEmpty) ...[
            const SizedBox(height: 16),
            SemiBoldText(
              'Combinations',
              fontSize: 18,
              textColor: const Color(0xFF091242),
            ),
            const SizedBox(height: 8),
            ...widget.combinations.asMap().entries.map((entry) {
              final index = entry.key;
              final combination = entry.value;
              return _buildCombinationItem(index, combination);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCombinationItem(int index, Map<String, String> combination) {
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
              // Delete button
              GestureDetector(
                onTap: () => widget.onDeleteCombination(index),
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
