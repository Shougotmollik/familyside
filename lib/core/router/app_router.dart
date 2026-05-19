import 'package:familyside/view/auth/onboarding_screen.dart';
import 'package:familyside/view/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router_path.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouterPath.splashScreen,
    routes: [
      GoRoute(
        path: RouterPath.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouterPath.onBoardingScreen,
        builder: (context, state) => const OnBoardingScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
