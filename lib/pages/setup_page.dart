import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';
import '../widgets/win95_taskbar.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final StorageService _storage = StorageService();
  bool _isLoading = true;
  bool _locationGranted = false;

  // Win95 Colors
  static const Color winTeal = Color(0xFF008080);
  static const Color winGray = Color(0xFFC0C0C0);
  static const Color winBlue = Color(0xFF000080);
  static const Color winDarkGray = Color(0xFF808080);
  static const Color winWhite = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationGranted = false;
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      setState(() {
        _isLoading = false;
        switch (permission) {
          case LocationPermission.denied:
          case LocationPermission.deniedForever:
          case LocationPermission.unableToDetermine:
            _locationGranted = false;
            break;
          case LocationPermission.whileInUse:
          case LocationPermission.always:
            _locationGranted = true;
            break;
        }
      });
    } catch (e) {
      setState(() {
        _locationGranted = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    await _checkLocationPermission();
    
    if (mounted && permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location in device settings'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _clearChatHistory(String petType) async {
    GeminiService.clearHistory(petType);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(petType == 'all' ? 'All chat history cleared!' : '${petType.toUpperCase()} history cleared!'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {});
    }
  }

  Future<void> _resetAllPets() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: winGray,
        shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black, width: 3), borderRadius: BorderRadius.circular(4)),
        title: const Text('⚠️ RESET ALL PETS', style: TextStyle(fontFamily: 'VT323', fontWeight: FontWeight.bold)),
        content: const Text('This will:\n• Store all active pets\n• Clear all chat history\n\nAre you sure?', style: TextStyle(fontFamily: 'VT323', fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL', style: TextStyle(fontFamily: 'VT323', color: Colors.black))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('RESET', style: TextStyle(fontFamily: 'VT323', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final pets = await _storage.loadPets();
      final updatedPets = pets.map((p) => p.copyWith(isActive: false)).toList();
      await _storage.savePets(updatedPets);
      GeminiService.clearHistory('all');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All pets reset!'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: winTeal,
        body: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Win95PageWithTaskbar(
      currentPage: 'Setup',
      backgroundColor: winTeal,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: _win95WindowDecoration(),
          child: Column(
            children: [
              _buildTitleBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Permission
                      _buildSection('LOCATION PERMISSION', 'For Ice pet weather data'),
                      _buildLocationPermissionRow(),
                      const SizedBox(height: 24),

                      // Clear Chat History
                      _buildSection('CLEAR CHAT HISTORY', 'Remove conversation memories'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSmallButton('MOUSE', () => _clearChatHistory('mouse')),
                          _buildSmallButton('STONE', () => _clearChatHistory('stone')),
                          _buildSmallButton('ICE', () => _clearChatHistory('ice')),
                          _buildSmallButton('BUNNY', () => _clearChatHistory('rabbit')),
                          _buildSmallButton('SQUAD', () => _clearChatHistory('todo')),
                          _buildSmallButton('ALL', () => _clearChatHistory('all'), danger: true),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Reset All Pets
                      _buildSection('DANGER ZONE', 'Irreversible actions'),
                      _buildDangerButton('RESET ALL PETS', _resetAllPets),
                      const SizedBox(height: 24),

                      // About Section
                      _buildAboutSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: winBlue,
      child: Row(
        children: [
          const Icon(Icons.settings, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          const Expanded(
            child: Text('SETUP', style: TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildSection(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontFamily: 'VT323', fontSize: 16, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(fontFamily: 'VT323', fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildLocationPermissionRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _win95InsetDecoration(),
      child: Row(
        children: [
          Icon(
            _locationGranted ? Icons.location_on : Icons.location_off,
            size: 20,
            color: _locationGranted ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Location Access', style: TextStyle(fontFamily: 'VT323', fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  _locationGranted ? 'Ice pet can check local weather' : 'Enable to use weather features',
                  style: const TextStyle(fontFamily: 'VT323', fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          // Win95 style switch
          GestureDetector(
            onTap: _locationGranted ? null : _requestLocationPermission,
            child: Container(
              width: 50,
              height: 24,
              decoration: BoxDecoration(
                color: _locationGranted ? Colors.green : winDarkGray,
                border: const Border(
                  top: BorderSide(color: Colors.black, width: 2),
                  left: BorderSide(color: Colors.black, width: 2),
                  right: BorderSide(color: winWhite, width: 2),
                  bottom: BorderSide(color: winWhite, width: 2),
                ),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 150),
                    left: _locationGranted ? 26 : 2,
                    top: 2,
                    child: Container(
                      width: 18,
                      height: 16,
                      decoration: BoxDecoration(
                        color: winGray,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 6,
                    top: 4,
                    child: Text(
                      _locationGranted ? '' : 'OFF',
                      style: const TextStyle(fontFamily: 'VT323', fontSize: 10, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 4,
                    child: Text(
                      _locationGranted ? 'ON' : '',
                      style: const TextStyle(fontFamily: 'VT323', fontSize: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String label, VoidCallback onTap, {bool danger = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: danger ? Colors.red.shade100 : winGray,
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: const [
            BoxShadow(color: winWhite, offset: Offset(1, 1)),
            BoxShadow(color: winDarkGray, offset: Offset(-1, -1)),
          ],
        ),
        child: Text(label, style: TextStyle(fontFamily: 'VT323', fontSize: 12, fontWeight: FontWeight.bold, color: danger ? Colors.red : Colors.black)),
      ),
    );
  }

  Widget _buildDangerButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, size: 16, color: Colors.red),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontFamily: 'VT323', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _win95InsetDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('PIXEL PAL', style: TextStyle(fontFamily: 'VT323', fontSize: 18, fontWeight: FontWeight.bold, color: winBlue)),
          SizedBox(height: 4),
          Text('Version 1.0.0', style: TextStyle(fontFamily: 'VT323', fontSize: 12)),
          SizedBox(height: 8),
          Text('Your digital companions await!', style: TextStyle(fontFamily: 'VT323', fontSize: 11, fontStyle: FontStyle.italic)),
          SizedBox(height: 8),
          Text('© 2026 Pixel Pal Team', style: TextStyle(fontFamily: 'VT323', fontSize: 10, color: Colors.black54)),
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
