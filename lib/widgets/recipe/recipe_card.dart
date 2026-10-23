import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/recipe_model.dart';
import '../../providers/recipe_provider.dart';
import '../common/rating_stars.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final double? width;
  final double? height;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push('/recipes/${recipe.id}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section with Hero animation
                Stack(
                  children: [
                    Hero(
                      tag: 'recipe-image-${recipe.id}',
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.restaurant, size: 40, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Category pill
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          recipe.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Consumer<RecipeProvider>(
                        builder: (context, provider, _) {
                          final isFav = recipe.isFavorite;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                provider.toggleFavorite(recipe.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.7)
                                      : Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(scale: anim, child: child),
                                  child: Icon(
                                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    key: ValueKey<bool>(isFav),
                                    size: 20,
                                    color: isFav ? AppColors.favoriteRed : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Card details
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingStars(
                        rating: recipe.rating,
                        reviewsCount: recipe.reviewsCount,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recipe.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 14,
                                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.totalTimeMinutes}m',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.local_fire_department_outlined,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${recipe.calories}cal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(recipe.difficulty).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              recipe.difficulty,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _getDifficultyColor(recipe.difficulty),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green.shade700;
      case 'medium':
        return Colors.orange.shade800;
      case 'hard':
        return Colors.red.shade700;
      default:
        return Colors.blueGrey;
    }
  }
}
