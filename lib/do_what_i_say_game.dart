import 'dart:math';

import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

enum _SentenceType { commanding, telling, asking, exclamatory }

class _DoWhatISaySentence {
  final String text;
  final _SentenceType type;

  const _DoWhatISaySentence({required this.text, required this.type});

  bool get isCommandOrRequest => type == _SentenceType.commanding;

  String get label {
    switch (type) {
      case _SentenceType.commanding:
        return 'Commanding / Requesting (Imperative)';
      case _SentenceType.telling:
        return 'Telling (Declarative)';
      case _SentenceType.asking:
        return 'Asking (Interrogative)';
      case _SentenceType.exclamatory:
        return 'Exclamatory';
    }
  }
}

class DoWhatISayGameScreen extends StatefulWidget {
  final String backgroundPath;

  const DoWhatISayGameScreen({super.key, required this.backgroundPath});

  @override
  State<DoWhatISayGameScreen> createState() => _DoWhatISayGameScreenState();
}

class _DoWhatISayGameScreenState extends State<DoWhatISayGameScreen> {
  final Random _random = Random();
  static const int _targetGoal = 10;

  // 50 total sentences: 14 Commanding/Requesting + 12 Telling + 12 Asking + 12 Exclamatory
  static const List<_DoWhatISaySentence> _allSentences = [
    // 1 - 14: Commanding & Requesting Sentences (Imperative)
    _DoWhatISaySentence(
      text: 'Please close the classroom door.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Open your notebooks to page ten.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Please pass the colored crayons.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Line up quietly in the hallway.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Please clean up your study desk.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Listen carefully to the teacher.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Please wait near the school gate.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Put your trash inside the bin.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Please share your blocks nicely.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Wash your hands before eating.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Please speak softly in the library.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Sit straight in your chair.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Please hand me the blue folder.',
      type: _SentenceType.commanding,
    ),
    _DoWhatISaySentence(
      text: 'Raise your hand before speaking.',
      type: _SentenceType.commanding,
    ),

    // 15 - 26: Telling Sentences (Declarative)
    _DoWhatISaySentence(
      text: 'The school bus arrives early.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'Birds sing in the tall trees.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'My little sister loves drawing.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'We study English every morning.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'The puppy sleeps on the mat.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'Our classroom has bright posters.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'She reads a storybook at night.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'The sun shines over the garden.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'Fish swim in the clear pond.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'Tom rides his bicycle to school.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'Apples grow on sturdy branches.',
      type: _SentenceType.telling,
    ),
    _DoWhatISaySentence(
      text: 'Mia waters the flowers every day.',
      type: _SentenceType.telling,
    ),

    // 27 - 38: Asking Sentences (Interrogative)
    _DoWhatISaySentence(
      text: 'Where is my blue backpack?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'What time does school start?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'Can you help me read this?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'Why is the sky so blue?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'Who won the spelling bee?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'Do you have an extra pencil?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'When will the rain stop?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'How many books are on the shelf?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'Are we going to the library?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'May I borrow your ruler?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'Did you finish your homework?',
      type: _SentenceType.asking,
    ),
    _DoWhatISaySentence(
      text: 'Is the playground open now?',
      type: _SentenceType.asking,
    ),

    // 39 - 50: Exclamatory Sentences
    _DoWhatISaySentence(
      text: 'What a sunny day at school!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'Hooray, our team won the game!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'How tall that rainbow looks!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'Watch out for that big puddle!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'What a cute little brown puppy!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'That magic trick was amazing!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'We love our fun reading corner!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'How fast the runner goes!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'What a giant colorful balloon!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'I found a shiny golden star!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'What a delicious birthday cake!',
      type: _SentenceType.exclamatory,
    ),
    _DoWhatISaySentence(
      text: 'Happy Friday to everyone here!',
      type: _SentenceType.exclamatory,
    ),
  ];

