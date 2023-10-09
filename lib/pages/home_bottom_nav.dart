import 'package:flutter/material.dart';
import 'package:vehicle_registration/pages/home.dart';
import 'package:vehicle_registration/pages/login_page.dart';

class HomePro extends StatefulWidget {
  const HomePro({
    super.key,
  });

  @override
  State<HomePro> createState() => _HomeProState();
}

class _HomeProState extends State<HomePro> {
  int _currentIndex = 0;

  final List<Widget> children = [
    const Home(),
  ];
  void onTappedBar(int newIndex) {
    if (newIndex == 1) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text('Logout'),
              ),
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
            selectedItemColor: const Color(0xFF006494),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Logout',
              ),
            ]),
        body: children[_currentIndex]);
  }
}
