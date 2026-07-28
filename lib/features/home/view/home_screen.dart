import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/services/theme_provider.dart';
import 'package:rocket_slice/core/widgets/app_bottom_nav_bar.dart';
import 'package:rocket_slice/features/cart/services/cart_provider.dart';
import 'package:rocket_slice/features/favourite/services/favorites_provider.dart';
import 'package:rocket_slice/features/home/services/pizza_provider.dart';
import 'package:rocket_slice/features/home/services/promo_provider.dart';
import 'package:rocket_slice/features/home/widgets/build_pizza_card.dart';
import 'package:rocket_slice/features/home/widgets/categories_selector.dart';
import 'package:rocket_slice/features/home/widgets/pizza_card_skeleton.dart';
import 'package:rocket_slice/features/home/widgets/promotional_banner.dart';
import 'package:rocket_slice/features/profile/services/profile_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final pizzaProvider = Provider.of<PizzaProvider>(context);
    final promoProvider = Provider.of<PromoProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    final filteredPizzas = pizzaProvider.filteredPizzas;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (drawerContext) => IconButton(
            icon: const Icon(Icons.menu_rounded, size: 28),
            onPressed: () {
              ScaffoldWithBottomNavBar.rootScaffoldKey.currentState
                  ?.openDrawer();
            },
            tooltip: 'Open Menu',
          ),
        ),
        title: GestureDetector(
          onTap: () {
            context.pushNamed(RouteNames.profile);
          },
          child: Column(
            children: [
              Text(
                'DELIVER TO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
                ),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        profileProvider.deliveryAddress,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 12.0,
            ), // Add spacing from edge
            child: GestureDetector(
              onTap: () {
                context.goNamed(RouteNames.profile);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 20, // Adjust if you want smaller (e.g., 20)
                  backgroundColor: AppTheme.secondaryColor,
                  backgroundImage: profileProvider.profileImagePath != null
                      ? FileImage(File(profileProvider.profileImagePath!))
                      : null,
                  child: profileProvider.profileImagePath == null
                      ? Text(
                          profileProvider.selectedAvatarEmoji,
                          style: const TextStyle(fontSize: 28),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pizzaProvider.refreshPizzas();
          promoProvider.refresh();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search & Filter Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) =>
                            pizzaProvider.setSearchQuery(value),
                        decoration: InputDecoration(
                          hintText: 'Search crispy pizzas, toppings...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: pizzaProvider.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () =>
                                      pizzaProvider.setSearchQuery(''),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Stack(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _showFilterBottomSheet(context, pizzaProvider);
                            },
                          ),
                        ),
                        if (pizzaProvider.currentSort !=
                                SortOption.defaultSort ||
                            pizzaProvider.isSpicyOnly)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppTheme.secondaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Promotional Special Banner
              PromotionalBanner(),

              // Categories Selector
              CategoriesSelector(pizzaProvider: pizzaProvider),

              // Pizza Catalog Section Header & Sorting Info
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${pizzaProvider.selectedCategory} Pizzas (${filteredPizzas.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          _showFilterBottomSheet(context, pizzaProvider),
                      child: Text(
                        _getSortLabel(pizzaProvider.currentSort),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Grid of Pizzas or Skeletons
              if (pizzaProvider.isLoading)
                // Show skeleton grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: 8, // number of skeletons
                  itemBuilder: (context, index) => const PizzaCardSkeleton(),
                )
              // Empty state if search or filter returns zero items
              else if (filteredPizzas.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          'No pizzas match your filter criteria',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppTheme.darkTextPrimary
                                : AppTheme.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try clearing search query or changing active category filter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => pizzaProvider.resetFilters(),
                          child: const Text('RESET ALL FILTERS'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Grid of Pizzas
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: filteredPizzas.length,
                  itemBuilder: (context, index) {
                    final pizza = filteredPizzas[index];
                    final isFav = favoritesProvider.isFavorite(pizza.id);

                    return BuildPizzaCard(
                      context: context,
                      pizza: pizza,
                      isFavorite: isFav,
                      onFavoriteToggle: () {
                        favoritesProvider.toggleFavorite(pizza.id);
                      },
                      onTap: () {
                        context.pushNamed(
                          RouteNames.productDetails,
                          pathParameters: {'id': pizza.id},
                        );
                      },
                      onQuickAdd: () {
                        cartProvider.addToCart(
                          pizza: pizza,
                          size: 'Medium',
                          crust: 'Thin Crust',
                          toppings: [],
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added ${pizza.name} (Medium) to cart! 🍕',
                            ),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              textColor: Theme.of(context).colorScheme.primary,
                              onPressed: () => context.goNamed(RouteNames.cart),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSortLabel(SortOption sort) {
    switch (sort) {
      case SortOption.popular:
        return 'Sorted: Popular 🔥';
      case SortOption.rating:
        return 'Sorted: Highest Rated ⭐';
      case SortOption.priceLowToHigh:
        return 'Sorted: Price Low -> High';
      case SortOption.priceHighToLow:
        return 'Sorted: Price High -> Low';
      case SortOption.defaultSort:
        return 'Sort & Filter ⚙️';
    }
  }

  void _showFilterBottomSheet(
    BuildContext context,
    PizzaProvider pizzaProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sort & Filter Options',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          pizzaProvider.resetFilters();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Reset All',
                          style: TextStyle(color: AppTheme.accentSpicy),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Sort Options
                  const SizedBox(height: 8),
                  const Text(
                    'Sort By',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildSortTile(
                    context,
                    title: 'Most Popular',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: AppTheme.primaryColor,
                    option: SortOption.popular,
                    pizzaProvider: pizzaProvider,
                  ),
                  _buildSortTile(
                    context,
                    title: 'Highest Rated',
                    icon: Icons.star_rounded,
                    iconColor: AppTheme.secondaryColor,
                    option: SortOption.rating,
                    pizzaProvider: pizzaProvider,
                  ),
                  _buildSortTile(
                    context,
                    title: 'Price: Low to High',
                    icon: Icons.arrow_upward_rounded,
                    iconColor: Colors.green,
                    option: SortOption.priceLowToHigh,
                    pizzaProvider: pizzaProvider,
                  ),
                  _buildSortTile(
                    context,
                    title: 'Price: High to Low',
                    icon: Icons.arrow_downward_rounded,
                    iconColor: Colors.orange,
                    option: SortOption.priceHighToLow,
                    pizzaProvider: pizzaProvider,
                  ),

                  const SizedBox(height: 12),
                  const Divider(),
                  const Text(
                    'Dietary & Preference',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('🔥 Spicy Pizzas Only'),
                    value: pizzaProvider.isSpicyOnly,
                    onChanged: (val) {
                      pizzaProvider.toggleSpicyFilter();
                      setModalState(() {});
                    },
                    activeTrackColor: AppTheme.primaryColor,
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('APPLY FILTERS'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required SortOption option,
    required PizzaProvider pizzaProvider,
  }) {
    final isSelected = pizzaProvider.currentSort == option;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppTheme.primaryColor : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor)
          : null,
      onTap: () {
        pizzaProvider.selectSortOption(
          isSelected ? SortOption.defaultSort : option,
        );
        Navigator.pop(context);
      },
    );
  }
}
