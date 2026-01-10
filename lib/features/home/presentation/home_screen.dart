import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  static const String routePath = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('Welcome to Diato AI Home Screen!'),
      ),
    );
  }
}