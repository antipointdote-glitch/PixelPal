import 'package:flutter/material.dart';

class PixelButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;

  const PixelButton({
    super.key, 
    required this.label, 
    required this.onPressed,
    this.icon,
    this.color = const Color(0xFF80DEEA), // Default Cyan
    this.size = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                )
              ]
            ),
            child: Icon(icon ?? Icons.circle, size: size * 0.5, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: const TextStyle(
            fontFamily: 'Courier', 
            fontWeight: FontWeight.bold, 
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
