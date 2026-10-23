# CookMate — Comprehensive Technical Project Report
**Phase 1: Flutter Foundations and UI Mastery | Navigation & Flutter Architecture**

---

### Student Information
- **Student Name:** Subhan Khawaja
- **Registration No:** SEP26-FD22-31
- **Project:** CookMate — Culinary Recipe Application

---

## 1. Executive Summary

**CookMate** is a production-grade, cross-platform culinary recipe application built using Flutter and Dart. Designed to showcase modern software engineering practices, this application implements:
- A responsive layout that adapts across mobile phones, tablets, and desktop/web viewports.
- Declarative navigation with deep linking via **GoRouter**.
- Robust state management with **Provider** (`ChangeNotifier`).
- Persistent offline data storage using **SharedPreferences**.
- Material Design 3 theming featuring dynamic Light and Dark modes.
- Fluid micro-interactions and **Hero animations** between list cards and detail views.
- An interactive cooking checklist and active step guidance.
- A validated multi-field recipe creation form with dynamic ingredient and instruction row management.
- A dataset of **15 gourmet recipes** across three global culinary traditions (**Italian**, **Asian**, and **Mexican**).

This report outlines the technical architecture, design system, routing strategy, data modeling, screen implementations, and verification procedures for the CookMate application.

---

## 2. System Architecture & Software Design

### 2.1 Architectural Pattern
CookMate adopts a **Layered Feature Architecture** following Clean Architecture principles to ensure strict separation of concerns, maintainability, and testability:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   Screens (Home, List, Detail, Search, Favs, Add)      │
│   Reusable Custom Widgets & Responsive Layouts         │
└───────────────────────────▲────────────────────────────┘
                            │
┌───────────────────────────┴────────────────────────────┐
│                    State & Logic Layer                 │
│        RecipeProvider      │      ThemeProvider        │
└───────────────────────────▲────────────────────────────┘
                            │
┌───────────────────────────┴────────────────────────────┐
│                     Data & Domain Layer                │
│    Recipe & Ingredient Models   │  JSON Dataset        │
│    FavoritesService (Local Storage with SharedPreferences)│
└────────────────────────────────────────────────────────┘
```

1. **Presentation Layer (`lib/screens`, `lib/widgets`)**:
   - Contains pure UI components and screen layouts.
   - Decoupled from direct data sources; consumes state via `Provider.of` or `Consumer`.
   - Adapts dynamically to viewport widths using breakpoints.
2. **State & Logic Layer (`lib/providers`)**:
   - `RecipeProvider`: Central state controller managing the master recipe list, active category filters, search queries, sort options, and favorite toggles.
   - `ThemeProvider`: Manages `ThemeMode.light` and `ThemeMode.dark` toggling with persistent preferences.
3. **Data Layer (`lib/data`)**:
   - `models/recipe_model.dart`: Immutable data models with `toMap`, `fromMap`, and `copyWith` utilities.
   - `recipes_data.dart`: 15 recipe entries serialized in JSON format.
   - `services/favorites_service.dart`: Encapsulates local persistence via `SharedPreferences`.

---

## 3. Navigation & Deep Linking Architecture (GoRouter)

Routing is managed declaratively through Flutter's modern **GoRouter** package (`v17+`).

### 3.1 StatefulShellRoute Hierarchy
CookMate implements a `StatefulShellRoute.indexedStack` to preserve the scroll position and state of each main branch when switching tabs:

| Branch Index | Route Path | Screen | Purpose |
|---|---|---|---|
| **0** | `/home` | `HomeScreen` | Featured recipes, category shortcuts, daily tip |
| **1** | `/recipes` | `RecipeListScreen` | Full recipe catalog with sorting & category chips |
| **2** | `/search` | `SearchScreen` | Real-time search query matching with tag chips |
| **3** | `/favorites` | `FavoritesScreen` | Persisted offline favorites list with swipe actions |
| **4** | `/add` | `AddRecipeScreen` | Form to author and validate new recipes |

### 3.2 Deep Linking & URL Parameters
- Individual recipes are accessed via `/recipes/:id` (e.g., `/recipes/rec_1` or `/recipes/rec_7`).
- When a user enters a URL directly in a web browser or triggers an OS deep link, GoRouter parses the `state.pathParameters['id']` and launches the `RecipeDetailScreen` directly.
- If an invalid route or non-existent recipe ID is supplied, GoRouter routes to an `errorBuilder` widget offering a 404 page with a "Return to Home" recovery action.

---

## 4. Material Design 3 Theming & Responsive Design

### 4.1 Color System & Brand Identity
The visual identity of CookMate is built on a culinary palette:
- **Primary Color**: Deep Orange (`#FF5722`) — evokes warmth, appetizing energy, and focus.
- **Secondary Color**: Saffron Amber (`#FF9800`) — accents and ratings.
- **Accent Color**: Fresh Basil Green (`#4CAF50`) — health indicators and checklist completion.
- **Surface & Background**:
  - *Light Theme*: Crisp off-white (`#FBFBFB`) and card surfaces (`#FFFFFF`).
  - *Dark Theme*: Charcoal (`#121212`) and card surfaces (`#262626`).

