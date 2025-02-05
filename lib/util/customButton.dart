import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final Color borderColor;
  final double borderRadius;
  final double fontSize;
  final EdgeInsets padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.gradientColors = const [Colors.blue, Colors.purple],
    this.borderColor = Colors.white,
    this.borderRadius = 10.0,
    this.fontSize = 20.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors, // Custom gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor, width: 2), // Custom border
          ),
          backgroundColor: Colors.transparent, // Transparent to show gradient
          shadowColor: Colors.transparent, // No default shadow
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: Colors.white), // Custom text style
        ),
      ),
    );
  }
}
