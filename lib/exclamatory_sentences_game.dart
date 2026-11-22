import 'dart:math';

import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

enum _ExclSentenceType { exclamatory, telling, asking, commanding }

class _ExclamatoryItem {
  final String text;
  final _ExclSentenceType type;

  const _ExclamatoryItem({required this.text, required this.type});

  bool get isExclamatory => type == _ExclSentenceType.exclamatory;

  String get typeName {
    switch (type) {
      case _ExclSentenceType.exclamatory:
        return 'Exclamatory (!)';
      case _ExclSentenceType.telling:
        return 'Telling (Declarative)';
      case _ExclSentenceType.asking:
        return 'Asking (Interrogative)';
      case _ExclSentenceType.commanding:
        return 'Commanding / Requesting';
    }
  }
}

class ExclamatorySentencesGameScreen extends StatefulWidget {
  final String backgroundPath;

  const ExclamatorySentencesGameScreen({
    super.key,
    required this.backgroundPath,
  });

  @override
  State<ExclamatorySentencesGameScreen> createState() =>
      _ExclamatorySentencesGameScreenState();
}

class _ExclamatorySentencesGameScreenState
    extends State<ExclamatorySentencesGameScreen> {
  final Random _random = Random();
  static const int _targetGoal = 10;

  // 50 total sentences: 14 Exclamatory + 12 Telling + 12 Asking + 12 Commanding
  static const List<_ExclamatoryItem> _allSentences = [
    // 1 - 14: Exclamatory Sentences
    _ExclamatoryItem(
      text: 'What a sunny day at school!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'Hooray, our team won the game!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'How tall that rainbow looks!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'Watch out for that big puddle!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'What a cute little brown puppy!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'That magic trick was amazing!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'We love our fun reading corner!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'How fast the runner goes!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'What a giant colorful balloon!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'I found a shiny golden star!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'What a delicious birthday cake!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'Happy Friday to everyone here!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'How brightly the fireworks shine!',
      type: _ExclSentenceType.exclamatory,
    ),
    _ExclamatoryItem(
      text: 'Yay, we finished our art project!',
      type: _ExclSentenceType.exclamatory,
    ),

    // 15 - 26: Telling Sentences
    _ExclamatoryItem(
      text: 'The school bus arrives early.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'Birds sing in the tall trees.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'My little sister loves drawing.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'We study English every morning.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'The puppy sleeps on the mat.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'Our classroom has bright posters.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'She reads a storybook at night.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'The sun shines over the garden.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'Fish swim in the clear pond.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'Tom rides his bicycle to school.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'Apples grow on sturdy branches.',
      type: _ExclSentenceType.telling,
    ),
    _ExclamatoryItem(
      text: 'Mia waters the flowers every day.',
      type: _ExclSentenceType.telling,
    ),

    // 27 - 38: Asking Sentences
    _ExclamatoryItem(
      text: 'Where is my blue backpack?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'What time does school start?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'Can you help me read this?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'Why is the sky so blue?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'Who won the spelling bee?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'Do you have an extra pencil?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'When will the rain stop?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'How many books are on the shelf?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'Are we going to the library?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'May I borrow your ruler?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'Did you finish your homework?',
      type: _ExclSentenceType.asking,
    ),
    _ExclamatoryItem(
      text: 'Is the playground open now?',
      type: _ExclSentenceType.asking,
    ),

    // 39 - 50: Commanding & Requesting Sentences
    _ExclamatoryItem(
      text: 'Please close the classroom door.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Open your notebooks to page ten.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Please pass the colored crayons.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Line up quietly in the hallway.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Please clean up your study desk.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Listen carefully to the teacher.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Please wait near the school gate.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Put your trash inside the bin.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Please share your blocks nicely.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Wash your hands before eating.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Please speak softly in the library.',
      type: _ExclSentenceType.commanding,
    ),
    _ExclamatoryItem(
      text: 'Sit straight in your chair.',
      type: _ExclSentenceType.commanding,
    ),
  ];

  late List<_ExclamatoryItem> _shuffledDeck;
  late List<_ExclamatoryItem> _choices;
  final List<_ExclamatoryItem> _foundList = [];
  int _round = 1;
  bool _solved = false;
  int? _wrongIndex;
  String _feedback = 'Find the Exclamatory sentence bursting with (!)!';
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
    _shuffledDeck = List<_ExclamatoryItem>.from(_allSentences)
      ..shuffle(_random);
    _foundList.clear();
    _round = 1;
    _buildRound();
  }

  void _buildRound() {
    final excl =
        _shuffledDeck
            .where((e) => e.type == _ExclSentenceType.exclamatory)
            .toList()
          ..shuffle(_random);
    final tell =
        _shuffledDeck.where((e) => e.type == _ExclSentenceType.telling).toList()
          ..shuffle(_random);
    final ask =
        _shuffledDeck.where((e) => e.type == _ExclSentenceType.asking).toList()
          ..shuffle(_random);
    final cmd =
        _shuffledDeck
            .where((e) => e.type == _ExclSentenceType.commanding)
            .toList()
          ..shuffle(_random);

    final lastText = _foundList.isNotEmpty ? _foundList.first.text : null;
    final freshExcl = excl.where((e) => e.text != lastText).toList();
    final picked = freshExcl.isNotEmpty ? freshExcl.first : excl.first;

    _choices = [picked, tell.first, ask.first, cmd.first]..shuffle(_random);
    _solved = false;
    _wrongIndex = null;
    _isError = false;
    _feedback = 'Find the Exclamatory sentence bursting with (!)!';
  }

  void _onTapOption(int idx, _ExclamatoryItem item) {
    SoundManager.instance.playClick();
    if (item.isExclamatory) {
      if (_solved) return;
      setState(() {
        _solved = true;
        _wrongIndex = null;
        _isError = false;
        _foundList.insert(0, item);
        _feedback = 'Awesome! "${item.text}" expresses strong feeling (!)!';
      });
    } else {
      setState(() {
        _wrongIndex = idx;
        _isError = true;
        _feedback =
            'Oops! That is ${item.typeName}. Tap the sentence ending with (!)!';
      });
    }
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
                                    color: const Color(0xFFFFF3E0)
                                        .withValues(alpha: 0.96),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: const Color(0xFFFF7043),
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
                                              Color(0xFFFF7043),
                                              Color(0xFFD84315),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24),
                                          ),
                                        ),
                                        child: Text(
                                          '5. Exclamatory Sentences • R$_round (${_foundList.length}/$_targetGoal)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18 * _textScale,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          children: [
                                            ...List.generate(_choices.length, (
                                              i,
                                            ) {
                                              final item = _choices[i];
                                              final ok =
                                                  _solved && item.isExclamatory;
                                              final bad = _wrongIndex == i;

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _onTapOption(i, item),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 12,
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
                                                            18,
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
                                                                      0xFFFF8A65,
                                                                    )),
                                                        width: 2.4,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor: ok
                                                              ? const Color(
                                                                  0xFF2E7D32,
                                                                )
                                                              : const Color(
                                                                  0xFFFF7043,
                                                                ),
                                                          child: const Text(
                                                            '!',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            item.text,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  15 *
                                                                  _textScale,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  const Color(
                                                                    0xFF263238,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                                                setState(() {
                                                  _round++;
                                                  _buildRound();
                                                });
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
