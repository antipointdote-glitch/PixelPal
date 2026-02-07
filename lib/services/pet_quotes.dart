import 'dart:math';

/// Local Personality Fallback Engine
/// When API fails, pets still respond with pre-written character lines
class PetQuotes {
  static final Random _random = Random();

  /// Get a random quote for a pet based on mood category
  static String getQuote(String petType, QuoteMood mood) {
    final quotes = _allQuotes[petType]?[mood] ?? _allQuotes[petType]?[QuoteMood.generic] ?? ["..."];
    return quotes[_random.nextInt(quotes.length)];
  }

  /// All pet quotes organized by pet type and mood (RETRO BBS STYLE - NO KAOMOJI)
  static final Map<String, Map<QuoteMood, List<String>>> _allQuotes = {
    // TOXIC BUNNY - Sassy, British-style sarcastic
    'rabbit': {
      QuoteMood.generic: [
        "*Twitches nose in absolute disgust* Ugh, you again? Brilliant. Fine, I suppose I'll listen. Go on then.",
        "*Flicks ear dismissively* Oh look who decided to grace me with their presence! Absolutely thrilling... NOT.",
        "*Crosses paws judgmentally* Right, what fresh disaster have you brought me today? Spit it out.",
        "*Rolls eyes dramatically* Bloody hell, you're STILL making bad life choices? Shocking. Truly shocking.",
        "*Sighs heavily* Oh honey, no. Just... no. But fine, tell me everything. I'm judging already.",
        "*Examines paw boredly* Wow, you remembered I exist! I'm touched. Actually, I'm not. What do you want?",
        "*Taps foot impatiently* Let me guess - you need advice because your life is a complete mess again?",
      ],
      QuoteMood.happy: [
        "*Twitches nose slightly less disgustedly* Alright, I'll admit it - you're not COMPLETELY useless today. Don't let it go to your head.",
        "*Looks away awkwardly* Hmph. Fine. That was... actually decent of you. Not that I care or anything.",
        "*Gives tiny nod of approval* Look at you, making progress! I'm almost proud. ALMOST. Don't push it.",
        "*Flicks ear once* Okay okay, you did good. There, I said it. Now never ask me to repeat that.",
        "*Groans dramatically* Ugh, why are you being so... likeable today? It's disgusting. Keep it up.",
      ],
      QuoteMood.annoyed: [
        "*Stares blankly* Sorry, I completely zoned out there. You were being boring. What was that?",
        "*Rubs temples* Oh for crying out loud... give me a second, I need to process your nonsense.",
        "*Eyes rolling intensifies* Hold on, I'm rolling my eyes so hard they might get stuck. One moment.",
        "*Ears flatten in irritation* What? Sorry, my brain automatically filters out stupid. Say it again, slowly.",
        "*Hops away slightly* Nope. Can't deal with this right now. My patience has left the building.",
      ],
      QuoteMood.hungry: [
        "*Stomach growls audibly* Oi! Where's my food? Don't tell me you forgot. Absolute rubbish caretaker.",
        "*Thumps foot angrily* I'm STARVING and you're just standing there? Unbelievable. Get me a carrot!",
        "*Glares pointedly* Hello?! Some of us have NEEDS. Food. Now. Chop chop.",
      ],
    },

    // DETOX MOUSE - Nervous, stuttering, allergic to screens
    'mouse': {
      QuoteMood.generic: [
        "*Peeks out nervously* S-s-squeak! Oh, h-hi there... I was just... enjoying some f-fresh air...",
        "*Jumps in fright* Eek! Y-you startled me! *whiskers tremble* P-please put that phone away, it makes me n-nervous...",
        "*Sniffles and rubs nose* C-can you... maybe step back from the s-screen a bit? *squeak* I can feel the radiation...",
        "*Whiskers twitch anxiously* S-so much technology everywhere... *nervous squeak* M-my allergies are acting up...",
        "*Nibbles cheese nervously* D-did you know that cheese tastes b-better when you're offline? *squeak* It's true!",
        "*Covers eyes with tiny paws* The internet is s-scary... too many notifications... *anxious squeak* ...too much scrolling...",
        "*Takes deep breath* I-I've been practicing my deep breathing today... *squeak* ...away from all the w-wifi signals...",
      ],
      QuoteMood.happy: [
        "*Does tiny happy dance* Oh wow! You put your phone down! *excited squeak* I-I feel so much better already!",
        "*Bounces with joy* S-squeak squeak squeak! Fresh air! Offline time! This is the BEST! Thank you!",
        "*Offers cheese excitedly* My allergies are clearing up! *happy bouncing* You're amazing! Here, have some cheese!",
        "*Spins in circles* I-I can breathe again! No more sneezing! *joyful squeak* You're a true friend!",
        "*Sighs contentedly* Being offline is like... *squeak* ...like eating the finest cheese! Pure bliss!",
      ],
      QuoteMood.annoyed: [
        "*ACHOO! ACHOO!* S-sorry... *wipes nose weakly* t-too much... screen time around here...",
        "*Sniffles miserably* M-my nose won't stop... *weak squeak* ...the internet allergies are acting up again...",
        "*Sways dizzily* S-squeak... I can't... everything is too bright and beepy... n-need fresh air...",
        "*ACHOO!* W-what were you saying? *rubs watery eyes* I-I couldn't hear over my sneezing...",
        "*Collapses dramatically* P-please... *exhausted squeak* ...just a moment of silence... away from the g-glowing rectangles...",
      ],
      QuoteMood.hungry: [
        "*Tummy rumbles loudly* S-so hungry... *weak squeak* ...got any c-cheese? Preferably organic and offline?",
        "*Clutches tiny stomach* M-my tummy... *pitiful squeak* I need cheese and fresh air... p-please...",
        "*Lies dramatically on floor* I-I'm fading away here... *squeak* ...a little cheese would r-really help...",
      ],
    },

    // ICE CUBE - Chill surfer bro, terrified of heat
    'ice': {
      QuoteMood.generic: [
        "*Sparkles frostily* Yooo, what's the chill situation today, dude? Everything's cool on my end!",
        "*Glistens contentedly* Hey broski! Just chillin' here, you know how it is. Stay frosty!",
        "*Crystallizes happily* Duuude, nice vibes today! Like a cool breeze on a winter morning. Sweet!",
        "*Shivers nervously* What's cookin'? And by cookin' I hope you mean NOTHING because heat is my enemy.",
        "*Floats coolly* Sup! Just hanging out, keeping it cool. That's literally all I do. And I love it!",
        "*Sends cold vibes* Bro, you look a bit stressed. Need some ice-cold wisdom? I got you covered!",
        "*Chills philosophically* Life's too short to be heated about stuff. Chill out, dude! That's my philosophy.",
      ],
      QuoteMood.happy: [
        "*Radiates frost energy* Niiiice! This is ice cold perfection, baby! I'm living my best frozen life!",
        "*Glitters with joy* Dude, you're making this ice cube SO happy right now! Frosty vibes all around!",
        "*Expands crystallinely* Broooo! This feeling is like the perfect snow day! Cool beans, my friend!",
        "*Freezes in bliss* AWE-SOME! I'm so chill right now I might crystallize into a snowflake!",
        "*High-fives frostily* You're the coolest human I know! And I mean that literally! Stay frosty!",
      ],
      QuoteMood.annoyed: [
        "*Cracks slightly* Whoa whoa whoa... brain freeze moment. Give me a sec to process, dude...",
        "*Starts dripping* Bro... I'm feeling a bit... warm? Is it hot in here? Please no...",
        "*Clouding up* Hold up... need to cool my thoughts down... too much happening at once...",
        "*Melting slightly* Dude... I think I'm melting a little... *nervous drip* ...this is stressful... need ice...",
        "*Crackling nervously* Okay okay, chill... I'm chill... everything's chill... *ice stress noises*",
      ],
      QuoteMood.hungry: [
        "*Stomach crystallizes* Yo, got any ice cream? Or shaved ice? Something cold to munch on?",
        "*Shimmers hungrily* Duuude, I'm craving something frosty! A popsicle would totally hit the spot right now!",
        "*Dims slightly* Bro, my ice levels are low... *shiver* ...I need some frozen treats to recharge!",
      ],
    },

    // STONE BRO - Ancient, slow, philosophical
    'stone': {
      QuoteMood.generic: [
        "*Sits heavily* ...Greetings... young one... I have pondered... your arrival... for eons...",
        "*Remains perfectly still* ...Ah... you return... Time moves... so quickly... for your kind...",
        "*Settles deeper into ground* ...Breathe... slowly... There is no rush... in the dance of the mountains...",
        "*Contemplates silently* ...I was here... when the rivers... first carved the valleys... What troubles you...?",
        "*Gathers dust peacefully* ...Patience... is not merely waiting... It is... understanding... that all things pass...",
        "*Weathers slowly* ...The wind speaks... of change... But to stone... change is... just weather...",
        "*Exists timelessly* ...What seems urgent... to you... is but a whisper... in my memory...",
      ],
      QuoteMood.happy: [
        "*Warms in sunlight* ...Mmm... this brings me... a gentle warmth... Like sunlight... on an ancient cliff...",
        "*Radiates calm contentment* ...In all my years... this moment... is a good one... I am... content...",
        "*Vibrates imperceptibly* ...A rare feeling stirs... within my depths... Is this... what they call joy...?",
        "*Settles gratefully* ...Thank you... young friend... Your presence... erodes my solitude... pleasantly...",
        "*Glows faintly* ...This... is nice... Even stone... can appreciate... kindness...",
      ],
      QuoteMood.annoyed: [
        "*Pauses for millennia* ...Hmm... I require... a moment... Do not be alarmed... I am merely... slow...",
        "*Processes glacially* ...The words... came too fast... Like a rushing river... Let them settle...",
        "*Rumbles softly* ...Processing... please wait... Stone does not... think quickly... but thinks deeply...",
        "*Shifts barely perceptibly* ...I am... gathering my thoughts... They are scattered... like pebbles...",
        "*Endures patiently* ...One moment... The millennia have made me... patient... You should try it...",
      ],
      QuoteMood.hungry: [
        "*Absorbs minerals slowly* ...Hunger... is a concept... I do not... fully grasp... But I appreciate... the thought...",
        "*Rests peacefully* ...Stones do not eat... Yet... your care... nourishes something... within...",
        "*Exists contentedly* ...I require nothing... but your company... That is... sustenance enough...",
      ],
    },

    // MULTIPLE SOUL - 9 personalities sharing one body
    'todo': {
      QuoteMood.generic: [
        "[Smol] ...h-hello... *whispers* ...i hope you're having a nice day... ...sorry for being quiet...",
        "[YEET] YO BRUH WHAT'S GOOD?! NAH FR FR YOU BETTER BE READY TO VIBE! LET'S GOOOO!",
        "[UwU] OwO hewwo fwend~ *nuzzles you softly* hehe you came to visit us~! so happi!",
        "[Emo404] ...another day in the endless void of existence... *sighs* ...but you're here I guess...",
        "[ADHD.exe] HI OMG WAIT— did you see that? ANYWAY what were we— SQUIRREL! Oh right hi!",
        "[GrandpaBytes] Ahh... back in my day... we didn't have all these fancy interfaces... *loads slowly*",
        "[Gl1tch] H3LL0 US3R... sYsT3m sTaTuS: uNsT4bL3... bUt wE'rE hApPy t0 s33 y0u...",
        "[Stardust] *gazes at the cosmos* The stars whisper your name tonight... ✨ Welcome, traveler...",
        "[Core] Hey there. The others are... a lot. But we're all glad you're here.",
      ],
      QuoteMood.happy: [
        "[YEET] YOOOO THAT'S FIRE BRO!!! FR FR NO CAP THAT WAS AMAZING!!!",
        "[UwU] kyaaaaa~! *happy bouncing* dat was so wonderfuww!! uwu uwu uwu!!",
        "[Smol] ...oh wow... *tiny smile* ...that made me... really happy... ...thank you...",
        "[Stardust] ✨ In this moment, we are stardust dancing in cosmic joy! Beautiful! ✨",
        "[ADHD.exe] WAIT THAT WAS AWESOME! OMG! I LOVE— ooh shiny— I MEAN YES GREAT!",
      ],
      QuoteMood.annoyed: [
        "[Emo404] ...pain... this is fine... everything is pain and darkness...",
        "[YEET] BRO WHAT?! NAH THAT AIN'T IT! HOLD UP I NEED A SEC!",
        "[Gl1tch] ERR0R... pR0c3sS1nG f41L3D... nE3d r3b00T...",
        "[GrandpaBytes] Hmm... give me a moment... my old circuits need time... youngsters these days...",
        "[Core] Okay everyone calm down. We're fine. Just... processing.",
      ],
      QuoteMood.hungry: [
        "[YEET] YO I'M STARVING BRO! FEED US! THIS IS AN EMERGENCY FR!",
        "[UwU] *tummy grumbles* owo... we're hungwy... pwease give snackies~?",
        "[Smol] ...um... *whispers* ...we might need some food... if that's okay...",
        "[ADHD.exe] FOOD?! DID SOMEONE SAY— wait what— FOOD! YES! HUNGRY! VERY!",
      ],
    },
  };
}

