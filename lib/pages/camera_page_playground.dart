// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../helper/database_helper.dart';

class CameraPagePlayGround extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPagePlayGround({super.key, this.cameras});

  @override
  _CameraPagePlayGroundState createState() => _CameraPagePlayGroundState();
}

class _CameraPagePlayGroundState extends State<CameraPagePlayGround> {
  double _zoomLevel = 1.0;
  late CameraController controller;
  List<XFile> capturedImages = [];
  XFile? currentImage;

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
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget previewWidget;

    if (currentImage == null) {
      previewWidget = Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Pick photo'),
                onPressed: () async {
                  final pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (pickedImage != null) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                constraints: const BoxConstraints.expand(),
                                child: Image.file(
                                  File(pickedImage.path),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          ],
                        );
                      },
                    );

                    final imageBytes =
                        await File(pickedImage.path).readAsBytes();
                    final base64Image = base64Encode(imageBytes);

                    final response = await uploadImageToBackend(base64Image);
                    Map<String, dynamic> jsonResponse = json.decode(response);
                    String plateNumber = jsonResponse["plate_number"];

                    Navigator.of(context).pop();
                    if (plateNumber.isNotEmpty) {
                      await DBHelper.instance.insertResponse(response);

                      showDialog(
                        context: context,
                        builder: (context) {
                          return Stack(
                            children: [
                              Container(
                                color: Colors.black,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              AlertDialog(
                                contentPadding: const EdgeInsets.only(
                                    top: 0, left: 20, right: 20),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          color: Colors.black45,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Success!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    const Center(
                                      child: Text(
                                        'Your license plate image is successfully uploaded',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 100),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 3.0,
                                        ),
                                      ),
                                      child: const CircleAvatar(
                                        radius: 50.0,
                                        backgroundColor: Colors.transparent,
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.green,
                                          size: 70.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(plateNumber,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 100),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      width: 200,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'CONTINUE',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      );

                      setState(() {
                        capturedImages.add(XFile(pickedImage.path));
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Stack(
                            children: [
                              Container(
                                color: Colors.black,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              AlertDialog(
                                backgroundColor:
                                    const Color.fromARGB(255, 218, 20, 20),
                                contentPadding: const EdgeInsets.only(
                                    top: 0, left: 20, right: 20),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          color: Colors.black45,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Error!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    const Center(
                                      child: Text(
                                        'Ooops! Something went wrong',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Center(
                                      child: Text(
                                        'Your license plate image is not successfully uploaded',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 80),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3.0,
                                        ),
                                      ),
                                      child: const CircleAvatar(
                                        radius: 50.0,
                                        backgroundColor: Colors.transparent,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 70.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const SizedBox(height: 100),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      width: 200,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'TRY AGAIN',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    setState(() {
                      capturedImages.add(pickedImage);
                      currentImage = null;
                    });
                  }
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (_zoomLevel > 1.0) {
                    _zoomLevel -= 0.1;
                    controller.setZoomLevel(_zoomLevel);
                  }
                },
                icon: const Icon(Icons.zoom_out),
              ),
              IconButton(
                onPressed: () {
                  if (_zoomLevel < 5.0) {
                    _zoomLevel += 0.1;
                    controller.setZoomLevel(_zoomLevel);
                  }
                },
                icon: const Icon(Icons.zoom_in),
              ),
            ],
          ),
        ],
      );
    } else {
      previewWidget = Column(
        children: [
          Expanded(
            child: Image.file(
              File(currentImage!.path),
              fit: BoxFit.contain,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentImage = null;
                  });
                },
                child: const Text('Retake Photo'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final imageFile = File(currentImage!.path);
                  final imageBytes = await imageFile.readAsBytes();
                  final base64Image = base64Encode(imageBytes);

                  final response = await uploadImageToBackend(base64Image);
                  Map<String, dynamic> jsonResponse = json.decode(response);
                  String plateNumber = jsonResponse["plate_number"];

                  if (response.isNotEmpty) {
                    await DBHelper.instance.insertResponse(response);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.only(
                              top: 0, left: 20, right: 20),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    color: Colors.black45,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Success!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(height: 50),
                              const Center(
                                child: Text(
                                  'Your license plate image is successfully uploaded',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 100),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 3.0,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.green,
                                    size: 70.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(plateNumber,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 100),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'CONTINUE',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Stack(
                          children: [
                            Container(
                              color: Colors.black,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            AlertDialog(
                              backgroundColor:
                                  const Color.fromARGB(255, 218, 20, 20),
                              contentPadding: const EdgeInsets.only(
                                  top: 0, left: 20, right: 20),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        color: Colors.black45,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Error!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  const Center(
                                    child: Text(
                                      'Ooops! Something went wrong',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      'Your license plate image is successfully uploaded',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 80),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3.0,
                                      ),
                                    ),
                                    child: const CircleAvatar(
                                      radius: 50.0,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 70.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(response,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 100),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    width: 200,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'TRY AGAIN',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  setState(() {
                    capturedImages.add(currentImage!);
                    currentImage = null;
                  });
                },
                child: const Text('Save Photo'),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: previewWidget,
        ),
      ],
    );
  }

  Future<String> uploadImageToBackend(String base64Image) async {
    final Uri url = Uri.parse('http://127.0.0.1:8000/create-vehicle/');
    final Map<String, dynamic> requestBody = {
      'image': base64Image,
      'gps_details': '12.3456,78.9012',
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;

        return responseBody;
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return Stack(
              children: [
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: double.infinity,
                ),
                AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 218, 20, 20),
                  contentPadding:
                      const EdgeInsets.only(top: 0, left: 20, right: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            color: Colors.black45,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Error!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Center(
                        child: Text(
                          'Ooops! Something went wrong',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Your license plate image is not successfully uploaded',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 70.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 100),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'TRY AGAIN',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }

    return '';
  }
}

class ImageListPage extends StatefulWidget {
  final List<XFile> images;

  const ImageListPage({super.key, required this.images});

  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  // ignore: unused_field
  late bool _imageDeleted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Photos')),
      body: ListView.builder(
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              _showFullscreenImageDialog(context, widget.images[index].path);
            },
            leading: Image.file(File(widget.images[index].path),
                width: 50, height: 50),
            title: Text('Image ${index + 1}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteImage(index, context);
              },
            ),
          );
        },
      ),
    );
  }

  void _showFullscreenImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteImage(int index, BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed) {
      setState(() {
        widget.images.removeAt(index);
        _imageDeleted = true;
      });
    }
  }
}
