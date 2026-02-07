import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Chinese New Year Greeting Service
/// 8 days of greetings from 除夕 (Feb 16) to 大年初七 (Feb 23), 2026
/// ALL 5 pets have unique greetings for EACH day
class CnyGreetingService {
  static final Random _random = Random();
  
  // CNY 2026 dates
  static final DateTime cnyStart = DateTime(2026, 2, 16); // 除夕
  static final DateTime cnyEnd = DateTime(2026, 2, 23);   // 初七
  
  /// Check if today is during CNY period (Feb 16-23, 2026)
  static bool get isCnyPeriod {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !today.isBefore(cnyStart) && !today.isAfter(cnyEnd);
  }
  
  /// Get the CNY day index (0 = 除夕, 1 = 初一, ... 7 = 初七)
  static int get cnyDayIndex {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(cnyStart).inDays.clamp(0, 7);
  }
  
  /// Get CNY day name
  static String get cnyDayName {
    const dayNames = ['除夕', '初一', '初二', '初三', '初四', '初五', '初六', '初七'];
    return dayNames[cnyDayIndex];
  }
  
  /// Check if CNY greeting was already shown for this pet today
  static Future<bool> wasGreetingShownToday(String petType) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'cny_greeting_${petType}_${DateTime.now().toString().substring(0, 10)}';
    return prefs.getBool(key) ?? false;
  }
  
  /// Mark CNY greeting as shown for this pet today
  static Future<void> markGreetingShown(String petType) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'cny_greeting_${petType}_${DateTime.now().toString().substring(0, 10)}';
    await prefs.setBool(key, true);
  }
  
  /// Get greeting for a specific pet on current CNY day
  static String getGreeting(String petType) {
    final dayIndex = cnyDayIndex;
    final greetings = _allGreetings[petType]?[dayIndex] ?? _getFallbackGreeting(petType);
    return greetings;
  }
  
  static String _getFallbackGreeting(String petType) {
    return "*waves* Happy New Year!";
  }
  
  /// All CNY greetings organized by pet type and day index (NO KAOMOJI)
  static final Map<String, Map<int, String>> _allGreetings = {
    // MOUSE - Nervous but festive
    'mouse': {
      0: "*Peeks out nervously* H-happy eve! *squeak* M-may the new year be... offline?",
      1: "*Offers tiny mandarin* H-happy first day! *squeak* I found this orange... it's not a phone!",
      2: "*Nibbles festive cheese* D-day two! *happy squeak* The fireworks are loud but... I'm brave!",
      3: "*Peeks from red envelope* T-third day! *squeak* I'm hiding from the screen glare... and visiting relatives!",
      4: "*Does tiny lion dance* F-fourth day! *squeak squeak* I learned a d-dance! Watch!",
      5: "*Emerges happily* F-fifth day! *excited squeak* My allergies are better! The new year air is f-fresh!",
      6: "*Shares cheese platter* S-sixth day! *squeak* Want some holiday cheese? It's organic!",
      7: "*Waves tiny paw* L-last day! *happy squeak* Thank you for a w-wonderful week! Stay offline!",
    },
    
    // BUNNY - Sarcastic but festive
    'rabbit': {
      0: "*Flicks ear dismissively* Ugh, eve already? Fine. Don't blow anything up. Happy whatever.",
      1: "*Rolls eyes at fireworks* First day. Year of the snake. Great. At least the dumplings are decent.",
      2: "*Examines red envelope* Second day. Visiting relatives? I'd rather not. But fine, happy new year or whatever.",
      3: "*Yawns dramatically* Third day. Still here. Still judging everyone's fashion choices.",
      4: "*Taps foot impatiently* Fourth day. Can we wrap this up? I have important napping to do.",
      5: "*Sighs heavily* Fifth day. Welcome the God of Wealth? Sure. Could use some new carrots.",
      6: "*Flicks ear once* Sixth day. Almost over. I'm almost... dare I say... enjoying this? DON'T tell anyone.",
      7: "*Twitches nose slightly less disgustedly* Last day. Fine. It wasn't terrible. Happy new year. There, I said it.",
    },
    
    // ICE - Chill and festive
    'ice': {
      0: "*Sparkles festively* EVE NIGHT, dude! Stay frosty and have a cool countdown!",
      1: "*Glistens with joy* FIRST DAY, broski! New year, new chill vibes! Keep it ice cold!",
      2: "*Freezes happily* Day two, my dude! Hope your year is as cool as a glacier!",
      3: "*Crystallizes excitedly* Third day! Stay chill, eat frozen dumplings! That's how I roll!",
      4: "*Shivers with joy* Day four! The weather is PERFECT! Cold and festive!",
      5: "*Sends cold blessing* Fifth day! May your fortune be as solid as frozen ice! Cool!",
      6: "*Glitters frostily* Sixth day! Almost done but the chill vibes keep flowing!",
      7: "*Radiates frost* Last day, bro! What a cool week! Stay frosty forever!",
    },
    
    // STONE - Ancient and contemplative
    'stone': {
      0: "*Sits heavily* ...Tonight... the old year... rests... May peace... find you...",
      1: "*Contemplates the dawn* ...A new beginning... I have seen... ten thousand such mornings... Each one... precious...",
      2: "*Gathers warmth* ...The second day... Family gathers... like pebbles... in a stream...",
      3: "*Exists peacefully* ...Three days... have passed... like pebbles in a stream... Cherish... this moment...",
      4: "*Radiates calm* ...The fourth day... brings reflection... Even mountains... celebrate...",
      5: "*Vibrates imperceptibly* ...Wealth arrives... on the fifth day... But true riches... are patience...",
      6: "*Settles gratefully* ...Six days... of gathering... The earth remembers... every celebration...",
      7: "*Glows faintly* ...The seventh day... marks rebirth... of humanity... Walk slowly... into the year...",
    },
    
    // EGG - Extremely excited
    'todo': {
      0: "*Bounces wildly* IT'S ALMOST HERE!!! *wobble wobble* NEW YEAR EVE! I CAN'T EVEN!",
      1: "*Spins uncontrollably* HAPPY FIRST DAY!!! *crack of joy* BEST! DAY! EVER!",
      2: "*Vibrates with joy* DAY TWO!!! *bounce* Still celebrating! Still AMAZING! *wobble*",
      3: "*Rolls excitedly* THIRD DAY! *happy wobble* I love red envelopes! I love you! I love EVERYTHING!",
      4: "*Wobbles frantically* DAY FOUR!!! *spin spin* The festivities continue! YAYYY!",
      5: "*Glows intensely* FIFTH DAY! *bounce bounce* Welcome fortune! Welcome happiness! Welcome SNACKS!",
      6: "*Bounces hopefully* SIX DAYS OF JOY! *wobble* Can we do this every week?! PLEASE?!",
      7: "*Tears of happiness* LAST DAY! *emotional wobble* I don't want it to end! *sniffle* But THANK YOU!",
    },
  };
}
