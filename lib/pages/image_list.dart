
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
      appBar: _buildAppBar(),
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

 AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF003366),
              Colors.black,
            ], // Gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello Nana!',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
          ),
          Text(
            'Dar-es-Salaam, Tanzania',
            style: TextStyle(
              color:Colors.white ,
              fontSize: 15// Text color
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white, // Icon color
          ),
          onPressed: () {},
        ),
      ],
    );
 }