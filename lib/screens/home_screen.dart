import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../data/recipes_data.dart';
import '../providers/recipe_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/recipe/category_chip.dart';
import '../widgets/recipe/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: MaxWidthContainer(
          child: CustomScrollView(
            slivers: [
              // Custom Header Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'CookMate',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'What would you like to cook today?',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                      // Dark / Light Theme Toggle
                      IconButton.filledTonal(
                        onPressed: () {
                          themeProvider.toggleTheme();
                        },
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          size: 20,
                        ),
                        tooltip: 'Toggle Theme',
                      ),
                    ],
                  ),
                ),
              ),

              // Search Trigger Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      context.go('/search');
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF262626) : const Color(0xFFF1F2F4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: theme.colorScheme.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Search recipes, pasta, ramen, tacos...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.tune_rounded,
                            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Hero Promotional Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5722), Color(0xFFFF8A65)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '✨ CHEF OF THE WEEK',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Explore 15 Handcrafted Gourmet Recipes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Authentic Italian, Asian, and Mexican flavors at home.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  context.go('/recipes');
                                },
                                child: const Text(
                                  'Browse Menu',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.ramen_dining_rounded,
                          size: 74,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Categories Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          recipeProvider.setCategory('All');
                          context.go('/recipes');
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories Horizontal List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: kCategories.length,
                    itemBuilder: (context, index) {
                      final category = kCategories[index];
                      return CategoryChip(
                        label: category,
                        isSelected: recipeProvider.selectedCategory == category,
                        onTap: () {
                          recipeProvider.setCategory(category);
                          context.go('/recipes');
                        },
                      );
                    },
                  ),
                ),
              ),

              // Featured Recipes Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Recipes ⭐',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/recipes');
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Recipes Horizontal Carousel
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 290,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: recipeProvider.featuredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipeProvider.featuredRecipes[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: RecipeCard(
                          recipe: recipe,
                          width: 240,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Daily Cooking Tip Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF23251F) : const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chef's Pro Tip",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Always save a cup of starchy pasta water before draining! Emulsifying it with butter or cheese creates a luscious restaurant-grade glaze.",
                                style: TextStyle(fontSize: 13, height: 1.35),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
