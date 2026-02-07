import 'package:flutter/material.dart';

/// Show a beautiful "Coming Soon" overlay for the Memory Palace feature
void showComingSoonOverlay(BuildContext context, String petName) {
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1), // Warm paper color
          border: Border.all(color: Colors.brown, width: 3),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with book icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.brown, width: 2),
              ),
              child: const Icon(Icons.auto_stories, size: 40, color: Colors.brown),
            ),
            const SizedBox(height: 16),
            
            // Title
            const Text(
              "📜 Memory Palace",
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              "with $petName",
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.brown.shade400,
              ),
            ),
            const SizedBox(height: 20),
            
            // Coming soon message
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.brown.shade200, width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                children: [
                  const Text(
                    "🔮 Coming Soon",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your precious memories with\n$petName will be stored here...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      color: Colors.brown.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Features preview
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _FeatureChip(icon: Icons.favorite, label: "Memories"),
                _FeatureChip(icon: Icons.psychology, label: "Insights"),
                _FeatureChip(icon: Icons.stars, label: "Bonds"),
              ],
            ),
            const SizedBox(height: 20),
            
            // Close button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.brown,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0),
                  ],
                ),
                child: const Text(
                  "OK, I'll Wait! 💕",
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  
  const _FeatureChip({required this.icon, required this.label});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.brown.shade400),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 10,
            color: Colors.brown.shade400,
          ),
        ),
      ],
    );
  }
}
