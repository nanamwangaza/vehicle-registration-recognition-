import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras; // list of cameras
  const CameraPage({this.cameras});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  List<XFile> capturedImages = [];

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
            XFile? pictureFile = await controller.takePicture();
          await uploadImageToBackend(pictureFile.path); //upload image to backend first
            _showFullscreenImageDialog(context, pictureFile.path);
            capturedImages.add(pictureFile);
          },
          child: Text('Take Photo'),
        ),
        
        // ElevatedButton(
        //   onPressed: () {
        //     _navigateToImageList(context);
        //   },
        //   child: Text('View Captured Photos'),
        // ),
      ],
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
              _navigateToImageList(context);
            },
            child: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.black, // Add a black background color
          child: Center(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain)),
            ),
          ),
        );
      },
    );
  }

  void _navigateToImageList(BuildContext context) async {
    bool imageDeleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageListPage(images: capturedImages),
      ),
    );

    if (imageDeleted) {
      setState(() {
        capturedImages.removeWhere((image) => !File(image.path).existsSync());
      });
    }
  }
}

class ImageListPage extends StatefulWidget {
  final List<XFile> images;

  ImageListPage({required this.images});

  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  bool _imageDeleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Captured Photos')),
      body: ListView.builder(
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              _showFullscreenImageDialog(context, widget.images[index].path);
            },
            leading: Image.file(
                File(widget.images[index].path),
                width: 50,
                height: 50),
            title: Text('Image ${index + 1}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
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
              constraints: BoxConstraints.expand(),
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
          title: Text('Delete Image'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the deletion
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the deletion
              },
              child: Text('Delete'),
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


Future<String> uploadImageToBackend(String imagePath) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('YOUR_BACKEND_URL/upload'), // Replace with actual API endpoint
  );

  request.files.add(await http.MultipartFile.fromPath('image', imagePath));

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return responseBody; // You can handle the response from the backend here
    }
  } catch (error) {
    print('Error uploading image: $error');
  }

  return '';
}
