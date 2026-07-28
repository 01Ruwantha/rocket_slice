import 'package:flutter/material.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/features/home/model/pizza.dart';

class BuildPizzaCard extends StatelessWidget {
  const BuildPizzaCard({
    super.key,
    required this.context,
    required this.pizza,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
    required this.onQuickAdd,
  });

  final BuildContext context;
  final Pizza pizza;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;

  @override
  Widget build(BuildContext context) {
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
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFavorite ? Colors.redAccent : Colors.white,
                        ),
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
}
