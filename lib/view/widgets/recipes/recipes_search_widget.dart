import 'package:flutter/material.dart';

class RecipesSearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSubmitted;
  final VoidCallback? onClear;

  const RecipesSearchWidget({
    Key? key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.onSubmitted,
    this.onClear,
  }) : super(key: key);

  @override
  State<RecipesSearchWidget> createState() => _RecipesSearchWidgetState();
}

class _RecipesSearchWidgetState extends State<RecipesSearchWidget> {
  bool _hasText = false;
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_textListener);
    _hasText = widget.controller?.text.isNotEmpty ?? false;
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_textListener);
    super.dispose();
  }

  void _textListener() {
    setState(() {
      _hasText = widget.controller?.text.isNotEmpty ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey.shade500,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: (_) => widget.onSubmitted?.call(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          // Show clear button when there's text
          if (_hasText) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onClear,
              child: Icon(
                Icons.clear,
                color: Colors.grey.shade500,
                size: 20,
              ),
            ),
          ],
          const SizedBox(width: 12),
          GestureDetector(
            onTap: widget.onFilterTap,
            child: Icon(
              Icons.tune,
              color: Colors.grey.shade500,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
