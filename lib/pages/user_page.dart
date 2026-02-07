import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/win95_taskbar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  
  int _selectedMonth = 1;
  int _selectedDay = 1;
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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final nickname = await UserService.getNickname();
    final profile = await UserService.getProfile();
    final birthday = await UserService.getBirthday();
    
    if (mounted) {
      setState(() {
        _nicknameController.text = nickname == 'User' ? '' : nickname;
        _profileController.text = profile;
        if (birthday != null) {
          _selectedMonth = birthday['month']!;
          _selectedDay = birthday['day']!;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    final nickname = _nicknameController.text.trim().isEmpty 
        ? 'User' 
        : _nicknameController.text.trim();
    
    await UserService.setNickname(nickname);
    await UserService.setBirthday(_selectedMonth, _selectedDay);
    await UserService.setProfile(_profileController.text.trim());
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved! Your pets will remember you.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _profileController.dispose();
    super.dispose();
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
      currentPage: 'User',
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
                      _buildSection('NICKNAME', 'Your pets will call you by this name'),
                      _buildTextField(_nicknameController, 'Enter your nickname...'),
                      const SizedBox(height: 16),
                      
                      _buildSection('BIRTHDAY', 'Your pets will wish you on this day'),
                      _buildBirthdayPicker(),
                      const SizedBox(height: 16),
                      
                      _buildSection('ABOUT YOU', 'Tell your pets about yourself'),
                      _buildProfileField(),
                      const SizedBox(height: 24),
                      
                      Center(child: _buildSaveButton()),
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
          const Icon(Icons.person, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'USER PROFILE',
              style: TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
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
          // Month dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: DropdownButton<int>(
              value: _selectedMonth,
              underline: const SizedBox(),
              style: const TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.black),
              items: List.generate(12, (i) => DropdownMenuItem(
                value: i + 1,
                child: Text(_getMonthName(i + 1)),
              )),
              onChanged: (value) => setState(() => _selectedMonth = value!),
            ),
          ),
          const SizedBox(width: 12),
          // Day dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: DropdownButton<int>(
              value: _selectedDay,
              underline: const SizedBox(),
              style: const TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.black),
              items: List.generate(_getDaysInMonth(_selectedMonth), (i) => DropdownMenuItem(
                value: i + 1,
                child: Text('${i + 1}'),
              )),
              onChanged: (value) => setState(() => _selectedDay = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField() {
    return Container(
      height: 150,
      decoration: _win95InsetDecoration(),
      child: TextField(
        controller: _profileController,
        maxLines: null,
        expands: true,
        style: const TextStyle(fontFamily: 'VT323', fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Tell your pets about yourself...\n\nHobbies, interests, favorite things, what makes you happy or sad... Your pets will use this to understand you better!',
          hintStyle: TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saveUserData,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: winGray,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(color: winWhite, offset: Offset(2, 2)),
            BoxShadow(color: winDarkGray, offset: Offset(-2, -2)),
            BoxShadow(color: Colors.black26, offset: Offset(3, 3)),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.save, size: 16),
            SizedBox(width: 8),
            Text('SAVE PROFILE', style: TextStyle(fontFamily: 'VT323', fontSize: 14, fontWeight: FontWeight.bold)),
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
