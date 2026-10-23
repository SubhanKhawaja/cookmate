import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/recipe_model.dart';
import '../../providers/recipe_provider.dart';
import '../common/rating_stars.dart';

class RecipeHorizontalCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onRemoveFavorite;

  const RecipeHorizontalCard({
    super.key,
    required this.recipe,
    this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push('/recipes/${recipe.id}');
            },
            child: Row(
              children: [
                // Image
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Hero(
                    tag: 'recipe-image-h-${recipe.id}',
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                recipe.category,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            RatingStars(
                              rating: recipe.rating,
                              iconSize: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recipe.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${recipe.totalTimeMinutes} min',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.local_fire_department_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${recipe.calories} kcal',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Action: Favorite or Remove
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Consumer<RecipeProvider>(
                    builder: (context, provider, _) {
                      return IconButton(
                        icon: Icon(
                          recipe.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: recipe.isFavorite ? AppColors.favoriteRed : Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {
                          if (onRemoveFavorite != null) {
                            onRemoveFavorite!();
                          } else {
                            provider.toggleFavorite(recipe.id);
                          }
                        },
                      );
                    },
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
