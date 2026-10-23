import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static const String _ratingsKey = 'cookmate_user_recipe_ratings';

  /// Loads all saved user ratings as a Map of recipeId -> rating
  Future<Map<String, double>> getUserRatings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_ratingsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
      }
    } catch (_) {
      // In case of error, fallback to empty map
    }
    return <String, double>{};
  }

  /// Persists a user's rating for a given recipe
  Future<void> saveUserRating(String recipeId, double rating) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ratings = await getUserRatings();
      ratings[recipeId] = rating;
      await prefs.setString(_ratingsKey, jsonEncode(ratings));
    } catch (_) {
      // Gracefully handle persistence error
    }
  }

  /// Retrieves user rating for a specific recipe, or null if not yet rated
  Future<double?> getUserRating(String recipeId) async {
    final ratings = await getUserRatings();
    return ratings[recipeId];
  }
}
