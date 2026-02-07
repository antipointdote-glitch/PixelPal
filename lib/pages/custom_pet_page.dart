import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/gemini_service.dart';
import '../services/custom_pet_service.dart';
import 'chat_history_page.dart';

class CustomPetPage extends StatefulWidget {
  final PetModel pet;
  const CustomPetPage({super.key, required this.pet});
  @override
  State<CustomPetPage> createState() => _CustomPetPageState();
}

class _CustomPetPageState extends State<CustomPetPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  double _marqueeOffset = 0;
  Timer? _marqueeTimer;

  static const Color winTeal = Color(0xFF008080);
  static const Color winGray = Color(0xFFC0C0C0);
  static const Color winBlue = Color(0xFF000080);
  static const Color winDarkGray = Color(0xFF808080);
  static const Color winWhite = Color(0xFFFFFFFF);
  static const Color terminalGreen = Color(0xFF00FF00);

  List<Map<String, String>> get chatHistory => GeminiService.getHistory('custom_${widget.pet.id}');

  String get marqueeText => widget.pet.marqueeText ?? '✨ YOUR CUSTOM PET FRIEND ✨ ${widget.pet.name.toUpperCase()} ✨';

  @override
  void initState() {
    super.initState();
    _startMarquee();
    _greetUser();
  }

  void _startMarquee() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _marqueeTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
        if (mounted) setState(() { _marqueeOffset -= 2; if (_marqueeOffset < -800) _marqueeOffset = 100; });
      });
    });
  }

  Future<void> _greetUser() async {
    setState(() => isLoading = true);
    final persona = CustomPetService.getPersona(widget.pet);
    final greeting = await GeminiService.getPetResponse(
      'Say hello to your owner for the first time!',
      'custom_${widget.pet.id}',
      context: persona,
    );
    GeminiService.addToHistory('custom_${widget.pet.id}', 'model', greeting);
    setState(() => isLoading = false);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _marqueeTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || isLoading) return;
    _textController.clear();
    GeminiService.addToHistory('custom_${widget.pet.id}', 'user', text);
    setState(() => isLoading = true);
    _scrollToBottom();
    
    final persona = CustomPetService.getPersona(widget.pet);
    final response = await GeminiService.getPetResponse(text, 'custom_${widget.pet.id}', context: persona);
    GeminiService.addToHistory('custom_${widget.pet.id}', 'model', response);
    setState(() => isLoading = false);
    _scrollToBottom();
  }

  void _doFeed() async {
    setState(() => isLoading = true);
    final persona = CustomPetService.getPersona(widget.pet);
    final response = await GeminiService.getPetResponse('Your owner just fed you! React to being fed.', 'custom_${widget.pet.id}', context: persona);
    GeminiService.addToHistory('custom_${widget.pet.id}', 'model', response);
    setState(() => isLoading = false);
    _scrollToBottom();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🍽️ Fed ${widget.pet.name}!'), backgroundColor: Colors.green));
  }

  void _doBath() async {
    setState(() => isLoading = true);
    final persona = CustomPetService.getPersona(widget.pet);
    final response = await GeminiService.getPetResponse('Your owner just gave you a bath! React to getting clean.', 'custom_${widget.pet.id}', context: persona);
    GeminiService.addToHistory('custom_${widget.pet.id}', 'model', response);
    setState(() => isLoading = false);
    _scrollToBottom();
  }

  void _doChat() {}

  void _doSleep() async {
    setState(() => isLoading = true);
    final persona = CustomPetService.getPersona(widget.pet);
    final response = await GeminiService.getPetResponse('Your owner is putting you to bed. Say goodnight!', 'custom_${widget.pet.id}', context: persona);
    GeminiService.addToHistory('custom_${widget.pet.id}', 'model', response);
    setState(() => isLoading = false);
    _scrollToBottom();
  }

  void _openChatHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatHistoryPage(petType: 'custom_${widget.pet.id}', petName: widget.pet.name, petColor: terminalGreen)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: winTeal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(flex: 5, child: _buildPetDisplayWindow()),
              const SizedBox(height: 8),
              Expanded(flex: 4, child: _buildTerminalWindow()),
              const SizedBox(height: 8),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetDisplayWindow() {
    return Container(
      decoration: _win95WindowDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: winBlue,
            child: Row(
              children: [
                const Icon(Icons.pets, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                Expanded(child: Text('MY DIGITAL PET - ${widget.pet.name.toUpperCase()}', style: const TextStyle(fontFamily: 'VT323', fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold))),
                GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 16, height: 16, decoration: _win95OutsetDecoration(), child: const Center(child: Icon(Icons.close, size: 10)))),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: winGray,
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: _win95InsetDecoration(),
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          child: widget.pet.imagePath != null
                              ? Image.file(File(widget.pet.imagePath!), fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 80, color: Colors.green))
                              : const Icon(Icons.pets, size: 80, color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 32,
                    width: double.infinity,
                    decoration: _win95InsetDecoration(),
                    child: Container(color: Colors.black, child: ClipRect(child: OverflowBox(alignment: Alignment.centerLeft, maxWidth: double.infinity, child: Transform.translate(offset: Offset(_marqueeOffset, 0), child: Text(marqueeText, style: TextStyle(fontFamily: 'VT323', fontSize: 18, color: terminalGreen), maxLines: 1, softWrap: false))))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalWindow() {
    return Container(
      decoration: _win95WindowDecoration(),
      child: Column(
        children: [
          Container(color: winDarkGray, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${widget.pet.name.toUpperCase()}_TERM.EXE', style: const TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.white)), const Text('v1.0.0', style: TextStyle(fontFamily: 'VT323', fontSize: 12, color: Colors.white))])),
          Expanded(
            child: Container(
              color: Colors.black,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: chatHistory.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isLoading && index == chatHistory.length) return Text('[...] *thinking*...', style: TextStyle(fontFamily: 'VT323', color: terminalGreen, fontSize: 14));
                  final msg = chatHistory[index];
                  final isUser = msg['role'] == 'user';
                  return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('${isUser ? '<User>' : '<${widget.pet.name}>'} ${msg['text']}', style: TextStyle(fontFamily: 'VT323', color: isUser ? Colors.white : terminalGreen, fontSize: 14)));
                },
              ),
            ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                GestureDetector(onTap: _openChatHistory, child: Container(padding: const EdgeInsets.all(4), margin: const EdgeInsets.only(right: 8), decoration: _win95OutsetDecoration(), child: Icon(Icons.history, size: 16, color: terminalGreen))),
                Text('>', style: TextStyle(fontFamily: 'VT323', color: terminalGreen, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Expanded(child: TextField(controller: _textController, enabled: !isLoading, style: TextStyle(fontFamily: 'VT323', color: terminalGreen, fontSize: 14), decoration: InputDecoration(hintText: 'SAY SOMETHING...', hintStyle: TextStyle(fontFamily: 'VT323', color: Colors.green.shade900, fontSize: 14), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero), onSubmitted: _sendMessage)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_build3DButton(Icons.restaurant, 'FEED', _doFeed), _build3DButton(Icons.bathtub, 'BATH', _doBath), _build3DButton(Icons.chat, 'CHAT', _doChat), _build3DButton(Icons.bedtime, 'SLEEP', _doSleep)]),
    );
  }

  Widget _build3DButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(width: 70, height: 60, decoration: BoxDecoration(color: winGray, border: const Border(top: BorderSide(color: winWhite, width: 2), left: BorderSide(color: winWhite, width: 2), right: BorderSide(color: winDarkGray, width: 2), bottom: BorderSide(color: winDarkGray, width: 2))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 24, color: Colors.black), Text(label, style: const TextStyle(fontFamily: 'VT323', fontSize: 10))])),
    );
  }

  BoxDecoration _win95WindowDecoration() => const BoxDecoration(color: winGray, border: Border(top: BorderSide(color: winWhite, width: 2), left: BorderSide(color: winWhite, width: 2), right: BorderSide(color: Colors.black, width: 2), bottom: BorderSide(color: Colors.black, width: 2)));
  BoxDecoration _win95OutsetDecoration() => const BoxDecoration(color: winGray, border: Border(top: BorderSide(color: winWhite, width: 1), left: BorderSide(color: winWhite, width: 1), right: BorderSide(color: winDarkGray, width: 1), bottom: BorderSide(color: winDarkGray, width: 1)));
  BoxDecoration _win95InsetDecoration() => const BoxDecoration(border: Border(top: BorderSide(color: winDarkGray, width: 2), left: BorderSide(color: winDarkGray, width: 2), right: BorderSide(color: winWhite, width: 2), bottom: BorderSide(color: winWhite, width: 2)));
}
