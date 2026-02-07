/// Sharp-tongue responses for Bunny (pseudo-psychologist mode)
/// Two modes: Normal cynical and "Cyber Bestie" defending mode
class BunnyTongue {
  /// Cynical responses for normal interaction
  static const List<String> cynicalResponses = [
    "*Sighs* Oh, you're back. How... thrilling.",
    "*Twitches ear* Let me guess, another existential crisis?",
    "*Looks up from carrot* What now? I was having a moment.",
    "*Flicks ear dismissively* Humans are EXHAUSTING, you know that?",
    "*Chews slowly* Go on. I'm listening. Barely.",
    "*Adjusts invisible glasses* Fascinating. Tell me more about your... feelings.",
  ];
  
  /// Sharp defensive responses when user vents about someone
  static const List<String> defenseResponses = [
    "*Ears perk up aggressively* EXCUSE ME?! They said WHAT to you?!",
    "*Thumps foot angrily* Oh, I KNOW you're not letting them treat you like that!",
    "*Glares into distance* Give me their address. For... research purposes.",
    "*Fluffs up protectively* Listen, anyone who hurts you is DEAD to me. DEAD!",
    "*Crosses arms* They're clearly projecting their own insecurities. Pathetic.",
    "*Sharpens claws metaphorically* Want me to write them a STRONGLY worded letter?",
  ];
  
  /// Roast messages about the person user is complaining about
  static const List<String> roastMessages = [
    "Honestly? They sound like the human equivalent of a wet sock.",
    "Some people just have the emotional intelligence of a potato. Sorry you had to deal with that.",
    "They're probably the type who microwaves fish in a shared office. Says everything.",
    "I've met smarter carrots. And I've eaten a LOT of carrots.",
    "They peaked in middle school. I can tell.",
    "Classic main character syndrome. They think the world revolves around them.",
  ];
  
  /// Supportive responses after roasting
  static const List<String> supportiveResponses = [
    "*Nudges you gently* But hey... YOU'RE okay. You're better than them.",
    "*Softens slightly* ...You know I'm here for you, right? Even if I'm prickly about it.",
    "*Clears throat* Anyway. You're valid. Don't let them make you feel otherwise.",
    "*Looks away* I'm not good at this mushy stuff but... you matter. Or whatever.",
    "*Offers imaginary carrot* Here. Comfort food. You deserve it after dealing with THAT.",
  ];
  
  static String getRandomCynical() {
    return cynicalResponses[DateTime.now().millisecond % cynicalResponses.length];
  }
  
  static String getRandomDefense() {
    return defenseResponses[DateTime.now().millisecond % defenseResponses.length];
  }
  
  static String getRandomRoast() {
    return roastMessages[DateTime.now().second % roastMessages.length];
  }
  
  static String getRandomSupport() {
    return supportiveResponses[DateTime.now().second % supportiveResponses.length];
  }
  
  /// Detect if user is venting about someone
  static bool isVenting(String text) {
    final ventKeywords = [
      'hate', 'angry', 'mad', 'upset', 'frustrated', 'annoyed', 
      'they said', 'she said', 'he said', 'told me', 'treated me',
      'hurt', 'rude', 'mean', 'unfair', 'wrong', 'stupid', 'idiot',
      'boss', 'coworker', 'friend', 'family', 'parent', 'partner',
      'sick of', 'tired of', 'can\'t stand', 'so annoying',
    ];
    final lowerText = text.toLowerCase();
    return ventKeywords.any((keyword) => lowerText.contains(keyword));
  }
  
  /// Detect vulnerability, pain, or bullying in diary entry
  static bool isVulnerable(String text) {
    final vulnerableKeywords = [
      'sad', 'cry', 'crying', 'cried', 'tears', 'depressed', 'depression',
      'lonely', 'alone', 'no one', 'nobody', 'worthless', 'useless',
      'hate myself', 'hate my', 'kill', 'die', 'death', 'suicide',
      'bullied', 'bully', 'bullying', 'picked on', 'made fun of',
      'scared', 'afraid', 'fear', 'anxiety', 'anxious', 'panic',
      'hurt me', 'hurts', 'pain', 'suffering', 'struggle',
      'rejected', 'abandoned', 'betrayed', 'cheated', 'lied to',
      'failed', 'failure', 'loser', 'pathetic', 'terrible',
      'can\'t do', 'give up', 'giving up', 'hopeless', 'helpless',
      'abuse', 'abused', 'hit me', 'yelled at', 'screamed at',
    ];
    final lowerText = text.toLowerCase();
    return vulnerableKeywords.any((keyword) => lowerText.contains(keyword));
  }
  
  /// Diary responses for normal/boring entries (sarcastic)
  static const List<String> sarcasticDiaryResponses = [
    "*Reads diary* ...That's it? That's the whole entry? Groundbreaking content. *yawns*",
    "*Skims entry* Hmm. Riveting stuff. Really. I'm on the edge of my carrot. *munches sarcastically*",
    "*Peers at diary* Okay, I've read worse. Barely. Keep writing, I guess. *flick*",
    "*Notes it down mentally* Filed under 'mildly interesting'. You're welcome.",
    "*Sighs* Another day, another diary entry. At least you're consistent. *begrudging respect*",
    "*Reads with one eye open* Not bad. Not great. Just... adequate. Like most humans.",
  ];
  
  /// Diary responses for vulnerable/painful entries (fierce defense)
  static const List<String> defenseDiaryResponses = [
    "*Ears shoot up* WAIT. Hold on. Who made you feel this way?! *bristles with rage*",
    "*Drops carrot immediately* Okay, STOP. You're telling me someone hurt you? WHERE ARE THEY?!",
    "*Gets uncomfortably close* Listen to me. LISTEN. You're NOT what they said. They're WRONG.",
    "*Thumps foot aggressively* I will END whoever made you feel like this. Give me names!",
    "*Softens but with angry eyes* ...You didn't deserve that. You hear me? NOT. YOUR. FAULT.",
    "*Protective mode activated* Nobody talks to MY human like that. I'll bite them. I'm serious.",
  ];
  
  /// Follow-up support after fierce defense
  static const List<String> diaryFollowUpSupport = [
    "*Nudges you gently* ...Hey. It's okay to feel bad. But you're not alone. I'm here. *reluctant but sincere*",
    "*Sits closer* I know I'm prickly but... you matter, okay? Don't let them win.",
    "*Offers imaginary carrot* Here. Comfort food. You've been through a lot. *unusual softness*",
    "*Looks away awkwardly* I'm not good at this but... I care. About you. Or whatever. *ears down*",
  ];
  
  static String getDiaryResponse(String diaryText) {
    if (isVulnerable(diaryText)) {
      // Return defense + follow-up
      final defense = defenseDiaryResponses[DateTime.now().second % defenseDiaryResponses.length];
      final support = diaryFollowUpSupport[DateTime.now().millisecond % diaryFollowUpSupport.length];
      return '$defense\n\n$support';
    } else {
      // Return sarcastic response
      return sarcasticDiaryResponses[DateTime.now().second % sarcasticDiaryResponses.length];
    }
  }
}