### 4.2 Responsive Layout Strategy
CookMate adapts to the user's screen dimension using `ResponsiveLayout` breakpoints:
- **Mobile (< 600px)**:
  - Bottom `NavigationBar` with 5 destinations.
  - 1 or 2-column recipe cards.
  - Full-width scrollable detail view.
- **Tablet (600px – 1024px)**:
  - Left-hand `NavigationRail` preserving vertical canvas.
  - 3-column recipe grid.
- **Desktop & Web (> 1024px)**:
  - Extended `NavigationRail`.
  - 4-column recipe grid.
  - Centered detail container constrained to `maxWidth: 800px` for optimal typography hierarchy and readability.

---

## 5. Detailed Screen Implementations

### Screen 1: Home Screen (`/home`)
- **Brand Header**: Culinary icon, CookMate typography, and real-time Dark/Light theme toggle switch.
- **Interactive Search Preview**: Tapping routes immediately to `/search`.
- **Hero Promotional Banner**: "Chef of the Week" banner celebrating handcrafted international cuisines.
- **Category Chips Carousel**: Tap any chip to filter recipes by Italian, Asian, or Mexican.
- **Featured Recipes Carousel**: Horizontal carousel featuring the 4 highest-rated recipes with animated favorite buttons.
- **Chef's Pro Tip Card**: Daily culinary insight card designed to boost user engagement.

### Screen 2: Recipe List Screen (`/recipes`)
- **Category Filter Tabs**: Horizontally scrollable chips allowing instant cuisine switching.
- **Multi-Option Sorting Dropdown**:
  - Top Rated (highest rating first)
  - Quickest (lowest prep + cook time)
  - Lowest Calories
  - A-Z Alphabetical
- **Layout Switcher**: One-tap toggle between responsive multi-column **Grid View** and compact **List View**.
- **Real-Time Counter**: Displays current matching recipe count.

### Screen 3: Recipe Detail Screen (`/recipes/:id`)
- **SliverAppBar with Hero Image**: The recipe's photo smoothly expands from the catalog card using Flutter's `Hero` widget (`tag: recipe-image-${recipe.id}`).
- **Favorite & Share Actions**: Tapping the heart toggles storage in `SharedPreferences`; tapping share provides a formatted link.
- **Specs Summary**: Quick badges for Prep Time, Cook Time, Servings count, and Difficulty level.
- **Nutritional Fact Breakdown**: 4 macro badges for Calories, Protein, Carbs, and Fat.
- **Interactive Ingredients Checklist**: Checkboxes allow the cook to check off ingredients one by one as they prepare the dish.
- **Step-by-Step Instructions**: Interactive step cards with circular indices that highlight when active.
- **Tag Cloud**: Badges showing recipe metadata (e.g., `#Pasta`, `#Street Food`, `#Vegetarian`).

### Screen 4: Live Search Screen (`/search`)
- **Auto-Filtering Input**: Automatically filters matching recipes as the user types across recipe title, category, tags, and ingredient names.
- **Popular Search Chips**: Quick-tap suggestion chips for "Pasta", "Ramen", "Tacos", "Chicken", "Salmon", etc.
- **Empty State**: Custom vector graphic and helpful suggestions when no items match.

### Screen 5: Favorites Screen (`/favorites`)
- **Persistent Storage**: Retains saved recipes between app restarts via `SharedPreferences`.
- **Swipe-to-Dismiss**: Users can swipe left on any saved recipe to remove it with an "Undo" SnackBar option.
- **Badge Counter**: Displays the number of currently saved recipes.
- **Empty State**: Friendly graphic with a direct "Discover Recipes" button leading to the catalog.

### Screen 6: Validated Recipe Submission Form (`/add`)
- **Form Architecture**: Enclosed in a `Form` widget managed by `GlobalKey<FormState>()`.
- **Validation Rules**:
  - *Title*: Required, minimum 3 characters.
  - *Category*: Required selection (Italian, Asian, Mexican).
  - *Description*: Required, minimum 10 characters.
  - *Prep & Cook Time*: Numeric validation, must be positive integers.
  - *Servings & Calories*: Numeric validation, must be greater than zero.
  - *Image URL*: Live image preview thumbnail displayed dynamically upon input.
  - *Ingredients List*: Dynamic form rows where users can add or remove ingredient rows (at least 1 required).
  - *Instructions List*: Dynamic numbered rows where users can add or remove steps (at least 1 required).
