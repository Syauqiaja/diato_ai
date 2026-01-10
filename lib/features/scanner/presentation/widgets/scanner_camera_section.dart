import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScannerCameraSection extends StatelessWidget {
  final CameraController? cameraController;
  final bool isInitialized;
  final String? error;
  final VoidCallback onRetry;

  const ScannerCameraSection({
    super.key,
    required this.cameraController,
    required this.isInitialized,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Show loading while initializing
    if (!isInitialized || cameraController == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(color: Colors.blueGrey, height: 64, width: 64, child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    // Show camera preview
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(top: kToolbarHeight + 32, left: 24, right: 24),
      clipBehavior: Clip.hardEdge,
      child: CameraPreview(cameraController!),
    );
  }
}
