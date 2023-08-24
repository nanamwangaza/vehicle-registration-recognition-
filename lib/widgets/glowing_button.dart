import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final Color color1;
  final Color color2;
  final String text;
  final VoidCallback? onTap;

  const GlowingButton({
    Key? key,
    required this.color1,
    required this.color2,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  var glowing = false;
  var scale = 1.0;

  void _startGlowingAnimation() {
    setState(() {
      glowing = true;
      scale = 1.1;
    });
  }

  void _stopGlowingAnimation() {
    setState(() {
      glowing = false;
      scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (_) {
        if (widget.onTap != null) {
          widget.onTap!();
        }
        _stopGlowingAnimation();
      },
      onTapDown: (_) {
        _startGlowingAnimation();
      },
      onTapCancel: () {
        _stopGlowingAnimation();
      },
      child: AnimatedContainer(
        transform: Matrix4.identity()..scale(scale),
        duration: Duration(milliseconds: 100),
        height: 48,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [widget.color1, widget.color2]),
          boxShadow: glowing
              ? [
                  BoxShadow(
                    color: widget.color1.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 32,
                    offset: Offset(-8, 0),
                  ),
                  BoxShadow(
                    color: widget.color1.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 32,
                    offset: Offset(8, 0),
                  ),
                ]
              : [],
        ),
        child: TextButton(
          onPressed: widget.onTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.transparent,
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
