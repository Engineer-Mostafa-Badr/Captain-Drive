// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;
//
// class VideoRecordingScreen extends StatefulWidget {
//   @override
//   _VideoRecordingScreenState createState() => _VideoRecordingScreenState();
// }
//
// class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
//   CameraController? _controller;
//   List<CameraDescription>? cameras;
//   bool _isRecording = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     cameras = await availableCameras();
//     if (cameras != null && cameras!.isNotEmpty) {
//       _controller = CameraController(cameras![0], ResolutionPreset.high);
//       await _controller!.initialize();
//       if (mounted) {
//         setState(() {});
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _startRecording() async {
//     if (_controller != null && _controller!.value.isInitialized) {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = join(directory.path, '${DateTime.now()}.mp4');
//       await _controller!.startVideoRecording();
//       setState(() {
//         _isRecording = true;
//       });
//     }
//   }
//
//   // Future<void> _stopRecording() async {
//   //   if (_controller != null && _controller!.value.isRecordingVideo) {
//   //     await _controller!.stopVideoRecording();
//   //     setState(() {
//   //       _isRecording = false;
//   //     });
//   //   }
//   // }
//   //save video
//   Future<void> _stopRecording() async {
//     if (_controller != null && _controller!.value.isRecordingVideo) {
//       XFile videoFile = await _controller!.stopVideoRecording();
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = join(directory.path, '${DateTime.now()}.mp4');
//       await videoFile.saveTo(filePath);
//       setState(() {
//         _isRecording = false;
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Record Video'),
//       ),
//       body: _controller == null || !_controller!.value.isInitialized
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//         children: [
//           CameraPreview(_controller!),
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: FloatingActionButton(
//                 onPressed: _isRecording ? _stopRecording : _startRecording,
//                 child: Icon(_isRecording ? Icons.stop : Icons.videocam),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
