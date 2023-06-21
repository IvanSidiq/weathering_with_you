import 'package:go_router/go_router.dart';

import '../modules/weather/home_screen.dart';

List<RouteBase> configureRoutes() {
  List<RouteBase> router = [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ];
  return router;
}
