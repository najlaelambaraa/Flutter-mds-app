import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;

  const CustomIconButton({required this.icon, required this.onPressed, this.iconSize = 40.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, 
      height: 150, 
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), 
          ),
         backgroundColor: Color(0xFF4A919E),
       
        ),
        child: Icon(icon, color: Colors.white), 
      ),
    );
  }
}