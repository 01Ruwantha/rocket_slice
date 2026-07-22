import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rocket_slice/core/widgets/app_bottom_nav_bar.dart';
import 'package:rocket_slice/features/cart/view/cart_screen.dart';
import 'package:rocket_slice/features/favourite/view/favorites_screen.dart';
import 'package:rocket_slice/features/home/view/home_screen.dart';
import 'package:rocket_slice/features/home/view/product_details_screen.dart';
import 'package:rocket_slice/features/profile/view/profile_screen.dart';
import 'package:rocket_slice/features/splash/view/splash_screen.dart';
import 'route_names.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');
  // static final rootScaffoldKey = GlobalKey<ScaffoldState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splashPath,
    routes: [
      // Top-level Splash route
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Shell Route for persistent Bottom Navigation Bar tabs
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: RouteNames.homePath,
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.cartPath,
            name: RouteNames.cart,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: RouteNames.favoritesPath,
            name: RouteNames.favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: RouteNames.profilePath,
            name: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Product Details pushed over root navigator
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.productDetailsPath,
        name: RouteNames.productDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'p1';
          return ProductDetailsScreen(pizzaId: id);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
