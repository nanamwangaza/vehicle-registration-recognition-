import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
   Map<String, dynamic>? userData; // Store fetched user data

  // Future<void> fetchUserData() async {
  //   final apiUrl = 'YOUR_BACKEND_URL_HERE'; // Replace with your backend URL
  //   final response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     userData = jsonDecode(response.body);
  //     setState(() {}); // Refresh UI to display fetched data
  //   } else {
  //     print('Failed to fetch user data');
  //   }
  // }

  @override
  void initState() {
    super.initState();
   // fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: 
      Center(
        child: 
        // userData==null? CircularProgressIndicator():
         Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'First Name: ${userData?['firstName']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Last Name: ${userData?['lastName']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Email: ${userData?['email']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}

//user_data==null? CircularProgresssIndicator