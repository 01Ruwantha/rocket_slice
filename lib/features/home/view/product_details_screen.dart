import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/services/theme_provider.dart';
import 'package:rocket_slice/features/cart/services/cart_provider.dart';
import 'package:rocket_slice/features/favourite/services/favorites_provider.dart';
import 'package:rocket_slice/features/home/model/pizza.dart';
import 'package:rocket_slice/features/home/services/pizza_provider.dart';
import 'package:rocket_slice/features/home/widgets/build_meta_chip_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String pizzaId;

  const ProductDetailsScreen({super.key, required this.pizzaId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String _selectedSize;
  late String _selectedCrust;
  final Set<PizzaOption> _selectedToppings = {};
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedSize = 'Medium';
    _selectedCrust = 'Thin Crust';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final pizzaProvider = Provider.of<PizzaProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final pizza =
        pizzaProvider.getPizzaById(widget.pizzaId) ??
        pizzaProvider.allPizzas.first;
    final isFavorite = favoritesProvider.isFavorite(pizza.id);

    // Calculate dynamic total price for selected configuration
    double basePrice = pizza.price;
    if (_selectedSize == 'Medium') basePrice *= 1.25;
    if (_selectedSize == 'Large') basePrice *= 1.50;

    double crustExtra = _selectedCrust == 'Stuffed Crust' ? 2.50 : 0.0;
    double toppingsExtra = _selectedToppings.fold(
      0.0,
      (sum, t) => sum + t.extraPrice,
    );
    double singleUnitPrice = basePrice + crustExtra + toppingsExtra;
    double totalPrice = singleUnitPrice * _quantity;

    return Scaffold(
      body: Stack(
        children: [
          // Content Scroll View
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Image Banner
                SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          pizza.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDark
                                  ? AppTheme.darkCard
                                  : AppTheme.lightCard,
                              child: const Center(
                                child: Text(
                                  '🍕',
                                  style: TextStyle(fontSize: 80),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Top Overlay Actions
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () => context.pop(),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black.withValues(
                                  alpha: 0.5,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isFavorite
                                        ? Colors.redAccent
                                        : Colors.white,
                                  ),
                                  onPressed: () {
                                    favoritesProvider.toggleFavorite(pizza.id);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Content Body
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Badges
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              pizza.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '\$${singleUnitPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Meta Chips (Rating, Prep Time, Calories)
                      Row(
                        children: [
                          BuildMetaChipWidget(
                            context: context,
                            icon: Icons.star_rounded,
                            iconColor: AppTheme.secondaryColor,
                            label:
                                '${pizza.rating} (${pizza.reviewsCount} reviews)',
                          ),
                          const SizedBox(width: 8),
                          BuildMetaChipWidget(
                            context: context,
                            icon: Icons.timer_rounded,
                            iconColor: AppTheme.primaryColor,
                            label: '${pizza.prepTimeMinutes} mins',
                          ),
                          const SizedBox(width: 8),
                          BuildMetaChipWidget(
                            context: context,
                            icon: Icons.local_fire_department_rounded,
                            iconColor: Colors.orangeAccent,
                            label: '${pizza.calories} kcal',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pizza.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Size Selector
                      const Text(
                        'Select Size',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: pizza.sizes.map((size) {
                          final isSelected = size == _selectedSize;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark
                                                ? AppTheme.darkTextPrimary
                                                : AppTheme.lightTextPrimary),
                                    ),
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: AppTheme.primaryColor,
                                backgroundColor: isDark
                                    ? AppTheme.darkCard
                                    : AppTheme.lightCard,
                                onSelected: (val) {
                                  if (val) setState(() => _selectedSize = size);
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Crust Selector
                      const Text(
                        'Select Crust Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: pizza.crusts.map((crust) {
                          final extraStr = crust == 'Stuffed Crust'
                              ? ' (+\$2.50)'
                              : '';
                          final isSelected = _selectedCrust == crust;
                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() => _selectedCrust = crust),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : (isDark
                                                  ? AppTheme.darkBorder
                                                  : AppTheme.lightBorder),
                                        width: isSelected ? 6 : 2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '$crust$extraStr',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Extra Toppings Selector
                      const Text(
                        'Customize Extra Toppings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pizza.availableToppings.map((topping) {
                          final isSelected = _selectedToppings.contains(
                            topping,
                          );
                          return FilterChip(
                            label: Text(
                              '${topping.name} (+\$${topping.extraPrice.toStringAsFixed(2)})',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                          ? AppTheme.darkTextPrimary
                                          : AppTheme.lightTextPrimary),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppTheme.primaryColor,
                            backgroundColor: isDark
                                ? AppTheme.darkCard
                                : AppTheme.lightCard,
                            checkmarkColor: Colors.white,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _selectedToppings.add(topping);
                                } else {
                                  _selectedToppings.remove(topping);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar for Quantity & Add to Cart
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity Adjuster
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_rounded, size: 20),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_rounded, size: 20),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Add to Cart CTA Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        cartProvider.addToCart(
                          pizza: pizza,
                          size: _selectedSize,
                          crust: _selectedCrust,
                          toppings: _selectedToppings.toList(),
                          quantity: _quantity,
                        );
                        context.pop();
                        context.pushNamed(RouteNames.cart);
                      },
                      child: Text(
                        'ADD TO CART • \$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
