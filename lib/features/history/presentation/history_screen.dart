import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history';
  static const String routePath = '/history';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Screen'),
      ),
      body: const Center(
        child: Text('Welcome to Diato AI History Screen!'),
      ),
    );
  }
}