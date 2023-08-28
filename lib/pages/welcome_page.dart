import 'package:flutter/material.dart';
import 'package:vehicle_registration/pages/signup.dart';
import '../widgets/glowing_button.dart';
import '../widgets/glowing_text_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/car.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container( 
          color: Colors.black.withOpacity(0.8), // Adjust the opacity as needed
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
             GlowingText(
                    text: 'WELCOME TO',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    glowColor: Color(0xFF003366),
                  ),
                SizedBox(height: 200),
                Center(
                  child: GlowingText(
                    text: 'VEHICLE LICENSE PLATE RECOGNITION',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    glowColor: Color(0xFF003366),
                  ),
                ),
                SizedBox(height: 150),
                GlowingButton(
                  color1: Color(0xFF003366),
                  color2:Color(0xFF003366),
                  text: 'Get Started',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signup(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




