import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/main_repository.dart';
import '../utils/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      lazy: false,
      create: (context) => MainRepository(),
      child: const _SplashBody(),
    );
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody({Key? key}) : super(key: key);

  @override
  __SplashBodyState createState() => __SplashBodyState();
}

class __SplashBodyState extends State<_SplashBody>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.surface,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
