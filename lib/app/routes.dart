import 'package:go_router/go_router.dart';
import 'package:weathering_with_you/modules/splash_screen.dart';
import 'package:weathering_with_you/modules/weather/home_screen.dart';

List<RouteBase> configureRoutes() {
  List<RouteBase> router = [
    GoRoute(
      path: '/',
      name: 'root',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ];
  return router;
}
