import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _boxName = 'favorites_box';
  late Box _box;
  final Set<String> _favoriteIds = {'p1', 'p3'};

  FavoritesProvider() {
    _loadFavorites();
  }

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  void _loadFavorites() {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      final List<dynamic>? saved = _box.get('fav_list');
      if (saved != null) {
        _favoriteIds.clear();
        _favoriteIds.addAll(saved.cast<String>());
      }
    }
  }

  bool isFavorite(String pizzaId) {
    return _favoriteIds.contains(pizzaId);
  }

  Future<void> toggleFavorite(String pizzaId) async {
    if (_favoriteIds.contains(pizzaId)) {
      _favoriteIds.remove(pizzaId);
    } else {
      _favoriteIds.add(pizzaId);
    }

    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      await _box.put('fav_list', _favoriteIds.toList());
    }

    notifyListeners();
  }
}
