class Ingredient {
  final String name;
  final String amount;

  const Ingredient({
    required this.name,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] ?? '',
      amount: map['amount'] ?? '',
    );
  }
}

class Recipe {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String description;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty; // Easy, Medium, Hard
  final double rating;
  final int reviewsCount;
  final int calories;
  final int protein; // grams
  final int carbs; // grams
  final int fat; // grams
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final List<String> tags;
  final bool isFavorite;
  final bool isCustom;

  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.rating,
    required this.reviewsCount,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    this.isFavorite = false,
    this.isCustom = false,
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  Recipe copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    String? description,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    int? servings,
    String? difficulty,
    double? rating,
    int? reviewsCount,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    List<String>? tags,
    bool? isFavorite,
    bool? isCustom,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'instructions': instructions,
      'tags': tags,
      'isFavorite': isFavorite,
      'isCustom': isCustom,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      prepTimeMinutes: (map['prepTimeMinutes'] as num?)?.toInt() ?? 0,
      cookTimeMinutes: (map['cookTimeMinutes'] as num?)?.toInt() ?? 0,
      servings: (map['servings'] as num?)?.toInt() ?? 1,
      difficulty: map['difficulty'] ?? 'Easy',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      reviewsCount: (map['reviewsCount'] as num?)?.toInt() ?? 0,
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      protein: (map['protein'] as num?)?.toInt() ?? 0,
      carbs: (map['carbs'] as num?)?.toInt() ?? 0,
      fat: (map['fat'] as num?)?.toInt() ?? 0,
      ingredients: (map['ingredients'] as List<dynamic>?)
              ?.map((x) => Ingredient.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      instructions: List<String>.from(map['instructions'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      isFavorite: map['isFavorite'] ?? false,
      isCustom: map['isCustom'] ?? false,
    );
  }
}
