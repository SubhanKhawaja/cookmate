import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../data/models/recipe_model.dart';
import '../data/recipes_data.dart';
import '../data/services/favorites_service.dart';
import '../data/services/rating_service.dart';

enum RecipeSortOption {
  highestRated,
  quickest,
  lowestCalories,
  alphabetical,
}

class RecipeProvider extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();
  final RatingService _ratingService = RatingService();

  List<Recipe> _allRecipes = [];
  Set<String> _favoriteIds = {};
  Map<String, double> _userRatings = {};
  bool _isLoading = true;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  RecipeSortOption _sortOption = RecipeSortOption.highestRated;

  List<Recipe> get allRecipes => _allRecipes;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  RecipeSortOption get sortOption => _sortOption;
  Map<String, double> get userRatings => _userRatings;

  RecipeProvider() {
    _initializeRecipes();
  }

  Future<void> _initializeRecipes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> jsonList = jsonDecode(kRawRecipesJson);
      _allRecipes = jsonList.map((e) => Recipe.fromMap(e as Map<String, dynamic>)).toList();

      _favoriteIds = await _favoritesService.getFavoriteIds();
      _userRatings = await _ratingService.getUserRatings();
      _syncFavorites();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing recipes: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _syncFavorites() {
    _allRecipes = _allRecipes.map((r) {
      return r.copyWith(isFavorite: _favoriteIds.contains(r.id));
    }).toList();
  }

  Recipe? getRecipeById(String id) {
    try {
      return _allRecipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Recipe> get favoriteRecipes {
    return _allRecipes.where((r) => r.isFavorite).toList();
  }

  List<Recipe> get featuredRecipes {
    // Top 4 highest rated recipes
    final list = List<Recipe>.from(_allRecipes);
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list.take(4).toList();
  }

  List<Recipe> get filteredRecipes {
    List<Recipe> list = List<Recipe>.from(_allRecipes);

    // Filter by Category
    if (_selectedCategory != 'All') {
      list = list.where((r) => r.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((r) {
        final inTitle = r.title.toLowerCase().contains(query);
        final inCategory = r.category.toLowerCase().contains(query);
        final inTags = r.tags.any((t) => t.toLowerCase().contains(query));
        final inIngredients = r.ingredients.any((i) => i.name.toLowerCase().contains(query));
        return inTitle || inCategory || inTags || inIngredients;
      }).toList();
    }

    // Apply Sorting
    switch (_sortOption) {
      case RecipeSortOption.highestRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case RecipeSortOption.quickest:
        list.sort((a, b) => a.totalTimeMinutes.compareTo(b.totalTimeMinutes));
        break;
      case RecipeSortOption.lowestCalories:
        list.sort((a, b) => a.calories.compareTo(b.calories));
        break;
      case RecipeSortOption.alphabetical:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return list;
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void setSortOption(RecipeSortOption option) {
    if (_sortOption != option) {
      _sortOption = option;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String recipeId) async {
    final isNowFav = await _favoritesService.toggleFavorite(recipeId);
    if (isNowFav) {
      _favoriteIds.add(recipeId);
    } else {
      _favoriteIds.remove(recipeId);
    }
    _syncFavorites();
    notifyListeners();
  }

  /// Adds a newly submitted recipe from the validated submission form
  void addCustomRecipe(Recipe newRecipe) {
    _allRecipes.insert(0, newRecipe);
    notifyListeners();
  }

  /// Updates an existing recipe in-place, preserving its list position and favorite state
  void updateRecipe(Recipe updatedRecipe) {
    final index = _allRecipes.indexWhere((r) => r.id == updatedRecipe.id);
    if (index != -1) {
      // Preserve favorite state
      final wasFavorite = _favoriteIds.contains(updatedRecipe.id);
      _allRecipes[index] = updatedRecipe.copyWith(isFavorite: wasFavorite);
      notifyListeners();
    }
  }

  /// Returns the rating given by the user for this recipe, or null if unrated
  double? getUserRating(String recipeId) {
    return _userRatings[recipeId];
  }

  /// Rates a recipe, updates the average rating and review count, and persists the choice
  Future<void> rateRecipe(String recipeId, double newRating) async {
    final index = _allRecipes.indexWhere((r) => r.id == recipeId);
    if (index == -1) return;

    final recipe = _allRecipes[index];
    final previousRating = _userRatings[recipeId];

    double updatedRating;
    int updatedReviewsCount = recipe.reviewsCount;

    if (previousRating != null) {
      // User is updating their rating: recalculate the sum minus old rating plus new rating
      if (recipe.reviewsCount > 0) {
        final totalScore = (recipe.rating * recipe.reviewsCount) - previousRating + newRating;
        updatedRating = totalScore / recipe.reviewsCount;
      } else {
        updatedRating = newRating;
        updatedReviewsCount = 1;
      }
    } else {
      // First time rating by this user
      final totalScore = (recipe.rating * recipe.reviewsCount) + newRating;
      updatedReviewsCount = recipe.reviewsCount + 1;
      updatedRating = totalScore / updatedReviewsCount;
    }

    // Clamp between 1.0 and 5.0 and round to 1 decimal place
    updatedRating = (updatedRating * 10).roundToDouble() / 10;
    if (updatedRating > 5.0) updatedRating = 5.0;
    if (updatedRating < 1.0) updatedRating = 1.0;

    _userRatings[recipeId] = newRating;
    await _ratingService.saveUserRating(recipeId, newRating);

    _allRecipes[index] = recipe.copyWith(
      rating: updatedRating,
      reviewsCount: updatedReviewsCount,
    );

    notifyListeners();
  }
}
