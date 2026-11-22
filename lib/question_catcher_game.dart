import 'dart:math';

import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

enum SentenceCategory { asking, telling, commanding, exclamatory }

class _CatcherSentence {
  final String text;
  final SentenceCategory category;

  const _CatcherSentence({required this.text, required this.category});

  bool get isQuestion => category == SentenceCategory.asking;

  String get typeLabel {
    switch (category) {
      case SentenceCategory.asking:
        return 'Asking (Interrogative)';
      case SentenceCategory.telling:
        return 'Telling (Declarative)';
      case SentenceCategory.commanding:
        return 'Commanding / Requesting';
      case SentenceCategory.exclamatory:
        return 'Exclamatory';
    }
  }
}

class QuestionCatcherGameScreen extends StatefulWidget {
  final String backgroundPath;

  const QuestionCatcherGameScreen({super.key, required this.backgroundPath});

  @override
  State<QuestionCatcherGameScreen> createState() =>
      _QuestionCatcherGameScreenState();
}

class _QuestionCatcherGameScreenState extends State<QuestionCatcherGameScreen> {
  final Random _random = Random();

  // 50 total sentences across 4 sentence types:
  // 14 Asking + 12 Telling + 12 Commanding/Requesting + 12 Exclamatory
  static const List<_CatcherSentence> _allSentences = [
    // 1 - 14: Asking Sentences (Interrogative)
    _CatcherSentence(
      text: 'Where is my backpack?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'What time does school start?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Can you help me read this?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Why is the sky so blue?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Who won the spelling bee?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Do you have an extra pencil?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'When will the rain stop?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'How many books are on the shelf?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Are we going to the library?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Whose lunchbox is on the table?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'May I borrow your ruler?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Did you finish your homework?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Which color do you like best?',
      category: SentenceCategory.asking,
    ),
    _CatcherSentence(
      text: 'Is the playground open now?',
      category: SentenceCategory.asking,
    ),

    // 15 - 26: Telling Sentences (Declarative)
    _CatcherSentence(
      text: 'The school bus arrives early.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'Birds sing in the tall trees.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'My little sister loves drawing.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'We study English every morning.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'The puppy sleeps on the mat.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'Our classroom has bright posters.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'She reads a storybook at night.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'The sun shines over the garden.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'Fish swim in the clear pond.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'Tom rides his bicycle to school.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'Apples grow on sturdy branches.',
      category: SentenceCategory.telling,
    ),
    _CatcherSentence(
      text: 'Mia waters the flowers every day.',
      category: SentenceCategory.telling,
    ),

    // 27 - 38: Commanding & Requesting Sentences (Imperative)
    _CatcherSentence(
      text: 'Please close the classroom door.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Open your notebooks to page ten.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Please pass the colored crayons.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Line up quietly in the hallway.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Please clean up your study desk.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Listen carefully to the teacher.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Please wait near the school gate.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Put your trash inside the bin.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Please share your blocks nicely.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Wash your hands before eating.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Please speak softly in the library.',
      category: SentenceCategory.commanding,
    ),
    _CatcherSentence(
      text: 'Sit straight in your chair.',
      category: SentenceCategory.commanding,
    ),

    // 39 - 50: Exclamatory Sentences
    _CatcherSentence(
      text: 'What a sunny day at school!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'Hooray, our team won the game!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'How tall that rainbow looks!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'Watch out for that big puddle!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'What a cute little brown puppy!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'That magic trick was amazing!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'We love our fun reading corner!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'How fast the runner goes!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'What a giant colorful balloon!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'I found a shiny golden star!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'What a delicious birthday cake!',
      category: SentenceCategory.exclamatory,
    ),
    _CatcherSentence(
      text: 'Happy Friday to everyone here!',
      category: SentenceCategory.exclamatory,
    ),
  ];

