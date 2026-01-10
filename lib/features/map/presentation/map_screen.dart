import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = 'map';
  static const String routePath = '/map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: const Center(
        child: Text('Welcome to Diato AI Map Screen!'),
      ),
    );
  }
}