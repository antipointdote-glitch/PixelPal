import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Pal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Courier', 
        scaffoldBackgroundColor: const Color(0xFFF0F4F8), // Light Cloud Blue
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      builder: (context, child) {
        return Container(
          color: const Color(0xFF2D2D2D), // Dark Grey Background
          alignment: Alignment.center,
          child: ClipRect(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 375, maxHeight: 812), // iPhone X-ish ratio
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 8), // Phone Bezel
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: child,
              ),
            ),
          ),
        );
      },
      home: const HomePage(),
    );
  }
}
