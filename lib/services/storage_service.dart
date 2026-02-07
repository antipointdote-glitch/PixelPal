import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet_model.dart';

class StorageService {
  static const String keyPets = 'user_pets';

  Future<void> savePets(List<PetModel> pets) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(pets.map((p) => p.toJson()).toList());
    await prefs.setString(keyPets, data);
  }

  Future<List<PetModel>> loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(keyPets);
    if (data == null) {
      return _getInitialPets();
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => PetModel.fromJson(json)).toList();
    } catch (e) {
      return _getInitialPets();
    }
  }

  // Pre-populate with the 5 pets
  List<PetModel> _getInitialPets() {
    return [
      PetModel(
        id: 'mouse',
        name: 'Internet Detox Mouse',
        description: 'Allergic to the internet. Sneezes when you scroll too much.',
        type: 'mouse',
        isUnlocked: true, // First one unlocked
        isActive: false, 
      ),
      PetModel(
        id: 'stone',
        name: 'Walking Stone',
        description: 'Just a stone. Unlocks shiny forms if you walk enough.',
        type: 'stone',
        isUnlocked: true,
        isActive: false,
      ),
       PetModel(
        id: 'ice',
        name: 'Weather Ice',
        description: 'Melts when it is hot. Freezes when it is cold.',
        type: 'ice',
        isUnlocked: true,
        isActive: false,
      ),
       PetModel(
        id: 'todo',
        name: '9 Tamagotchis',
        description: 'Complete tasks to satisfy them. They are needy.',
        type: 'todo',
        isUnlocked: true,
        isActive: false,
      ),
       PetModel(
        id: 'rabbit',
        name: 'Psych Rabbit',
        description: 'Writes "honest" diary feedback. Toxic but healing.',
        type: 'rabbit',
        isUnlocked: true,
        isActive: false,
      ),
    ];
  }
}
