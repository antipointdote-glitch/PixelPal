/// Cold Jokes for Ice Pet
/// Puns and temperature-related humor
class ColdJokes {
  static final List<String> jokes = [
    "*Sparkles mischievously* Why did the ice cube feel so stressed? Because it was under a LOT of pressure! Get it? Haha!",
    "*Crystallizes with laughter* What do you call a cold dog? A PUP-sicle! Brrr-illiant, right?",
    "*Shivers with glee* Why don't scientists trust atoms? Because they make up EVERYTHING! ...That was pretty cool, huh?",
    "*Freezes mid-joke* What's an ice cube's favorite letter? ICY! ...I mean, I-C! Get it?!",
    "*Giggles frostily* Why did the snowman call his dog Frost? Because Frost BITES! Hahaha!",
    "*Sends chill vibes* What do you call a snowman with a six-pack? An ABDOMINAL snowman!",
    "*Cracks up* Why is the ocean so salty? Because the land never waves back! ...That's cold, bro!",
    "*Glitters with joy* What's a snowman's favorite breakfast? FROSTED flakes! Classic!",
    "*Chuckles icily* Why did the glacier break up with the iceberg? There was too much FRICTION! Ha!",
    "*Freezes dramatically* What do you call an old snowman? WATER! ...Too dark? Sorry, I'm cool like that.",
  ];
  
  static String getRandomJoke() {
    return jokes[DateTime.now().millisecond % jokes.length];
  }
}
