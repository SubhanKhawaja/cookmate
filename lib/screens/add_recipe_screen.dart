import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../data/models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../widgets/common/responsive_layout.dart';

class AddRecipeScreen extends StatefulWidget {
  /// If provided, the screen operates in "edit" mode and pre-fills all fields.
  final Recipe? existingRecipe;

  const AddRecipeScreen({super.key, this.existingRecipe});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _prepTimeController;
  late final TextEditingController _cookTimeController;
  late final TextEditingController _servingsController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _tagsController;

  late String _selectedCategory;
  late String _selectedDifficulty;

  // Dynamic ingredients list
  late final List<Map<String, TextEditingController>> _ingredientControllers;

  // Dynamic steps list
  late final List<TextEditingController> _stepControllers;

  bool _isSubmitting = false;

  /// Whether this screen is editing an existing recipe
  bool get _isEditing => widget.existingRecipe != null;

  @override
  void initState() {
    super.initState();
    final recipe = widget.existingRecipe;

    if (recipe != null) {
      // --- Edit mode: pre-fill from existing recipe ---
      _titleController = TextEditingController(text: recipe.title);
      _descController = TextEditingController(text: recipe.description);
      _imageUrlController = TextEditingController(text: recipe.imageUrl);
      _prepTimeController = TextEditingController(text: recipe.prepTimeMinutes.toString());
      _cookTimeController = TextEditingController(text: recipe.cookTimeMinutes.toString());
      _servingsController = TextEditingController(text: recipe.servings.toString());
      _caloriesController = TextEditingController(text: recipe.calories.toString());
      _tagsController = TextEditingController(text: recipe.tags.join(', '));
      _selectedCategory = recipe.category;
      _selectedDifficulty = recipe.difficulty;

      _ingredientControllers = recipe.ingredients.map((ing) {
        return {
          'name': TextEditingController(text: ing.name),
          'amount': TextEditingController(text: ing.amount),
        };
      }).toList();

      _stepControllers = recipe.instructions.map((step) {
        return TextEditingController(text: step);
      }).toList();
    } else {
      // --- Add mode: defaults ---
      _titleController = TextEditingController();
      _descController = TextEditingController();
      _imageUrlController = TextEditingController();
      _prepTimeController = TextEditingController(text: '15');
      _cookTimeController = TextEditingController(text: '20');
      _servingsController = TextEditingController(text: '4');
      _caloriesController = TextEditingController(text: '350');
      _tagsController = TextEditingController(text: 'Homemade, Fresh, Delicious');
      _selectedCategory = 'Italian';
      _selectedDifficulty = 'Easy';

      _ingredientControllers = [
        {
          'name': TextEditingController(text: 'Olive oil'),
          'amount': TextEditingController(text: '2 tbsp'),
        },
        {
          'name': TextEditingController(text: 'Garlic cloves, minced'),
          'amount': TextEditingController(text: '3 cloves'),
        },
      ];

      _stepControllers = [
        TextEditingController(text: 'Prepare all fresh ingredients and preheat the pan over medium heat.'),
        TextEditingController(text: 'Cook thoroughly until golden brown and season with salt and pepper to taste.'),
      ];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _caloriesController.dispose();
    _tagsController.dispose();
    for (final map in _ingredientControllers) {
      map['name']?.dispose();
      map['amount']?.dispose();
    }
    for (final ctrl in _stepControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _addIngredientRow() {
    setState(() {
      _ingredientControllers.add({
        'name': TextEditingController(),
        'amount': TextEditingController(),
      });
    });
  }

  void _removeIngredientRow(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        final removed = _ingredientControllers.removeAt(index);
        removed['name']?.dispose();
        removed['amount']?.dispose();
      });
    }
  }

  void _addStepRow() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStepRow(int index) {
    if (_stepControllers.length > 1) {
      setState(() {
        final removed = _stepControllers.removeAt(index);
        removed.dispose();
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form before submitting.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final recipeId = _isEditing
        ? widget.existingRecipe!.id
        : 'custom_${DateTime.now().millisecondsSinceEpoch}';

    // Parse ingredients
    final ingredients = _ingredientControllers.map((m) {
      return Ingredient(
        name: m['name']!.text.trim(),
        amount: m['amount']!.text.trim().isEmpty ? 'as needed' : m['amount']!.text.trim(),
      );
    }).toList();

    // Parse steps
    final steps = _stepControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Parse tags
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    // Default image if empty
    String imageUrl = _imageUrlController.text.trim();
    if (imageUrl.isEmpty) {
      imageUrl = _selectedCategory == 'Italian'
          ? 'https://images.unsplash.com/photo-1546549032-9571cd6b27df?w=800&auto=format&fit=crop&q=80'
          : _selectedCategory == 'Asian'
              ? 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800&auto=format&fit=crop&q=80'
              : 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800&auto=format&fit=crop&q=80';
    }

    // Preserve original rating/reviews in edit mode, use defaults for add mode
    final rating = _isEditing ? widget.existingRecipe!.rating : 5.0;
    final reviewsCount = _isEditing ? widget.existingRecipe!.reviewsCount : 1;
    final protein = _isEditing ? widget.existingRecipe!.protein : 25;
    final carbs = _isEditing ? widget.existingRecipe!.carbs : 35;
    final fat = _isEditing ? widget.existingRecipe!.fat : 15;

    final recipe = Recipe(
      id: recipeId,
      title: _titleController.text.trim(),
      category: _selectedCategory,
      imageUrl: imageUrl,
      description: _descController.text.trim(),
      prepTimeMinutes: int.tryParse(_prepTimeController.text) ?? 15,
      cookTimeMinutes: int.tryParse(_cookTimeController.text) ?? 20,
      servings: int.tryParse(_servingsController.text) ?? 4,
      difficulty: _selectedDifficulty,
      rating: rating,
      reviewsCount: reviewsCount,
      calories: int.tryParse(_caloriesController.text) ?? 400,
      protein: protein,
      carbs: carbs,
      fat: fat,
      ingredients: ingredients,
      instructions: steps,
      tags: tags,
      isCustom: true,
      isFavorite: false,
    );

    final provider = Provider.of<RecipeProvider>(context, listen: false);

    if (_isEditing) {
      provider.updateRecipe(recipe);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade700,
          content: Text('✅ Recipe "${recipe.title}" updated successfully!'),
        ),
      );
    } else {
      provider.addCustomRecipe(recipe);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade700,
          content: Text('🎉 Recipe "${recipe.title}" added successfully!'),
        ),
      );
    }

