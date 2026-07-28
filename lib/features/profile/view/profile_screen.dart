import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/services/theme_provider.dart';
import 'package:rocket_slice/core/widgets/app_bottom_nav_bar.dart';
import 'package:rocket_slice/features/cart/services/cart_provider.dart';
import 'package:rocket_slice/features/favourite/services/favorites_provider.dart';
import 'package:rocket_slice/features/profile/services/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final favProvider = Provider.of<FavoritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppTheme.lightBackground,
        leading: Builder(
          builder: (drawerContext) => IconButton(
            icon: const Icon(Icons.menu_rounded, size: 28),
            onPressed: () {
              ScaffoldWithBottomNavBar.rootScaffoldKey.currentState
                  ?.openDrawer();
            },
            tooltip: 'Open Menu',
          ),
        ),
        title: const Text('My Profile'),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          //     color: isDark ? AppTheme.secondaryColor : AppTheme.primaryColor,
          //   ),
          //   onPressed: () => themeProvider.toggleTheme(),
          //   tooltip: 'Toggle Theme Mode',
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Avatar Card
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _showImagePickerMenu(context, profileProvider),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryColor,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 44,
                                backgroundColor: AppTheme.secondaryColor,
                                backgroundImage:
                                    profileProvider.profileImagePath != null
                                    ? FileImage(
                                        File(profileProvider.profileImagePath!),
                                      )
                                    : null,
                                child: profileProvider.profileImagePath == null
                                    ? Text(
                                        profileProvider.selectedAvatarEmoji,
                                        style: const TextStyle(fontSize: 44),
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppTheme.darkSurface
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profileProvider.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profileProvider.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profileProvider.phone,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.workspace_premium_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'ROCKET VIP GOLD MEMBER',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () =>
                            _showEditProfileSheet(context, profileProvider),
                        icon: const Icon(Icons.edit_rounded, size: 16),
                        label: const Text('Edit Profile Info'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Stats Row
            Row(
              children: [
                _buildStatCard(
                  context,
                  title: '...',
                  subtitle: 'Total Orders',
                  icon: Icons.receipt_long_rounded,
                  color: AppTheme.primaryColor,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order history feature coming soon!'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  title: '${favProvider.favoriteIds.length}',
                  subtitle: 'Saved Favorites',
                  icon: Icons.favorite_rounded,
                  color: Colors.redAccent,
                  onTap: () => context.goNamed(RouteNames.favorites),
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  context,
                  title: '${cartProvider.itemCount}',
                  subtitle: 'Cart Items',
                  icon: Icons.shopping_bag_rounded,
                  color: AppTheme.secondaryColor,
                  onTap: () => context.goNamed(RouteNames.cart),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Profile Info Details Card
            Card(
              child: Column(
                children: [
                  _buildInfoTile(
                    context,
                    icon: Icons.person_rounded,
                    label: 'Full Name',
                    value: profileProvider.name,
                    // onTap: () =>
                    //     _showEditProfileSheet(context, profileProvider),
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    context,
                    icon: Icons.email_rounded,
                    label: 'Email Address',
                    value: profileProvider.email,
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    context,
                    icon: Icons.phone_rounded,
                    label: 'Phone Number',
                    value: profileProvider.phone,
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    context,
                    icon: Icons.location_on_rounded,
                    label: 'Delivery Address',
                    value: profileProvider.deliveryAddress,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings & Preferences List
            Card(
              child: Column(
                children: [
                  // Theme Mode Switch Tile
                  SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    title: const Text(
                      'Theme Mode',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      isDark ? 'Dark Theme active' : 'Light Theme active',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                    ),
                    value: isDark,
                    onChanged: (val) => themeProvider.toggleTheme(),
                    activeTrackColor: AppTheme.primaryColor,
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    context,
                    icon: Icons.credit_card_rounded,
                    title: 'Payment Methods',
                    subtitle: 'Visa ending in 4242',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    context,
                    icon: Icons.card_giftcard_rounded,
                    title: 'Rewards & Coupons',
                    subtitle: '50% OFF voucher active (ROCKET50)',
                    onTap: () => context.goNamed(RouteNames.cart),
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    context,
                    icon: Icons.notifications_rounded,
                    title: 'Notification Preferences',
                    subtitle: 'Order tracking & promos enabled',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    context,
                    icon: Icons.support_agent_rounded,
                    title: 'Help & Support',
                    subtitle: 'Live Chat & Order FAQs',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentSpicy,
                  side: const BorderSide(
                    color: AppTheme.accentSpicy,
                    width: 1.5,
                  ),
                ),
                onPressed: () => context.goNamed(RouteNames.splash),
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'SIGN OUT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showImagePickerMenu(
    BuildContext context,
    ProfileProvider profileProvider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emojis = [
      '🚀',
      '🍕',
      '🔥',
      '⭐',
      '👨‍🍳',
      '😎',
      '🤩',
      '🎯',
      '💎',
      '🦄',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Profile Picture',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        await profileProvider.pickProfileImage(
                          ImageSource.camera,
                        );
                      },
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                        await profileProvider.pickProfileImage(
                          ImageSource.gallery,
                        );
                      },
                      icon: const Icon(Icons.photo_library_rounded),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Or pick an emoji avatar:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: emojis.map((emoji) {
                  final isSelected =
                      profileProvider.selectedAvatarEmoji == emoji &&
                      profileProvider.profileImagePath == null;
                  return GestureDetector(
                    onTap: () async {
                      await profileProvider.setAvatarEmoji(emoji);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileSheet(
    BuildContext context,
    ProfileProvider profileProvider,
  ) {
    final nameCtrl = TextEditingController(text: profileProvider.name);
    final emailCtrl = TextEditingController(text: profileProvider.email);
    final phoneCtrl = TextEditingController(text: profileProvider.phone);
    final addressCtrl = TextEditingController(
      text: profileProvider.deliveryAddress,
    );
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Profile Info',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    controller: nameCtrl,
                    label: 'Full Name',
                    icon: Icons.person_rounded,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: emailCtrl,
                    label: 'Email Address',
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: phoneCtrl,
                    label: 'Phone Number',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Phone is required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: addressCtrl,
                    label: 'Delivery Address',
                    icon: Icons.location_on_rounded,
                    maxLines: 2,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Address is required'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (formKey.currentState?.validate() == true) {
                          await profileProvider.updateProfile(
                            name: nameCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            phone: phoneCtrl.text.trim(),
                            deliveryAddress: addressCtrl.text.trim(),
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Profile updated successfully!'),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: const Text(
                        'SAVE CHANGES',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isDark
              ? AppTheme.darkTextSecondary
              : AppTheme.lightTextSecondary,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      trailing: onTap != null
          ? Icon(Icons.edit_rounded, size: 18, color: AppTheme.primaryColor)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: isDark
              ? AppTheme.darkTextSecondary
              : AppTheme.lightTextSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}
