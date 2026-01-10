import 'package:diato_ai/features/scanner/presentation/widgets/scanner_bottom_app_bar.dart';
import 'package:diato_ai/features/scanner/presentation/widgets/scanner_top_app_bar.dart';
import 'package:flutter/material.dart';


class ScannerScreen extends StatefulWidget {
  static const String routeName = 'scanner';
  static const String routePath = '/scanner';
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          ScannerTopAppBar(),
          ScannerBottomAppBar()
        ],
      ),
    );
  }

}
