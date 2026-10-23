import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../data/models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../widgets/common/nutrition_badge.dart';
import '../widgets/common/rating_stars.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/recipe/rate_recipe_sheet.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // Set of checked ingredient indices for interactive cooking mode
  final Set<int> _checkedIngredients = {};
  int _activeStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipe = recipeProvider.getRecipeById(widget.recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Recipe not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => context.go('/recipes'),
                child: const Text('Back to Recipes'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Hero Header
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            stretch: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/recipes');
                    }
                  },
                ),
              ),
            ),
            actions: [
              // Favorite button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: Icon(
                      recipe.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: recipe.isFavorite ? AppColors.favoriteRed : Colors.white,
                    ),
                    onPressed: () {
                      recipeProvider.toggleFavorite(recipe.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 1200),
                          content: Text(
                            recipe.isFavorite
                                ? 'Removed from favorites'
                                : 'Added to favorites!',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Rate button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: Icon(
                      recipeProvider.getUserRating(recipe.id) != null
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: recipeProvider.getUserRating(recipe.id) != null
                          ? AppColors.ratingStar
                          : Colors.white,
                    ),
                    tooltip: 'Rate Recipe',
                    onPressed: () {
                      RateRecipeSheet.show(context, recipe);
                    },
                  ),
                ),
              ),
              // Edit button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
                    tooltip: 'Edit Recipe',
                    onPressed: () {
                      context.push('/recipes/${recipe.id}/edit');
                    },
                  ),
                ),
              ),
              // Share button
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sharing link: https://cookmate.app/recipes/${recipe.id}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'recipe-image-${recipe.id}',
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.restaurant, size: 60, color: Colors.white54),
                      ),
                    ),
                  ),
                  // Subtle gradient overlay for readibility
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            recipe.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              RateRecipeSheet.show(context, recipe);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingStars(
                                    rating: recipe.rating,
                                    reviewsCount: recipe.reviewsCount,
                                    textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.touch_app_outlined,
                                    size: 13,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recipe Body Content
          SliverToBoxAdapter(
            child: MaxWidthContainer(
              maxWidth: 800,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Description
                    Text(
                      recipe.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.45,
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick Specs Row (Prep, Cook, Servings, Difficulty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF262626) : const Color(0xFFF6F7F9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSpecItem(
                            context,
                            icon: Icons.timer_outlined,
                            label: 'Prep Time',
                            value: '${recipe.prepTimeMinutes} min',
                          ),
                          _buildDivider(context),
                          _buildSpecItem(
                            context,
                            icon: Icons.outdoor_grill_outlined,
                            label: 'Cook Time',
                            value: '${recipe.cookTimeMinutes} min',
                          ),
                          _buildDivider(context),
                          _buildSpecItem(
                            context,
                            icon: Icons.group_outlined,
                            label: 'Servings',
                            value: '${recipe.servings} ppl',
                          ),
                          _buildDivider(context),
                          _buildSpecItem(
                            context,
                            icon: Icons.bar_chart_rounded,
                            label: 'Difficulty',
                            value: recipe.difficulty,
                            valueColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nutritional Overview
                    const Text(
                      'Nutritional Facts (Per Serving)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: NutritionBadge(
                            label: 'Calories',
                            value: '${recipe.calories} kcal',
                            icon: Icons.local_fire_department_rounded,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: NutritionBadge(
                            label: 'Protein',
                            value: '${recipe.protein}g',
                            icon: Icons.fitness_center_rounded,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: NutritionBadge(
                            label: 'Carbs',
                            value: '${recipe.carbs}g',
                            icon: Icons.grain_rounded,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: NutritionBadge(
                            label: 'Fat',
                            value: '${recipe.fat}g',
                            icon: Icons.opacity_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Interactive Ingredients Checklist
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ingredients',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${recipe.ingredients.length} items (${_checkedIngredients.length} checked)',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        if (_checkedIngredients.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _checkedIngredients.clear();
                              });
                            },
                            child: const Text('Reset checklist'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Ingredients List with Checkboxes
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.ingredients.length,
                      itemBuilder: (context, index) {
                        final ing = recipe.ingredients[index];
                        final isChecked = _checkedIngredients.contains(index);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isChecked
                                ? (isDark ? const Color(0xFF1B2E1E) : const Color(0xFFE8F5E9))
                                : (isDark ? const Color(0xFF222222) : const Color(0xFFF9F9FA)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isChecked
                                  ? Colors.green.withValues(alpha: 0.4)
                                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04)),
                            ),
                          ),
                          child: CheckboxListTile(
                            value: isChecked,
                            activeColor: Colors.green,
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            title: Text(
                              ing.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: isChecked ? TextDecoration.lineThrough : null,
                                color: isChecked
                                    ? Colors.grey
                                    : (isDark ? Colors.white : Colors.black87),
                              ),
                            ),
                            subtitle: Text(
                              ing.amount,
                              style: TextStyle(
                                fontSize: 12,
                                color: isChecked
                                    ? Colors.grey.shade600
                                    : AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _checkedIngredients.add(index);
                                } else {
                                  _checkedIngredients.remove(index);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // Step-by-Step Instructions
                    const Text(
                      'Step-by-Step Instructions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.instructions.length,
                      itemBuilder: (context, index) {
                        final stepText = recipe.instructions[index];
                        final isCurrent = _activeStepIndex == index;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _activeStepIndex = index;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AppColors.primary.withValues(alpha: 0.08)
                                  : (isDark ? const Color(0xFF242424) : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isCurrent
                                    ? AppColors.primary
                                    : (isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06)),
                                width: isCurrent ? 1.5 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: isCurrent ? AppColors.primary : Colors.grey.shade400,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    stepText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.45,
                                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // Ratings & Reviews Interactive Section
                    _buildRatingSection(context, recipe, recipeProvider, isDark),

                    const SizedBox(height: 28),

                    // Tags Wrap
                    const Text(
                      'Tags',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recipe.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
    );
  }

  Widget _buildRatingSection(
    BuildContext context,
    Recipe recipe,
    RecipeProvider provider,
    bool isDark,
  ) {
    final userRating = provider.getUserRating(recipe.id);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242424) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rating & Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  RateRecipeSheet.show(context, recipe);
                },
                icon: Icon(
                  userRating != null ? Icons.edit_rounded : Icons.star_rate_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: Text(
                  userRating != null ? 'Edit Rating' : 'Rate Recipe',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Community rating summary
          Row(
            children: [
              Text(
                recipe.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      final starVal = (index + 1).toDouble();
                      return Icon(
                        starVal <= recipe.rating
                            ? Icons.star_rounded
                            : (starVal - 0.5 <= recipe.rating
                                ? Icons.star_half_rounded
                                : Icons.star_outline_rounded),
                        size: 20,
                        color: AppColors.ratingStar,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${recipe.reviewsCount} community ratings',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
          const SizedBox(height: 12),

          // Interactive Quick Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userRating != null ? 'Your Rating:' : 'Rate this recipe:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (userRating != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${userRating.toStringAsFixed(1)} ★ Rated',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // 5 interactive stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = (index + 1).toDouble();
              final isFilled = starValue <= (userRating ?? 0.0);

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await provider.rateRecipe(recipe.id, starValue);
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(milliseconds: 1800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.greenAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text('You rated this recipe ${starValue.toInt()} ★!'),
                        ],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 34,
                    color: isFilled ? AppColors.ratingStar : Colors.grey.shade400,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              userRating != null
                  ? 'Tap any star to update your rating'
                  : 'Tap a star to rate instantly',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
