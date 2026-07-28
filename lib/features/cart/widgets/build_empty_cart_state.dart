import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';

class BuildEmptyCartState extends StatelessWidget {
  const BuildEmptyCartState({
    super.key,
    required this.context,
    required this.isDark,
  });

  final BuildContext context;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛒', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text(
              'Your Cart is Empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you haven\'t added any delicious Rocket Slice pizzas yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.goNamed(RouteNames.home),
              icon: const Icon(Icons.local_pizza_rounded),
              label: const Text('EXPLORE PIZZAS'),
            ),
          ],
        ),
      ),
    );
  }
}
