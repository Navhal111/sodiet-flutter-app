import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.grey.shade300;
    final highlightColor = widget.highlightColor ?? Colors.grey.shade100;
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8);

    // Handle infinite width by using Expanded or Flexible
    if (widget.width == double.infinity) {
      return SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    baseColor,
                    highlightColor,
                    baseColor,
                  ],
                  stops: [
                    _animation.value - 0.3,
                    _animation.value,
                    _animation.value + 0.3,
                  ],
                  transform: GradientRotation(0.0),
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  baseColor,
                  highlightColor,
                  baseColor,
                ],
                stops: [
                  _animation.value - 0.3,
                  _animation.value,
                  _animation.value + 0.3,
                ],
                transform: GradientRotation(0.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Predefined shimmer widgets for common use cases
class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerCard({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
          // Title shimmer
          ShimmerLoading(
            width: width * 0.6,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          // Content area shimmer
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: ShimmerLoading(
                width: 100, // Use a reasonable width since it's inside Expanded
                height:
                    100, // Use a reasonable height since it's inside Expanded
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerListItem extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerListItem({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Circle shimmer (like avatar)
          ShimmerLoading(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(width: 12),
          // Content shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerLoading(
                  width: width * 0.6,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                ShimmerLoading(
                  width: width * 0.4,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerChart extends StatelessWidget {
  final double width;
  final double height;
  final String title;

  const ShimmerChart({
    Key? key,
    required this.width,
    required this.height,
    this.title = 'Loading Chart...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoading(
                width: width * 0.4,
                height: 22,
                borderRadius: BorderRadius.circular(4),
              ),
              ShimmerLoading(
                width: 24,
                height: 24,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Legend area
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendShimmer(),
              const SizedBox(width: 16),
              _buildLegendShimmer(),
              const SizedBox(width: 16),
              _buildLegendShimmer(),
              const SizedBox(width: 16),
              _buildLegendShimmer(),
            ],
          ),
          const SizedBox(height: 20),
          // Chart area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Y-axis labels and chart area
                  Expanded(
                    child: Row(
                      children: [
                        // Y-axis
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            5,
                            (index) => ShimmerLoading(
                              width: 30,
                              height: 12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Chart area
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade300,
                            ),
                            child: ShimmerLoading(
                              width:
                                  100, // Use a reasonable width since it's inside Expanded
                              height:
                                  100, // Use a reasonable height since it's inside Expanded
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // X-axis labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      5,
                      (index) => ShimmerLoading(
                        width: 40,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendShimmer() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerLoading(
          width: 12,
          height: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(width: 6),
        ShimmerLoading(
          width: 60,
          height: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class ShimmerCombinationForm extends StatelessWidget {
  final double width;
  final double height;
  final String title;

  const ShimmerCombinationForm({
    Key? key,
    required this.width,
    required this.height,
    this.title = 'Loading Combination...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
          // Combination title
          ShimmerLoading(
            width: width * 0.4,
            height: 18,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),

          // Food items section (reduced to 2 items to save space)
          Expanded(
            child: Column(
              children: [
                // Food item 1
                _buildFoodItemShimmer(width),
                const SizedBox(height: 6),
                // Food item 2
                _buildFoodItemShimmer(width),
                const SizedBox(height: 12),

                // Add food section
                Row(
                  children: [
                    // Dropdown shimmer
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ShimmerLoading(
                          width: 100,
                          height: 36,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Quantity input shimmer
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ShimmerLoading(
                          width: 80,
                          height: 36,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Add button shimmer
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ShimmerLoading(
                        width: 36,
                        height: 36,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItemShimmer(double width) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Food icon shimmer
          ShimmerLoading(
            width: 20,
            height: 20,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(width: 10),
          // Food name and quantity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  width: width * 0.5,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 3),
                ShimmerLoading(
                  width: width * 0.3,
                  height: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          // Delete button shimmer
          ShimmerLoading(
            width: 18,
            height: 18,
            borderRadius: BorderRadius.circular(9),
          ),
        ],
      ),
    );
  }
}
