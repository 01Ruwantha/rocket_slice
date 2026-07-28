import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rocket_slice/app/router/route_names.dart';
import 'package:rocket_slice/app/theme/app_theme.dart';
import 'package:rocket_slice/core/services/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ✅ Correct mixin for multiple controllers
  late AnimationController _textController;
  late Animation<double> _titleFade;
  late Animation<double> _taglineFade;
  late Animation<double> _descFade;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // -------- Text animations (run once) --------
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Interval(0.1, 0.4, curve: Curves.easeOut),
      ),
    );
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );
    _descFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _textController.forward().then((_) {
      if (mounted) context.goNamed(RouteNames.home);
    });

    // -------- Scale animation (continuous loop) --------
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.2,
            colors: isDark
                ? [const Color(0xFF331C14), AppTheme.darkBackground]
                : [const Color(0xFFFFF3E0), AppTheme.lightBackground],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/icon/ic_launcher_monochrome.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),

                        FadeTransition(
                          opacity: _titleFade,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.lightTextPrimary,
                              ),
                              children: const [
                                TextSpan(text: 'ROCKET '),
                                TextSpan(
                                  text: 'SLICE',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        FadeTransition(
                          opacity: _taglineFade,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '🔥 FAST & HOT PIZZA DELIVERY 🚀',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        FadeTransition(
                          opacity: _descFade,
                          child: Text(
                            'Handcrafted gourmet pizzas delivered straight to your galaxy in 20 minutes or less.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
