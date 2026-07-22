import 'package:go_router/go_router.dart';
import 'package:rocket_slice/features/home/view/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    ],
  );
}
