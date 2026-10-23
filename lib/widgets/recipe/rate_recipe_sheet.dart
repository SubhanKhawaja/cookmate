import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/recipe_model.dart';
import '../../providers/recipe_provider.dart';

/// Modal bottom sheet for rating a recipe with interactive stars and quick feedback tags
class RateRecipeSheet extends StatefulWidget {
  final Recipe recipe;

  const RateRecipeSheet({
    super.key,
    required this.recipe,
  });

  /// Convenient helper method to display the rate recipe bottom sheet
  static Future<void> show(BuildContext context, Recipe recipe) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RateRecipeSheet(recipe: recipe),
    );
  }

  @override
  State<RateRecipeSheet> createState() => _RateRecipeSheetState();
}

class _RateRecipeSheetState extends State<RateRecipeSheet> {
  late double _selectedRating;
  final Set<String> _selectedTags = {};
  bool _isSubmitting = false;

  final List<String> _feedbackOptions = [
    'Delicious taste',
    'Easy to follow',
    'Family favorite',
    'Perfect seasonings',
    'Quick & simple',
    'Restaurant quality',
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RecipeProvider>(context, listen: false);
    final existingRating = provider.getUserRating(widget.recipe.id);
    _selectedRating = existingRating ?? 5.0;
  }

  String _getRatingFeedback(double rating) {
    if (rating >= 5.0) return "Chef's Kiss! Outstanding! 👨‍🍳✨";
    if (rating >= 4.0) return 'Very Good & Delicious! 😋';
    if (rating >= 3.0) return 'Good & Satisfying 🙂';
    if (rating >= 2.0) return 'Fair / Needs Tweaking 😐';
    return 'Poor / Not for me 🙁';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = Provider.of<RecipeProvider>(context);
    final existingRating = provider.getUserRating(widget.recipe.id);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF202020) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            existingRating != null ? 'Update Your Rating' : 'Rate this Recipe',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Recipe Name
          Text(
            widget.recipe.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),

          // Interactive 5 Star Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = (index + 1).toDouble();
              final isFilled = starValue <= _selectedRating;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = starValue;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedScale(
                    scale: isFilled ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 44,
                      color: isFilled ? AppColors.ratingStar : Colors.grey.shade400,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Rating Feedback Label
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _getRatingFeedback(_selectedRating),
              key: ValueKey<double>(_selectedRating),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          if (existingRating != null) ...[
            const SizedBox(height: 6),
            Text(
              'Your previous rating was ${existingRating.toStringAsFixed(1)} ★',
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              ),
            ),
          ],

          const SizedBox(height: 22),

          // Quick Feedback Chips
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'What did you like most? (Optional)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _feedbackOptions.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                selected: isSelected,
                label: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                backgroundColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF2F2F2),
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white12 : Colors.black12),
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Submit & Cancel Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);

                          setState(() {
                            _isSubmitting = true;
                          });

                          await provider.rateRecipe(
                            widget.recipe.id,
                            _selectedRating,
                          );

                          navigator.pop();
                          messenger.showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.greenAccent,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        existingRating != null
                                            ? 'Rating updated to ${_selectedRating.toStringAsFixed(1)} ★!'
                                            : 'Thank you! Rated ${_selectedRating.toStringAsFixed(1)} ★',
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                duration: const Duration(milliseconds: 2000),
                              ),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          existingRating != null ? 'Update Rating' : 'Submit Rating',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
