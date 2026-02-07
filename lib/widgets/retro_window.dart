import 'package:flutter/material.dart';

/// Retro Browser Window Frame Widget
/// Looks like an old Windows 95/98 browser window
class RetroWindow extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;
  final bool isSelected;

  const RetroWindow({
    super.key,
    required this.title,
    required this.child,
    this.onMinimize,
    this.onMaximize,
    this.onClose,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC0C0C0), // Windows gray
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Bar
          _buildTitleBar(),
          // Content area with inner border
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF000080) : const Color(0xFF808080),
        border: const Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: Row(
        children: [
          // Window icon (pixel square)
          Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: const Center(
              child: Text('◆', style: TextStyle(fontSize: 8, color: Colors.black)),
            ),
          ),
          // Title
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Window control buttons
          _buildWindowButton('_', onMinimize),
          const SizedBox(width: 2),
          _buildWindowButton('□', onMaximize),
          const SizedBox(width: 2),
          _buildWindowButton('×', onClose),
        ],
      ),
    );
  }

  Widget _buildWindowButton(String symbol, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: const Color(0xFFC0C0C0),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Center(
          child: Text(
            symbol,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
