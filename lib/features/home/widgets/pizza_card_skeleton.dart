import 'package:flutter/material.dart';
import 'package:rocket_slice/core/widgets/skelton.dart';

class PizzaCardSkeleton extends StatelessWidget {
  const PizzaCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + badges (full area with placeholder)
          Expanded(
            child: Stack(
              children: [
                // Image area
                Skelton(shimmer: true),
                // Favorite button placeholder
                Positioned(
                  top: 8,
                  right: 8,
                  child: Skelton(width: 32, height: 32, shape: BoxShape.circle),
                ),
                // Spicy/Popular badge placeholder
                Positioned(
                  top: 8,
                  left: 8,
                  child: Skelton(
                    width: 40,
                    height: 12,
                    shimmer: true,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ],
            ),
          ),
          // Bottom details
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Skelton(height: 14, borderRadius: 4.0),
                const SizedBox(height: 4),
                // Rating & prep time
                Row(
                  children: [
                    Skelton(width: 30, height: 12, borderRadius: 4.0),
                    const SizedBox(width: 6),
                    Skelton(width: 40, height: 12, borderRadius: 4.0),
                  ],
                ),
                const SizedBox(height: 8),
                // Price & add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skelton(width: 50, height: 16, borderRadius: 4.0),
                    Skelton(width: 32, height: 32, borderRadius: 8.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