  late List<_DoWhatISaySentence> _roundChoices;
  final List<_DoWhatISaySentence> _completedCommands = [];
  int _roundNumber = 1;
  int _score = 0;
  int _stars = 3;
  bool _solvedThisRound = false;
  int? _wrongTappedIndex;
  String _feedbackText = 'Tap the Commanding or Requesting sentence!';
  bool _isErrorFeedback = false;

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
    _generateRound(resetAll: true);
  }

  void _generateRound({bool resetAll = false}) {
    if (resetAll) {
      _completedCommands.clear();
      _roundNumber = 1;
      _score = 0;
      _stars = 3;
    }

    final master = List<_DoWhatISaySentence>.from(_allSentences)
      ..shuffle(_random);

    final commandingPool = master
        .where((s) => s.type == _SentenceType.commanding)
        .toList();
    final tellingPool = master
        .where((s) => s.type == _SentenceType.telling)
        .toList();
    final askingPool = master
        .where((s) => s.type == _SentenceType.asking)
        .toList();
    final exclamatoryPool = master
        .where((s) => s.type == _SentenceType.exclamatory)
        .toList();

    final lastText = _completedCommands.isNotEmpty
        ? _completedCommands.first.text
        : null;
    final freshCommands = commandingPool
        .where((s) => s.text != lastText)
        .toList();

    final chosenCommand = freshCommands.isNotEmpty
        ? freshCommands[_random.nextInt(freshCommands.length)]
        : commandingPool[_random.nextInt(commandingPool.length)];

    _roundChoices = [
      chosenCommand,
      tellingPool[_random.nextInt(tellingPool.length)],
      askingPool[_random.nextInt(askingPool.length)],
      exclamatoryPool[_random.nextInt(exclamatoryPool.length)],
    ]..shuffle(_random);

    _solvedThisRound = false;
    _wrongTappedIndex = null;
    _isErrorFeedback = false;
    _feedbackText = 'Tap the Commanding or Requesting sentence!';
  }

  void _onChoiceTap(int index, _DoWhatISaySentence sentence) {
    SoundManager.instance.playClick();

    if (sentence.isCommandOrRequest) {
      if (_solvedThisRound) return;
      setState(() {
        _solvedThisRound = true;
        _wrongTappedIndex = null;
        _isErrorFeedback = false;
        _score += 10;
        _completedCommands.insert(0, sentence);
        _feedbackText =
            'Great job! "${sentence.text}" gives a command or polite request!';
      });

      if (_completedCommands.length >= _targetGoal) {
        _showVictoryDialog();
      }
    } else {
      setState(() {
        _wrongTappedIndex = index;
        _isErrorFeedback = true;
        if (_stars > 1) _stars--;
        _feedbackText =
            'Not that one! That is ${sentence.label}. Look for a command or polite request!';
      });
    }
  }

  void _onNextPressed() {
    SoundManager.instance.playClick();
    setState(() {
      _roundNumber++;
      _generateRound(resetAll: false);
    });
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Well Done, Leader!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFE65100),
          ),
        ),
        content: Text(
          'You spotted $_targetGoal Commanding & Requesting sentences!\nFinal Score: $_score',
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
                child: const Text('Back to Apply'),
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
                  setState(() => _generateRound(resetAll: true));
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                onError: (exception, stackTrace) {},
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Back Button using back.jpeg
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
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.black87,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Settings Button
                  const Positioned(top: 15, right: 15, child: SettingsButton()),

                  // Main Card + Feedback Ribbon
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
                                _buildGameCard(),
                                const SizedBox(height: 14),
                                _buildFeedbackRibbon(),
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

  Widget _buildGameCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 430),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFF9800), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Warm Orange Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFEF6C00)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Text(
                  '3. Do What I Say • Round $_roundNumber',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20 * _textScale,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        color: Color(0xFF8D4004),
                        offset: Offset(1.5, 1.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'Caught: ${_completedCommands.length}/$_targetGoal',
                        style: TextStyle(
                          color: const Color(0xFFE65100),
                          fontWeight: FontWeight.bold,
                          fontSize: 13 * _textScale,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (i) {
                          return Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: i < _stars
                                ? const Color(0xFFFFB300)
                                : Colors.grey.shade300,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Instruction Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            color: const Color(0xFFFFECB3),
            child: Text(
              'Spot the sentence that gives a command or polite request ("Please..."):',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF4E342E),
                fontSize: 13.5 * _textScale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 4 Sentence Option Cards
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              children: List.generate(_roundChoices.length, (index) {
                final sentence = _roundChoices[index];
                final isCorrectCard =
                    _solvedThisRound && sentence.isCommandOrRequest;
                final isWrongCard = _wrongTappedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => _onChoiceTap(index, sentence),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 170),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isCorrectCard
                            ? const Color(0xFFC8E6C9)
                            : (isWrongCard
                                  ? const Color(0xFFFFCDD2)
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isCorrectCard
                              ? const Color(0xFF2E7D32)
                              : (isWrongCard
                                    ? const Color(0xFFD32F2F)
                                    : const Color(0xFFFFB74D)),
                          width: 2.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 2.5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: isCorrectCard
                                  ? const Color(0xFF2E7D32)
                                  : (isWrongCard
                                        ? const Color(0xFFD32F2F)
                                        : const Color(0xFFFF9800)),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCorrectCard
                                  ? Icons.check_rounded
                                  : (isWrongCard
                                        ? Icons.close_rounded
                                        : Icons.campaign_rounded),
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              sentence.text,
                              style: TextStyle(
                                fontSize: 15 * _textScale,
                                fontWeight: FontWeight.bold,
                                color: isCorrectCard
                                    ? const Color(0xFF1B5E20)
                                    : (isWrongCard
                                          ? const Color(0xFFB71C1C)
                                          : const Color(0xFF3E2723)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Green "Next ->" Button
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: _onNextPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xFF1B5E20),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * _textScale,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackRibbon() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 430),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isErrorFeedback
              ? const [Color(0xFFFFE082), Color(0xFFFFCA28)]
              : const [Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isErrorFeedback
              ? const Color(0xFFF57C00)
              : const Color(0xFF2E7D32),
          width: 2.5,
        ),
      ),
      child: Text(
        _feedbackText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF1B5E20),
          fontSize: 14.5 * _textScale,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
