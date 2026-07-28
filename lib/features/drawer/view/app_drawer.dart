import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/services/theme_provider.dart';
import 'package:rocket_slice/features/profile/services/profile_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final profileProvider = Provider.of<ProfileProvider>(context);
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // User Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF2D231E), const Color(0xFF1E1A17)]
                    : [AppTheme.primaryColor, AppTheme.primaryGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.goNamed(RouteNames.profile);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 30,
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
                                  style: const TextStyle(fontSize: 28),
                                )
                              : null,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                      tooltip: 'Toggle Theme',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  profileProvider.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'VIP Gold',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        profileProvider.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Drawer Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              children: [
                _buildDrawerTile(
                  context,
                  icon: Icons.local_pizza_rounded,
                  title: 'Explore Menu',
                  routeName: RouteNames.home,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.shopping_bag_rounded,
                  title: 'My Cart',
                  routeName: RouteNames.cart,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.favorite_rounded,
                  title: 'Favorites',
                  routeName: RouteNames.favorites,
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.person_rounded,
                  title: 'My Profile',
                  routeName: RouteNames.profile,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(),
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.receipt_long_rounded,
                  title: 'Order History',
                  subtitle: '... active orders',
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(RouteNames.profile);
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.location_on_rounded,
                  title: 'Delivery Addresses',
                  subtitle: profileProvider.deliveryAddress,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(RouteNames.profile);
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.local_offer_rounded,
                  title: 'Promos & Coupons',
                  subtitle: '50% OFF available',
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(RouteNames.cart);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.primaryColor.withValues(alpha: 0.2)
                          : AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    isDark ? 'Dark Mode' : 'Light Mode',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (val) => themeProvider.toggleTheme(),
                    activeTrackColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.accentSpicy,
                    side: const BorderSide(color: AppTheme.accentSpicy),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context.goNamed(RouteNames.splash);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign Out'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Rocket Slice v1.0.0 • Hot & Fast',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    String? routeName,
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
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
            if (routeName != null) context.goNamed(routeName);
          },
    );
  }
}
