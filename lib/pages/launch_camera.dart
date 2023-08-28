import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';

class LaunchCamera extends StatefulWidget {
  const LaunchCamera({super.key});

  @override
  State<LaunchCamera> createState() => _LaunchCameraState();
}

class _LaunchCameraState extends State<LaunchCamera> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: ()async{
               await availableCameras().then(  //waits for list of available cameras, then goes to the CameraPage
                (value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraPage(cameras:value))) 
                //value is the list of available cameras
                );
                },
                child: Text('Launch Camera',style: TextStyle(color: Color(0xFF006494)),)
                ),
          )
        ],
      ),
    );
  }
}