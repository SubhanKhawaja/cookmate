import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/recipes_data.dart';
import '../providers/recipe_provider.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/recipe/category_chip.dart';
import '../widgets/recipe/recipe_card.dart';
import '../widgets/recipe/recipe_horizontal_card.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipes = recipeProvider.filteredRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recipes'),
        actions: [
          IconButton(
            tooltip: _isGridView ? 'Switch to List View' : 'Switch to Grid View',
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: MaxWidthContainer(
          child: Column(
            children: [
              // Categories horizontal list
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: kCategories.length,
                    itemBuilder: (context, index) {
                      final category = kCategories[index];
                      return CategoryChip(
                        label: category,
                        isSelected: recipeProvider.selectedCategory == category,
                        onTap: () {
                          recipeProvider.setCategory(category);
                        },
                      );
                    },
                  ),
                ),
              ),

              // Filter/Sort bar & count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '${recipes.length} ${recipes.length == 1 ? 'recipe' : 'recipes'} found',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF262626) : const Color(0xFFF1F1F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<RecipeSortOption>(
                          value: recipeProvider.sortOption,
                          isDense: true,
                          icon: const Icon(Icons.sort_rounded, size: 18),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: RecipeSortOption.highestRated,
                              child: Text('Top Rated'),
                            ),
                            DropdownMenuItem(
                              value: RecipeSortOption.quickest,
                              child: Text('Quickest'),
                            ),
                            DropdownMenuItem(
                              value: RecipeSortOption.lowestCalories,
                              child: Text('Lowest Calories'),
                            ),
                            DropdownMenuItem(
                              value: RecipeSortOption.alphabetical,
                              child: Text('A-Z Alphabetical'),
                            ),
                          ],
                          onChanged: (option) {
                            if (option != null) {
                              recipeProvider.setSortOption(option);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recipes list or grid
              Expanded(
                child: recipes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No recipes found in this category',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                recipeProvider.setCategory('All');
                              },
                              child: const Text('Show All Recipes'),
                            ),
                          ],
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          int crossAxisCount = 1;
                          if (_isGridView) {
                            if (width >= 1024) {
                              crossAxisCount = 4;
                            } else if (width >= 650) {
                              crossAxisCount = 3;
                            } else if (width >= 400) {
                              crossAxisCount = 2;
                            }
                          }

                          if (!_isGridView) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                return RecipeHorizontalCard(recipe: recipes[index]);
                              },
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 16,
                              childAspectRatio: crossAxisCount == 1 ? 1.05 : 0.76,
                            ),
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              return RecipeCard(recipe: recipes[index]);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
