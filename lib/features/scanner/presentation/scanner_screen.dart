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
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;

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
      
      final backCamera = cameras.indexWhere((e) => e.lensDirection == CameraLensDirection.back);
      if(backCamera != -1){
        _currentCameraIndex = backCamera;
      }

      _cameras = cameras;

      await _startCamera();
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize camera: ${e.toString()}';
      });
    }
  }

  Future<void> _startCamera() async {
    // Use the camera at current index
    final camera = _cameras[_currentCameraIndex];

    // Dispose previous controller if exists
    await _cameraController?.dispose();

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

    // Set flash mode after initialization
    await _cameraController!.setFlashMode(_flashMode);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _rotateCamera() async {
    if (_cameras.length <= 1) {
      // Only one camera available, show message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No other cameras available'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    setState(() {
      _isInitialized = false;
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    });

    await _startCamera();
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      // Cycle through flash modes: off -> auto -> always -> torch -> off
      FlashMode newFlashMode;
      switch (_flashMode) {
        case FlashMode.off:
          newFlashMode = FlashMode.torch;
          break;
        case FlashMode.torch:
          newFlashMode = FlashMode.off;
          break;
        default:
          newFlashMode = FlashMode.off;
          break;
      }

      await _cameraController!.setFlashMode(newFlashMode);

      setState(() {
        _flashMode = newFlashMode;
      });
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
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
            ScannerBottomAppBar(
              onRotateCamera: _rotateCamera,
              onToggleFlash: _toggleFlash,
              flashMode: _flashMode,
            ),
          ],
        ),
      ),
    );
  }
}
