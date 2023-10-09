import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/car.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.8),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                GlowingText(
                  text: 'WELCOME TO',
                  textStyle: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  glowColor: const Color(0xFF003366),
                ),
                const SizedBox(height: 200),
                Center(
                  child: GlowingText(
                    text: 'VEHICLE LICENSE PLATE RECOGNITION',
                    textStyle: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    glowColor: const Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 150),
                GlowingButton(
                  color1: const Color(0xFF003366),
                  color2: const Color(0xFF003366),
                  text: 'Get Started',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signup(),
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
