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
        title: const Text('Peta Diatom'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 48 + kBottomNavigationBarHeight),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          color: Colors.grey[300],
          ),
          child: const Center(
            child: Text(
              'Map View Placeholder',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}