import 'package:diato_ai/features/app_layout/app_layout.dart';
import 'package:diato_ai/features/explore/presentation/explore_screen.dart';
import 'package:diato_ai/features/history/presentation/history_screen.dart';
import 'package:diato_ai/features/home/presentation/home_screen.dart';
import 'package:diato_ai/features/map/presentation/map_screen.dart';
import 'package:diato_ai/features/scanner/presentation/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/scanner/presentation/scanner_detail_screen.dart';

class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: HomeScreen.routePath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppLayout(child: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomeScreen.routePath,
                name: HomeScreen.routeName,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ExploreScreen.routePath,
                name: ExploreScreen.routeName,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MapScreen.routePath,
                name: MapScreen.routeName,
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HistoryScreen.routePath,
                name: HistoryScreen.routeName,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: ScannerScreen.routePath,
        name: ScannerScreen.routeName,
        builder: (context, state) => const ScannerScreen(),
        routes: [
          GoRoute(path: ScannerDetailScreen.routePath,
            name: ScannerDetailScreen.routeName,
            builder: (context, state) => const ScannerDetailScreen(),
          ),
        ]
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
  );
}
