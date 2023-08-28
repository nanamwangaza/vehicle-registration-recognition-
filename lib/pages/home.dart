import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_registration/pages/camera_page.dart';
import 'package:vehicle_registration/pages/geolocator.dart';
import 'package:vehicle_registration/pages/launch_camera.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Added app bar
      body: Container(
        color: Colors.white, // White background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'Hello Nana!',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 26,
                          //     color: Color(0xFF003366), // Text color
                          //   ),
                          // ),
                          // Text(
                          //   'Dar-es-Salaam, Tanzania',
                          //   style: TextStyle(
                          //     color: Color(0xFF003366), // Text color
                          //   ),
                          // )
                        ],
                      ),
                      InkWell(
                        child: Icon(
                          Icons.person,
                          color: Colors.white, // Text color
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/car.jpg', // Replace with your image asset
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),

                  _buildActionButton(Icons.camera_alt, 'Take Photo', ()async {
                    await availableCameras().then(  //waits for list of available cameras, then goes to the CameraPage
                (value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraPage(cameras:value))) 
                //value is the list of available cameras
                );
                  }
                  ),
                  _buildActionButton(Icons.image, 'Gallery', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageListPage(images: []),
                      ),
                    );
                  }),
                  _buildActionButton(Icons.location_on, 'My location', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserLocation(),
                      ),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Card(
      color: Color(0xFF003366), // Card color
      child: SizedBox(
        width: 200,
        height: 50,
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white), // Icon color
              SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.white)), // Text color
            ],
          ),
        ),
      ),
    );
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
}
