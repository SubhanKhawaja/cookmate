import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/add_recipe_screen.dart';
import '../../screens/favorites_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/recipe_detail_screen.dart';
import '../../screens/recipe_list_screen.dart';
import '../../screens/search_screen.dart';
import '../../screens/shell_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScreen(navigationShell: navigationShell);
      },
      branches: [
        // 1. Home Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
          ],
        ),

        // 2. Recipe List Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/recipes',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RecipeListScreen(),
              ),
            ),
          ],
        ),

        // 3. Search Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SearchScreen(),
              ),
            ),
          ],
        ),

        // 4. Favorites Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FavoritesScreen(),
              ),
            ),
          ],
        ),

        // 5. Add Recipe Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/add',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AddRecipeScreen(),
              ),
            ),
          ],
        ),
      ],
    ),

    // Recipe Detail Route with deep linking support (/recipes/:id)
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/recipes/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return RecipeDetailScreen(recipeId: id);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page Not Found')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 70, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            'Route "${state.uri.toString()}" Not Found',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Return to Home'),
          ),
        ],
      ),
    ),
  ),
);
