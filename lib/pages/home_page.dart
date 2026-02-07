import 'package:flutter/material.dart';
import 'dart:io';
import '../models/pet_model.dart';
import '../services/storage_service.dart';
import '../services/cny_greeting_service.dart';
import '../services/custom_pet_service.dart';
import 'pet_selection_page.dart';
import 'mouse_pet_page.dart';
import 'stone_pet_page.dart';
import 'ice_pet_page.dart';
import 'bunny_pet_page.dart';
import 'egg_pet_page.dart';
import 'dev_blog_page.dart';
import 'custom_pet_page.dart';
import '../widgets/win95_taskbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storage = StorageService();
  List<PetModel> _activePets = [];
  bool _isLoading = true;

  // Win95 Colors
  static const Color winTeal = Color(0xFF008080);
  static const Color winGray = Color(0xFFC0C0C0);
  static const Color winBlue = Color(0xFF000080);
  static const Color winDarkGray = Color(0xFF808080);
  static const Color winWhite = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _loadActivePets();
  }

  Future<void> _loadActivePets() async {
    final pets = await _storage.loadPets();
    final customPets = await CustomPetService.getCustomPets();
    if (mounted) {
      setState(() {
        _activePets = [
          ...pets.where((p) => p.isActive),
          ...customPets,
        ];
        _isLoading = false;
      });
    }
  }

  void _navigateToPet(PetModel pet) {
    Widget page;
    switch (pet.type) {
      case 'mouse': page = MousePetPage(pet: pet); break;
      case 'stone': page = StonePetPage(pet: pet); break;
      case 'ice': page = IcePetPage(pet: pet); break;
      case 'rabbit': page = BunnyPetPage(pet: pet); break;
      case 'todo': page = EggPetPage(pet: pet); break;
      case 'custom': page = CustomPetPage(pet: pet); break;
      default: page = MousePetPage(pet: pet);
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) => _loadActivePets());
  }

  void _goToAdoption() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const PetSelectionPage()));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(backgroundColor: winTeal, body: const Center(child: CircularProgressIndicator(color: Colors.white)));
    }

    return Win95PageWithTaskbar(
      currentPage: 'Main',
      backgroundColor: winTeal,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text('PIXEL PAL', style: TextStyle(fontFamily: 'VT323', fontSize: 40, color: winWhite, fontWeight: FontWeight.bold, shadows: const [Shadow(color: Colors.black, offset: Offset(2, 2))])),
                const Text('OFFICIAL MOBILE TERMINAL', style: TextStyle(fontFamily: 'VT323', fontSize: 10, color: Colors.white70, letterSpacing: 2)),
              ],
            ),
          ),
          // System Message Window - Click to open Dev Blog
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DevBlogPage())),
            child: _buildWin95Window(
              title: 'SYSTEM_MSG.LOG',
              icon: Icons.description,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(width: 24, height: 24, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: winBlue, border: Border.all()), child: const Icon(Icons.info, color: Colors.white, size: 16)),
                    Expanded(
                      child: Text(
                        CnyGreetingService.isCnyPeriod ? 'KERNEL: CNY MODE ACTIVE 🧧\nHAPPY CHINESE NEW YEAR!!!' : 'KERNEL: ${_activePets.length} entities detected.\nSTATUS: Online / Waiting for input...',
                        style: const TextStyle(fontFamily: 'VT323', fontSize: 11, color: Colors.black),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Active Pets Window
          Expanded(
            child: _buildWin95Window(
              title: 'ACTIVE_PETS.EXE',
              icon: Icons.pets,
              expand: true,
              child: _activePets.isEmpty ? _buildEmptyState() : _buildPetGrid(),
            ),
          ),
          const SizedBox(height: 8),
          // Adoption Center Window
          _buildWin95Window(
            title: 'ADOPT.HTM',
            icon: Icons.language,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('ADOPTION CENTER', style: TextStyle(fontFamily: 'VT323', fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Find a new digital companion', style: TextStyle(fontFamily: 'VT323', fontSize: 10)),
                  ])),
                  _buildWin95Button('VISIT', _goToAdoption),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildWin95Window({required String title, required IconData icon, required Widget child, bool expand = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: winGray,
          border: const Border(top: BorderSide(color: winWhite, width: 2), left: BorderSide(color: winWhite, width: 2), right: BorderSide(color: Colors.black, width: 2), bottom: BorderSide(color: Colors.black, width: 2)),
        ),
        child: Column(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          children: [
            // Title bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              color: winBlue,
              child: Row(
                children: [
                  Icon(icon, size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(title, style: const TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(width: 14, height: 14, decoration: BoxDecoration(color: winGray, border: Border.all()), child: const Center(child: Text('_', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)))),
                  const SizedBox(width: 2),
                  Container(width: 14, height: 14, decoration: BoxDecoration(color: winGray, border: Border.all()), child: const Icon(Icons.close, size: 10)),
                ],
              ),
            ),
            // Content
            expand 
              ? Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: winDarkGray)),
                    child: child,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: winDarkGray)),
                  child: child,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, size: 48, color: Colors.black54),
          const SizedBox(height: 12),
          const Text('NO ACTIVE PETS', style: TextStyle(fontFamily: 'VT323', fontSize: 20, color: Colors.black54)),
          const SizedBox(height: 8),
          const Text('Visit the Adoption Center', style: TextStyle(fontFamily: 'VT323', fontSize: 12)),
          const SizedBox(height: 16),
          _buildWin95Button('ADOPT NOW', _goToAdoption),
        ],
      ),
    );
  }

  Widget _buildPetGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.85),
      itemCount: _activePets.length,
      itemBuilder: (context, index) => _buildPetCard(_activePets[index]),
    );
  }

  Widget _buildPetCard(PetModel pet) {
    return GestureDetector(
      onTap: () => _navigateToPet(pet),
      child: Container(
        decoration: BoxDecoration(color: winGray, border: const Border(top: BorderSide(color: winWhite, width: 1), left: BorderSide(color: winWhite, width: 1), right: BorderSide(color: winDarkGray, width: 1), bottom: BorderSide(color: winDarkGray, width: 1))),
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black, border: Border.all(color: winDarkGray)),
                padding: const EdgeInsets.all(4),
                child: pet.isCustom
                    ? (pet.imagePath != null
                        ? Image.file(File(pet.imagePath!), fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Colors.green, size: 32))
                        : const Icon(Icons.pets, color: Colors.green, size: 32))
                    : _buildPetImage(pet.type),
              ),
            ),
            const SizedBox(height: 4),
            Text(pet.name.toUpperCase(), style: const TextStyle(fontFamily: 'VT323', fontSize: 12, fontWeight: FontWeight.bold, color: winBlue)),
            if (pet.isCustom)
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                color: Colors.green,
                child: const Text('CUSTOM', style: TextStyle(fontFamily: 'VT323', fontSize: 8, color: Colors.white)),
              ),
            const SizedBox(height: 2),
            // Progress bar
            Container(
              height: 8,
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
              child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: 0.8, child: Container(color: winBlue)),
            ),
            const SizedBox(height: 4),
            _buildWin95Button('INTERACT', () => _navigateToPet(pet), compact: true),
          ],
        ),
      ),
    );
  }

  Widget _buildWin95Button(String label, VoidCallback onTap, {bool compact = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: compact ? 3 : 6),
        decoration: BoxDecoration(color: winGray, border: const Border(top: BorderSide(color: winWhite, width: 1), left: BorderSide(color: winWhite, width: 1), right: BorderSide(color: winDarkGray, width: 1), bottom: BorderSide(color: winDarkGray, width: 1))),
        child: Text(label, style: TextStyle(fontFamily: 'VT323', fontSize: compact ? 10 : 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPetImage(String type) {
    String imagePath;
    switch (type) {
      case 'mouse': imagePath = 'assets/images/mouse.png'; break;
      case 'stone': imagePath = 'assets/images/stone.png'; break;
      case 'ice': imagePath = 'assets/images/ice.png'; break;
      case 'rabbit': imagePath = 'assets/images/bunny.gif'; break;
      case 'todo': imagePath = 'assets/images/egg.png'; break;
      default: imagePath = 'assets/images/mouse.png';
    }
    return Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Colors.white, size: 32));
  }
}