  late List<_CatcherSentence> _roundChoices;
  final List<_CatcherSentence> _caughtQuestions = [];
  int _roundNumber = 1;
  bool _caughtThisRound = false;
  bool _basketPopped = false;
  String _feedbackText = 'Catch the Asking Sentence (?)!';
  bool _isErrorFeedback = false;

  @override
  void initState() {
    super.initState();
    _generateRandomRound(resetCaught: true);
  }

  void _generateRandomRound({bool resetCaught = false}) {
    if (resetCaught) {
      _caughtQuestions.clear();
      _roundNumber = 1;
    }

    final shuffledMaster = List<_CatcherSentence>.from(_allSentences)
      ..shuffle(_random);

    final askingPool = shuffledMaster
        .where((s) => s.category == SentenceCategory.asking)
        .toList();
    final tellingPool = shuffledMaster
        .where((s) => s.category == SentenceCategory.telling)
        .toList();
    final commandingPool = shuffledMaster
        .where((s) => s.category == SentenceCategory.commanding)
        .toList();
    final exclamatoryPool = shuffledMaster
        .where((s) => s.category == SentenceCategory.exclamatory)
        .toList();

    final lastCaughtText = _caughtQuestions.isNotEmpty
        ? _caughtQuestions.first.text
        : null;
    final candidateAsking = askingPool
        .where((s) => s.text != lastCaughtText)
        .toList();
    final chosenAsking = candidateAsking.isNotEmpty
        ? candidateAsking[_random.nextInt(candidateAsking.length)]
        : askingPool[_random.nextInt(askingPool.length)];

    _roundChoices = [
      chosenAsking,
      tellingPool[_random.nextInt(tellingPool.length)],
      commandingPool[_random.nextInt(commandingPool.length)],
      exclamatoryPool[_random.nextInt(exclamatoryPool.length)],
    ]..shuffle(_random);

    _caughtThisRound = false;
    _isErrorFeedback = false;
    _feedbackText = 'Catch the Asking Sentence (?)!';
  }

  void _onSentenceTap(_CatcherSentence sentence) {
    SoundManager.instance.playClick();

    if (sentence.isQuestion) {
      if (_caughtThisRound) return;
      setState(() {
        _caughtThisRound = true;
        _basketPopped = true;
        _isErrorFeedback = false;
        _caughtQuestions.insert(0, sentence);
        _feedbackText = 'Awesome catch! Added to your basket on the right!';
      });

      Future.delayed(const Duration(milliseconds: 260), () {
        if (mounted) {
          setState(() => _basketPopped = false);
        }
      });
    } else {
      setState(() {
        _isErrorFeedback = true;
        _feedbackText =
            'Not that one! That is ${sentence.typeLabel}. Catch the Asking (?) sentence!';
      });
    }
  }

  void _onNextRound() {
    SoundManager.instance.playClick();
    setState(() {
      _roundNumber++;
      _generateRandomRound(resetCaught: false);
    });
  }