- **Publish Flow**: On valid submission, constructs an immutable `Recipe` object, inserts it at index 0 in `RecipeProvider`, displays a celebratory SnackBar, and navigates directly to the new recipe's detail screen.

---

## 6. Local Storage & Data Persistence Architecture

The app uses `shared_preferences` to persist user favorites locally on the device:
1. `FavoritesService` stores a `List<String>` representing unique `recipe.id` values under the key `cookmate_favorite_recipe_ids`.
2. When the app initializes, `RecipeProvider` reads the saved IDs and updates the `isFavorite` flag for all recipes.
3. Every favorite toggle action synchronously updates the in-memory state and asynchronously writes the updated string list to disk.
4. The user's Light/Dark mode preference is likewise stored under `cookmate_theme_mode`.

---

## 7. Curated Recipe Dataset (15 Recipes)

CookMate includes 15 recipes across 3 global categories:

| ID | Title | Category | Total Time | Calories | Difficulty | Rating |
|---|---|---|---|---|---|---|
| `rec_1` | Classic Margherita Pizza | Italian | 32 min | 280 kcal | Medium | 4.9 ⭐ |
| `rec_2` | Creamy Fettuccine Alfredo | Italian | 25 min | 520 kcal | Easy | 4.8 ⭐ |
| `rec_3` | Traditional Bolognese Ragu | Italian | 115 min | 480 kcal | Hard | 4.9 ⭐ |
| `rec_4` | Classic Italian Tiramisu | Italian | 30 min | 360 kcal | Medium | 5.0 ⭐ |
| `rec_5` | Creamy Tuscan Garlic Chicken | Italian | 35 min | 490 kcal | Easy | 4.7 ⭐ |
| `rec_6` | Authentic Chicken Pad Thai | Asian | 35 min | 460 kcal | Medium | 4.9 ⭐ |
| `rec_7` | Rich Japanese Chicken Ramen | Asian | 75 min | 510 kcal | Hard | 4.9 ⭐ |
| `rec_8` | Crispy Teriyaki Salmon | Asian | 27 min | 420 kcal | Easy | 4.8 ⭐ |
| `rec_9` | Thai Green Coconut Curry | Asian | 40 min | 390 kcal | Medium | 4.9 ⭐ |
| `rec_10` | Honey Garlic Asian Chicken | Asian | 30 min | 440 kcal | Easy | 4.8 ⭐ |
| `rec_11` | Sizzling Steak Fajitas | Mexican | 40 min | 480 kcal | Medium | 4.9 ⭐ |
| `rec_12` | Authentic Street Tacos | Mexican | 35 min | 380 kcal | Easy | 5.0 ⭐ |
| `rec_13` | Cheesy Enchiladas Verdes | Mexican | 50 min | 460 kcal | Medium | 4.8 ⭐ |
| `rec_14` | Fresh Guacamole & Chips | Mexican | 15 min | 210 kcal | Easy | 4.9 ⭐ |
| `rec_15` | Slow-Cooked Carnitas Bowl | Mexican | 80 min | 540 kcal | Medium | 4.9 ⭐ |

---

## 8. Verification, Testing & Quality Assurance

1. **Static Analysis**:
   - Command: `flutter analyze`
   - Result: **0 issues found** across all source files.
2. **Automated Unit & State Tests**:
   - Command: `flutter test`
   - Verified JSON data integrity (all 15 recipes, correct categorization, ingredient & step integrity).
   - Verified `RecipeProvider` search query filtering and category filtering.
   - Verified `FavoritesService` toggling and persistence logic.
   - Verified dynamic recipe submission and insertion.
   - Verified `ThemeProvider` mode switching.
   - Result: **All test suites passed (5/5 tests passing)**.
3. **Cross-Platform Web Compilation**:
   - Command: `flutter build web`
   - Result: **Built `build/web` cleanly** in 70.9s without compilation errors.

---

## 9. Conclusion

The **CookMate** project fulfills all requirements of Phase 1: Flutter Foundations and UI Mastery. By pairing strict architectural patterns (Layered Architecture, Provider state management, GoRouter declarative routing) with Material Design 3 aesthetics and persistent offline storage, CookMate provides a complete and engaging cross-platform recipe experience.
