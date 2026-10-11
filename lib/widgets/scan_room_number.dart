import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanRoomNumber extends StatelessWidget {
  const ScanRoomNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return CameraView();
  }
}

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<StatefulWidget> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? controller;
  final TextRecognizer recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  String text = '';

  Future<void> recognizeText() async {
    if (controller == null) {
      return;
    } else if (!controller!.value.isInitialized) {
      return;
    }

    final image = await controller!.takePicture();
    final inputImg = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await recognizer.processImage(
      inputImg,
    );

    setState(() {
      text = recognizedText.text;
    });
  }

  @override
  void initState() {
    super.initState();

    late List<CameraDescription> cameras;

    (() async {
      cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller!
          .initialize()
          .then((_) {
            if (!mounted) {
              return;
            }
            setState(() {});
          })
          .catchError((Object e) {
            if (e is CameraException) {
              switch (e.code) {
                case 'CameraAccessDenied':
                  log('Camera access denied');
                  break;
                default:
                  log('Camera access denied');
                  break;
              }
            }
          });
    })();
  }

  @override
  void dispose() {
    controller!.dispose();
    recognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Text('loading');
    } else if (!controller!.value.isInitialized) {
      return Text('loading');
    }

    return Stack(
      children: [
        CameraPreview(controller!),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: recognizeText,
              child: const Text('scan text'),
            ),
          ),
        ),
        if (text.isNotEmpty)
          Positioned(top: 50, left: 20, right: 20, child: Text(text)),
      ],
    );
  }
}
