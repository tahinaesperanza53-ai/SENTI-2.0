import 'dart:math';

import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

class _RealLifeScenario {
  final String situation;
  final String correctSentence;
  final String sentenceTypeHint;
  final List<String> distractors;

  const _RealLifeScenario({
    required this.situation,
    required this.correctSentence,
    required this.sentenceTypeHint,
    required this.distractors,
  });
}

class RealLifeSentencesGameScreen extends StatefulWidget {
  final String backgroundPath;

  const RealLifeSentencesGameScreen({super.key, required this.backgroundPath});

  @override
  State<RealLifeSentencesGameScreen> createState() =>
      _RealLifeSentencesGameScreenState();
}

class _RealLifeSentencesGameScreenState
    extends State<RealLifeSentencesGameScreen> {
  final Random _random = Random();

  // 50 real-life scenarios
  static const List<_RealLifeScenario> _scenarios = [
    _RealLifeScenario(
      situation: 'You lost your pencil case in the classroom and want to ask your classmate.',
      correctSentence: 'Have you seen my blue pencil case?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'Close the classroom door.',
        'What a giant rainbow!',
        'The library opens at eight.',
      ],
    ),
    _RealLifeScenario(
      situation:
          'Your friend is about to step into a deep puddle on the playground.',
      correctSentence: 'Watch out for that big puddle!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Where is the school canteen?',
        'My shoes are black and white.',
        'Please write your name neatly.',
      ],
    ),
    _RealLifeScenario(
      situation:
          'You want your younger brother to politely pass the box of crayons.',
      correctSentence: 'Please pass the box of crayons.',
      sentenceTypeHint: 'Requesting Sentence (Imperative)',
      distractors: [
        'Why is the sky so blue?',
        'Crayons come in many colors.',
        'Hooray, our painting is done!',
      ],
    ),
    _RealLifeScenario(
      situation: 'Your teacher asks you to tell the class what animal you saw at the farm.',
      correctSentence: 'I saw a brown horse in the barn.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Can you feed the chickens?',
        'Please wash your hands now.',
        'What a huge tractor that is!',
      ],
    ),
    _RealLifeScenario(
      situation:
          'Your school team just scored the winning point in the final match!',
      correctSentence: 'Hooray, our team won the game!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'When does the bus arrive?',
        'Put the ball in the basket.',
        'We practice every Tuesday.',
      ],
    ),
    _RealLifeScenario(
      situation:
          'You are in the school library and need to ask what time it closes.',
      correctSentence: 'What time does the library close?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'Please speak softly inside.',
        'Books are arranged on shelves.',
        'What an exciting adventure story!',
      ],
    ),
    _RealLifeScenario(
      situation: 'It is time for lunch and you remind your seatmate to wash their hands.',
      correctSentence: 'Wash your hands before eating.',
      sentenceTypeHint: 'Commanding Sentence (Imperative)',
      distractors: [
        'Did you bring a sandwich?',
        'My lunchbox has fresh mangoes.',
        'How yummy this soup smells!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You want to tell your parents about your favorite subject in school.',
      correctSentence: 'English is my favorite subject.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Which book did you borrow?',
        'Open your book to page five.',
        'What a fun spelling game!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You see a bright rainbow right after a sudden afternoon rain shower.',
      correctSentence: 'How tall and bright that rainbow is!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Where did the clouds go?',
        'Rain falls from dark clouds.',
        'Please bring your umbrella inside.',
      ],
    ),
    _RealLifeScenario(
      situation:
          'You forgot your eraser at home and ask to borrow one from a friend.',
      correctSentence: 'May I borrow your eraser, please?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'Erasers remove pencil marks.',
        'Please put the eraser down.',
        'What a tiny pink eraser!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You are leaving the room and want everyone to keep their desks neat.',
      correctSentence: 'Please clean up your study desk.',
      sentenceTypeHint: 'Requesting Sentence (Imperative)',
      distractors: [
        'Is your desk clean today?',
        'The desk is made of wood.',
        'What a tidy classroom!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You are telling a friend what time your piano lesson starts.',
      correctSentence: 'My piano lesson starts at four o’clock.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'When does your lesson start?',
        'Please practice the song now.',
        'How loud that piano sounds!',
      ],
    ),
    _RealLifeScenario(
      situation: 'A heavy book is about to slide off the edge of the table.',
      correctSentence: 'Look out, that heavy book is falling!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Whose book is on the table?',
        'The book has a blue cover.',
        'Please pick up the book.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You want to know how many pages are in the new storybook.',
      correctSentence: 'How many pages are in this book?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'Turn to the first page.',
        'This book has colorful pictures.',
        'What a wonderful story!',
      ],
    ),
    _RealLifeScenario(
      situation:
          'You ask your classmate to stand in a straight line for assembly.',
      correctSentence: 'Line up quietly in the hallway.',
      sentenceTypeHint: 'Commanding Sentence (Imperative)',
      distractors: [
        'Are we standing in line?',
        'The line goes to the hall.',
        'What a long morning line!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You share a simple fact about the weather outside today.',
      correctSentence: 'The morning breeze feels cool today.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Does the breeze feel cool?',
        'Please open the window wide.',
        'How fresh the air feels!',
      ],
    ),
    _RealLifeScenario(
      situation:
          'Your little cousin just made a funny face and you laugh together!',
      correctSentence: 'What a funny face you just made!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Why are you making that face?',
        'He has a round face.',
        'Please stop making faces.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You are not sure if the art room is open during lunch break.',
      correctSentence: 'Is the art room open right now?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'The art room is next door.',
        'Please lock the art room.',
        'What a colorful art room!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You politely ask your partner to share the colored markers.',
      correctSentence: 'Please share the colored markers.',
      sentenceTypeHint: 'Requesting Sentence (Imperative)',
      distractors: [
        'Do you have green markers?',
        'Markers come in a box.',
        'What bright colors these are!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You tell your teacher that you finished coloring your map.',
      correctSentence: 'I finished coloring my map.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Did you finish your map?',
        'Please color the map neatly.',
        'What a detailed map this is!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You spot a huge shiny trophy on the school display shelf!',
      correctSentence: 'Look at that huge shiny trophy!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Who won that shiny trophy?',
        'The trophy sits on the shelf.',
        'Please dust the trophy shelf.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You want to ask which seat belongs to the new student.',
      correctSentence: 'Which seat is for our new classmate?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'The front seat is empty.',
        'Please sit in your seat.',
        'How nice it is to meet you!',
      ],
    ),
    _RealLifeScenario(
      situation:
          'You remind a friend to throw empty wrappers into the trash bin.',
      correctSentence: 'Put your wrapper inside the bin.',
      sentenceTypeHint: 'Commanding Sentence (Imperative)',
      distractors: [
        'Where is the trash bin?',
        'The bin is near the door.',
        'What a clean schoolyard!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You tell your friend what kind of pet you have at home.',
      correctSentence: 'I have a gentle white cat at home.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Do you have a pet cat?',
        'Please feed the white cat.',
        'What a soft little cat!',
      ],
    ),
    _RealLifeScenario(
      situation: 'Your class just solved a tricky riddle together!',
      correctSentence: 'Hooray, we solved the riddle together!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Can you solve this riddle?',
        'Read the riddle out loud.',
        'Riddles can be fun to read.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You want to ask if the school bus has arrived yet.',
      correctSentence: 'Has the school bus arrived yet?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'The school bus is yellow.',
        'Please wait by the gate.',
        'What a big yellow bus!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You ask your classmate to listen closely to the story.',
      correctSentence: 'Listen carefully to the story.',
      sentenceTypeHint: 'Commanding Sentence (Imperative)',
      distractors: [
        'Did you hear the story?',
        'The story is about a bear.',
        'What an exciting story!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You tell your partner what color your water bottle is.',
      correctSentence: 'My water bottle is sky blue.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Where is your water bottle?',
        'Please fill your bottle now.',
        'How cold this water is!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You see a giant balloon floating high above the park!',
      correctSentence: 'What a giant balloon in the sky!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Where did that balloon come from?',
        'The balloon is round and red.',
        'Hold the string tightly.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You ask your teacher when the spelling quiz will happen.',
      correctSentence: 'When is our spelling quiz today?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'We have a spelling quiz.',
        'Please spell the word clearly.',
        'How fun spelling games can be!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You ask your friend to open their notebook to page ten.',
      correctSentence: 'Open your notebook to page ten.',
      sentenceTypeHint: 'Commanding Sentence (Imperative)',
      distractors: [
        'Is your notebook on page ten?',
        'My notebook has lined pages.',
        'What a neat notebook!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You tell your family that you helped water the plants.',
      correctSentence: 'I watered the garden plants today.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Did you water the plants?',
        'Please water the small plants.',
        'How green the leaves look!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You taste a sweet slice of mango and love how good it is!',
      correctSentence: 'How sweet and juicy this mango is!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Is this mango sweet?',
        'Mangoes grow on trees.',
        'Please share a slice of mango.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You want to ask who left the umbrella near the door.',
      correctSentence: 'Whose umbrella is by the door?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'The umbrella is folded.',
        'Please hang the umbrella up.',
        'What a colorful umbrella!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You ask someone to sit up straight during class reading.',
      correctSentence: 'Sit straight in your chair.',
      sentenceTypeHint: 'Commanding Sentence (Imperative)',
      distractors: [
        'Are you sitting straight?',
        'The chair is next to the desk.',
        'How comfortable this chair is!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You state a clear fact about birds in the morning.',
      correctSentence: 'Birds sing songs in the morning.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Do birds sing in the morning?',
        'Please listen to the birds.',
        'What a cheerful bird song!',
      ],
    ),
    _RealLifeScenario(
      situation: 'Your friend just finished a huge 100-piece puzzle!',
      correctSentence: 'Wow, you finished the whole puzzle!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'How many pieces are left?',
        'Puzzles have many shapes.',
        'Please put the box away.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You ask if anyone needs help carrying the art supplies.',
      correctSentence: 'Can I help carry those supplies?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'The supplies are in the box.',
        'Please carry the box slowly.',
        'What helpful classmates we have!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You politely ask your groupmate to hand over the glue stick.',
      correctSentence: 'Please pass the glue stick to me.',
      sentenceTypeHint: 'Requesting Sentence (Imperative)',
      distractors: [
        'Where is the glue stick?',
        'Glue helps paper stick together.',
        'How neat your collage looks!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You tell your classmate what you ate for breakfast.',
      correctSentence: 'I ate warm rice and eggs.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'What did you eat today?',
        'Please eat a healthy breakfast.',
        'What a yummy breakfast!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You see a fast runner zoom past the finish line!',
      correctSentence: 'How fast that runner crossed the line!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Who ran the fastest today?',
        'Runners wear sneakers.',
        'Please cheer for the runners.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You want to ask why the class pet turtle is hiding.',
      correctSentence: 'Why is the turtle hiding in its shell?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'Turtles have hard shells.',
        'Please do not tap the glass.',
        'What a cute little turtle!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You remind everyone to speak softly inside the library.',
      correctSentence: 'Please speak softly in the library.',
      sentenceTypeHint: 'Requesting Sentence (Imperative)',
      distractors: [
        'Are we speaking softly?',
        'The library has quiet corners.',
        'What a peaceful reading room!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You tell a friend that your dog likes chasing balls.',
      correctSentence: 'My dog loves chasing red balls.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Does your dog chase balls?',
        'Please throw the red ball.',
        'What a playful puppy!',
      ],
    ),
    _RealLifeScenario(
      situation: 'A sudden gust of wind blows papers across the desk!',
      correctSentence: 'Watch out, the wind is blowing!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Why is the window open?',
        'Wind moves the tree leaves.',
        'Please close the window now.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You ask your teacher how to pronounce a new word.',
      correctSentence: 'How do you say this new word?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'This word has three syllables.',
        'Please read the word aloud.',
        'What a great new word!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You ask your partner to put the crayons back in the tray.',
      correctSentence: 'Please put the crayons in the tray.',
      sentenceTypeHint: 'Requesting Sentence (Imperative)',
      distractors: [
        'Are the crayons in the tray?',
        'The tray holds twelve crayons.',
        'How colorful the tray looks!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You tell the class that fish breathe underwater.',
      correctSentence: 'Fish swim in rivers and oceans.',
      sentenceTypeHint: 'Telling Sentence (Declarative)',
      distractors: [
        'Do fish live in the river?',
        'Please keep the water clean.',
        'What bright orange fish!',
      ],
    ),
    _RealLifeScenario(
      situation: 'You see a huge sparkling star in the evening sky!',
      correctSentence: 'How brightly that star shines tonight!',
      sentenceTypeHint: 'Exclamatory Sentence (!)',
      distractors: [
        'Which star is the brightest?',
        'Stars appear at night.',
        'Please look up at the sky.',
      ],
    ),
    _RealLifeScenario(
      situation: 'You ask your friend if they are ready for story time.',
      correctSentence: 'Are you ready for story time?',
      sentenceTypeHint: 'Asking Sentence (Interrogative)',
      distractors: [
        'Story time starts soon.',
        'Please sit on the rug.',
        'Hooray, it is story time!',
      ],
    ),
  ];

  late List<_RealLifeScenario> _shuffledScenarios;
  late List<String> _currentOptions;
  int _index = 0;
  int _score = 0;
  bool _solved = false;
  String? _wrongSelected;
  String _feedback = 'Choose the sentence that best fits the real-life scene!';
  bool _isError = false;

  double get _textScale {
    switch (GameSettingsController.instance.textSize) {
      case 'Small':
        return 0.9;
      case 'Large':
        return 1.12;
      default:
        return 1.0;
    }
  }

  @override
  void initState() {
    super.initState();
    SoundManager.instance.syncWithSettings();
    _startRandomSession();
  }

  void _startRandomSession() {
    _shuffledScenarios = List<_RealLifeScenario>.from(_scenarios)
      ..shuffle(_random);
    _score = 0;
    _loadScenario(0);
  }

  void _loadScenario(int idx) {
    if (idx >= _shuffledScenarios.length) {
      _shuffledScenarios.shuffle(_random);
      _index = 0;
    } else {
      _index = idx;
    }

    final current = _shuffledScenarios[_index];
    _currentOptions = [current.correctSentence, ...current.distractors]
      ..shuffle(_random);
    _solved = false;
    _wrongSelected = null;
    _isError = false;
    _feedback = 'Choose the sentence that best fits the real-life scene!';
  }

  void _onOptionTap(String option) {
    SoundManager.instance.playClick();
    final current = _shuffledScenarios[_index];

    if (option == current.correctSentence) {
      if (_solved) return;
      setState(() {
        _solved = true;
        _wrongSelected = null;
        _isError = false;
        _score += 10;
        _feedback = 'Spot on! That uses a ${current.sentenceTypeHint}.';
      });
    } else {
      setState(() {
        _wrongSelected = option;
        _isError = true;
        _feedback = 'Try again! Think about what you would say in that moment.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _shuffledScenarios[_index];

    return ListenableBuilder(
      listenable: GameSettingsController.instance,
      builder: (context, _) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.backgroundPath),
                fit: BoxFit.cover,
                onError: (_, _) {},
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 15,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        SoundManager.instance.playClick();
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            'assets/images/back.jpeg',
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.black87,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(top: 15, right: 15, child: SettingsButton()),
                  Column(
                    children: [
                      const SizedBox(height: 68),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                    maxWidth: 430,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2F1)
                                        .withValues(alpha: 0.96),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: const Color(0xFF00897B),
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.24,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF26A69A),
                                              Color(0xFF00695C),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24),
                                          ),
                                        ),
                                        child: Text(
                                          '6. Real Life, Real Sentences • Score: $_score',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.5 * _textScale,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFDE7),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFFB300,
                                                  ),
                                                  width: 2.2,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.lightbulb_rounded,
                                                    color: Color(0xFFFFA000),
                                                    size: 28,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      current.situation,
                                                      style: TextStyle(
                                                        fontSize:
                                                            14.5 * _textScale,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                          0xFF3E2723,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ..._currentOptions.map((opt) {
                                              final ok =
                                                  _solved &&
                                                  opt ==
                                                      current.correctSentence;
                                              final bad = _wrongSelected == opt;

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 9,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _onOptionTap(opt),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 11,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: ok
                                                          ? const Color(
                                                              0xFFC8E6C9,
                                                            )
                                                          : (bad
                                                                ? const Color(
                                                                    0xFFFFCDD2,
                                                                  )
                                                                : Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      border: Border.all(
                                                        color: ok
                                                            ? const Color(
                                                                0xFF2E7D32,
                                                              )
                                                            : (bad
                                                                  ? const Color(
                                                                      0xFFD32F2F,
                                                                    )
                                                                  : const Color(
                                                                      0xFF4DB6AC,
                                                                    )),
                                                        width: 2.2,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      opt,
                                                      style: TextStyle(
                                                        fontSize:
                                                            14.5 * _textScale,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                          0xFF1B365D,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                            const SizedBox(height: 6),
                                            GestureDetector(
                                              onTap: () {
                                                SoundManager.instance
                                                    .playClick();
                                                setState(
                                                  () =>
                                                      _loadScenario(_index + 1),
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 10,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFF66BB6A),
                                                          Color(0xFF2E7D32),
                                                        ],
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(26),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF1B5E20,
                                                    ),
                                                    width: 2.5,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Next',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            18 * _textScale,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    const Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                    maxWidth: 430,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isError
                                          ? const [
                                              Color(0xFFFFE082),
                                              Color(0xFFFFCA28),
                                            ]
                                          : const [
                                              Color(0xFFC8E6C9),
                                              Color(0xFFA5D6A7),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _isError
                                          ? const Color(0xFFF57C00)
                                          : const Color(0xFF2E7D32),
                                      width: 2.5,
                                    ),
                                  ),
                                  child: Text(
                                    _feedback,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF1B5E20),
                                      fontSize: 14.5 * _textScale,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
