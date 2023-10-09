import 'package:flutter/material.dart';

class GlowingText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color glowColor;
  final TextAlign? textAlign;

  const GlowingText({
    Key? key,
    required this.text,
    required this.textStyle,
    required this.glowColor,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle.copyWith(
        shadows: [
          Shadow(
            color: glowColor,
            offset: const Offset(0, 0),
            blurRadius: 30,
          ),
          Shadow(
            color: glowColor,
            offset: const Offset(0, 0),
            blurRadius: 40,
          ),
          Shadow(
            color: glowColor,
            offset: const Offset(0, 0),
            blurRadius: 45,
          ),
        ],
      ),
    );
  }
}
