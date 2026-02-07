import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/gemini_service.dart';

class IcePetPage extends StatefulWidget {
  final PetModel pet;
  const IcePetPage({super.key, required this.pet});

  @override
  State<IcePetPage> createState() => _IcePetPageState();
}

class _IcePetPageState extends State<IcePetPage> {
  final TextEditingController _textController = TextEditingController();
  
  String _dialogueText = "Stay cool.";
  bool isLoading = false;

  // Theme: Icy Blue
  static const Color colBackground = Color(0xFFE0F7FA); 
  static const Color colScreenBG = Colors.white; 
  static const Color colBorder = Colors.black;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();
    setState(() { isLoading = true; });

    try {
      final response = await GeminiService.getPetResponse(text, widget.pet.type);
      if (mounted) {
        setState(() {
          _dialogueText = response;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _dialogueText = "Error: $e";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          automaticallyImplyLeading: false, 
          backgroundColor: Colors.transparent, 
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
             child: GestureDetector(
               onTap: () => Navigator.pop(context),
               child: const Row(
                 children: [
                   Icon(Icons.arrow_back, color: Colors.black, size: 24),
                   Text("BACK", style: TextStyle(fontFamily: 'Courier', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                 ],
               ),
             ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLCDText("-5°C"),
                _buildLCDText(widget.pet.name.toUpperCase()),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colScreenBG,
                  border: Border.all(color: colBorder, width: 3),
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: const EdgeInsets.all(4), 
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 2)),
                  child: Center(
                    child: Image.asset('assets/images/ice.png', height: 120, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity, height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: colBorder, width: 3),
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
              ),
              child: SingleChildScrollView(
                child: Text(
                  isLoading ? "Thinking..." : _dialogueText,
                  style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                       color: Colors.white,
                       border: Border.all(color: Colors.black, width: 3),
                       borderRadius: BorderRadius.circular(2),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: "Chill?",
                        hintStyle: TextStyle(fontFamily: 'Courier', fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                      ),
                      style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_textController.text),
                  child: Container(
                    height: 48, width: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF80DEEA), // cyan
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(2),
                       boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)],
                    ),
                    child: const Icon(Icons.send, color: Colors.black),
                  ),
                )
              ],
            ),
             const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLCDText(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(text, style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
