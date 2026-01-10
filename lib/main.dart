import 'package:diato_ai/core/routes/route.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Diato AI',
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
