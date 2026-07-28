import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/features/cart/services/cart_provider.dart';
import 'package:rocket_slice/features/drawer/view/app_drawer.dart';
import 'package:rocket_slice/features/favourite/services/favorites_provider.dart';
import 'package:rocket_slice/features/home/view/home_screen.dart';
import 'package:rocket_slice/features/cart/view/cart_screen.dart';
import 'package:rocket_slice/features/favourite/view/favorites_screen.dart';
import 'package:rocket_slice/features/profile/view/profile_screen.dart';

class ScaffoldWithBottomNavBar extends StatefulWidget {
  final Widget? child; // Kept for ShellRoute compatibility, but not used.

  const ScaffoldWithBottomNavBar({super.key, this.child});

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();

  static final GlobalKey<ScaffoldState> rootScaffoldKey =
      GlobalKey<ScaffoldState>();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  late final PageController _pageController;

  // Tracks the last route index we processed – prevents redundant animations.
  int _lastRouteIndex = -1;

  // Flag to ignore onPageChanged events triggered by programmatic scrolling.
  bool _isProgrammaticScroll = false;

  static const List<Widget> _pages = [
    HomeScreen(),
    CartScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  int _indexFromRoute(String location) {
    if (location.startsWith(RouteNames.cartPath)) return 1;
    if (location.startsWith(RouteNames.favoritesPath)) return 2;
    if (location.startsWith(RouteNames.profilePath)) return 3;
    return 0; // home
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Initialize _lastRouteIndex after first build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = GoRouterState.of(context).uri.path;
      _lastRouteIndex = _indexFromRoute(location);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Called when a bottom nav item is tapped.
  void _onItemTapped(int index, BuildContext context) async {
    // Prevent onPageChanged from reacting during programmatic animation.
    _isProgrammaticScroll = true;

    // Animate to the selected page.
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    _isProgrammaticScroll = false;

    // Update the route *and* mark this index as already synced,
    // so the build doesn't schedule another animation.
    if (!context.mounted) return;
    _goToRoute(index, context);
    _lastRouteIndex = index;
  }

  // Called when the user swipes the PageView.
  void _onPageChanged(int index, BuildContext context) {
    // Ignore if this change was caused by programmatic animation.
    if (_isProgrammaticScroll) return;

    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = _indexFromRoute(currentLocation);
    if (index != currentIndex) {
      // Update route and mark as synced.
      _goToRoute(index, context);
      _lastRouteIndex = index;
    }
  }

  void _goToRoute(int index, BuildContext context) {
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

  // Animate the PageView to match an external route change (deep link, back button).
  void _syncToRoute(int routeIndex) {
    if (_pageController.hasClients) {
      final currentPage = _pageController.page?.round() ?? 0;
      if (currentPage != routeIndex && !_isProgrammaticScroll) {
        _isProgrammaticScroll = true;
        _pageController
            .animateToPage(
              routeIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
            .then((_) {
              _isProgrammaticScroll = false;
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String location = GoRouterState.of(context).uri.path;
    final int routeIndex = _indexFromRoute(location);

    // If the route index changed externally (and we haven't synced it yet),
    // schedule an animation after the frame is built.
    if (routeIndex != _lastRouteIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncToRoute(routeIndex);
        _lastRouteIndex = routeIndex; // Prevent repeated calls.
      });
    }

    return Scaffold(
      key: ScaffoldWithBottomNavBar.rootScaffoldKey,
      drawer: const AppDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => _onPageChanged(index, context),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: routeIndex,
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
              children: [
                const Icon(Icons.shopping_bag_rounded),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.favorite_rounded),
                if (favProvider.favoriteIds.isNotEmpty)
                  Positioned(
                    right: -4,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
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
