import 'package:flutter/material.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/features/cart/services/cart_provider.dart';

class BuildCartItemCard extends StatelessWidget {
  const BuildCartItemCard({
    super.key,
    required this.context,
    required this.item,
    required this.cartProvider,
    required this.isDark,
  });

  final BuildContext context;
  final dynamic item;
  final CartProvider cartProvider;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final toppingsText = item.selectedToppings.isEmpty
        ? 'No extra toppings'
        : item.selectedToppings.map((t) => t.name).join(', ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.pizza.imageUrl,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 75,
                  height: 75,
                  color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                  child: const Center(
                    child: Text('🍕', style: TextStyle(fontSize: 32)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.pizza.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.selectedSize} • ${item.selectedCrust}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    toppingsText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.darkCard
                              : AppTheme.lightCard,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                cartProvider.updateQuantity(
                                  item.id,
                                  item.quantity - 1,
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.remove, size: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                cartProvider.updateQuantity(
                                  item.id,
                                  item.quantity + 1,
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.add, size: 16),
                              ),
                            ),
                          ],
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
}
