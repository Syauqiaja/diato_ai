import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/linear_line.dart';

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
      body: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16, 
          bottom: 48 + kBottomNavigationBarHeight
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'PETA',
                          style: context.textTheme.displayMedium?.copyWith(
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                        Text(
                          'Peta Sebaran Lokasi Diatom',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          
              LinearLine(),
          
              SizedBox(height: 16),
          
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}
