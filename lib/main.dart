import 'package:flutter/material.dart';
// import 'package:vehicle_registration/pages/camera_page.dart';
// import 'package:vehicle_registration/pages/geolocator.dart';
// import 'package:vehicle_registration/pages/home.dart';
// import 'package:vehicle_registration/pages/home_pro.dart';
// import 'package:vehicle_registration/pages/launch_camera.dart';
// import 'package:vehicle_registration/pages/login_page.dart';
// import 'package:vehicle_registration/pages/signup.dart';
import 'package:vehicle_registration/pages/camera_page.dart';
import 'package:vehicle_registration/pages/geolocator.dart';
import 'package:vehicle_registration/pages/home.dart';
import 'package:vehicle_registration/pages/home_pro.dart';
import 'package:vehicle_registration/pages/launch_camera.dart';
import 'package:vehicle_registration/pages/login_page.dart';

import 'package:vehicle_registration/pages/signup.dart';
import 'package:vehicle_registration/pages/user_profile.dart';
import 'package:vehicle_registration/pages/welcome_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF006494)),
        useMaterial3: true,
      ),
      home:const WelcomePage()
    );
  }
}





