import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookmate/data/models/recipe_model.dart';
import 'package:cookmate/data/recipes_data.dart';
import 'package:cookmate/providers/recipe_provider.dart';
import 'package:cookmate/providers/theme_provider.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

void main() {
  setUp(() {
    HttpOverrides.global = _TestHttpOverrides();
    SharedPreferences.setMockInitialValues({});
  });

  group('CookMate Recipe Data & Models Test', () {
    test('JSON data contains exactly 15 recipes across 3 categories', () {
      final List<dynamic> jsonList = jsonDecode(kRawRecipesJson);
      expect(jsonList.length, 15);

      final recipes = jsonList.map((e) => Recipe.fromMap(e as Map<String, dynamic>)).toList();
      expect(recipes.length, 15);

      final italian = recipes.where((r) => r.category == 'Italian').toList();
      final asian = recipes.where((r) => r.category == 'Asian').toList();
      final mexican = recipes.where((r) => r.category == 'Mexican').toList();

      expect(italian.length, 5, reason: 'Italian category must have 5 recipes');
      expect(asian.length, 5, reason: 'Asian category must have 5 recipes');
      expect(mexican.length, 5, reason: 'Mexican category must have 5 recipes');

      for (final r in recipes) {
        expect(r.id.isNotEmpty, true);
        expect(r.title.isNotEmpty, true);
        expect(r.imageUrl.isNotEmpty, true);
        expect(r.ingredients.isNotEmpty, true);
        expect(r.instructions.isNotEmpty, true);
        expect(r.calories > 0, true);
        expect(r.rating >= 4.0, true);
      }
    });

    test('RecipeProvider loads recipes and filters properly', () async {
      final provider = RecipeProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(provider.allRecipes.length, 15);
      expect(provider.featuredRecipes.length, 4);

      // Test Category Filtering
      provider.setCategory('Italian');
      expect(provider.filteredRecipes.length, 5);
      expect(provider.filteredRecipes.every((r) => r.category == 'Italian'), true);

      provider.setCategory('Asian');
      expect(provider.filteredRecipes.length, 5);
      expect(provider.filteredRecipes.every((r) => r.category == 'Asian'), true);

      // Test Search Query
      provider.setCategory('All');
      provider.setSearchQuery('Pizza');
      expect(provider.filteredRecipes.length, 1);
      expect(provider.filteredRecipes.first.title.contains('Pizza'), true);

      provider.clearSearch();
      expect(provider.filteredRecipes.length, 15);
    });

    test('RecipeProvider favorites toggle and persist', () async {
      final provider = RecipeProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(provider.favoriteRecipes.isEmpty, true);

      // Toggle favorite on first recipe
      final firstId = provider.allRecipes.first.id;
      await provider.toggleFavorite(firstId);

      expect(provider.favoriteRecipes.length, 1);
      expect(provider.favoriteRecipes.first.id, firstId);

      // Toggle off
      await provider.toggleFavorite(firstId);
      expect(provider.favoriteRecipes.isEmpty, true);
    });

    test('RecipeProvider allows adding custom validated recipe', () async {
      final provider = RecipeProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      final custom = Recipe(
        id: 'custom_test_1',
        title: 'Custom Garlic Pasta',
        category: 'Italian',
        imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3d5d62816e8',
        description: 'A custom delicious pasta dish.',
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        servings: 2,
        difficulty: 'Easy',
        rating: 5.0,
        reviewsCount: 1,
        calories: 380,
        protein: 10,
        carbs: 45,
        fat: 12,
        ingredients: [
          const Ingredient(name: 'Pasta', amount: '200g'),
          const Ingredient(name: 'Garlic', amount: '3 cloves'),
        ],
        instructions: ['Boil pasta', 'Sauté garlic', 'Combine'],
        tags: ['Quick', 'Custom'],
      );

      provider.addCustomRecipe(custom);
      expect(provider.allRecipes.length, 16);
      expect(provider.allRecipes.first.id, 'custom_test_1');
    });

    test('ThemeProvider toggles light and dark modes', () async {
      final themeProvider = ThemeProvider();
      expect(themeProvider.isDarkMode, false);

      await themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, true);

      await themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, false);
    });
  });
}
