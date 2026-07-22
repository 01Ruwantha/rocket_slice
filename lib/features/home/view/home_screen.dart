import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/services/theme_provider.dart';
import 'package:rocket_slice/features/home/model/pizza.dart';
import 'package:rocket_slice/features/home/services/pizza_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final pizzaProvider = Provider.of<PizzaProvider>(context);

    final filteredPizzas = pizzaProvider.filteredPizzas;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (drawerContext) => IconButton(
            icon: const Icon(Icons.menu_rounded, size: 28),
            onPressed: () {},
            tooltip: 'Open Menu',
          ),
        ),
        title: Column(
          children: [
            Text(
              'Rocket Slice',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
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
                      onChanged: (value) => pizzaProvider.setSearchQuery(value),
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
                      if (pizzaProvider.currentSort != SortOption.defaultSort ||
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'SPECIAL PROMO',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '50% OFF FIRST ORDER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Use code: ROCKET50 at checkout',
                            style: TextStyle(
                              color: Color(0xE6FFFFFF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      child: const Text('🍕', style: TextStyle(fontSize: 42)),
                    ),
                  ],
                ),
              ),
            ),

            // Categories Selector
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: pizzaProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = pizzaProvider.categories[index];
                  final isSelected = category == pizzaProvider.selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          pizzaProvider.selectCategory(category);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

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
                    onTap: () => _showFilterBottomSheet(context, pizzaProvider),
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

            // Empty state if search or filter returns zero items
            if (filteredPizzas.isEmpty)
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

                  return _buildPizzaCard(
                    context,
                    pizza: pizza,
                    onFavoriteToggle: () {},
                    onTap: () {},
                    onQuickAdd: () {},
                  );
                },
              ),
          ],
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

  Widget _buildPizzaCard(
    BuildContext context, {
    required Pizza pizza,
    required VoidCallback onFavoriteToggle,
    required VoidCallback onTap,
    required VoidCallback onQuickAdd,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Badges
            Expanded(
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
                            child: Text('🍕', style: TextStyle(fontSize: 40)),
                          ),
                        );
                      },
                    ),
                  ),
                  // Favorite Toggle Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.favorite_border_rounded, size: 18),
                        onPressed: onFavoriteToggle,
                      ),
                    ),
                  ),
                  // Spicy / Popular Badge
                  if (pizza.isSpicy || pizza.isPopular)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: pizza.isSpicy
                              ? AppTheme.accentSpicy
                              : AppTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          pizza.isSpicy ? '🔥 SPICY' : '⭐ TOP',
                          style: TextStyle(
                            color: pizza.isSpicy ? Colors.white : Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Card Body Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    pizza.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Rating & Prep Time
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${pizza.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
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
                  const SizedBox(height: 8),

                  // Price & Quick Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${pizza.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: onQuickAdd,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
