import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:vehicle_registration/pages/home.dart';
import 'package:vehicle_registration/pages/launch_camera.dart';
import 'package:vehicle_registration/pages/login_page.dart';
import 'package:vehicle_registration/pages/logout.dart';
//import 'package:vehicle_registration/pages/signup.dart';
//import 'package:vehicle_registration/pages/user_profile.dart';





class HomePro extends StatefulWidget {
  const HomePro({super.key,});

  @override
  State<HomePro> createState() => _HomeProState();
}

class _HomeProState extends State<HomePro> {

 
   
  int _currentIndex = 0;

 // List<XFile> capturedImages = [];
  final List<Widget> children=[

    const Home(),
  //const Login()

  ];
  void onTappedBar(int newIndex) {
    if (newIndex == 1) {
      // Logout clicked
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Confirm Logout'),
            content: Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                  // Perform logout actions here (backend and local)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Text('Logout'),
              ),

//               ElevatedButton(
//   onPressed: () async {
//     final apiUrl = 'https://your-backend-url.com/api/logout';

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Authorization': 'Bearer YOUR_AUTH_TOKEN'}, // Include the user's token
//     );

//     if (response.statusCode == 200) {
//       // Logout successful, navigate to login page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } else {
//       // Handle logout failure
//       showDialog(
//         context: context,
//         builder: (BuildContext dialogContext) {
//           return AlertDialog(
//             title: Text('Logout Failed'),
//             content: Text('Failed to logout. Please try again.'),
//             actions: <Widget>[
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(dialogContext).pop(); // Close the error dialog
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   },
//   child: Text('Logout'),
// ),



            ],
          );
        },
      );
    } else {
      setState(() {
        _currentIndex = newIndex;
      });
    }
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

          // BottomNavigationBarItem(
          //   icon: Icon(Icons.camera),
          //   label: 'Take photos',
          // ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ]
        ),
      body: 
     children[_currentIndex]
    );
  }
}