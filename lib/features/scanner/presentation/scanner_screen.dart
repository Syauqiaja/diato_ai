import 'package:camera/camera.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/scanner/presentation/widgets/scanner_bottom_app_bar.dart';
import 'package:diato_ai/features/scanner/presentation/widgets/scanner_camera_section.dart';
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
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Get available cameras
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _error = 'No cameras found on this device';
        });
        return;
      }

      // Use the first camera (usually back camera)
      final camera = cameras.first;

      // Create camera controller
      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Initialize the controller
      _initializeControllerFuture = _cameraController!.initialize();

      await _initializeControllerFuture;

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize camera: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        color: AppTheme.secondaryCanvasColor,
        child: Stack(
          children: [
            ScannerCameraSection(
              cameraController: _cameraController,
              isInitialized: _isInitialized,
              error: _error,
              onRetry: () {
                setState(() {
                  _error = null;
                });
                _initializeCamera();
              },
            ),
            ScannerTopAppBar(),
            ScannerBottomAppBar()
          ],
        ),
      ),
    );
  }

}
