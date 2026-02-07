import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../services/custom_pet_service.dart';
import '../widgets/win95_taskbar.dart';

class CreatePetPage extends StatefulWidget {
  const CreatePetPage({super.key});

  @override
  State<CreatePetPage> createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _marqueeController = TextEditingController();
  
  int _selectedMonth = 1;
  int _selectedDay = 1;
  String? _imagePath;
  bool _isCreating = false;

  // Win95 Colors
  static const Color winTeal = Color(0xFF008080);
  static const Color winGray = Color(0xFFC0C0C0);
  static const Color winBlue = Color(0xFF000080);
  static const Color winDarkGray = Color(0xFF808080);
  static const Color winWhite = Color(0xFFFFFFFF);

  @override
  void dispose() {
    _nicknameController.dispose();
    _profileController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: winGray,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('SELECT IMAGE', style: TextStyle(fontFamily: 'VT323', fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(Icons.camera_alt, 'CAMERA', () async {
                  final photo = await picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, photo);
                }),
                _buildImageOption(Icons.photo_library, 'GALLERY', () async {
                  final photo = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, photo);
                }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (result != null) {
      // Copy image to app directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'pet_${DateTime.now().millisecondsSinceEpoch}.${result.path.split('.').last}';
      final savedPath = '${appDir.path}/$fileName';
      await File(result.path).copy(savedPath);
      
      setState(() => _imagePath = savedPath);
    }
  }

  Widget _buildImageOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: winGray,
          border: const Border(
            top: BorderSide(color: winWhite, width: 2),
            left: BorderSide(color: winWhite, width: 2),
            right: BorderSide(color: winDarkGray, width: 2),
            bottom: BorderSide(color: winDarkGray, width: 2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontFamily: 'VT323', fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _createPet() async {
    final nickname = _nicknameController.text.trim();
    final profile = _profileController.text.trim();

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a nickname!'), backgroundColor: Colors.red),
      );
      return;
    }

    if (profile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your pet!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final birthday = '${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';
      
      await CustomPetService.createCustomPet(
        name: nickname,
        profile: profile,
        birthday: birthday,
        imagePath: _imagePath,
        marqueeText: _marqueeController.text.trim().isNotEmpty ? _marqueeController.text.trim() : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nickname has been created! 🎉'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Return true to indicate pet was created
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating pet: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Win95PageWithTaskbar(
      currentPage: 'Adopt',
      backgroundColor: winTeal,
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                      // Pet Image
                      _buildSection('PET IMAGE', 'Add a photo or GIF of your pet'),
                      _buildImagePicker(),
                      const SizedBox(height: 16),

                      // Nickname
                      _buildSection('NICKNAME', 'Give your pet a name'),
                      _buildTextField(_nicknameController, 'Enter nickname...'),
                      const SizedBox(height: 16),

                      // Birthday
                      _buildSection('BIRTHDAY', 'When was your pet born?'),
                      _buildBirthdayPicker(),
                      const SizedBox(height: 16),

                      // Profile
                      _buildSection('PROFILE', 'Describe your pet\'s personality'),
                      _buildProfileField(),
                      const SizedBox(height: 16),

                      // Marquee Text
                      _buildSection('MARQUEE TEXT', 'Custom scrolling message (optional)'),
                      _buildTextField(_marqueeController, 'YOUR CUSTOM MESSAGE...'),
                      const SizedBox(height: 24),

                      // Create Button
                      Center(child: _buildCreateButton()),
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
          const Icon(Icons.add_circle, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          const Expanded(
            child: Text('CREATE YOUR PAL', style: TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: _win95InsetDecoration(),
        child: _imagePath != null
            ? ClipRRect(
                child: Image.file(File(_imagePath!), fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade600),
                  const SizedBox(height: 8),
                  const Text('TAP TO ADD IMAGE', style: TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.black54)),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: _win95InsetDecoration(),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontFamily: 'VT323', fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildBirthdayPicker() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _win95InsetDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
            child: DropdownButton<int>(
              value: _selectedMonth,
              underline: const SizedBox(),
              style: const TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.black),
              items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(_getMonthName(i + 1)))),
              onChanged: (value) => setState(() {
                _selectedMonth = value!;
                if (_selectedDay > _getDaysInMonth(_selectedMonth)) {
                  _selectedDay = _getDaysInMonth(_selectedMonth);
                }
              }),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
            child: DropdownButton<int>(
              value: _selectedDay,
              underline: const SizedBox(),
              style: const TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.black),
              items: List.generate(_getDaysInMonth(_selectedMonth), (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
              onChanged: (value) => setState(() => _selectedDay = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField() {
    return Container(
      height: 120,
      decoration: _win95InsetDecoration(),
      child: TextField(
        controller: _profileController,
        maxLines: null,
        expands: true,
        style: const TextStyle(fontFamily: 'VT323', fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Describe your pet...\n\nAre they playful? Lazy? Sassy?\nWhat do they like? Their quirks?',
          hintStyle: TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: _isCreating ? null : _createPet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: _isCreating ? winDarkGray : winGray,
          border: const Border(
            top: BorderSide(color: winWhite, width: 2),
            left: BorderSide(color: winWhite, width: 2),
            right: BorderSide(color: Colors.black, width: 2),
            bottom: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isCreating)
              const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            else
              const Icon(Icons.pets, size: 16),
            const SizedBox(width: 8),
            Text(
              _isCreating ? 'CREATING...' : 'CREATE PAL',
              style: const TextStyle(fontFamily: 'VT323', fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }

  int _getDaysInMonth(int month) {
    const days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
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
