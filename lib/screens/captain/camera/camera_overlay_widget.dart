import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraOverlayWidget extends StatefulWidget {
  const CameraOverlayWidget({super.key});

  @override
  State<CameraOverlayWidget> createState() => _CameraOverlayWidgetState();
}

class _CameraOverlayWidgetState extends State<CameraOverlayWidget> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.low);
    await _cameraController.initialize();
    setState(() => _isLoading = false);

    _startRecording();
  }

  _startRecording() async {
    if (!_isRecording) {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else {
      return Stack(
        children: [
          CameraPreview(_cameraController),
        ],
      );
    }
  }
}
