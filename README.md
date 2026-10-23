# 🍳 CookMate — Cross-Platform Flutter Recipe Application

> **Phase 1: Flutter Foundations and UI Mastery**  
> *Navigation, Responsive Design, State Management, and Material Design 3 Architecture*

[![Flutter](https://img.shields.io/badge/Flutter-3.38.3-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.1-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue)](#)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

CookMate is an all-in-one culinary companion mobile, desktop, and web application built with **Flutter**, featuring **GoRouter** declarative routing with deep linking, **Material Design 3** with dynamic light/dark theming, persistent favorites with **SharedPreferences**, animated **Hero** transitions, interactive cooking checklists, and a validated recipe submission form.

---

## 🌟 Key Features

### 1. Multi-Screen Architecture (6 Screens)
- **Home Screen (`/home`)**:
  - Greeting header with culinary brand identity.
  - One-tap light/dark mode switch.
  - Interactive search bar preview.
  - "Chef of the Week" promo hero banner.
  - Quick category selector chips with dynamic icons.
  - Featured high-rated recipes carousel.
  - Daily "Chef's Pro Tip" card.
- **Recipe List Screen (`/recipes`)**:
  - Filter across 3 distinct cuisines (**Italian**, **Asian**, **Mexican**).
  - Multi-criteria sorting: Top Rated, Quickest, Lowest Calories, A-Z Alphabetical.
  - One-touch toggle between responsive multi-column **Grid View** and **List View**.
  - Dynamic result counter.
- **Recipe Detail Screen (`/recipes/:id`)**:
  - Smooth **Hero** image transition from cards.
  - Direct deep linking support via route URL parameters.
  - Persisted favorites toggle with animated feedback.
  - Quick stat pill chips (Prep time, Cook time, Servings, Difficulty).
  - Nutritional facts breakdown (Calories, Protein, Carbs, Fat).
  - **Interactive Ingredients Checklist**: Check off items in real time as you cook.
  - Step-by-step numbered cooking instructions with active step highlighting.
  - Tag chips and share link action.
- **Search Screen (`/search`)**:
  - Live query filtering as the user types (matches title, ingredients, tags, cuisine).
  - Quick popular search chips ("Pasta", "Ramen", "Tacos", "Chicken", "Salmon", etc.).
  - Instant filter reset button and friendly empty state.
- **Favorites Screen (`/favorites`)**:
  - Locally persisted offline storage via `shared_preferences`.
  - Counter badge showing total saved dishes.
  - Swipe-to-dismiss (with Undo action) and remove button.
  - Engaging empty state with "Discover Recipes" call to action.
- **Recipe Submission Form Screen (`/add`)**:
  - Validated form using `GlobalKey<FormState>()`.
  - Field validation: Title (min 3 chars), Category dropdown, Description (min 10 chars), Prep/Cook time (> 0), Servings (> 0), Calories (> 0).
  - Live image URL thumbnail preview.
  - Dynamic interactive ingredients list (add/remove rows).
  - Dynamic interactive instruction steps (add/remove numbered steps).
  - Instantly publishes recipe into state and navigates directly to the new recipe detail screen.

### 2. Modern Theming & Aesthetics (Material Design 3)
- Warm culinary color palette with Deep Orange (`#FF5722`), Amber, and Forest Green accents.
- Seamless Light and Dark modes with saved preferences across sessions.
- Glassmorphic overlays, rounded card elevation, and smooth transitions.

### 3. Responsive Layout
- **Mobile (< 600px)**: Bottom `NavigationBar`, single/two-column cards.
- **Tablet (600px - 1024px)**: Adaptive `NavigationRail`, 3-column recipe grid.
- **Desktop/Web (> 1024px)**: Expanded `NavigationRail`, 4-column recipe grid, centered max-width content containers for optimal readability.

### 4. 15 Curated Recipes across 3 Categories
- **5 Italian Classics**: Classic Margherita Pizza, Creamy Fettuccine Alfredo, Traditional Bolognese Ragu, Classic Italian Tiramisu, Creamy Tuscan Garlic Chicken.
- **5 Asian Delights**: Authentic Chicken Pad Thai, Rich Japanese Chicken Ramen, Crispy Teriyaki Salmon, Thai Green Coconut Curry, Honey Garlic Asian Chicken.
- **5 Mexican & Latin Specialties**: Sizzling Steak Fajitas, Authentic Street Tacos, Cheesy Enchiladas Verdes, Fresh Guacamole & Chips, Slow-Cooked Carnitas Bowl.

---

## 🏗️ Project Architecture

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Color definitions & brand tokens
│   ├── routes/
│   │   └── app_router.dart         # GoRouter with StatefulShellRoute & deep links
│   └── theme/
│       └── app_theme.dart          # Material Design 3 light & dark theme definitions
├── data/
│   ├── models/
│   │   └── recipe_model.dart       # Recipe & Ingredient data models + JSON serialization
│   ├── recipes_data.dart           # Hardcoded JSON data (15 recipes across 3 cuisines)
│   └── services/
│       └── favorites_service.dart  # SharedPreferences service for favorites persistence
├── providers/
│   ├── recipe_provider.dart        # Core ChangeNotifier: search, filter, sort, favorites, add recipe
│   └── theme_provider.dart         # ThemeMode state & persistence
├── widgets/
│   ├── common/
│   │   ├── nutrition_badge.dart    # Nutritional macro badge widget
│   │   ├── rating_stars.dart       # Reusable star rating widget
│   │   └── responsive_layout.dart  # Breakpoints & max-width wrappers
│   └── recipe/
│       ├── category_chip.dart      # Category pill chip with icons
│       ├── recipe_card.dart        # Hero card with favorite animation & stats
│       └── recipe_horizontal_card.dart # Horizontal list card
├── screens/
│   ├── add_recipe_screen.dart      # Validated recipe creation form
│   ├── favorites_screen.dart       # Saved recipes screen with swipe to remove
│   ├── home_screen.dart            # Main dashboard with featured recipes & chef tip
│   ├── recipe_detail_screen.dart   # Interactive detail screen with cooking checklist
│   ├── recipe_list_screen.dart     # Searchable & sortable recipe catalog
│   ├── search_screen.dart          # Live search & popular tags
│   └── shell_screen.dart           # Adaptive NavigationBar / NavigationRail shell
└── main.dart                       # Entry point with MultiProvider & MaterialApp.router
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.10.0 or higher)
- Dart SDK (v3.0.0 or higher)
- Supported browser (Chrome/Edge) or Windows/Android emulator

### Installation & Run
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/cookmate.git
   cd cookmate
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis:
   ```bash
   flutter analyze
   ```

4. Run unit tests:
   ```bash
   flutter test
   ```

5. Launch the application:
   ```bash
   # Run in Chrome / Web
   flutter run -d chrome

   # Run on Windows Desktop
   flutter run -d windows
   ```

---

## 🔗 Deep Linking Guide (GoRouter)

| URL Path | Destination | Description |
|---|---|---|
| `/home` | HomeScreen | Dashboard with featured recipes and tips |
| `/recipes` | RecipeListScreen | Complete recipe catalog with category filters |
| `/recipes/rec_1` | RecipeDetailScreen | Direct deep link to Margherita Pizza |
| `/recipes/rec_7` | RecipeDetailScreen | Direct deep link to Japanese Ramen |
| `/search` | SearchScreen | Live search with tag suggestions |
| `/favorites` | FavoritesScreen | Offline saved favorites list |
| `/add` | AddRecipeScreen | Validated recipe creator form |

---

## 🧪 Testing Suite

Run all test suites with:
```bash
flutter test
```
The test suite validates:
- Complete JSON parsing of all 15 recipes across Italian, Asian, and Mexican categories.
- Real-time search query filtering and category switching in `RecipeProvider`.
- Local favorites toggle and `SharedPreferences` mock persistence.
- Validated custom recipe addition and list update.
- Theme switching between light and dark modes.

---

## 📹 Demo Recording & Submission Checklist

- [x] Complete cross-platform Flutter recipe app called **CookMate**.
- [x] At least 5 screens (6 screens implemented: Home, List, Detail, Search, Favorites, Add Form).
- [x] Custom reusable widgets (`RecipeCard`, `RecipeHorizontalCard`, `CategoryChip`, `NutritionBadge`, `RatingStars`, `ResponsiveLayout`).
- [x] `GoRouter` navigation with deep linking (`/recipes/:id`).
- [x] Material Design 3 theming (Light + Dark modes with custom warm palette).
- [x] Responsive layout (Mobile bottom bar, Tablet/Desktop navigation rail, adaptive grids).
- [x] Smooth animations with `Hero` image transitions.
- [x] Validated recipe submission form.
- [x] Local favorites storage using `shared_preferences`.
- [x] Hardcoded JSON data for 15 recipes across 3 categories.
- [x] Source code ready for GitHub repository.
- [x] Complete 4-5 page report (`PROJECT_REPORT.md`).
- [x] Script to package project into a clean submission ZIP (`create_project_zip.ps1`).
