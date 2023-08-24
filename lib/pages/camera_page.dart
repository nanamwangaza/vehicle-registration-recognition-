import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;//list of cameras
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
      if (!mounted) { //If not in widget tree the callback shouldn't continue executing, as it might cause errors or unwanted behavior
        return;
      }

      setState(() {});//triggers widget rebuild

      // Load stored image paths from SharedPreferences
    // final prefs = await SharedPreferences.getInstance();
    // List<String> storedImagePaths = prefs.getStringList('captured_images') ?? [];
    // capturedImages = storedImagePaths.map((path) => XFile(path)).toList();


      @override
      void dispose() {
        controller.dispose();
        super.dispose();
      }







   String locationMessage = 'Current location of the user';
  String address = ''; // Variable to hold the address
  late String lat;
  late String long;

  // Getting current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request');
    }

    return Geolocator.getCurrentPosition();
  }

  // Listen to location updates
  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'Latitude: $lat, Longitude: $long';
      });
    });
  }

  // Get address
  Future<void> _getAddressFromLatLong(Position position) async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    if (placemark.isNotEmpty) {
      final street = placemark[0].street ?? '';
      final subAdministrativeArea = placemark[0].subAdministrativeArea ?? '';
      final locality = placemark[0].locality ?? '';
      final administrativeArea = placemark[0].administrativeArea ?? '';
      final country = placemark[0].country ?? '';

      setState(() {
        address = '$street, $subAdministrativeArea, $locality, $administrativeArea, $country';
      });
    } else {
      setState(() {
        address = 'Address information not available';
      });
    }
  }


    }
    );
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
            if (pictureFile !=null) {
              _showFullscreenImageDialog(context, pictureFile.path);
              capturedImages.add(pictureFile);
            }
          },
          child: Text('Take Picture'),
        ),
        ElevatedButton(
          onPressed: () {
            _navigateToImageList(context);
          },
          child: Text('View Captured Photos'),
        ),
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

  void _deleteImage(int index, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Image'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Image deleted')),
                );
                Navigator.pop(context, true); // Signal image deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
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
            leading: Image.file(File(widget.images[index].path), width: 50, height: 50),
            title: Text('Image ${index + 1}'),
            trailing: IconButton(
              icon: Icon(Icons.delete,color:Colors.red ,),
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
