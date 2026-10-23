import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/recipe_provider.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/recipe/recipe_card.dart';
import '../widgets/recipe/recipe_horizontal_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favorites = recipeProvider.favoriteRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        actions: [
          if (favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.favoriteRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${favorites.length} saved',
                    style: const TextStyle(
                      color: AppColors.favoriteRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: MaxWidthContainer(
          child: favorites.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            size: 72,
                            color: AppColors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No Favorites Yet',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tap the heart icon on any recipe card to save your favorite dishes here for quick access offline.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.75),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.go('/recipes');
                          },
                          icon: const Icon(Icons.explore_rounded),
                          label: const Text('Discover Recipes'),
                        ),
                      ],
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    if (width >= 700) {
                      // Grid layout on larger screens
                      final crossAxis = width >= 1024 ? 4 : (width >= 700 ? 3 : 2);
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxis,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.76,
                        ),
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          return RecipeCard(recipe: favorites[index]);
                        },
                      );
                    }

                    // List layout on phone screens
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final recipe = favorites[index];
                        return Dismissible(
                          key: Key('fav-${recipe.id}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
                                SizedBox(width: 8),
                                Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (_) {
                            recipeProvider.toggleFavorite(recipe.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Removed "${recipe.title}" from favorites'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    recipeProvider.toggleFavorite(recipe.id);
                                  },
                                ),
                              ),
                            );
                          },
                          child: RecipeHorizontalCard(
                            recipe: recipe,
                            onRemoveFavorite: () {
                              recipeProvider.toggleFavorite(recipe.id);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
