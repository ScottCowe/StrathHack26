import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanRoomNumber extends StatefulWidget {
  const ScanRoomNumber({super.key, required this.onDetect});

  final void Function(String roomNumber) onDetect;

  @override
  State<StatefulWidget> createState() => _CameraViewState();
}

class _CameraViewState extends State<ScanRoomNumber> {
  CameraController? controller;
  final TextRecognizer recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  String roomNumber = '';

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

    RegExp re = RegExp(r'\b[A-Z]{2}\d{3,4}\b');
    RegExpMatch? roomNumberRe = re.firstMatch(recognizedText.text);

    if (roomNumberRe != null) {
      roomNumber = roomNumberRe[0]!;
    }

    setState(() {
      widget.onDetect(roomNumber);
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
    recognizer.close();
    controller!.dispose();
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
          child: Center(
            child: ElevatedButton(
              onPressed: recognizeText,
              child: const Text("Scan"),
            ),
          ),
        ),
      ],
    );
  }
}
