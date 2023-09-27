import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_registration/pages/camera_page.dart';
import 'package:vehicle_registration/pages/geolocator.dart';
import 'package:vehicle_registration/pages/records.dart';
import 'package:vehicle_registration/pages/user_profile.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF003366),
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello Nana!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Dar-es-Salaam, Tanzania',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),

                  Image.asset(
                    'assets/images/car.jpg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  _buildActionButton(Icons.camera_alt, 'Take Photo', () async {
                    await availableCameras().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraPage(cameras: value),
                        ),
                      ),
                    );
                  }),
                  _buildActionButton(Icons.image, 'Records', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResponsesScreen()
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
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Card(
      color: Color(0xFF003366),
      child: SizedBox(
        width: 200,
        height: 50,
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
