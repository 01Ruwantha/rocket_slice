import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skelton extends StatelessWidget {
  const Skelton({
    super.key,
    this.width,
    this.height,
    this.shimmer = true,
    this.alpha = 1.0,
    this.darkColor = Colors.white,
    this.lightColor = Colors.black,
    this.shape = BoxShape.rectangle,
    this.borderRadius = 16.0,
  });
  final double? width, height;
  final bool shimmer;
  final double alpha;
  final Color darkColor;
  final Color lightColor;
  final BoxShape shape;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    final container = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.all(Radius.circular(borderRadius))
            : null,
        color: shimmer
            ? (isDark ? darkColor : lightColor)
            : (isDark
                  ? Colors.white.withValues(alpha: alpha)
                  : Colors.black.withValues(alpha: alpha)),
      ),
    );

    if (shimmer) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: container,
      );
    } else {
      return container;
    }
  }
}
