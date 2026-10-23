import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'italian':
        return Icons.local_pizza_outlined;
      case 'asian':
        return Icons.ramen_dining_outlined;
      case 'mexican':
        return Icons.dinner_dining_outlined;
      default:
        return Icons.restaurant_menu_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F2)),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCategoryIcon(label),
                  size: 18,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey.shade300 : Colors.black87),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey.shade300 : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
