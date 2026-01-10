import 'package:diato_ai/features/home/presentation/widgets/home_app_bar.dart';
import 'package:diato_ai/features/home/presentation/widgets/home_body_section.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  static const String routePath = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          HomeAppBar(scrollController: _scrollController),
          HomeBodySection(),
        ],
      ),
    );
  }
}