  void _openCaughtQuestionsSheet() {
    SoundManager.instance.playClick();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Question Basket (${_caughtQuestions.length} caught)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
              ),
            ),
            const SizedBox(height: 10),
            if (_caughtQuestions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No asking sentences in the basket yet. Tap a sentence ending with (?)!',
                  textAlign: TextAlign.center,
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _caughtQuestions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, idx) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF8E24AA),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF2E7D32),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _caughtQuestions[idx].text,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1B5E20),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

              // Main Content Area
              Column(
                children: [
                  const SizedBox(height: 68),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // LEFT SIDE: 4 Sentence Types Choice Board
                                Expanded(flex: 6, child: _buildChoicesBoard()),
                                const SizedBox(width: 10),
                                // RIGHT SIDE: Caught Questions List + Basket
                                Expanded(
                                  flex: 4,
                                  child: _buildCaughtRightPanel(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildFeedbackRibbon(),
                          const SizedBox(height: 12),
                        ],
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

  Widget _buildChoicesBoard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD8F3FF).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E88E5), width: 3.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Text(
              '2. Question Catcher • Round $_roundNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            color: const Color(0xFFFFE082),
            child: const Text(
              '4 Sentence Types Mixed! Tap only the Asking (?) sentence:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: _roundChoices.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final sentence = _roundChoices[index];
                final isCaughtCard = _caughtThisRound && sentence.isQuestion;

                return GestureDetector(
                  onTap: () => _onSentenceTap(sentence),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isCaughtCard
                          ? const Color(0xFFC8E6C9)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCaughtCard
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF42A5F5),
                        width: 2.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCaughtCard
                              ? Icons.check_circle_rounded
                              : Icons.catching_pokemon_rounded,
                          color: isCaughtCard
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFF1E88E5),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sentence.text,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isCaughtCard
                                  ? const Color(0xFF1B5E20)
                                  : const Color(0xFF0D47A1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: _onNextRound,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF1B5E20), width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
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

  Widget _buildCaughtRightPanel() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5).withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF8E24AA), width: 3.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const Text(
                  'Caught (?)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Score: ${_caughtQuestions.length}',
                    style: const TextStyle(
                      color: Color(0xFF311B92),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _caughtQuestions.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 34,
                            color: Color(0xFF8E24AA),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Caught questions appear here!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF4A148C),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: _caughtQuestions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final caught = _caughtQuestions[index];
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF43A047),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                caught.text,
                                style: const TextStyle(
                                  color: Color(0xFF1B5E20),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
            child: GestureDetector(
              onTap: _openCaughtQuestionsSheet,
              child: AnimatedScale(
                scale: _basketPopped ? 1.12 : 1.0,
                duration: const Duration(milliseconds: 160),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 84,
                      height: 46,
                      child: CustomPaint(
                        painter: const _LowerRightBasketPainter(),
                      ),
                    ),
                    Text(
                      'Basket (${_caughtQuestions.length})',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E342E),
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isErrorFeedback
              ? const [Color(0xFFFFE082), Color(0xFFFFCA28)]
              : const [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isErrorFeedback
              ? const Color(0xFFF57C00)
              : const Color(0xFFEC407A),
          width: 2.5,
        ),
      ),
      child: Text(
        _feedbackText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF1A237E),
          fontSize: 14.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LowerRightBasketPainter extends CustomPainter {
  const _LowerRightBasketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPath = Path()
      ..moveTo(w * 0.12, h * 0.24)
      ..lineTo(w * 0.88, h * 0.24)
      ..lineTo(w * 0.76, h * 0.94)
      ..lineTo(w * 0.24, h * 0.94)
      ..close();

    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFA1887F));
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = const Color(0xFF4E342E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    final weavePaint = Paint()
      ..color = const Color(0xFF6D4C41)
      ..strokeWidth = 1.6;
    canvas.drawLine(
      Offset(w * 0.16, h * 0.48),
      Offset(w * 0.84, h * 0.48),
      weavePaint,
    );
    canvas.drawLine(
      Offset(w * 0.20, h * 0.72),
      Offset(w * 0.80, h * 0.72),
      weavePaint,
    );
    canvas.drawLine(
      Offset(w * 0.36, h * 0.24),
      Offset(w * 0.38, h * 0.94),
      weavePaint,
    );
    canvas.drawLine(
      Offset(w * 0.50, h * 0.24),
      Offset(w * 0.50, h * 0.94),
      weavePaint,
    );
    canvas.drawLine(
      Offset(w * 0.64, h * 0.24),
      Offset(w * 0.62, h * 0.94),
      weavePaint,
    );

    final rimRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.06, h * 0.10, w * 0.88, h * 0.18),
      const Radius.circular(8),
    );
    canvas.drawRRect(rimRect, Paint()..color = const Color(0xFF8D6E63));
    canvas.drawRRect(
      rimRect,
      Paint()
        ..color = const Color(0xFF3E2723)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
