import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:vehicle_registration/pages/camera_page.dart';
import 'package:vehicle_registration/pages/launch_camera.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // int _currentIndex = 0;
  // final List<Widget> children=[
  //   Home(),
  //   LaunchCamera(),
  //   Home()
  // ];

  // void onTappedBar(int newIndex){
  //   setState(() {
  //     _currentIndex=newIndex;
  //   });
  // }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: onTappedBar,
      //   currentIndex: _currentIndex,
      //   items: <BottomNavigationBarItem>[

        

      //      BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),

      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.camera),
      //       label: 'Take photos',
      //     ),
          
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.photo_album),
      //       label: 'View Photos',
      //     ),
      //   ]
      //   ),
      body: 
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
            Container(
              padding: EdgeInsets.only(top: 40,left: 20,right: 20,bottom: 20),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello Nana!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            Text('Dar-es-Salaam, Tanzania')
                          ],
                        ),
                        Icon(Icons.person)
                      ],
                    ),
                  )
                ],
              ),
              
            ),

            //  children [_currentIndex]
        
        ],
      ),
    );
  }
}