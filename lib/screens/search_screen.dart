import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/recipes_data.dart';
import '../providers/recipe_provider.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/recipe/category_chip.dart';
import '../widgets/recipe/recipe_horizontal_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _popularTags = [
    'Pasta',
    'Ramen',
    'Tacos',
    'Chicken',
    'Salmon',
    'Curry',
    'Vegetarian',
    'Dessert',
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RecipeProvider>(context, listen: false);
    _controller.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final results = recipeProvider.filteredRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
      ),
      body: SafeArea(
        child: MaxWidthContainer(
          child: Column(
            children: [
              // Search Input Box
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _controller,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Search by title, ingredient, tag...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _controller.clear();
                              recipeProvider.clearSearch();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) {
                    recipeProvider.setSearchQuery(val);
                    setState(() {});
                  },
                ),
              ),

              // Categories Chips Filter
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kCategories.length,
                  itemBuilder: (context, index) {
                    final cat = kCategories[index];
                    return CategoryChip(
                      label: cat,
                      isSelected: recipeProvider.selectedCategory == cat,
                      onTap: () {
                        recipeProvider.setCategory(cat);
                      },
                    );
                  },
                ),
              ),

              // Quick Tag Suggestions
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Searches',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _popularTags.map((tag) {
                          final isSelected = _controller.text.toLowerCase() == tag.toLowerCase();
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                              label: Text(tag),
                              avatar: const Icon(Icons.trending_up_rounded, size: 14),
                              backgroundColor: isSelected
                                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                                  : null,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onPressed: () {
                                _controller.text = tag;
                                recipeProvider.setSearchQuery(tag);
                                setState(() {});
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${results.length} results found',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    if (_controller.text.isNotEmpty || recipeProvider.selectedCategory != 'All')
                      TextButton.icon(
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Reset filters', style: TextStyle(fontSize: 12)),
                        onPressed: () {
                          _controller.clear();
                          recipeProvider.clearSearch();
                          recipeProvider.setCategory('All');
                          setState(() {});
                        },
                      ),
                  ],
                ),
              ),

              // Results list
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 70,
                                color: isDark ? Colors.white24 : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No matching recipes found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try searching for "Pizza", "Chicken", "Tacos" or "Pasta"',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          return RecipeHorizontalCard(recipe: results[index]);
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
