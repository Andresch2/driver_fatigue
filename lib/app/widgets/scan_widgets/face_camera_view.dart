import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FaceCameraView extends StatelessWidget {
  final CameraController cameraController;
  final bool isProcessing;
  final AnimationController ringController;

  const FaceCameraView({
    super.key,
    required this.cameraController,
    required this.isProcessing,
    required this.ringController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CameraPreview(cameraController),
        ),
        if (!isProcessing)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 3),
            ),
            child: const Center(
              child: Icon(
                Icons.face_retouching_natural,
                size: 50,
                color: Colors.white70,
              ),
            ),
          ),
        if (isProcessing)
          SizedBox(
            width: 220,
            height: 220,
            child: AnimatedBuilder(
              animation: ringController,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: ringController.value,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                );
              },
            ),
          ),
      ],
    );
  }
}
