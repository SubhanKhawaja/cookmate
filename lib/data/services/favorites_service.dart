import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'cookmate_favorite_recipe_ids';

  /// Loads saved favorite recipe IDs from SharedPreferences
  Future<Set<String>> getFavoriteIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_favoritesKey);
      if (list != null) {
        return list.toSet();
      }
    } catch (e) {
      // In case of any storage error, fallback to empty set
    }
    return <String>{};
  }

  /// Persists the updated set of favorite recipe IDs
  Future<void> saveFavoriteIds(Set<String> favoriteIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, favoriteIds.toList());
    } catch (e) {
      // Handle error gracefully
    }
  }

  /// Toggles favorite status for a recipe and returns true if now favorite
  Future<bool> toggleFavorite(String recipeId) async {
    final currentFavorites = await getFavoriteIds();
    final isFav = currentFavorites.contains(recipeId);
    if (isFav) {
      currentFavorites.remove(recipeId);
    } else {
      currentFavorites.add(recipeId);
    }
    await saveFavoriteIds(currentFavorites);
    return !isFav;
  }
}
