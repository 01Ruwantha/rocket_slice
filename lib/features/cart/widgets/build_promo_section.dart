import 'package:flutter/material.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/features/cart/services/cart_provider.dart';

class BuildPromoSection extends StatelessWidget {
  const BuildPromoSection({
    super.key,
    required TextEditingController promoController,
    required this.context,
    required this.cartProvider,
    required this.isDark,
  }) : _promoController = promoController;

  final TextEditingController _promoController;
  final BuildContext context;
  final CartProvider cartProvider;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_offer_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Promo Code / Voucher',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (cartProvider.appliedPromoCode != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Code "${cartProvider.appliedPromoCode}" applied!',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => cartProvider.removePromoCode(),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Enter ROCKET50',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final success = cartProvider.applyPromoCode(
                        _promoController.text,
                      );
                      if (success) {
                        _promoController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Promo Code Applied! 🎉'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Invalid Code. Try ROCKET50 or HOT20',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('APPLY'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
