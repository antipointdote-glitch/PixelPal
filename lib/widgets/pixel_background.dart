import 'package:flutter/material.dart';

/// Pixelated Background Patterns
/// Two patterns: Blue Sky and Gray Desktop
class PixelBackground extends StatelessWidget {
  final bool isBlueSky; // true = blue sky, false = gray desktop
  final Widget child;

  const PixelBackground({
    super.key,
    required this.isBlueSky,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isBlueSky ? const Color(0xFF008080) : const Color(0xFF008080),
      ),
      child: CustomPaint(
        painter: _PixelPatternPainter(isBlueSky: isBlueSky),
        child: child,
      ),
    );
  }
}

class _PixelPatternPainter extends CustomPainter {
  final bool isBlueSky;

  _PixelPatternPainter({required this.isBlueSky});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    const pixelSize = 8.0;

    if (isBlueSky) {
      // Blue sky with pixel clouds pattern
      paint.color = const Color(0xFF00AAAA); // Teal base
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

      // Draw pixel "clouds" pattern
      paint.color = const Color(0xFF55FFFF);
      for (double y = 0; y < size.height; y += pixelSize * 4) {
        for (double x = 0; x < size.width; x += pixelSize * 6) {
          final offsetX = ((y / pixelSize) % 2 == 0) ? pixelSize * 2 : 0;
          canvas.drawRect(
            Rect.fromLTWH(x + offsetX, y, pixelSize, pixelSize),
            paint,
          );
        }
      }
    } else {
      // Gray desktop checker pattern (like Windows 95)
      paint.color = const Color(0xFF008080); // Teal base
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

      // Draw checker pattern
      paint.color = const Color(0xFF006666);
      for (double y = 0; y < size.height; y += pixelSize * 2) {
        for (double x = 0; x < size.width; x += pixelSize * 2) {
          final isOdd = ((x + y) / (pixelSize * 2)) % 2 == 0;
          if (isOdd) {
            canvas.drawRect(
              Rect.fromLTWH(x, y, pixelSize, pixelSize),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
