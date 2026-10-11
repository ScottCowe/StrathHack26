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

  Timer? timer;

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
      RegExp re = RegExp(r'\b[A-Z]{2}\d{3,4}\b');
      roomNumber = re.firstMatch(recognizedText.text).toString();
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

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => recognizeText());
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

    return CameraPreview(controller!);
  }
}
