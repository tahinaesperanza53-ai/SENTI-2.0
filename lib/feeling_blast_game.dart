import 'dart:math';

import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

enum _EmotionType { excited, surprised, happy, careful }

class _FeelingPrompt {
  final String sentence;
  final _EmotionType emotion;

  const _FeelingPrompt({required this.sentence, required this.emotion});
}

class FeelingBlastGameScreen extends StatefulWidget {
  final String backgroundPath;

  const FeelingBlastGameScreen({super.key, required this.backgroundPath});

  @override
  State<FeelingBlastGameScreen> createState() => _FeelingBlastGameScreenState();
}

class _FeelingBlastGameScreenState extends State<FeelingBlastGameScreen> {
  final Random _random = Random();
  static const int _targetGoal = 10;

  // 50 total sentences: 14 Excited + 12 Surprised + 12 Happy + 12 Careful
  static const List<_FeelingPrompt> _allPrompts = [
    // 1 - 14: Excited
    _FeelingPrompt(
      sentence: 'Hooray, our class won the reading trophy!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'We are going on a field trip tomorrow!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'Yay, it is finally Friday afternoon!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'How fast that bright red racecar goes!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'Our school band is playing on stage today!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'Yay, recess starts in one minute!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'We get to paint big posters in art class!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'Hooray, our relay team took first place!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'I cannot wait to ride the big slide!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'Yay, my story was chosen for the wall!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'We are having a fun picnic on the lawn!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'Hooray, the school fair starts this morning!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'Yay, we unlocked a new classroom badge!',
      emotion: _EmotionType.excited,
    ),
    _FeelingPrompt(
      sentence: 'How exciting our science experiment looks!',
      emotion: _EmotionType.excited,
    ),

    // 15 - 26: Surprised
    _FeelingPrompt(
      sentence: 'Wow, look at that giant colorful rainbow!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'That magic trick was truly amazing!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'I found a shiny golden star in the grass!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'Oh, how tall that ancient tree has grown!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'Whoa, a tiny green frog hopped right past my shoe!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'Surprise! Everyone shouted together when I walked in!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'Oh my, it started snowing in the story!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'Whoa, how high that blue kite flew!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'I did not expect to see a twin of my hat!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'Wow, that puzzle piece fit on the very first try!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'Oh, look at the bright comet in the picture!',
      emotion: _EmotionType.surprised,
    ),
    _FeelingPrompt(
      sentence: 'Whoa, the loud thunder made us jump!',
      emotion: _EmotionType.surprised,
    ),

    // 27 - 38: Happy & Joyful
    _FeelingPrompt(
      sentence: 'What a cute little brown puppy!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'We love our cozy classroom reading corner!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'What a delicious birthday cake this is!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'What a sunny and cheerful day at school!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'I love sharing snacks with my best friends!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'What a warm hug from my mom!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'Our garden is full of pretty yellow flowers!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'Reading funny stories makes me smile all day!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'What a sweet song the children sang!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'Playing together on the swings brings big smiles!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'What a lovely morning to walk with family!',
      emotion: _EmotionType.happy,
    ),
    _FeelingPrompt(
      sentence: 'Helping a friend makes my heart feel glad!',
      emotion: _EmotionType.happy,
    ),

    // 39 - 50: Watch Out / Careful
    _FeelingPrompt(
      sentence: 'Watch out for that big slippery puddle!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Look out, the soccer ball is rolling fast!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Be careful near the wet classroom steps!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Hold onto your hat in this strong wind!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Watch out for the sharp scissors on the table!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Careful, that hot soup needs time to cool!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Look out for the low branch on the trail!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Watch your step going down the stairs!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Be careful not to spill the paint cup!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Watch out, a cyclist is coming down the lane!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Hold tight to the railing on the bridge!',
      emotion: _EmotionType.careful,
    ),
    _FeelingPrompt(
      sentence: 'Careful, the glass jar can break easily!',
      emotion: _EmotionType.careful,
    ),
  ];

