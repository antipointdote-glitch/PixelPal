import 'package:flutter/material.dart';

/// 📝 Developer's Blog Page (Windows 95 Style)
/// In-app blog with dev updates - no external links
class DevBlogPage extends StatefulWidget {
  const DevBlogPage({super.key});

  @override
  State<DevBlogPage> createState() => _DevBlogPageState();
}

class _DevBlogPageState extends State<DevBlogPage> {
  // Simulated visitor counter
  static int _visitorCount = 42;
  
  // Win95 Colors
  static const Color winTeal = Color(0xFF008080);
  static const Color winGray = Color(0xFFC0C0C0);
  static const Color winBlue = Color(0xFF000080);
  static const Color winDarkGray = Color(0xFF808080);
  static const Color winWhite = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _visitorCount++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: winTeal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: _win95WindowDecoration(),
            child: Column(
              children: [
                // Title Bar
                _buildTitleBar(),
                // Content
                Expanded(
                  child: Container(
                    color: winGray,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Box
                          _buildWin95Box(
                            child: Column(
                              children: [
                                const Text(
                                  "★ DEVELOPER'S CORNER ★",
                                  style: TextStyle(fontFamily: 'VT323', fontSize: 24, fontWeight: FontWeight.bold, color: winBlue),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "～Welcome to my humble webpage～",
                                  style: TextStyle(fontFamily: 'VT323', fontSize: 14, fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "You are visitor #${_visitorCount.toString().padLeft(6, '0')}",
                                  style: const TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Under Construction Banner
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade200,
                              border: const Border(
                                top: BorderSide(color: winDarkGray, width: 2),
                                left: BorderSide(color: winDarkGray, width: 2),
                                right: BorderSide(color: winWhite, width: 2),
                                bottom: BorderSide(color: winWhite, width: 2),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("🚧", style: TextStyle(fontSize: 16)),
                                SizedBox(width: 8),
                                Text(
                                  "UNDER CONSTRUCTION",
                                  style: TextStyle(fontFamily: 'VT323', fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                SizedBox(width: 8),
                                Text("🚧", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Blog Posts
                          ..._blogPosts.map((post) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildBlogPost(post),
                          )),
                          
                          const SizedBox(height: 16),
                          
                          // Footer
                          _buildWin95Box(
                            child: Column(
                              children: [
                                const Text(
                                  "━━━━━━━━━━━━━━━━━━━━",
                                  style: TextStyle(fontFamily: 'VT323', fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Best viewed in 800x600",
                                  style: TextStyle(fontFamily: 'VT323', fontSize: 12, fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Last updated: ${DateTime.now().toString().substring(0, 10)}",
                                  style: const TextStyle(fontFamily: 'VT323', fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Thanks for visiting! ☆ﾟ.*･｡ﾟ",
                                  style: TextStyle(fontFamily: 'VT323', fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Status Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: winGray,
                  child: Row(
                    children: [
                      const Text('Ready', style: TextStyle(fontFamily: 'VT323', fontSize: 11)),
                      const Spacer(),
                      Text('${_blogPosts.length} entries', style: const TextStyle(fontFamily: 'VT323', fontSize: 11)),
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

  Widget _buildTitleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: winBlue,
      child: Row(
        children: [
          const Icon(Icons.description, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          const Expanded(child: Text('SYSTEM_MSG.LOG - Developer Corner', style: TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold))),
          GestureDetector(child: Container(width: 16, height: 16, color: winGray, child: const Center(child: Text('_', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))))),
          const SizedBox(width: 2),
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 16, height: 16, color: winGray, child: const Icon(Icons.close, size: 12))),
        ],
      ),
    );
  }

  Widget _buildWin95Box({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: winDarkGray, width: 2),
          left: BorderSide(color: winDarkGray, width: 2),
          right: BorderSide(color: winWhite, width: 2),
          bottom: BorderSide(color: winWhite, width: 2),
        ),
      ),
      child: child,
    );
  }

  Widget _buildBlogPost(Map<String, String> post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: winWhite, width: 2),
          left: BorderSide(color: winWhite, width: 2),
          right: BorderSide(color: winDarkGray, width: 2),
          bottom: BorderSide(color: winDarkGray, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: winBlue,
            child: Row(
              children: [
                const Text("📝 ", style: TextStyle(fontSize: 12)),
                Text(
                  post['date'] ?? '',
                  style: const TextStyle(fontFamily: 'VT323', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          // Post content
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'] ?? '',
                  style: const TextStyle(fontFamily: 'VT323', fontSize: 16, fontWeight: FontWeight.bold, color: winBlue),
                ),
                const SizedBox(height: 4),
                Text(
                  post['content'] ?? '',
                  style: const TextStyle(fontFamily: 'VT323', fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
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

  // Blog posts - Developer updates here
  static final List<Map<String, String>> _blogPosts = [
    {
      'date': '2026.01.14',
      'title': 'Stone Walker Feature! 🗿',
      'content': 'Added the Stone Walker feature!\n'
          'Now you can track your steps with Stone.\n'
          'Release Stone to the river when you reach 5000 steps~\n'
          'But if you regret... Stone will come back! (´・ω・`)',
    },
    {
      'date': '2026.01.13',
      'title': 'API Keys Fixed! ☆',
      'content': 'Fixed the API connection issues.\n'
          'Pets should respond properly now!\n'
          '*Throws pixelated confetti*',
    },
    {
      'date': '2026.01.12',
      'title': 'Welcome to MySuperApp! 🎉',
      'content': 'App launched! Welcome everyone!\n'
          '5 pets are now available:\n'
          '- Mouse (Detox helper)\n'
          '- Stone (Walker companion)\n'
          '- Ice (Chill buddy)\n'
          '- Bunny (Sassy therapist)\n'
          '- Egg (Needy friend)\n'
          '\n'
          'More features coming soon! ＼(★^∀^★)／',
    },
  ];
}
