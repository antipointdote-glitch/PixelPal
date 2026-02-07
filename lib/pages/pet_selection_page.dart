import 'dart:io';
import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/storage_service.dart';
import '../services/custom_pet_service.dart';
import 'home_page.dart';
import 'user_page.dart';
import 'setup_page.dart';
import 'create_pet_page.dart';
import 'custom_pet_page.dart';
import '../widgets/win95_taskbar.dart';

class PetSelectionPage extends StatefulWidget {
  const PetSelectionPage({super.key});

  @override
  State<PetSelectionPage> createState() => _PetSelectionPageState();
}

class _PetSelectionPageState extends State<PetSelectionPage> {
  final StorageService _storage = StorageService();
  List<PetModel> _pets = [];
  List<PetModel> _customPets = [];
  bool _isLoading = true;
  String _currentTime = '';
  double _marqueeOffset = 0;

  // Win95 Colors
  static const Color winTeal = Color(0xFF008080);
  static const Color winGray = Color(0xFFC0C0C0);
  static const Color winBlue = Color(0xFF000080);
  static const Color winDarkGray = Color(0xFF808080);
  static const Color winWhite = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _loadPets();
    _updateTime();
    _startMarquee();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) { _updateTime(); return true; }
      return false;
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final amPm = now.hour >= 12 ? 'PM' : 'AM';
    if (mounted) setState(() => _currentTime = '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $amPm');
  }

  void _startMarquee() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) { setState(() { _marqueeOffset -= 2; if (_marqueeOffset < -500) _marqueeOffset = 400; }); return true; }
      return false;
    });
  }

  Future<void> _loadPets() async {
    final pets = await _storage.loadPets();
    final customPets = await CustomPetService.getCustomPets();
    if (mounted) setState(() { _pets = pets; _customPets = customPets; _isLoading = false; });
  }

  Future<void> _togglePetAdoption(PetModel pet) async {
    final updatedPet = pet.copyWith(isActive: !pet.isActive);
    final index = _pets.indexWhere((p) => p.id == pet.id);
    if (index == -1) return;
    setState(() => _pets[index] = updatedPet);
    await _storage.savePets(_pets);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(updatedPet.isActive ? 'Adopted ${pet.name}!' : 'Stored ${pet.name}.')));
    }
  }

  int get _activeCount => _pets.where((p) => p.isActive).length;
  void _goHome() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(backgroundColor: winTeal, body: const Center(child: CircularProgressIndicator(color: Colors.white)));

    return Win95PageWithTaskbar(
      currentPage: 'Adopt',
      backgroundColor: winTeal,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(color: winGray, border: const Border(top: BorderSide(color: winWhite, width: 2), left: BorderSide(color: winWhite, width: 2), right: BorderSide(color: Colors.black, width: 2), bottom: BorderSide(color: Colors.black, width: 2))),
          child: Column(
            children: [
              // Title Bar
              _buildTitleBar(),
              // Marquee Banner
              _buildMarqueeBanner(),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // AVAILABLE PALS Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        color: winGray,
                        child: Column(
                          children: [
                            const Text('AVAILABLE PALS', style: TextStyle(fontFamily: 'VT323', fontSize: 18, fontWeight: FontWeight.bold, color: winBlue)),
                            Text('Current Capacity: $_activeCount / ${_pets.length}', style: const TextStyle(fontFamily: 'VT323', fontSize: 11)),
                          ],
                        ),
                      ),
                      // Pet List
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: winDarkGray, width: 2)),
                        child: Column(
                          children: _pets.map((pet) => _buildPetRow(pet)).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // CREATE PALS Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        color: winGray,
                        child: const Column(
                          children: [
                            Text('CREATE PALS', style: TextStyle(fontFamily: 'VT323', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                            Text('Design your own AI companion!', style: TextStyle(fontFamily: 'VT323', fontSize: 11)),
                          ],
                        ),
                      ),
                      // Custom Pet List + Create Button
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: winDarkGray, width: 2)),
                        child: Column(
                          children: [
                            ..._customPets.map((pet) => _buildCustomPetRow(pet)),
                            // Create New button
                            _buildCreateButton(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              // Status Bar
              _buildStatusBar(),
            ],
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
          const Icon(Icons.pets, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          const Expanded(child: Text('Pixel Pal - Adoption', style: TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold))),
          GestureDetector(child: Container(width: 16, height: 16, color: winGray, child: const Center(child: Text('_', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))))),
          const SizedBox(width: 2),
          GestureDetector(onTap: _goHome, child: Container(width: 16, height: 16, color: winGray, child: const Icon(Icons.close, size: 12))),
        ],
      ),
    );
  }

  Widget _buildMarqueeBanner() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: ClipRect(
        child: Transform.translate(
          offset: Offset(_marqueeOffset, 0),
          child: const Text('WELCOME TO THE ADOPTION CENTER - FIND YOUR NEW PIXELATED FRIEND TODAY - 100% DIGITAL -', style: TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.black)),
        ),
      ),
    );
  }

  Widget _buildPetRow(PetModel pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: pet.isActive ? const Color(0xFFE8FFE8) : Colors.white, border: Border.all(color: winGray)),
      child: Row(
        children: [
          Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.black, border: Border.all(color: winDarkGray)), child: _buildPetImage(pet.type)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet.name.toUpperCase(), style: const TextStyle(fontFamily: 'VT323', fontSize: 14, fontWeight: FontWeight.bold, color: winBlue)),
                Text(pet.description, style: const TextStyle(fontFamily: 'VT323', fontSize: 10)),
                if (pet.isActive) Container(margin: const EdgeInsets.only(top: 2), padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), color: Colors.green, child: const Text('ADOPTED', style: TextStyle(fontFamily: 'VT323', fontSize: 9, color: Colors.white))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _togglePetAdoption(pet),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: winGray, border: const Border(top: BorderSide(color: winWhite, width: 1), left: BorderSide(color: winWhite, width: 1), right: BorderSide(color: winDarkGray, width: 1), bottom: BorderSide(color: winDarkGray, width: 1))),
              child: Text(pet.isActive ? 'STORE' : 'ADOPT', style: const TextStyle(fontFamily: 'VT323', fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 50,
      color: winGray,
      child: Row(
        children: [
          _buildNavButton(Icons.home, 'Main', _goHome, false),
          _buildNavButton(Icons.pets, 'Adopt', null, true),
          _buildNavButton(Icons.person, 'User', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserPage())), false),
          _buildNavButton(Icons.settings, 'Setup', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SetupPage())), false),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, VoidCallback? onTap, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: isActive ? Colors.white : winGray,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isActive ? winBlue : Colors.black),
              Text(label.toUpperCase(), style: TextStyle(fontFamily: 'VT323', fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? winBlue : Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: const BoxDecoration(color: winGray, border: Border(top: BorderSide(color: winDarkGray))),
      child: Row(
        children: [
          const Text('System Ready', style: TextStyle(fontFamily: 'VT323', fontSize: 10)),
          const Spacer(),
          Text(_currentTime, style: const TextStyle(fontFamily: 'VT323', fontSize: 10)),
        ],
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
    return Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Colors.white, size: 24));
  }

  Widget _buildCustomPetRow(PetModel pet) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => CustomPetPage(pet: pet)));
        _loadPets(); // Refresh after returning
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: const Color(0xFFFFF8E8), border: Border.all(color: winGray)),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: Colors.grey.shade200, border: Border.all(color: winDarkGray)),
              child: pet.imagePath != null
                  ? Image.file(
                      File(pet.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 24),
                    )
                  : const Icon(Icons.pets, size: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name.toUpperCase(), style: const TextStyle(fontFamily: 'VT323', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                  Text(pet.description.length > 40 ? '${pet.description.substring(0, 40)}...' : pet.description, style: const TextStyle(fontFamily: 'VT323', fontSize: 10)),
                  Container(margin: const EdgeInsets.only(top: 2), padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), color: Colors.green, child: const Text('CUSTOM', style: TextStyle(fontFamily: 'VT323', fontSize: 9, color: Colors.white))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: winGray, border: const Border(top: BorderSide(color: winWhite, width: 1), left: BorderSide(color: winWhite, width: 1), right: BorderSide(color: winDarkGray, width: 1), bottom: BorderSide(color: winDarkGray, width: 1))),
              child: const Text('CHAT', style: TextStyle(fontFamily: 'VT323', fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePetPage()));
        if (result == true) {
          _loadPets(); // Refresh list after creating pet
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFE8FFE8), border: Border.all(color: Colors.green)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, size: 20, color: Colors.green),
            SizedBox(width: 8),
            Text('+ CREATE NEW PAL', style: TextStyle(fontFamily: 'VT323', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