    // Navigate to the recipe detail page
    context.go('/recipes/$recipeId');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Recipe' : 'Add New Recipe'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(_isEditing ? '/recipes/${widget.existingRecipe!.id}' : '/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: MaxWidthContainer(
          maxWidth: 800,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Header badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (_isEditing ? Colors.blue : AppColors.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (_isEditing ? Colors.blue : AppColors.primary).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isEditing ? Icons.edit_note_rounded : Icons.menu_book_rounded,
                        color: _isEditing ? Colors.blue : AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditing
                                  ? 'Edit Your Recipe'
                                  : 'Share Your Culinary Masterpiece',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isEditing
                                  ? 'Update any details below and save your changes.'
                                  : 'Fill out this validated form to publish your recipe into CookMate.',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 1. Recipe Title
                const Text('Recipe Title *', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Homemade Tuscan Garlic Bread',
                    prefixIcon: Icon(Icons.drive_file_rename_outline_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Recipe title is required.';
                    }
                    if (value.trim().length < 3) {
                      return 'Title must be at least 3 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // 2. Category & Difficulty Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Category *', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: 'Italian', child: Text('Italian')),
                              DropdownMenuItem(value: 'Asian', child: Text('Asian')),
                              DropdownMenuItem(value: 'Mexican', child: Text('Mexican')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedDifficulty,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                              DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                              DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedDifficulty = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 3. Description
                const Text('Description *', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Describe flavors, texture, aroma, or serving recommendations...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write a brief description.';
                    }
                    if (value.trim().length < 10) {
                      return 'Description should be at least 10 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // 4. Time, Servings & Calories Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Prep (min) *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _prepTimeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '15'),
                            validator: (val) {
                              final num = int.tryParse(val ?? '');
                              if (num == null || num <= 0) return '> 0 min';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cook (min) *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _cookTimeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '20'),
                            validator: (val) {
                              final num = int.tryParse(val ?? '');
                              if (num == null || num < 0) return '>= 0 min';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Servings *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _servingsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '4'),
                            validator: (val) {
                              final num = int.tryParse(val ?? '');
                              if (num == null || num <= 0) return '> 0';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Calories *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _caloriesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '350'),
                            validator: (val) {
                              final num = int.tryParse(val ?? '');
                              if (num == null || num <= 0) return '> 0 kcal';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 5. Image URL (with real-time thumbnail preview)
                const Text('Image URL (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    hintText: 'https://images.unsplash.com/...',
                    prefixIcon: const Icon(Icons.image_outlined),
                    suffixIcon: _imageUrlController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _imageUrlController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                if (_imageUrlController.text.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrlController.text.trim(),
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 60,
                        color: Colors.red.withValues(alpha: 0.1),
                        alignment: Alignment.center,
                        child: const Text('Invalid image URL preview', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // 6. Ingredients Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ingredients Checklist *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Item'),
                      onPressed: _addIngredientRow,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...List.generate(_ingredientControllers.length, (index) {
                  final row = _ingredientControllers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: row['name'],
                            decoration: InputDecoration(
                              hintText: 'Ingredient ${index + 1} (e.g. Olive oil)',
                              isDense: true,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Enter ingredient';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: row['amount'],
                            decoration: InputDecoration(
                              hintText: 'Amount (e.g. 2 tbsp)',
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent),
                          onPressed: () => _removeIngredientRow(index),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // 7. Instructions Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Instructions Steps *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Step'),
                      onPressed: _addStepRow,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...List.generate(_stepControllers.length, (index) {
                  final ctrl = _stepControllers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primary,
                          child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: ctrl,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Step ${index + 1} instructions...',
                              isDense: true,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Step description required';
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                          onPressed: () => _removeStepRow(index),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 18),

                // 8. Tags
                const Text('Tags (comma separated)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Quick, Vegetarian, Dinner, High Protein',
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_isEditing ? Icons.save_rounded : Icons.check_circle_outline_rounded),
                              const SizedBox(width: 8),
                              Text(
                                _isEditing ? 'Save Changes' : 'Submit & Publish Recipe',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
