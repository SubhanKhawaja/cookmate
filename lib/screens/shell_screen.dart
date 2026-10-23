import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../widgets/common/responsive_layout.dart';

class ShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScreen({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isMobile) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu_rounded),
              label: 'Recipes',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_rounded),
              selectedIcon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline_rounded),
              selectedIcon: Icon(Icons.add_circle_rounded),
              label: 'Add',
            ),
          ],
        ),
      );
    }

    // Tablet & Desktop: NavigationRail
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            indicatorColor: AppColors.primary.withValues(alpha: 0.15),
            selectedIconTheme: const IconThemeData(color: AppColors.primary),
            selectedLabelTextStyle: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                selectedIcon: Icon(Icons.restaurant_menu_rounded),
                label: Text('Recipes'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search_rounded),
                selectedIcon: Icon(Icons.search_rounded),
                label: Text('Search'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border_rounded),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: Text('Favorites'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_circle_outline_rounded),
                selectedIcon: Icon(Icons.add_circle_rounded),
                label: Text('Add Recipe'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
