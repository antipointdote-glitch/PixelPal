import 'package:flutter/material.dart';

/// Tamagotchi-style A/B/C Control Buttons
/// A = Select/Scroll, B = Confirm/Action, C = Cancel/Back
class TamagotchiControls extends StatelessWidget {
  final VoidCallback? onA;
  final VoidCallback? onB;
  final VoidCallback? onC;
  
  const TamagotchiControls({
    super.key,
    this.onA,
    this.onB,
    this.onC,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF404040),
        border: Border(
          top: BorderSide(color: Colors.black, width: 3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton('A', 'SELECT', onA),
          _buildButton('B', 'ACTION', onB),
          _buildButton('C', 'BACK', onC),
        ],
      ),
    );
  }

  Widget _buildButton(String letter, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pixel button
          Container(
            width: 44,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF808080),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0),
              ],
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Label
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
