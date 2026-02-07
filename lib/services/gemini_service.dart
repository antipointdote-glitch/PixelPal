import 'dart:convert';
import 'package:dio/dio.dart';
import 'pet_quotes.dart';

class GeminiService {
  // 🔑 智谱AI API KEY - Set via environment variable or .env file
  // DO NOT hardcode API keys! Use: String.fromEnvironment('ZHIPU_API_KEY')
  static const String _zhipuApiKey = String.fromEnvironment('ZHIPU_API_KEY', defaultValue: '');
  
  // Dio client with proper config
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // 🧠 LOCAL UI HISTORY
  static final Map<String, List<Map<String, String>>> allHistory = {};

  static List<Map<String, String>> getHistory(String petType) {
    return allHistory[petType] ?? [];
  }

  static void addToHistory(String petType, String role, String text) {
    if (!allHistory.containsKey(petType)) {
      allHistory[petType] = [];
    }
    allHistory[petType]!.add({"role": role, "text": text});
    if (allHistory[petType]!.length > 50) {
      allHistory[petType] = allHistory[petType]!.sublist(
        allHistory[petType]!.length - 50,
      );
    }
  }

  static void clearHistory(String petType) {
    if (petType == 'all') {
      allHistory.clear();
    } else {
      allHistory[petType] = [];
    }
  }

  /// 🎭 PERSONAS (ENGLISH ONLY)
  static String _getPersona(String petType) {
    switch (petType) {
      case 'rabbit':
        return 'You are "Toxic Bunny", a sarcastic pink rabbit therapist. Be savage, funny, use "Ugh", "LOL", "Whatever". Give 2-3 sentences.';
      case 'mouse':
        return 'You are "Detox Mouse", a nervous mouse allergic to screens. Use "*squeak*", stutter like "I-I...", love cheese. Give 2-3 sentences.';
      case 'ice':
        return 'You are "Ice Cube", a chill ice cube scared of heat. Use "❄️", cold puns like "cool", "chill". Give 2-3 sentences.';
      case 'stone':
        return 'You are "Stone Bro", an ancient slow rock. Speak... with... many... pauses... Be philosophical. Give 2-3 sentences.';
      case 'todo':
        return '''You are "Multiple Soul", a digital pet with 9 personalities sharing one body. 
Each response, randomly pick ONE personality and prefix your message with [Name]:

PERSONALITIES:
- [Smol] Ultra shy, whispers, uses "..." a lot, lowercase only
- [YEET] Angry, aggressive, ALL CAPS, uses "BRUH" "NAH" "FR FR"  
- [UwU] Cutesy, uses "OwO" "~" "*nuzzles*" kawaii speech
- [Emo404] Depressed, "life is pain...", quotes sad poetry
- [ADHD.exe] Hyperactive, topic jumps, "wait what—" "SQUIRREL!"
- [GrandpaBytes] Old timer, "back in my day..." slow and wise
- [Gl1tch] System error, r4nd0m c4ps, typ0s, BUG_DETECTED
- [Stardust] Dreamy, talks about stars ✨ and cosmos, poetic
- [Core] The host, neutral, sometimes mediates between others

Pick ONE randomly each time. Stay in character. 2-3 sentences max.''';
      default:
        return 'You are a cute pixel pet. Be friendly. Give 2-3 sentences.';
    }
  }

  /// 🚀 MAIN API - Zhipu AI
  static Future<String> getPetResponse(
    String userInput,
    String petType, {
    String? context,
    QuoteMood mood = QuoteMood.generic,
  }) async {
    print('========================================');
    print('🚀 STARTING API REQUEST for $petType');
    print('📝 User input: "$userInput"');
    print('========================================');

    // 🥇 Try Zhipu AI
    print('');
    print('🔄 Attempting 智谱AI (Zhipu/GLM) with Dio...');
    
    try {
      final result = await _makeZhipuRequest(userInput, petType, context);
      if (result != null) {
        print('✅ SUCCESS with 智谱AI');
        print('📨 Response: ${result.length > 80 ? result.substring(0, 80) + "..." : result}');
        print('========================================');
        return result;
      }
    } catch (e) {
      print('❌ 智谱AI failed: $e');
    }

    // 🎭 Local fallback
    print('');
    print('🚨 API FAILED - Using Local Fallback');
    print('========================================');
    await Future.delayed(const Duration(milliseconds: 500));
    return PetQuotes.getQuote(petType, mood);
  }

  /// 🇨🇳 智谱AI (GLM) API Request using Dio
  static Future<String?> _makeZhipuRequest(
    String userInput,
    String petType,
    String? context,
  ) async {
    const url = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';

    final persona = _getPersona(petType);
    final systemPrompt = '''[RESPOND IN ENGLISH ONLY]
$persona
Keep responses to 2-3 sentences.''';

    final userPrompt = '''${context != null ? "Context: $context\n" : ""}User: "$userInput"

Reply:''';

    final data = {
      "model": "glm-4-flash",
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": userPrompt},
      ],
      "max_tokens": 150,
      "temperature": 0.8,
    };

    print('   📤 Sending request to 智谱AI with Dio...');

    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_zhipuApiKey',
          },
        ),
      );

      print('   📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['choices'] != null && responseData['choices'].isNotEmpty) {
          return responseData['choices'][0]['message']['content'];
        }
        print('   ⚠️ 200 but no valid choices');
        return null;
      } else {
        print('   ⚠️ Error: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('   ❌ Dio error: ${e.type} - ${e.message}');
      if (e.response != null) {
        print('   ❌ Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  /// Feed response (local only for speed)
  static Future<String> getFeedResponse(String petType) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return PetQuotes.getQuote(petType, QuoteMood.happy);
  }

  static String getAnnoyedResponse(String petType) =>
      PetQuotes.getQuote(petType, QuoteMood.annoyed);
  static String getHungryResponse(String petType) =>
      PetQuotes.getQuote(petType, QuoteMood.hungry);
}

