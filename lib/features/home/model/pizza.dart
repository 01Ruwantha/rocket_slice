class PizzaOption {
  final String name;
  final double extraPrice;

  const PizzaOption({required this.name, this.extraPrice = 0.0});

  Map<String, dynamic> toMap() => {
        'name': name,
        'extraPrice': extraPrice,
      };

  factory PizzaOption.fromMap(Map<dynamic, dynamic> map) => PizzaOption(
        name: map['name'] as String? ?? '',
        extraPrice: (map['extraPrice'] as num?)?.toDouble() ?? 0.0,
      );
}

class Pizza {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewsCount;
  final int prepTimeMinutes;
  final int calories;
  final String imageUrl;
  final String category; // 'All', 'Meat', 'Cheese', 'Veggie', 'Spicy'
  final bool isSpicy;
  final bool isPopular;
  final List<String> sizes; // ['Small', 'Medium', 'Large']
  final List<String> crusts; // ['Thin Crust', 'Stuffed Crust', 'Pan Crust']
  final List<PizzaOption> availableToppings;

  const Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.prepTimeMinutes,
    required this.calories,
    required this.imageUrl,
    required this.category,
    this.isSpicy = false,
    this.isPopular = false,
    this.sizes = const ['Small', 'Medium', 'Large'],
    this.crusts = const ['Thin Crust', 'Stuffed Crust', 'Pan Crust'],
    this.availableToppings = const [
      PizzaOption(name: 'Extra Cheese', extraPrice: 1.50),
      PizzaOption(name: 'Jalapeños', extraPrice: 1.00),
      PizzaOption(name: 'Mushrooms', extraPrice: 1.25),
      PizzaOption(name: 'Bacon Strips', extraPrice: 2.00),
      PizzaOption(name: 'Black Olives', extraPrice: 1.00),
      PizzaOption(name: 'Pepperoni Slices', extraPrice: 1.75),
    ],
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'rating': rating,
        'reviewsCount': reviewsCount,
        'prepTimeMinutes': prepTimeMinutes,
        'calories': calories,
        'imageUrl': imageUrl,
        'category': category,
        'isSpicy': isSpicy,
        'isPopular': isPopular,
        'sizes': sizes,
        'crusts': crusts,
        'availableToppings': availableToppings.map((t) => t.toMap()).toList(),
      };

  factory Pizza.fromMap(Map<dynamic, dynamic> map) => Pizza(
        id: map['id'] as String? ?? 'p1',
        name: map['name'] as String? ?? '',
        description: map['description'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
        reviewsCount: map['reviewsCount'] as int? ?? 0,
        prepTimeMinutes: map['prepTimeMinutes'] as int? ?? 0,
        calories: map['calories'] as int? ?? 0,
        imageUrl: map['imageUrl'] as String? ?? '',
        category: map['category'] as String? ?? 'All',
        isSpicy: map['isSpicy'] as bool? ?? false,
        isPopular: map['isPopular'] as bool? ?? false,
        sizes: (map['sizes'] as List?)?.cast<String>() ?? const ['Small', 'Medium', 'Large'],
        crusts: (map['crusts'] as List?)?.cast<String>() ?? const ['Thin Crust', 'Stuffed Crust', 'Pan Crust'],
        availableToppings: (map['availableToppings'] as List?)
                ?.map((t) => PizzaOption.fromMap(t as Map))
                .toList() ??
            const [],
      );
}
