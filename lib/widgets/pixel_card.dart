import 'package:flutter/material.dart';

class PixelCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const PixelCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 3.0,
    this.padding = const EdgeInsets.all(12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(2), // Max 2px as requested
          boxShadow: [
            BoxShadow(
              color: Colors.black, // Pure black hard shadow
              offset: const Offset(4, 4),
              blurRadius: 0, // No blur
            ),
          ],
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
