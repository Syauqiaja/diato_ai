import 'package:diato_ai/features/diatom_calculator/presentation/diatom_calculator_screen.dart';
import 'package:diato_ai/features/diatom_calculator/presentation/saved_calculations_screen.dart';
import 'package:diato_ai/features/app_layout/app_layout.dart';
import 'package:diato_ai/features/explore/presentation/explore_screen.dart';
import 'package:diato_ai/features/contents/presentation/content_detail_screen.dart';
import 'package:diato_ai/features/home/presentation/home_screen.dart';
import 'package:diato_ai/features/map/presentation/map_screen.dart';
import 'package:diato_ai/features/scanner/presentation/scanner_screen.dart';
import 'package:diato_ai/features/species/presentation/species_detail_screen.dart';
import 'package:diato_ai/features/setting/presentation/app_info_screen.dart';
import 'package:diato_ai/features/setting/presentation/developer_info_screen.dart';
import 'package:diato_ai/features/setting/presentation/settings_screen.dart';
import 'package:diato_ai/features/setting/presentation/usage_guide_screen.dart';
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
            routes: [GoRoute(path: HomeScreen.routePath, name: HomeScreen.routeName, builder: (context, state) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: ExploreScreen.routePath, name: ExploreScreen.routeName, builder: (context, state) => const ExploreScreen(), routes: [
                  
                ],
              )],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: MapScreen.routePath, name: MapScreen.routeName, builder: (context, state) => const MapScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: DiatomCalculatorScreen.routePath,
                name: DiatomCalculatorScreen.routeName,
                builder: (context, state) => const DiatomCalculatorScreen(),
                routes: [
                  GoRoute(
                    path: SavedCalculationsScreen.routePath,
                    name: SavedCalculationsScreen.routeName,
                    builder: (context, state) => const SavedCalculationsScreen(),
                  ),
                ],
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
          GoRoute(
            path: ScannerDetailScreen.routePath,
            name: ScannerDetailScreen.routeName,
            builder: (context, state) =>
                ScannerDetailScreen(imagePath: state.extra as String?),
          ),
        ],
      ),
      GoRoute(
        path: ContentDetailScreen.routePath,
        name: ContentDetailScreen.routeName,
        builder: (context, state) {
          final contentId = int.parse(state.pathParameters['contentId']!);
          return ContentDetailScreen(contentId: contentId);
        },
      ),
      GoRoute(
        path: SpeciesDetailScreen.routePath,
        name: SpeciesDetailScreen.routeName,
        builder: (context, state) {
          final speciesId = int.parse(state.pathParameters['speciesId']!);
          return SpeciesDetailScreen(speciesId: speciesId);
        },
      ),
      GoRoute(
        path: SettingsScreen.routePath,
        name: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: AppInfoScreen.routePath,
            name: AppInfoScreen.routeName,
            builder: (context, state) => AppInfoScreen(),
          ),
          GoRoute(
            path: UsageGuideScreen.routePath,
            name: UsageGuideScreen.routeName,
            builder: (context, state) => UsageGuideScreen(),
          ),
          GoRoute(
            path: DeveloperInfoScreen.routePath,
            name: DeveloperInfoScreen.routeName,
            builder: (context, state) => DeveloperInfoScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Page not found \n${state.error}'))),
  );
}
