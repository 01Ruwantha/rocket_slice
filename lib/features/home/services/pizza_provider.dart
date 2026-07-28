import 'package:flutter/material.dart';
import 'package:rocket_slice/features/home/model/pizza.dart';

enum SortOption { defaultSort, popular, rating, priceLowToHigh, priceHighToLow }

class PizzaProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // In the constructor, start loading simulation
  PizzaProvider() {
    _simulateLoading();
  }

  void _simulateLoading() async {
    // Simulate network delay (e.g., 2 seconds)
    await Future.delayed(const Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshPizzas() async {
    // If already loading, skip to avoid multiple refreshes
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay (replace with actual API call)
    await Future.delayed(const Duration(seconds: 2));

    // If you have a real data source, re‑fetch your pizzas here.
    // For static data, we just keep the same list.

    _isLoading = false;
    notifyListeners();
  }

  String _selectedCategory = 'All';
  String _searchQuery = '';
  SortOption _currentSort = SortOption.defaultSort;
  bool _isSpicyOnly = false;

  final List<String> _categories = [
    'All',
    'Popular',
    'Spicy',
    'Cheese',
    'Meat',
    'Veggie',
  ];

  final List<Pizza> _pizzas = const [
    Pizza(
      id: 'p1',
      name: 'Cosmic Pepperoni Burst',
      description:
          'Double layer of crispy beef pepperoni, melted mozzarella, signature rocket tomato sauce, and Italian oregano spice.',
      price: 14.99,
      rating: 4.9,
      reviewsCount: 320,
      prepTimeMinutes: 20,
      calories: 840,
      imageUrl:
          'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600&auto=format&fit=crop&q=80',
      category: 'Meat',
      isPopular: true,
    ),
    Pizza(
      id: 'p2',
      name: 'Supreme Blast Pizza',
      description:
          'Loaded with pepperoni, Italian sausage, bell peppers, red onions, mushrooms, and black olives over rich mozzarella.',
      price: 16.50,
      rating: 4.8,
      reviewsCount: 245,
      prepTimeMinutes: 25,
      calories: 920,
      imageUrl:
          'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=600&auto=format&fit=crop&q=80',
      category: 'Meat',
      isPopular: true,
    ),
    Pizza(
      id: 'p3',
      name: 'Flame Inferno Spicy Supreme',
      description:
          'Fiery jalapeños, chili flakes, spicy chorizo sausage, smoked ham, habanero drizzle, and melted hot jack cheese.',
      price: 15.99,
      rating: 4.7,
      reviewsCount: 189,
      prepTimeMinutes: 18,
      calories: 880,
      imageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&auto=format&fit=crop&q=80',
      category: 'Spicy',
      isSpicy: true,
      isPopular: true,
    ),
    Pizza(
      id: 'p4',
      name: 'Quad Cheese Supernova',
      description:
          'A cheese lover’s dream featuring Aged Cheddar, Creamy Mozzarella, Gorgonzola Blue Cheese, and Fresh Parmesan with garlic herb crust.',
      price: 13.99,
      rating: 4.9,
      reviewsCount: 410,
      prepTimeMinutes: 15,
      calories: 780,
      imageUrl:
          'https://images.unsplash.com/photo-1573821663912-569905455b1c?w=600&auto=format&fit=crop&q=80',
      category: 'Cheese',
      isPopular: false,
    ),
    Pizza(
      id: 'p5',
      name: 'Veggie Galaxy Deluxe',
      description:
          'Fresh basil leaves, sweet bell peppers, cherry tomatoes, grilled zucchini, artichoke hearts, and pesto drizzle.',
      price: 12.99,
      rating: 4.6,
      reviewsCount: 142,
      prepTimeMinutes: 15,
      calories: 640,
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=80',
      category: 'Veggie',
      isPopular: false,
    ),
    Pizza(
      id: 'p6',
      name: 'BBQ Chicken Comet',
      description:
          'Smokey barbecue grilled chicken, caramelized red onions, sweet corn, cilantro, and smoked gouda cheese blend.',
      price: 15.49,
      rating: 4.8,
      reviewsCount: 298,
      prepTimeMinutes: 22,
      calories: 810,
      imageUrl:
          'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=600&auto=format&fit=crop&q=80',
      category: 'Meat',
      isPopular: true,
    ),
  ];

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortOption get currentSort => _currentSort;
  bool get isSpicyOnly => _isSpicyOnly;
  List<String> get categories => _categories;
  List<Pizza> get allPizzas => _pizzas;

  List<Pizza> get filteredPizzas {
    List<Pizza> list = _pizzas.where((pizza) {
      final matchesSearch =
          pizza.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pizza.description.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesCategory = true;
      if (_selectedCategory == 'Popular') {
        matchesCategory = pizza.isPopular;
      } else if (_selectedCategory == 'Spicy') {
        matchesCategory = pizza.isSpicy || pizza.category == 'Spicy';
      } else if (_selectedCategory != 'All') {
        matchesCategory = pizza.category == _selectedCategory;
      }

      bool matchesSpicyFilter = !_isSpicyOnly || pizza.isSpicy;

      return matchesSearch && matchesCategory && matchesSpicyFilter;
    }).toList();

    // Apply Sorting
    switch (_currentSort) {
      case SortOption.popular:
        list.sort(
          (a, b) => (b.isPopular ? 1 : 0).compareTo(a.isPopular ? 1 : 0),
        );
        break;
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.defaultSort:
        break;
    }

    return list;
  }

  Pizza? getPizzaById(String id) {
    try {
      return _pizzas.firstWhere((p) => p.id == id);
    } catch (_) {
      return _pizzas.first;
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectSortOption(SortOption sort) {
    _currentSort = sort;
    notifyListeners();
  }

  void toggleSpicyFilter() {
    _isSpicyOnly = !_isSpicyOnly;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _currentSort = SortOption.defaultSort;
    _isSpicyOnly = false;
    notifyListeners();
  }
}
