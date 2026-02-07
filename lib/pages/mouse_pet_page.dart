import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/gemini_service.dart';
import '../widgets/pixel_button.dart';

class MousePetPage extends StatefulWidget {
  final PetModel pet;
  const MousePetPage({super.key, required this.pet});

  @override
  State<MousePetPage> createState() => _MousePetPageState();
}

class _MousePetPageState extends State<MousePetPage> {
  // Stats
  final double _screenTime = 2.5; 
  bool _isSneezing = false;
  Timer? _sneezeTimer;
  
  // Gemini & State
  final TextEditingController _textController = TextEditingController();
  String _dialogueText = "♥ I'm allergic to scrolling...";
  bool isLoading = false; // REQUIRED: Feedback state

  // Colors: Retro Green/Blue Theme
  static const Color colBackground = Color(0xFFD8E2D1); 
  static const Color colScreenBG = Colors.white; 
  static const Color colBorder = Colors.black;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  @override
  void dispose() {
    _sneezeTimer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _checkStatus() {
    // Sneeze logic
    if (_screenTime > 2.0) {
      _sneezeTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (mounted) {
          setState(() { _isSneezing = true; });
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) { setState(() { _isSneezing = false; }); }
          });
        }
      });
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();
    
    // REQUIRED: Set loading true
    setState(() {
      isLoading = true;
    });

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
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
             child: GestureDetector(
               onTap: () => Navigator.pop(context),
               child: const Row(
                 children: [
                   Icon(Icons.arrow_back, color: Colors.black, size: 24),
                   SizedBox(width: 8),
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
            // 1. HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLCDText("10:45 AM"),
                _buildLCDText(widget.pet.name.toUpperCase()),
              ],
            ),
            const SizedBox(height: 16),

            // 2. PET DISPLAY
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
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 2), 
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          // ignore: deprecated_member_use
                          transform: _isSneezing ? (Matrix4.identity()..translate(5.0, 0.0)) : Matrix4.identity(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               _isSneezing 
                                // ignore: deprecated_member_use
                                ? Image.asset('assets/images/mouse.png', height: 100, color: Colors.red.withOpacity(0.5), colorBlendMode: BlendMode.srcATop)
                                : Image.asset('assets/images/mouse.png', height: 100),
                                
                              if (_isSneezing)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    color: Colors.black,
                                    child: const Text("ACHOO!", style: TextStyle(fontFamily: 'Courier', color: Colors.white)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: Text("TIME: ${_screenTime}H", style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // 3. DIALOGUE BOX
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: colBorder, width: 3),
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
              ),
              child: SingleChildScrollView(
                child: Text(
                  isLoading ? "Thinking..." : _dialogueText, // REQUIRED: Feedback text
                  style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 4. INPUT
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
                        hintText: "Say hi...",
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
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF176),
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

            // 5. BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PixelButton(
                  label: "FEED",
                  icon: Icons.rice_bowl,
                  color: const Color(0xFFFFF176), 
                  onPressed: () {},
                ),
                PixelButton(
                  label: "DETOX",
                  icon: Icons.phonelink_off,
                  color: const Color(0xFFAED581), 
                  onPressed: () {},
                ),
               
              ],
            ),
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
