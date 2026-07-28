import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/widgets/skelton.dart';
import 'package:rocket_slice/features/home/services/promo_provider.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PromoProvider>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingPlaceholder(context);
        }

        if (controller.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return _BannerCarousel(items: controller.items);
      },
    );
  }

  // Shared loading placeholder – also respects 16:9
  Widget _buildLoadingPlaceholder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveWidth = screenWidth - 32; // horizontal padding (16+16)
    final height = effectiveWidth * 9 / 16;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Skelton(width: double.infinity, height: height, borderRadius: 20),
    );
  }
}

// Carousel that adapts to 16:9
class _BannerCarousel extends StatefulWidget {
  final List<PromoItem> items;
  const _BannerCarousel({required this.items});

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Effective width: screen width minus horizontal padding (16 from outer + 16 from inner)
    final effectiveWidth = screenWidth - 32;
    final itemHeight = effectiveWidth * 9 / 16; // 16:9 ratio

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index, realIndex) {
            final promo = widget.items[index];
            return _buildBannerCard(promo);
          },
          options: CarouselOptions(
            height: itemHeight, // dynamic height based on 16:9
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.asMap().entries.map((entry) {
            return Container(
              width: 26,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(4),
                color: _currentIndex == entry.key
                    ? AppTheme.primaryColor
                    : Colors.grey.shade400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBannerCard(PromoItem promo) {
    return Padding(
      // Only horizontal padding – vertical is handled by the carousel height
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: double.infinity, // fill the carousel item height
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.primaryGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.35),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      promo.tag,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    promo.subtitle,
                    style: const TextStyle(
                      color: Color(0xE6FFFFFF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: Text(promo.emoji, style: const TextStyle(fontSize: 42)),
            ),
          ],
        ),
      ),
    );
  }
}