  late List<_FeelingPrompt> _deck;
  int _index = 0;
  int _score = 0;
  int _blastsCleared = 0;
  bool _solvedRound = false;
  _EmotionType? _wrongChoice;
  String _feedback = 'Match the feeling behind the sentence!';
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
    _resetGame();
  }

  void _resetGame() {
    _deck = List<_FeelingPrompt>.from(_allPrompts)..shuffle(_random);
    _index = 0;
    _score = 0;
    _blastsCleared = 0;
    _solvedRound = false;
    _wrongChoice = null;
    _isError = false;
    _feedback = 'Match the feeling behind the sentence!';
  }

  void _onEmotionTap(_EmotionType chosen) {
    SoundManager.instance.playClick();
    final current = _deck[_index];

    if (chosen == current.emotion) {
      if (_solvedRound) return;
      setState(() {
        _solvedRound = true;
        _wrongChoice = null;
        _isError = false;
        _score += 10;
        _blastsCleared++;
        _feedback = 'Feeling Blast! Great match!';
      });

      if (_blastsCleared >= _targetGoal) {
        _showVictoryDialog();
      }
    } else {
      setState(() {
        _wrongChoice = chosen;
        _isError = true;
        _feedback = 'Not quite! Read the clues in the sentence again.';
      });
    }
  }

  void _onNext() {
    SoundManager.instance.playClick();
    setState(() {
      _index++;
      if (_index >= _deck.length) {
        _deck.shuffle(_random);
        _index = 0;
      }
      _solvedRound = false;
      _wrongChoice = null;
      _isError = false;
      _feedback = 'Match the feeling behind the sentence!';
    });
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Feeling Blast Complete!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFAD1457),
          ),
        ),
        content: Text(
          'You matched $_targetGoal lively sentences!\nScore:$_score',
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
                  backgroundColor: const Color(0xFFEC407A),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  SoundManager.instance.playClick();
                  Navigator.pop(ctx);
                  setState(_resetGame);
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
    final current = _deck[_index];

    final options = [
      (
        type: _EmotionType.excited,
        label: 'Excited!',
        icon: Icons.celebration_rounded,
        color: const Color(0xFFFF7043),
      ),
      (
        type: _EmotionType.surprised,
        label: 'Surprised!',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFF7E57C2),
      ),
      (
        type: _EmotionType.happy,
        label: 'Happy & Joyful!',
        icon: Icons.sentiment_very_satisfied_rounded,
        color: const Color(0xFF43A047),
      ),
      (
        type: _EmotionType.careful,
        label: 'Watch Out / Careful!',
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFF0288D1),
      ),
    ];

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
                    child: _BackImageButton(
                      onTap: () {
                        SoundManager.instance.playClick();
                        Navigator.pop(context);
                      },
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
                                    color: const Color(0xFFFCE4EC)
                                        .withValues(alpha: 0.96),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: const Color(0xFFEC407A),
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
                                              Color(0xFFEC407A),
                                              Color(0xFFC2185B),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24),
                                          ),
                                        ),
                                        child: Text(
                                          '4. Feeling Blast ($_blastsCleared/$_targetGoal)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20 * _textScale,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFF48FB1,
                                                  ),
                                                  width: 2.5,
                                                ),
                                              ),
                                              child: Text(
                                                '"${current.sentence}"',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17 * _textScale,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(
                                                    0xFF880E4F,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            GridView.count(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 2.1,
                                              children: options.map((opt) {
                                                final isCorrect =
                                                    _solvedRound &&
                                                    opt.type == current.emotion;
                                                final isWrong =
                                                    _wrongChoice == opt.type;

                                                return GestureDetector(
                                                  onTap: () =>
                                                      _onEmotionTap(opt.type),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: isCorrect
                                                          ? const Color(
                                                              0xFFC8E6C9,
                                                            )
                                                          : (isWrong
                                                                ? const Color(
                                                                    0xFFFFCDD2,
                                                                  )
                                                                : Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      border: Border.all(
                                                        color: isCorrect
                                                            ? const Color(
                                                                0xFF2E7D32,
                                                              )
                                                            : (isWrong
                                                                  ? const Color(
                                                                      0xFFD32F2F,
                                                                    )
                                                                  : opt.color),
                                                        width: 2.5,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          opt.icon,
                                                          color: opt.color,
                                                          size: 22,
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            opt.label,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  13.5 *
                                                                  _textScale,
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
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(height: 16),
                                            _GreenNextButton(
                                              textScale: _textScale,
                                              onTap: _onNext,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _BottomFeedbackRibbon(
                                  text: _feedback,
                                  isError: _isError,
                                  textScale: _textScale,
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

class _BackImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackImageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}

class _GreenNextButton extends StatelessWidget {
  final double textScale;
  final VoidCallback onTap;

  const _GreenNextButton({required this.textScale, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
          ),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFF1B5E20), width: 2.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18 * textScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _BottomFeedbackRibbon extends StatelessWidget {
  final String text;
  final bool isError;
  final double textScale;

  const _BottomFeedbackRibbon({
    required this.text,
    required this.isError,
    required this.textScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 430),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isError
              ? const [Color(0xFFFFE082), Color(0xFFFFCA28)]
              : const [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isError ? const Color(0xFFF57C00) : const Color(0xFFEC407A),
          width: 2.5,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF1A237E),
          fontSize: 14.5 * textScale,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
