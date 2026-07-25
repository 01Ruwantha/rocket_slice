import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/services/theme_provider.dart';
import 'package:rocket_slice/features/cart/services/cart_provider.dart';
import 'package:rocket_slice/features/favourite/services/favorites_provider.dart';
import 'package:rocket_slice/features/home/services/pizza_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final pizzaProvider = Provider.of<PizzaProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final favPizzas = pizzaProvider.allPizzas
        .where((pizza) => favoritesProvider.isFavorite(pizza.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites (${favPizzas.length})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.goNamed(RouteNames.home),
        ),
        actions: [],
      ),
      body: favPizzas.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('💔', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 16),
                    Text(
                      'No Favorite Pizzas Saved',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on any pizza in the menu to save it to your favorites list.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: () => context.goNamed(RouteNames.home),
                      icon: const Icon(Icons.explore_rounded),
                      label: const Text('DISCOVER PIZZAS'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favPizzas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pizza = favPizzas[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Image Thumbnail
                        GestureDetector(
                          onTap: () => context.pushNamed(
                            RouteNames.productDetails,
                            pathParameters: {'id': pizza.id},
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              pizza.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 80,
                                    height: 80,
                                    color: isDark
                                        ? AppTheme.darkCard
                                        : AppTheme.lightCard,
                                    child: const Center(
                                      child: Text(
                                        '🍕',
                                        style: TextStyle(fontSize: 32),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Info Details
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.pushNamed(
                              RouteNames.productDetails,
                              pathParameters: {'id': pizza.id},
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pizza.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: AppTheme.secondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${pizza.rating} (${pizza.reviewsCount})',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '• ${pizza.prepTimeMinutes} mins',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? AppTheme.darkTextSecondary
                                            : AppTheme.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${pizza.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Action Buttons
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.favorite_rounded,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                favoritesProvider.toggleFavorite(pizza.id);
                              },
                              tooltip: 'Remove from Favorites',
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                cartProvider.addToCart(
                                  pizza: pizza,
                                  size: 'Medium',
                                  crust: 'Thin Crust',
                                  toppings: [],
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added ${pizza.name} to cart! 🍕',
                                    ),
                                    action: SnackBarAction(
                                      label: 'VIEW CART',
                                      onPressed: () =>
                                          context.goNamed(RouteNames.cart),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('ADD'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
