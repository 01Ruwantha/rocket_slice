import 'package:rocket_slice/features/home/model/pizza.dart';

class CartItem {
  final String id;
  final Pizza pizza;
  final String selectedSize;
  final String selectedCrust;
  final List<PizzaOption> selectedToppings;
  int quantity;

  CartItem({
    required this.id,
    required this.pizza,
    required this.selectedSize,
    required this.selectedCrust,
    required this.selectedToppings,
    this.quantity = 1,
  });

  double get unitPrice {
    double sizeMultiplier = 1.0;
    if (selectedSize == 'Medium') sizeMultiplier = 1.25;
    if (selectedSize == 'Large') sizeMultiplier = 1.50;

    double crustExtra = 0.0;
    if (selectedCrust == 'Stuffed Crust') crustExtra = 2.50;

    double toppingsExtra = selectedToppings.fold(
      0.0,
      (sum, item) => sum + item.extraPrice,
    );

    return (pizza.price * sizeMultiplier) + crustExtra + toppingsExtra;
  }

  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toMap() => {
    'id': id,
    'pizza': pizza.toMap(),
    'selectedSize': selectedSize,
    'selectedCrust': selectedCrust,
    'selectedToppings': selectedToppings.map((t) => t.toMap()).toList(),
    'quantity': quantity,
  };

  factory CartItem.fromMap(Map<dynamic, dynamic> map) => CartItem(
    id: map['id'] as String? ?? '',
    pizza: Pizza.fromMap(map['pizza'] as Map),
    selectedSize: map['selectedSize'] as String? ?? 'Medium',
    selectedCrust: map['selectedCrust'] as String? ?? 'Thin Crust',
    selectedToppings:
        (map['selectedToppings'] as List?)
            ?.map((t) => PizzaOption.fromMap(t as Map))
            .toList() ??
        [],
    quantity: map['quantity'] as int? ?? 1,
  );

  CartItem copyWith({
    String? id,
    Pizza? pizza,
    String? selectedSize,
    String? selectedCrust,
    List<PizzaOption>? selectedToppings,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      pizza: pizza ?? this.pizza,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedCrust: selectedCrust ?? this.selectedCrust,
      selectedToppings: selectedToppings ?? this.selectedToppings,
      quantity: quantity ?? this.quantity,
    );
  }
}
