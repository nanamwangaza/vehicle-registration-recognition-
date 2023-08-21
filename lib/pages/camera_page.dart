import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {

  final List<CameraDescription>? cameras;
  const CameraPage({super.key,  this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});

      @override
      void dispose() {
        controller.dispose();
        super.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            pictureFile = await controller.takePicture();
            setState(() {});
          },
          child: Text('Take Picture'),
        ),
        if (pictureFile != null)
          GestureDetector(
            onTap: () {
              _showFullscreenImageDialog(context);
            },
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Image.file(File(pictureFile!.path)),
            ),
          ),
      ],
    );
  }

  void _showFullscreenImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              constraints: BoxConstraints.expand(),
              child: Image.file(File(pictureFile!.path), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }
}