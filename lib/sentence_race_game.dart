import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

class _RaceQuestion {
  final String incompleteSentence;
  final String correctEnding;
  final List<String> wrongEndings;

  const _RaceQuestion({
    required this.incompleteSentence,
    required this.correctEnding,
    required this.wrongEndings,
  });
}

class SentenceRaceGameScreen extends StatefulWidget {
  final String backgroundPath;

  const SentenceRaceGameScreen({super.key, required this.backgroundPath});

  @override
  State<SentenceRaceGameScreen> createState() => _SentenceRaceGameScreenState();
}

class _SentenceRaceGameScreenState extends State<SentenceRaceGameScreen> {
  final Random _random = Random();
  static const int _finishSteps = 10;

  // 50 total sentences
  static const List<_RaceQuestion> _raceBank = [
    _RaceQuestion(
      incompleteSentence: 'Where did you put ___',
      correctEnding: 'my red backpack?',
      wrongEndings: ['my red backpack.', 'my red backpack!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'The school bus arrives ___',
      correctEnding: 'at seven in the morning.',
      wrongEndings: ['at seven in the morning?', 'at seven in the morning!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Hooray, our team won ___',
      correctEnding: 'the championship trophy!',
      wrongEndings: ['the championship trophy.', 'the championship trophy?'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Please close the ___',
      correctEnding: 'classroom door quietly.',
      wrongEndings: ['classroom door quietly?', 'classroom door quietly!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Can you help me ___',
      correctEnding: 'carry these heavy books?',
      wrongEndings: ['carry these heavy books.', 'carry these heavy books!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Watch out for that ___',
      correctEnding: 'deep puddle on the path!',
      wrongEndings: ['deep puddle on the path.', 'deep puddle on the path?'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Birds build their nests ___',
      correctEnding: 'in the tall green trees.',
      wrongEndings: ['in the tall green trees?', 'in the tall green trees!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'How many stars can you ___',
      correctEnding: 'count in the night sky?',
      wrongEndings: ['count in the night sky.', 'count in the night sky!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'What a delicious ___',
      correctEnding: 'chocolate birthday cake!',
      wrongEndings: ['chocolate birthday cake.', 'chocolate birthday cake?'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Wash your hands ___',
      correctEnding: 'before eating your lunch.',
      wrongEndings: ['before eating your lunch?', 'before eating your lunch!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Why is the sky ___',
      correctEnding: 'so bright and blue today?',
      wrongEndings: ['so bright and blue today.', 'so bright and blue today!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'My little sister loves ___',
      correctEnding: 'drawing colorful butterflies.',
      wrongEndings: [
        'drawing colorful butterflies?',
        'drawing colorful butterflies!',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'What a giant ___',
      correctEnding: 'rainbow across the clouds!',
      wrongEndings: [
        'rainbow across the clouds.',
        'rainbow across the clouds?',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'Please pass the ___',
      correctEnding: 'box of colored pencils.',
      wrongEndings: ['box of colored pencils?', 'box of colored pencils!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Who left the ___',
      correctEnding: 'storybook on the table?',
      wrongEndings: ['storybook on the table.', 'storybook on the table!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'We read new stories ___',
      correctEnding: 'every morning in class.',
      wrongEndings: ['every morning in class?', 'every morning in class!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'How fast that ___',
      correctEnding: 'yellow racecar zoomed past!',
      wrongEndings: [
        'yellow racecar zoomed past.',
        'yellow racecar zoomed past?',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'Open your notebooks ___',
      correctEnding: 'to page twelve now.',
      wrongEndings: ['to page twelve now?', 'to page twelve now!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Do you have an ___',
      correctEnding: 'extra blue eraser?',
      wrongEndings: ['extra blue eraser.', 'extra blue eraser!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Fish swim quietly ___',
      correctEnding: 'in the clear pond.',
      wrongEndings: ['in the clear pond?', 'in the clear pond!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'That magic trick ___',
      correctEnding: 'was truly amazing!',
      wrongEndings: ['was truly amazing.', 'was truly amazing?'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Line up quietly ___',
      correctEnding: 'beside the school gate.',
      wrongEndings: ['beside the school gate?', 'beside the school gate!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'When does the ___',
      correctEnding: 'afternoon art class start?',
      wrongEndings: [
        'afternoon art class start.',
        'afternoon art class start!',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'Apples grow on ___',
      correctEnding: 'sturdy orchard branches.',
      wrongEndings: ['sturdy orchard branches?', 'sturdy orchard branches!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'We love our ___',
      correctEnding: 'cozy classroom reading corner!',
      wrongEndings: [
        'cozy classroom reading corner.',
        'cozy classroom reading corner?',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'Please clean up ___',
      correctEnding: 'your wooden study desk.',
      wrongEndings: ['your wooden study desk?', 'your wooden study desk!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Are we going ___',
      correctEnding: 'to the library today?',
      wrongEndings: ['to the library today.', 'to the library today!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Tom rides his ___',
      correctEnding: 'new bicycle to school.',
      wrongEndings: ['new bicycle to school?', 'new bicycle to school!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'I found a ___',
      correctEnding: 'shiny golden star sticker!',
      wrongEndings: [
        'shiny golden star sticker.',
        'shiny golden star sticker?',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'Listen carefully to ___',
      correctEnding: 'your teacher’s instructions.',
      wrongEndings: [
        'your teacher’s instructions?',
        'your teacher’s instructions!',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'Whose lunchbox is ___',
      correctEnding: 'sitting on the bench?',
      wrongEndings: ['sitting on the bench.', 'sitting on the bench!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'The puppy sleeps ___',
      correctEnding: 'on the soft mat.',
      wrongEndings: ['on the soft mat?', 'on the soft mat!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Happy Friday to ___',
      correctEnding: 'everyone in our class!',
      wrongEndings: ['everyone in our class.', 'everyone in our class?'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Put your empty ___',
      correctEnding: 'cup inside the bin.',
      wrongEndings: ['cup inside the bin?', 'cup inside the bin!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'May I borrow ___',
      correctEnding: 'your green ruler, please?',
      wrongEndings: ['your green ruler, please.', 'your green ruler, please!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Mia waters the ___',
      correctEnding: 'flowers every sunny morning.',
      wrongEndings: [
        'flowers every sunny morning?',
        'flowers every sunny morning!',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'How tall that ___',
      correctEnding: 'green tree has grown!',
      wrongEndings: ['green tree has grown.', 'green tree has grown?'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Please share your ___',
      correctEnding: 'building blocks nicely.',
      wrongEndings: ['building blocks nicely?', 'building blocks nicely!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Did you finish ___',
      correctEnding: 'your science worksheet?',
      wrongEndings: ['your science worksheet.', 'your science worksheet!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'The sun shines ___',
      correctEnding: 'over the school garden.',
      wrongEndings: ['over the school garden?', 'over the school garden!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'What a cute ___',
      correctEnding: 'little brown puppy that is!',
      wrongEndings: [
        'little brown puppy that is.',
        'little brown puppy that is?',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'Please speak softly ___',
      correctEnding: 'inside the quiet library.',
      wrongEndings: ['inside the quiet library?', 'inside the quiet library!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Which color do ___',
      correctEnding: 'you like best for painting?',
      wrongEndings: [
        'you like best for painting.',
        'you like best for painting!',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'She reads a ___',
      correctEnding: 'picture book before bed.',
      wrongEndings: ['picture book before bed?', 'picture book before bed!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Yay, we finished ___',
      correctEnding: 'our group poster on time!',
      wrongEndings: ['our group poster on time.', 'our group poster on time?'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Sit straight in ___',
      correctEnding: 'your chair while reading.',
      wrongEndings: ['your chair while reading?', 'your chair while reading!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Is the playground ___',
      correctEnding: 'open for recess now?',
      wrongEndings: ['open for recess now.', 'open for recess now!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'Our classroom has ___',
      correctEnding: 'bright learning posters.',
      wrongEndings: ['bright learning posters?', 'bright learning posters!'],
    ),
    _RaceQuestion(
      incompleteSentence: 'How brightly the ___',
      correctEnding: 'afternoon sun shines down!',
      wrongEndings: [
        'afternoon sun shines down.',
        'afternoon sun shines down?',
      ],
    ),
    _RaceQuestion(
      incompleteSentence: 'Raise your hand ___',
      correctEnding: 'before asking a question.',
      wrongEndings: ['before asking a question?', 'before asking a question!'],
    ),
  ];

  late List<_RaceQuestion> _deck;
  late List<String> _options;
  int _deckIndex = 0;
  int _progressSteps = 0;
  int _secondsElapsed = 0;
  Timer? _timer;
  bool _finished = false;
  String _feedback = 'Pick the right ending + punctuation to speed up!';
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
    _startRace();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRace() {
    _timer?.cancel();
    _deck = List<_RaceQuestion>.from(_raceBank)..shuffle(_random);
    _deckIndex = 0;
    _progressSteps = 0;
    _secondsElapsed = 0;
    _finished = false;
    _isError = false;
    _feedback = 'Pick the right ending + punctuation to speed up!';
    _prepareQuestion();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _finished) return;
      setState(() => _secondsElapsed++);
    });
  }

  void _prepareQuestion() {
    if (_deckIndex >= _deck.length) {
      _deck.shuffle(_random);
      _deckIndex = 0;
    }
    final q = _deck[_deckIndex];
    _options = [q.correctEnding, ...q.wrongEndings]..shuffle(_random);
  }

  void _onEndingSelected(String chosen) {
    if (_finished) return;
    SoundManager.instance.playClick();
    final q = _deck[_deckIndex];

    if (chosen == q.correctEnding) {
      setState(() {
        _progressSteps++;
        _isError = false;
        _feedback = 'Zoom! Great sentence ending!';
        if (_progressSteps >= _finishSteps) {
          _finished = true;
          _timer?.cancel();
          _showFinishDialog();
        } else {
          _deckIndex++;
          _prepareQuestion();
        }
      });
    } else {
      setState(() {
        _isError = true;
        _feedback = 'Speed bump! Check whether it tells (.), asks (?), or exclaims (!).';
      });
    }
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Finish Line Reached!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
        ),
        content: Text(
          'You completed all $_finishSteps sentences in $_secondsElapsed seconds!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  SoundManager.instance.playClick();
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF43A047),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  SoundManager.instance.playClick();
                  Navigator.pop(ctx);
                  setState(_startRace);
                },
                child: const Text('Race Again'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _deck[_deckIndex];
    final ratio = (_progressSteps / _finishSteps).clamp(0.0, 1.0);

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
                                    color: const Color(0xFFE3F2FD)
                                        .withValues(alpha: 0.96),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: const Color(0xFF1E88E5),
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
                                              Color(0xFF1E88E5),
                                              Color(0xFF0D47A1),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24),
                                          ),
                                        ),
                                        child: Text(
                                          '7. Sentence Race • ${_secondsElapsed}s',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20 * _textScale,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF37474F),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFFCA28,
                                                  ),
                                                  width: 2.5,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Lap $_progressSteps/$_finishSteps',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.flag_rounded,
                                                        color: Color(
                                                          0xFFFFCA28,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    child: LinearProgressIndicator(
                                                      value: ratio,
                                                      minHeight: 14,
                                                      backgroundColor:
                                                          Colors.white24,
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                            Color
                                                          >(Color(0xFF66BB6A)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF42A5F5,
                                                  ),
                                                  width: 2.5,
                                                ),
                                              ),
                                              child: Text(
                                                current.incompleteSentence,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17 * _textScale,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(
                                                    0xFF0D47A1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ..._options.map((ending) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 9,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _onEndingSelected(ending),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFFFF9C4,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFFFFA000,
                                                        ),
                                                        width: 2.2,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      ending,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            15 * _textScale,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                          0xFF3E2723,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
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
