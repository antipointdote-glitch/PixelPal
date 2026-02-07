import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/pet_selection_page.dart';
import '../pages/user_page.dart';
import '../pages/setup_page.dart';

/// A wrapper that provides Win95 taskbar with floating Start menu overlay
/// The Start menu floats on the left side of the screen on top of content
class Win95PageWithTaskbar extends StatefulWidget {
  final String currentPage;
  final Widget child;
  final Color backgroundColor;

  const Win95PageWithTaskbar({
    super.key,
    required this.currentPage,
    required this.child,
    this.backgroundColor = const Color(0xFF008080),
  });

  @override
  State<Win95PageWithTaskbar> createState() => _Win95PageWithTaskbarState();
}

class _Win95PageWithTaskbarState extends State<Win95PageWithTaskbar> {
  bool _showStartMenu = false;
  int _hoveredIndex = -1;

  // Win95 Colors
  static const Color winGray = Color(0xFFC0C0C0);
  static const Color winBlue = Color(0xFF000080);
  static const Color winDarkGray = Color(0xFF808080);
  static const Color winWhite = Color(0xFFFFFFFF);

  String get _currentTime {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _navigateTo(String page) {
    setState(() => _showStartMenu = false);
    
    if (page == widget.currentPage) return;
    
    Widget destination;
    switch (page) {
      case 'Main':
        destination = const HomePage();
        break;
      case 'Adopt':
        destination = const PetSelectionPage();
        break;
      case 'User':
        destination = const UserPage();
        break;
      case 'Setup':
        destination = const SetupPage();
        break;
      default:
        return;
    }
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content + taskbar at bottom (full layout)
            Column(
              children: [
                Expanded(child: widget.child),
                _buildTaskbar(),
              ],
            ),
            // Tap outside to close menu (invisible overlay)
            if (_showStartMenu)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _showStartMenu = false),
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox(),
                ),
              ),
            // Floating Start menu overlay (on top of everything)
            _buildStartMenuOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskbar() {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: winGray,
        border: Border(top: BorderSide(color: winWhite, width: 2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Start button
          GestureDetector(
            onTap: () => setState(() => _showStartMenu = !_showStartMenu),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _showStartMenu ? winDarkGray : winGray,
                border: _showStartMenu
                    ? const Border(
                        top: BorderSide(color: winDarkGray, width: 1),
                        left: BorderSide(color: winDarkGray, width: 1),
                        right: BorderSide(color: winWhite, width: 1),
                        bottom: BorderSide(color: winWhite, width: 1),
                      )
                    : const Border(
                        top: BorderSide(color: winWhite, width: 1),
                        left: BorderSide(color: winWhite, width: 1),
                        right: BorderSide(color: winDarkGray, width: 1),
                        bottom: BorderSide(color: winDarkGray, width: 1),
                      ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.window, size: 14),
                  SizedBox(width: 4),
                  Text('Start', style: TextStyle(fontFamily: 'VT323', fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Current page indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: Text(
              widget.currentPage,
              style: const TextStyle(fontFamily: 'VT323', fontSize: 10),
            ),
          ),
          const Spacer(),
          // Clock
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(border: Border.all(color: winDarkGray)),
            child: Text(_currentTime, style: const TextStyle(fontFamily: 'VT323', fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildStartMenuOverlay() {
    if (!_showStartMenu) return const SizedBox.shrink();
    
    final menuItems = [
      {'icon': Icons.home, 'label': 'Main'},
      {'icon': Icons.pets, 'label': 'Adopt'},
      {'icon': Icons.person, 'label': 'User'},
      {'icon': Icons.settings, 'label': 'Setup'},
    ];

    return Positioned(
      left: 8,
      bottom: 44,
      child: Container(
        width: 150,
        decoration: const BoxDecoration(
          color: winGray,
          border: Border(
            top: BorderSide(color: winWhite, width: 2),
            left: BorderSide(color: winWhite, width: 2),
            right: BorderSide(color: Colors.black, width: 2),
            bottom: BorderSide(color: Colors.black, width: 2),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(4, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: winBlue,
              child: const Text(
                'PIXEL PAL',
                style: TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            // Menu items
            for (int i = 0; i < menuItems.length; i++)
              _buildMenuItem(
                menuItems[i]['icon'] as IconData,
                menuItems[i]['label'] as String,
                i,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index) {
    final isHovered = _hoveredIndex == index;
    final isCurrent = label == widget.currentPage;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _hoveredIndex = index),
      onTapUp: (_) {
        _navigateTo(label);
        setState(() => _hoveredIndex = -1);
      },
      onTapCancel: () => setState(() => _hoveredIndex = -1),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: isHovered ? winBlue : (isCurrent ? const Color(0xFFD0D0D0) : winGray),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isHovered ? Colors.white : Colors.black),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 14,
                color: isHovered ? Colors.white : Colors.black,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple taskbar widget for backward compatibility (use Win95PageWithTaskbar instead)
class Win95Taskbar extends StatelessWidget {
  final String currentPage;
  
  const Win95Taskbar({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    // Win95 Colors
    const Color winGray = Color(0xFFC0C0C0);
    const Color winDarkGray = Color(0xFF808080);
    const Color winWhite = Color(0xFFFFFFFF);

    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: winGray,
        border: Border(top: BorderSide(color: winWhite, width: 2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: const BoxDecoration(
              color: winGray,
              border: Border(
                top: BorderSide(color: winWhite, width: 1),
                left: BorderSide(color: winWhite, width: 1),
                right: BorderSide(color: winDarkGray, width: 1),
                bottom: BorderSide(color: winDarkGray, width: 1),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.window, size: 14),
                SizedBox(width: 4),
                Text('Start', style: TextStyle(fontFamily: 'VT323', fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: Text(currentPage, style: const TextStyle(fontFamily: 'VT323', fontSize: 10)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(border: Border.all(color: winDarkGray)),
            child: Text(currentTime, style: const TextStyle(fontFamily: 'VT323', fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
