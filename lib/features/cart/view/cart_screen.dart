import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/services/theme_provider.dart';
import 'package:rocket_slice/features/cart/services/cart_provider.dart';
import 'package:rocket_slice/features/cart/widgets/build_cart_item_card.dart';
import 'package:rocket_slice/features/cart/widgets/build_empty_cart_state.dart';
import 'package:rocket_slice/features/cart/widgets/build_promo_section.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  String _selectedPayment = 'Credit Card';

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart (${cartProvider.itemCount})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.goNamed(RouteNames.home),
        ),
        actions: [
          if (cartProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () {
                _showClearConfirmation(context, cartProvider);
              },
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      body: cartProvider.items.isEmpty
          ? BuildEmptyCartState(context: context, isDark: isDark)
          : Column(
              children: [
                // Scrollable Item List & Summaries
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart Items List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartProvider.items.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = cartProvider.items[index];
                            return BuildCartItemCard(
                              context: context,
                              item: item,
                              cartProvider: cartProvider,
                              isDark: isDark,
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Promo Code Input Box
                        BuildPromoSection(
                          promoController: _promoController,
                          context: context,
                          cartProvider: cartProvider,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 24),

                        // Payment Options
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildPaymentOption(
                              'Credit Card',
                              Icons.credit_card_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildPaymentOption(
                              'Apple Pay',
                              Icons.phone_iphone_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildPaymentOption(
                              'Cash',
                              Icons.attach_money_rounded,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Order Cost Summary Breakdown Card
                        _buildOrderSummaryCard(context, cartProvider, isDark),
                      ],
                    ),
                  ),
                ),

                // Bottom Sticky Place Order Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkSurface
                        : AppTheme.lightSurface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        _showOrderSuccessDialog(context, cartProvider);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'PLACE ORDER NOW',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '\$${cartProvider.grandTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    final isSelected = _selectedPayment == title;
    return Expanded(
      child: ChoiceChip(
        avatar: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : AppTheme.primaryColor,
        ),
        label: Text(title, style: const TextStyle(fontSize: 11)),
        selected: isSelected,
        onSelected: (val) {
          if (val) setState(() => _selectedPayment = title);
        },
      ),
    );
  }

  Widget _buildOrderSummaryCard(
    BuildContext context,
    CartProvider cartProvider,
    bool isDark,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Cost Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCostRow(
              'Subtotal',
              '\$${cartProvider.subtotal.toStringAsFixed(2)}',
              isDark,
            ),
            if (cartProvider.discountAmount > 0)
              _buildCostRow(
                'Discount Promo',
                '-\$${cartProvider.discountAmount.toStringAsFixed(2)}',
                isDark,
                isDiscount: true,
              ),
            _buildCostRow(
              'Delivery Fee',
              '\$${cartProvider.deliveryFee.toStringAsFixed(2)}',
              isDark,
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grand Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${cartProvider.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(
    String label,
    String value,
    bool isDark, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDiscount
                  ? Colors.green
                  : (isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.pop(context);
            },
            child: const Text(
              'CLEAR ALL',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderSuccessDialog(
    BuildContext context,
    CartProvider cartProvider,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Text('🚀', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Placed Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Rocket Slice pizza is now being prepared in the kitchen. Estimated arrival: 18-22 mins!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.pop(context);
                context.goNamed(RouteNames.home);
              },
              child: const Text('TRACK ORDER'),
            ),
          ],
        ),
      ),
    );
  }
}
