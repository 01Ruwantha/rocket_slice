import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';

class ScaffoldWithBottomNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNavBar({super.key, required this.child});
  static final rootScaffoldKey = GlobalKey<ScaffoldState>();

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(RouteNames.cartPath)) {
      return 1;
    }
    if (location.startsWith(RouteNames.favoritesPath)) {
      return 2;
    }
    if (location.startsWith(RouteNames.profilePath)) {
      return 3;
    }
    if (location.startsWith(RouteNames.homePath)) {
      return 0;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
        break;
      case 1:
        context.goNamed(RouteNames.cart);
        break;
      case 2:
        context.goNamed(RouteNames.favorites);
        break;
      case 3:
        context.goNamed(RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      key: rootScaffoldKey,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: isDark ? Colors.white60 : Colors.black54,
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        elevation: 8,
        onTap: (index) => _onItemTapped(index, context),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_pizza_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [const Icon(Icons.shopping_bag_rounded)],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [const Icon(Icons.favorite_rounded)],
            ),
            label: 'Favorites',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
