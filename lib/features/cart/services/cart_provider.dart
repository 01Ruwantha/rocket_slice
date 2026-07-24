import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rocket_slice/features/cart/model/cart_item.dart';
import 'package:rocket_slice/features/home/model/pizza.dart';

class CartProvider extends ChangeNotifier {
  static const String _boxName = 'cart_box';
  late Box _box;

  final List<CartItem> _items = [];
  String? _appliedPromoCode;
  double _discountPercentage = 0.0;
  final double _deliveryFee = 2.99;

  CartProvider() {
    _loadCart();
  }

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  String? get appliedPromoCode => _appliedPromoCode;
  double get deliveryFee => _items.isEmpty ? 0.0 : _deliveryFee;

  void _loadCart() {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      final List<dynamic>? savedList = _box.get('items');
      if (savedList != null) {
        _items.clear();
        for (var itemMap in savedList) {
          if (itemMap is Map) {
            _items.add(CartItem.fromMap(itemMap));
          }
        }
      }
      _appliedPromoCode = _box.get('appliedPromoCode');
      _discountPercentage = _box.get('discountPercentage', defaultValue: 0.0);
    }
  }

  Future<void> _saveCart() async {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      final listMaps = _items.map((i) => i.toMap()).toList();
      await _box.put('items', listMaps);
      await _box.put('appliedPromoCode', _appliedPromoCode);
      await _box.put('discountPercentage', _discountPercentage);
    }
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get discountAmount {
    return subtotal * _discountPercentage;
  }

  double get grandTotal {
    if (_items.isEmpty) return 0.0;
    final total = subtotal - discountAmount + deliveryFee;
    return total < 0 ? 0.0 : total;
  }

  void addToCart({
    required Pizza pizza,
    required String size,
    required String crust,
    required List<PizzaOption> toppings,
    int quantity = 1,
  }) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.pizza.id == pizza.id &&
          item.selectedSize == size &&
          item.selectedCrust == crust &&
          _areToppingsEqual(item.selectedToppings, toppings),
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          id: '${pizza.id}_${DateTime.now().millisecondsSinceEpoch}',
          pizza: pizza,
          selectedSize: size,
          selectedCrust: crust,
          selectedToppings: List.from(toppings),
          quantity: quantity,
        ),
      );
    }
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      _saveCart();
      notifyListeners();
    }
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    _saveCart();
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'ROCKET50' || cleanCode == 'PIZZA50') {
      _appliedPromoCode = cleanCode;
      _discountPercentage = 0.50; // 50% OFF promo from Stitch design!
      _saveCart();
      notifyListeners();
      return true;
    } else if (cleanCode == 'ROCKET20' || cleanCode == 'HOT20') {
      _appliedPromoCode = cleanCode;
      _discountPercentage = 0.20;
      _saveCart();
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    _saveCart();
    notifyListeners();
  }

  bool _areToppingsEqual(List<PizzaOption> list1, List<PizzaOption> list2) {
    if (list1.length != list2.length) return false;
    final names1 = list1.map((e) => e.name).toSet();
    final names2 = list2.map((e) => e.name).toSet();
    return names1.containsAll(names2);
  }
}
