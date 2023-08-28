import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:vehicle_registration/pages/camera_page.dart';
import 'package:vehicle_registration/pages/launch_camera.dart';
//import 'package:vehicle_registration/pages/signup.dart';
//import 'package:vehicle_registration/pages/user_profile.dart';
import 'home.dart';




class HomePro extends StatefulWidget {
  const HomePro({super.key,});

  @override
  State<HomePro> createState() => _HomeProState();
}

class _HomeProState extends State<HomePro> {

 
   
  int _currentIndex = 0;
  List<XFile> capturedImages = [];
  final List<Widget> children=[
    const Home(),
   const  LaunchCamera(),
  ImageListPage(images:const [])
  ];
  void onTappedBar(int newIndex){
    setState(() {
      _currentIndex=newIndex;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        selectedItemColor: const  Color(0xFF006494),
        items: const <BottomNavigationBarItem>[

        

           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Take photos',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'View Photos',
          ),
        ]
        ),
      body: 
     children[_currentIndex]
    );
  }
}