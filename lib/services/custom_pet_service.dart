import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet_model.dart';
import 'gemini_service.dart';

/// Service for managing custom user-created pets
class CustomPetService {
  static SharedPreferences? _prefs;
  static const String _keyCustomPets = 'custom_pets';

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get all custom pets
  static Future<List<PetModel>> getCustomPets() async {
    await init();
    final String? json = _prefs!.getString(_keyCustomPets);
    if (json == null) return [];
    
    final List<dynamic> list = jsonDecode(json);
    return list.map((e) => PetModel.fromJson(e)).toList();
  }

  /// Save a custom pet
  static Future<void> saveCustomPet(PetModel pet) async {
    await init();
    final pets = await getCustomPets();
    
    // Check if pet already exists (update) or is new (add)
    final index = pets.indexWhere((p) => p.id == pet.id);
    if (index >= 0) {
      pets[index] = pet;
    } else {
      pets.add(pet);
    }
    
    await _prefs!.setString(_keyCustomPets, jsonEncode(pets.map((p) => p.toJson()).toList()));
  }

  /// Delete a custom pet
  static Future<void> deleteCustomPet(String petId) async {
    await init();
    final pets = await getCustomPets();
    pets.removeWhere((p) => p.id == petId);
    await _prefs!.setString(_keyCustomPets, jsonEncode(pets.map((p) => p.toJson()).toList()));
  }

  /// Generate a unique ID for custom pet
  static String generatePetId() {
    return 'custom_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Generate AI personality based on user input
  static Future<String> generatePersonality({
    required String name,
    required String profile,
    String? birthday,
  }) async {
    // Create a prompt to generate a unique personality
    final prompt = '''Based on this pet's information, create a SHORT personality description (2-3 sentences) for an AI pet character:

Pet Name: $name
${birthday != null ? 'Birthday: $birthday' : ''}
Owner's Description: $profile

Create a unique, quirky personality with:
- A distinctive speech pattern or catchphrase
- An emotional tendency (dramatic, shy, excited, etc.)
- A funny quirk or habit

Keep it SHORT and memorable!''';

    try {
      final response = await GeminiService.getPetResponse(prompt, 'custom');
      return response;
    } catch (e) {
      // Fallback personality if API fails
      return "A mysteriously charming pet who loves adventures and snacks. *wiggles excitedly* Always ready to chat!";
    }
  }

  /// Create a new custom pet with AI-generated personality
  static Future<PetModel> createCustomPet({
    required String name,
    required String profile,
    required String birthday,
    String? imagePath,
    String? marqueeText,
  }) async {
    // Generate personality using AI
    final personality = await generatePersonality(
      name: name,
      profile: profile,
      birthday: birthday,
    );

    final pet = PetModel(
      id: generatePetId(),
      name: name,
      description: profile,
      type: 'custom',
      isActive: true,
      isUnlocked: true,
      isCustom: true,
      imagePath: imagePath,
      birthday: birthday,
      personality: personality,
      marqueeText: marqueeText,
    );

    await saveCustomPet(pet);
    return pet;
  }

  /// Get persona for AI chat
  static String getPersona(PetModel pet) {
    return '''You are "${pet.name}", a custom digital pet with this personality:
${pet.personality ?? "A friendly and curious pet who loves to chat!"}

${pet.description.isNotEmpty ? "About you from your owner: ${pet.description}" : ""}

Be playful, use your personality traits, and respond in 2-3 sentences. Stay in character!''';
  }
}
