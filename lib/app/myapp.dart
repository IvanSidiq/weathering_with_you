import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../services/di_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final ColorScheme _lightScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 117, 152, 204),
      brightness: Brightness.light);

  @override
  void initState() {
    super.initState();
    DIService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final route = GetIt.I<GoRouter>();
    return MaterialApp.router(
      routerConfig: route,
      theme: ThemeData(
        colorScheme: _lightScheme,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
      ),
    );
  }
}
