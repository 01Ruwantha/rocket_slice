// promo_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';

class PromoItem {
  final String tag;
  final String title;
  final String subtitle;
  final String emoji;

  PromoItem({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.emoji,
  });
}

class PromoProvider extends ChangeNotifier {
  List<PromoItem> _items = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<PromoItem> get items => _items;

  PromoProvider() {
    fetchPromos(); // auto‑fetch on creation
  }

  Future<void> fetchPromos() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulate network

    _items = [
      PromoItem(
        tag: 'SPECIAL PROMO',
        title: '50% OFF FIRST ORDER',
        subtitle: 'Use code: ROCKET50',
        emoji: '🍕',
      ),
      PromoItem(
        tag: 'FLASH SALE',
        title: 'FREE DELIVERY TODAY',
        subtitle: 'Min. order \$15',
        emoji: '🚀',
      ),
      PromoItem(
        tag: 'WEEKEND DEAL',
        title: 'BUY 1 GET 1 FREE',
        subtitle: 'On all large pizzas',
        emoji: '🧀',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async => fetchPromos();
}
