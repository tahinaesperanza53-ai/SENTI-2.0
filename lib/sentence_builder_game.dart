import 'dart:math';

import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

class _SentencePuzzle {
  final List<String> words;
  final String punctuation;

  const _SentencePuzzle({required this.words, required this.punctuation});
}

class _ActivePuzzle {
  final List<String> targetWords;
  final List<String> scrambledWords;
  final String punctuation;

  const _ActivePuzzle({
    required this.targetWords,
    required this.scrambledWords,
    required this.punctuation,
  });
}

class SentenceBuilderGameScreen extends StatefulWidget {
  final String backgroundPath;

  const SentenceBuilderGameScreen({super.key, required this.backgroundPath});

  @override
  State<SentenceBuilderGameScreen> createState() =>
      _SentenceBuilderGameScreenState();
}

class _SentenceBuilderGameScreenState extends State<SentenceBuilderGameScreen> {
  final Random _random = Random();

  static const List<_SentencePuzzle> _allSentences = [
    // 1 - 13: Telling Sentences (Declarative)
    _SentencePuzzle(words: ['I', 'go', 'to', 'school'], punctuation: '.'),
    _SentencePuzzle(words: ['The', 'dog', 'barks', 'loudly'], punctuation: '.'),
    _SentencePuzzle(
      words: ['My', 'cat', 'sleeps', 'on', 'bed'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['We', 'read', 'books', 'every', 'day'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['The', 'sun', 'shines', 'so', 'bright'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Birds', 'fly', 'high', 'in', 'sky'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['She', 'likes', 'to', 'draw', 'stars'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Tom', 'rides', 'his', 'new', 'bike'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Rain', 'falls', 'on', 'the', 'roof'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Apples', 'grow', 'on', 'tall', 'trees'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Dad', 'cooks', 'rice', 'for', 'lunch'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Fish', 'swim', 'in', 'clear', 'water'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Our', 'class', 'planted', 'green', 'seeds'],
      punctuation: '.',
    ),

    // 14 - 26: Asking Sentences (Interrogative)
    _SentencePuzzle(words: ['Where', 'is', 'my', 'book'], punctuation: '?'),
    _SentencePuzzle(
      words: ['Who', 'ate', 'the', 'sweet', 'cake'],
      punctuation: '?',
    ),
    _SentencePuzzle(words: ['What', 'time', 'is', 'recess'], punctuation: '?'),
    _SentencePuzzle(
      words: ['Can', 'you', 'help', 'me', 'carry'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['Do', 'you', 'have', 'a', 'pencil'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['Why', 'is', 'the', 'sky', 'blue'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['When', 'does', 'the', 'bus', 'come'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['Is', 'your', 'bag', 'very', 'heavy'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['Did', 'you', 'wash', 'your', 'hands'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['How', 'many', 'stars', 'are', 'there'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['Are', 'we', 'going', 'outside', 'today'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['Whose', 'hat', 'is', 'on', 'chair'],
      punctuation: '?',
    ),
    _SentencePuzzle(
      words: ['May', 'I', 'drink', 'some', 'water'],
      punctuation: '?',
    ),

    // 27 - 38: Commanding & Requesting Sentences (Imperative)
    _SentencePuzzle(
      words: ['Please', 'close', 'the', 'door'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Open', 'your', 'notebook', 'now'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Please', 'pass', 'the', 'crayons'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Line', 'up', 'quietly', 'in', 'hall'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Please', 'clean', 'up', 'your', 'desk'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Listen', 'carefully', 'to', 'your', 'teacher'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Please', 'tie', 'your', 'shoe', 'laces'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Turn', 'off', 'the', 'classroom', 'light'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Please', 'share', 'your', 'toys', 'nicely'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Speak', 'clearly', 'for', 'everyone', 'here'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Please', 'wait', 'by', 'the', 'gate'],
      punctuation: '.',
    ),
    _SentencePuzzle(
      words: ['Throw', 'trash', 'in', 'the', 'bin'],
      punctuation: '.',
    ),

    // 39 - 50: Exclamatory Sentences
    _SentencePuzzle(words: ['What', 'a', 'sunny', 'day'], punctuation: '!'),
    _SentencePuzzle(
      words: ['How', 'tall', 'that', 'tree', 'is'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['We', 'won', 'the', 'school', 'game'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['What', 'a', 'cute', 'little', 'puppy'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['That', 'magic', 'trick', 'was', 'amazing'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['Look', 'out', 'for', 'that', 'puddle'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['What', 'a', 'big', 'red', 'balloon'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['I', 'found', 'a', 'shiny', 'star'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['How', 'fast', 'the', 'runner', 'goes'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['Hooray', 'it', 'is', 'friday', 'today'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['What', 'a', 'yummy', 'ice', 'cream'],
      punctuation: '!',
    ),
    _SentencePuzzle(
      words: ['We', 'love', 'our', 'fun', 'school'],
      punctuation: '!',
    ),
  ];

  late List<_SentencePuzzle> _shuffledDeck;
  late _ActivePuzzle _activePuzzle;
  int _currentIndex = 0;

  /// Stores the index from `_activePuzzle.scrambledWords` placed into each slot (`null` if empty).
  late List<int?> _slotToWordIndex;
  String _feedbackText = 'Tap words below to fill each box!';
  bool _isCorrect = false;
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    _startNewRandomSession();
  }

  void _startNewRandomSession() {
    _shuffledDeck = List<_SentencePuzzle>.from(_allSentences)..shuffle(_random);
    _loadRound(0);
  }

  List<String> _buildScrambledWords(List<String> targetWords) {
    final scrambled = List<String>.from(targetWords);
    if (scrambled.length > 1) {
      var attempts = 0;
      do {
        scrambled.shuffle(_random);
        attempts++;
      } while (attempts < 8 &&
          List.generate(
            scrambled.length,
            (i) => scrambled[i].toLowerCase() == targetWords[i].toLowerCase(),
          ).every((same) => same));
    }
    return scrambled;
  }

  void _loadRound(int index) {
    if (index >= _shuffledDeck.length) {
      _shuffledDeck.shuffle(_random);
      _currentIndex = 0;
    } else {
      _currentIndex = index;
    }

    final base = _shuffledDeck[_currentIndex];
    _activePuzzle = _ActivePuzzle(
      targetWords: base.words,
      scrambledWords: _buildScrambledWords(base.words),
      punctuation: base.punctuation,
    );

    _slotToWordIndex = List<int?>.filled(
      _activePuzzle.targetWords.length,
      null,
    );
    _feedbackText = 'Tap words below to fill each box!';
    _isCorrect = false;
    _hasChecked = false;
  }

  void _onTileTap(int wordIdx) {
    SoundManager.instance.playClick();
    if (_slotToWordIndex.contains(wordIdx)) return;

    final emptySlot = _slotToWordIndex.indexOf(null);
    if (emptySlot == -1) return;

    setState(() {
      _slotToWordIndex[emptySlot] = wordIdx;
      _hasChecked = false;
      _isCorrect = false;
      _feedbackText = 'Keep going!';
    });

    if (!_slotToWordIndex.contains(null)) {
      _evaluateSentence();
    }
  }

  void _onSlotTap(int slotIdx) {
    SoundManager.instance.playClick();
    if (_slotToWordIndex[slotIdx] == null) return;

    setState(() {
      _slotToWordIndex[slotIdx] = null;
      _hasChecked = false;
      _isCorrect = false;
      _feedbackText = 'Tap words below to fill each box!';
    });
  }

  void _evaluateSentence() {
    final builtWords = _slotToWordIndex
        .map((wIdx) => wIdx == null ? '' : _activePuzzle.scrambledWords[wIdx])
        .toList();

    final matches = List.generate(
      _activePuzzle.targetWords.length,
      (i) =>
          builtWords[i].toLowerCase() ==
          _activePuzzle.targetWords[i].toLowerCase(),
    ).every((ok) => ok);

    setState(() {
      _hasChecked = true;
      _isCorrect = matches;
      _feedbackText = matches
          ? 'Great job! Sentence correct!'
          : 'Try again! Tap a box to swap words.';
    });
  }

  void _onNextPressed() {
    SoundManager.instance.playClick();

    if (!_slotToWordIndex.contains(null) && !_hasChecked) {
      _evaluateSentence();
      return;
    }

    setState(() {
      _loadRound(_currentIndex + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = _activePuzzle;

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

              // Main Game Card + Bottom Feedback Ribbon
              Column(
                children: [
                  const SizedBox(height: 68),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildGameCard(puzzle),
                            const SizedBox(height: 16),
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
  }

  Widget _buildGameCard(_ActivePuzzle puzzle) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: const Color(0xFFD8F3FF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF4FC3F7), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Purple Title Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E24AA), Color(0xFF5E35B1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Text(
              '1. Sentence Builder (${_currentIndex + 1}/${_shuffledDeck.length})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Color(0xFF311B92),
                    offset: Offset(1.5, 1.5),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Yellow Instruction Banner with Stars
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF59D), Color(0xFFFFD54F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFFFFB300), width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star_rounded, color: Color(0xFFFFA000), size: 22),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Arrange the words to make a correct sentence.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1A237E),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.star_rounded, color: Color(0xFFFFA000), size: 22),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
            child: Column(
              children: [
                // Target Sentence Slots Row + Punctuation Mark
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 8,
                  children: [
                    ...List.generate(puzzle.targetWords.length, (slotIdx) {
                      final wordIdx = _slotToWordIndex[slotIdx];
                      final wordText = wordIdx == null
                          ? ''
                          : puzzle.scrambledWords[wordIdx];

                      return GestureDetector(
                        onTap: () => _onSlotTap(slotIdx),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 64),
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: wordIdx == null
                                ? const Color(0xFFB3E5FC)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _hasChecked
                                  ? (_isCorrect
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFE53935))
                                  : const Color(0xFF29B6F6),
                              width: 2.2,
                            ),
                            boxShadow: wordIdx == null
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Text(
                            wordText,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ),
                      );
                    }),
                    Text(
                      puzzle.punctuation,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Tappable Word Tiles Row
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF81D4FA),
                      width: 2,
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(puzzle.scrambledWords.length, (
                      wIdx,
                    ) {
                      final isUsed = _slotToWordIndex.contains(wIdx);
                      return GestureDetector(
                        onTap: isUsed ? null : () => _onTileTap(wIdx),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 140),
                          opacity: isUsed ? 0.32 : 1.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: const Color(0xFF1E88E5),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.14),
                                  blurRadius: 3,
                                  offset: const Offset(0, 2.5),
                                ),
                              ],
                            ),
                            child: Text(
                              puzzle.scrambledWords[wIdx],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 18),

                // Green "Next ->" Pill Button
                GestureDetector(
                  onTap: _onNextPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 34,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFF1B5E20),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.24),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Color(0xFF1B5E20),
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 24,
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
    );
  }

  Widget _buildFeedbackRibbon() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _hasChecked
              ? (_isCorrect
                    ? const [Color(0xFFF8BBD0), Color(0xFFF48FB1)]
                    : const [Color(0xFFFFE082), Color(0xFFFFCA28)])
              : const [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _hasChecked && !_isCorrect
              ? const Color(0xFFF57C00)
              : const Color(0xFFEC407A),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        _feedbackText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF1A237E),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