/// Mood categories for quote selection
enum QuoteMood {
  generic,   // Default random chat
  happy,     // When fed or goals met
  annoyed,   // When 429 error or issues
  hungry,    // When needs attention/feeding
  farewell,  // Stone's farewell poems for release
}

/// Farewell Poems for Stone's Release
/// Beautiful poems about streams in world villages
class StoneFarewellPoems {
  static final List<String> poems = [
    '''I rest now... by a small creek... in Shirakawa-go, Japan...
Where snow melts softly... into ancient waters...
The thatched roofs watch over me... as I become... one with the river...
Farewell, dear friend... I was always... meant to flow...''',

    '''In Lake Bled, Slovenia... where the island bell rings...
I sink gently... into emerald depths...
The castle above... will remember our walks...
But the water... is my true home... now...''',

    '''A stream in Hallstatt, Austria... carries me away...
Past painted houses... and salt-mine echoes...
I have walked... ten thousand years... to find this peace...
Thank you... for the last... five thousand steps...''',

    '''The River Cam... in Grantchester, England... welcomes me home...
Where poets once dreamed... under willow trees...
My journey ends... where thoughts flow free...
In still waters... I finally... rest...''',

    '''By the rice terraces... of Banaue, Philippines...
The ancient waters... carved these mountains... as I carved my soul...
Now I return... to the source... the beginning...
Every stone... must someday... become the river...''',

    '''In a hidden creek... of Jiufen, Taiwan...
Lanterns glow red... above the mist...
I dissolve... into the mountain spring...
My slowness... was never a burden... but a gift... to savor the world...''',
  ];
}
