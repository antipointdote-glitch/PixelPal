import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class ChatHistoryPage extends StatelessWidget {
  final String petType;
  final String petName;
  final Color petColor;

  const ChatHistoryPage({
    super.key,
    required this.petType,
    required this.petName,
    required this.petColor,
  });

  // Win95 Colors
  static const Color winTeal = Color(0xFF008080);
  static const Color winGray = Color(0xFFC0C0C0);
  static const Color winBlue = Color(0xFF000080);
  static const Color winDarkGray = Color(0xFF808080);
  static const Color winWhite = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final history = GeminiService.getHistory(petType);

    return Scaffold(
      backgroundColor: winTeal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: _win95WindowDecoration(),
            child: Column(
              children: [
                // Title bar
                _buildTitleBar(context, '${petName.toUpperCase()} - CHAT HISTORY'),
                
                // Stats bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: _win95InsetDecoration(),
                  child: Row(
                    children: [
                      const Icon(Icons.history, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        '📜 MEMORY PALACE',
                        style: const TextStyle(
                          fontFamily: 'VT323',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${history.length} memories',
                        style: const TextStyle(
                          fontFamily: 'VT323',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chat history terminal
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    decoration: _win95InsetDecoration().copyWith(color: Colors.black),
                    child: Column(
                      children: [
                        // Terminal header
                        Container(
                          color: winDarkGray,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'HISTORY.EXE',
                                style: const TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.white),
                              ),
                              Text(
                                'v1.0.0',
                                style: const TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        // Messages list
                        Expanded(
                          child: history.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder_open, size: 48, color: petColor),
                                      const SizedBox(height: 16),
                                      Text(
                                        'NO MEMORIES YET...',
                                        style: TextStyle(fontFamily: 'VT323', fontSize: 16, color: petColor),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Start chatting with your pet\nto create precious memories!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: 'VT323', fontSize: 12, color: petColor.withValues(alpha: 0.7)),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: history.length,
                                  itemBuilder: (context, index) {
                                    final message = history[index];
                                    final isUser = message['role'] == 'user';
                                    final prefix = isUser ? '<User>' : '<$petName>';
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Text(
                                        '$prefix ${message['text']}',
                                        style: TextStyle(
                                          fontFamily: 'VT323',
                                          color: isUser ? Colors.white : petColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _build3DButton(Icons.arrow_back, 'BACK', () => Navigator.pop(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: winBlue,
      child: Row(
        children: [
          const Icon(Icons.history, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'VT323',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 16,
              height: 16,
              decoration: _win95OutsetDecoration(),
              child: const Center(child: Icon(Icons.close, size: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: winGray,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(color: winWhite, offset: Offset(2, 2)),
            BoxShadow(color: winDarkGray, offset: Offset(-2, -2)),
            BoxShadow(color: Colors.black26, offset: Offset(3, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'VT323',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _win95WindowDecoration() {
    return const BoxDecoration(
      color: winGray,
      border: Border(
        top: BorderSide(color: winWhite, width: 2),
        left: BorderSide(color: winWhite, width: 2),
        right: BorderSide(color: Colors.black, width: 2),
        bottom: BorderSide(color: Colors.black, width: 2),
      ),
    );
  }

  BoxDecoration _win95InsetDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(color: winDarkGray, width: 2),
        left: BorderSide(color: winDarkGray, width: 2),
        right: BorderSide(color: winWhite, width: 2),
        bottom: BorderSide(color: winWhite, width: 2),
      ),
    );
  }

  BoxDecoration _win95OutsetDecoration() {
    return const BoxDecoration(
      color: winGray,
      border: Border(
        top: BorderSide(color: winWhite, width: 1),
        left: BorderSide(color: winWhite, width: 1),
        right: BorderSide(color: winDarkGray, width: 1),
        bottom: BorderSide(color: winDarkGray, width: 1),
      ),
    );
  }
}
