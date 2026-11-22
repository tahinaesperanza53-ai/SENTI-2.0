import 'dart:math';

import 'package:flutter/material.dart';

import 'island_map_widget.dart';
import 'settings_button.dart';
import 'sound_manager.dart';

List<T> _shuffledDeck<T>(List<T> source, Random random, {T? previous}) {
  final copy = List<T>.of(source)..shuffle(random);
  if (previous != null && copy.length > 1 && copy.first == previous) {
    final first = copy.removeAt(0);
    final insertAt = 1 + random.nextInt(copy.length);
    copy.insert(insertAt, first);
  }
  return copy;
}

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final Set<String> _completedIslands = {};

  static const List<Map<String, String>> _playLevels = [
    {
      'id': 'telling_island',
      'image': 'assets/images/play_btn1.jpeg',
      'background': 'assets/images/telling_bg.jpeg',
      'islandName': 'Fact Lagoon • Telling Sentences',
      'title': '1. Fact Lagoon (Telling Sentences)',
      'prompt':
          'Start at Stop 1 on Fact Lagoon and complete 15 right answers per stop to finish the island!',
    },
    {
      'id': 'asking_island',
      'image': 'assets/images/play_btn2.jpeg',
      'background': 'assets/images/asking_bg.jpeg',
      'islandName': 'Asking Sentences Island',
      'title': '2. Asking Sentences (Interrogative)',
      'prompt':
          'Unlock each stop in order with 15 correct answers across Sentence Quest, Choose the Asking Sentence, and Sentence Race!',
    },
    {
      'id': 'commanding_island',
      'image': 'assets/images/play_btn3.jpeg',
      'background': 'assets/images/commanding_bg.jpeg',
      'islandName': 'Commanding & Requesting Island',
      'title': '3. Commanding & Requesting Sentences (Imperative)',
      'prompt':
          'Get 15 correct answers per stop on Commanding & Requesting Island to unlock the final island!',
    },
    {
      'id': 'exclamatory_island',
      'image': 'assets/images/play_btn4.jpeg',
      'background': 'assets/images/exclamatory_bg.jpeg',
      'islandName': 'Exclamatory Sentences Island',
      'title': '4. Exclamatory Sentences',
      'prompt':
          'Conquer all 3 stops (15 correct answers each) on Exclamatory Sentences Island!',
    },
  ];

  bool _isIslandUnlocked(int index) {
    if (index == 0) return true;
    final previousId = _playLevels[index - 1]['id']!;
    return _completedIslands.contains(previousId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/play_bg.jpeg'),
            fit: BoxFit.cover,
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
              const Positioned(top: 15, right: 15, child: SettingsButton()),
              Column(
                children: [
                  const SizedBox(height: 120),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.92,
                        ),
                        itemCount: _playLevels.length,
                        itemBuilder: (context, index) {
                          final level = _playLevels[index];
                          final unlocked = _isIslandUnlocked(index);
                          final isCompleted =
                              _completedIslands.contains(level['id']);

                          return _PlayLevelButton(
                            imagePath: level['image']!,
                            isUnlocked: unlocked,
                            isCompleted: isCompleted,
                            onTap: () {
                              SoundManager.instance.playClick();
                              if (!unlocked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Finish "${_playLevels[index - 1]['title']}" first to unlock ${level['title']}!',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              _openPlayDialog(context, level);
                            },
                          );
                        },
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

  void _openPlayDialog(BuildContext context, Map<String, String> level) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          level['title']!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          level['prompt']!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                SoundManager.instance.playClick();
                Navigator.of(ctx).pop();

                final islandCleared = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _buildIslandMapScreen(level),
                  ),
                );

                if (islandCleared == true && mounted) {
                  setState(() {
                    _completedIslands.add(level['id']!);
                  });
                }
              },
              child: const Text('Let\'s Play!'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslandMapScreen(Map<String, String> level) {
    final id = level['id']!;
    final bg = level['background']!;
    final islandName = level['islandName']!;

    if (id == 'telling_island') {
      return IslandAdventureMapScreen(
        islandId: id,
        islandTitle: islandName,
        backgroundPath: bg,
        stopAnchors: const [
          Offset(0.48, 0.78),
          Offset(0.58, 0.50),
          Offset(0.44, 0.25),
        ],
        stops: [
          IslandMapStop(
            id: 'telling_quest',
            title: 'Sentence Quest',
            stopLabel: 'Stop 1',
            bannerAsset: 'assets/images/telling_quest.jpeg',
            builder: (_) => _TellingQuestGame(backgroundPath: bg),
          ),
          IslandMapStop(
            id: 'telling_game',
            title: 'Choose the Telling Sentence',
            stopLabel: 'Stop 2',
            bannerAsset: 'assets/images/telling_game.jpeg',
            builder: (_) => _ChooseTellingSentenceGame(backgroundPath: bg),
          ),
          IslandMapStop(
            id: 'telling_race',
            title: 'Sentence Race',
            stopLabel: 'Stop 3',
            bannerAsset: 'assets/images/telling_race.jpeg',
            builder: (_) => _TellingSentenceRaceGame(backgroundPath: bg),
          ),
        ],
      );
    }

    if (id == 'asking_island') {
      return IslandAdventureMapScreen(
        islandId: id,
        islandTitle: islandName,
        backgroundPath: bg,
        stopAnchors: const [
          Offset(0.52, 0.77),
          Offset(0.44, 0.50),
          Offset(0.54, 0.25),
        ],
        stops: [
          IslandMapStop(
            id: 'asking_quest',
            title: 'Sentence Quest',
            stopLabel: 'Stop 1',
            bannerAsset: 'assets/images/asking_quest.jpeg',
            builder: (_) => _AskingQuestGame(backgroundPath: bg),
          ),
          IslandMapStop(
            id: 'asking_game',
            title: 'Choose the Asking Sentence',
            stopLabel: 'Stop 2',
            bannerAsset: 'assets/images/asking_game.jpeg',
            builder: (_) => _ChooseAskingSentenceGame(backgroundPath: bg),
          ),
          IslandMapStop(
            id: 'asking_race',
            title: 'Sentence Race',
            stopLabel: 'Stop 3',
            bannerAsset: 'assets/images/asking_race.jpeg',
            builder: (_) => _AskingSentenceRaceGame(backgroundPath: bg),
          ),
        ],
      );
    }

    if (id == 'commanding_island') {
      return IslandAdventureMapScreen(
        islandId: id,
        islandTitle: islandName,
        backgroundPath: bg,
        stopAnchors: const [
          Offset(0.46, 0.77),
          Offset(0.56, 0.50),
          Offset(0.48, 0.25),
        ],
        stops: [
          IslandMapStop(
            id: 'commanding_quest',
            title: 'Sentence Quest',
            stopLabel: 'Stop 1',
            bannerAsset: 'assets/images/commanding_quest.jpeg',
            builder: (_) => _CommandingQuestGame(backgroundPath: bg),
          ),
          IslandMapStop(
            id: 'commanding_game',
            title: 'Choose the Commanding and Requesting Sentence',
            stopLabel: 'Stop 2',
            bannerAsset: 'assets/images/commanding_game.jpeg',
            builder: (_) => _ChooseCommandingSentenceGame(backgroundPath: bg),
          ),
          IslandMapStop(
            id: 'commanding_race',
            title: 'Sentence Race',
            stopLabel: 'Stop 3',
            bannerAsset: 'assets/images/commanding_race.jpeg',
            builder: (_) => _CommandingSentenceRaceGame(backgroundPath: bg),
          ),
        ],
      );
    }

    return IslandAdventureMapScreen(
      islandId: 'exclamatory_island',
      islandTitle: islandName,
      backgroundPath: bg,
      stopAnchors: const [
        Offset(0.50, 0.77),
        Offset(0.56, 0.50),
        Offset(0.45, 0.25),
      ],
      stops: [
        IslandMapStop(
          id: 'exclamatory_quest',
          title: 'Sentence Quest',
          stopLabel: 'Stop 1',
          bannerAsset: 'assets/images/exclamatory_quest.jpeg',
          builder: (_) => _ExclamatoryQuestGame(backgroundPath: bg),
        ),
        IslandMapStop(
          id: 'exclamatory_game',
          title: 'Choose the Exclamatory Sentence',
          stopLabel: 'Stop 2',
          bannerAsset: 'assets/images/exclamatory_game.jpeg',
          builder: (_) => _ChooseExclamatorySentenceGame(backgroundPath: bg),
        ),
        IslandMapStop(
          id: 'exclamatory_race',
          title: 'Sentence Race',
          stopLabel: 'Stop 3',
          bannerAsset: 'assets/images/exclamatory_race.jpeg',
          builder: (_) => _ExclamatorySentenceRaceGame(backgroundPath: bg),
        ),
      ],
    );
  }
}

class _PlayLevelButton extends StatelessWidget {
  final String imagePath;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onTap;

  const _PlayLevelButton({
    required this.imagePath,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          child: Opacity(
            opacity: isUnlocked ? 1.0 : 0.65,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
                if (!isUnlocked)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.38),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_rounded,
                        color: Color(0xFFFFCA28),
                        size: 40,
                      ),
                    ),
                  ),
                if (isCompleted)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFCA28),
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 1. TELLING SENTENCES ISLAND (35 items per game, 15 right answers per stop)
// ============================================================================

class _TellingQuestGame extends StatefulWidget {
  final String backgroundPath;

  const _TellingQuestGame({required this.backgroundPath});

  @override
  State<_TellingQuestGame> createState() => _TellingQuestGameState();
}

class _TellingQuestGameState extends State<_TellingQuestGame> {
  final Random _random = Random.secure();
  static const int _treasureGoal = 15;

  static const List<({String text, bool isTelling})> _questClues = [
    (text: 'The golden key rests under the oak tree.', isTelling: true),
    (text: 'Where is the hidden treasure chest?', isTelling: false),
    (text: 'Sailors follow the river to the bay.', isTelling: true),
    (text: 'Please open the wooden map box.', isTelling: false),
    (text: 'The compass points toward the north hill.', isTelling: true),
    (text: 'What a giant island we found!', isTelling: false),
    (text: 'Bright shells shine along the sandy shore.', isTelling: true),
    (text: 'The lagoon water is calm today.', isTelling: true),
    (text: 'Can you spot the lighthouse on the cliff?', isTelling: false),
    (text: 'Green palm trees sway in the breeze.', isTelling: true),
    (text: 'Please hand me the spyglass now.', isTelling: false),
    (text: 'Crabs scurry across the warm sand.', isTelling: true),
    (text: 'Hooray, we discovered the secret cave!', isTelling: false),
    (text: 'A wooden boat floats near the dock.', isTelling: true),
    (text: 'Who left footprints by the water?', isTelling: false),
    (text: 'Coconuts grow high up on the palm.', isTelling: true),
    (text: 'Walk slowly over the slippery rocks.', isTelling: false),
    (text: 'White seagulls fly above the waves.', isTelling: true),
    (text: 'How colorful those coral reefs look!', isTelling: false),
    (text: 'The sun sets behind the distant hills.', isTelling: true),
    (text: 'Sea turtles swim near the coral reef.', isTelling: true),
    (text: 'Why is the tide coming in fast?', isTelling: false),
    (text: 'Soft sand covers the little cove.', isTelling: true),
    (text: 'Please keep the picnic area clean.', isTelling: false),
    (text: 'A small raft rests by the tall reeds.', isTelling: true),
    (text: 'What a sunny morning on the beach!', isTelling: false),
    (text: 'Fishermen mend their nets at dawn.', isTelling: true),
    (text: 'Do you see the red flag by the pier?', isTelling: false),
    (text: 'Pelicans dive for fish near the rocks.', isTelling: true),
    (text: 'Bring your sun hat before going out.', isTelling: false),
    (text: 'Cool waves splash against the pebbles.', isTelling: true),
    (text: 'How fast that sailboat glides!', isTelling: false),
    (text: 'Starfish rest on the wet rocks.', isTelling: true),
    (text: 'When does the afternoon boat leave?', isTelling: false),
    (text: 'The island breeze smells fresh and salty.', isTelling: true),
  ];

  late List<({String text, bool isTelling})> _deck;
  int _index = 0;
  int _treasures = 0;
  String _message =
      'Get $_treasureGoal right answers to unlock Stop 2!';

  @override
  void initState() {
    super.initState();
    _deck = _shuffledDeck(_questClues, _random);
  }

  void _answer(bool pickTelling) {
    SoundManager.instance.playClick();
    final current = _deck[_index];
    setState(() {
      if (pickTelling == current.isTelling) {
        if (_treasures < _treasureGoal) _treasures++;
        _message = _treasures >= _treasureGoal
            ? 'Stop 1 cleared! Tap "Complete Stop 1" to unlock Stop 2!'
            : 'Treasure found! ($_treasures/$_treasureGoal) "${current.text}"';
      } else {
        _message =
            'Check the ending mark: "${current.text}" is not a telling sentence.';
      }
      _index++;
      if (_index >= _deck.length) {
        final lastShown = _deck.last;
        _deck = _shuffledDeck(_questClues, _random, previous: lastShown);
        _index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _deck[_index];
    final done = _treasures >= _treasureGoal;

    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/telling_quest.jpeg',
      title: 'Sentence Quest ($_treasures/$_treasureGoal)',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SentencePromptBox(text: current.text),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF43A047),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _answer(true),
                  child: const Text(
                    'Telling (.)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _answer(false),
                  child: const Text(
                    'Not Telling',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          if (done) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Complete Stop 1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChooseTellingSentenceGame extends StatefulWidget {
  final String backgroundPath;

  const _ChooseTellingSentenceGame({required this.backgroundPath});

  @override
  State<_ChooseTellingSentenceGame> createState() =>
      _ChooseTellingSentenceGameState();
}

class _ChooseTellingSentenceGameState
    extends State<_ChooseTellingSentenceGame> {
  final Random _random = Random.secure();
  static const int _goalCorrect = 15;
  static const int _pointsPerCorrect = 10;
  static const int _targetScore = _goalCorrect * _pointsPerCorrect;

  static const List<String> _tellingPool = [
    'The school bus arrives at seven.',
    'Birds sing in the green trees.',
    'My cat naps on the sunny mat.',
    'We read books every afternoon.',
    'Apples grow on tall branches.',
    'Rain helps the garden flowers grow.',
    'The puppy wags its happy tail.',
    'We draw pictures in art class.',
    'Frogs hop beside the quiet pond.',
    'Milk is good for strong bones.',
    'A yellow butterfly lands on the leaf.',
    'Our teacher reads stories after lunch.',
    'The library has many tall shelves.',
    'Trains travel along steel tracks.',
    'Oranges are juicy and sweet.',
    'The moon glows softly at night.',
    'Ants march in a neat line.',
    'We keep our classroom neat and tidy.',
  ];

  static const List<String> _otherPool = [
    'Where is my blue pencil?',
    'Please close the classroom door.',
    'What a bright sunny day!',
    'Can you help me carry this?',
    'Hooray, we won the game!',
    'Please pass the yellow crayons.',
    'Why is the sky so blue?',
    'Watch out for that big puddle!',
    'Do you want to play outside?',
    'Clean up your desk before lunch.',
    'Who is knocking on the door?',
    'How tall that rainbow looks!',
    'Please lend me your eraser.',
    'Did you finish your homework?',
    'What a delicious birthday cake!',
    'Stand behind the yellow line.',
    'When does school start today?',
  ];

  late List<({String text, bool isTelling})> _options;
  String? _lastCorrect;
  int _correctCount = 0;
  String _message =
      'Get $_goalCorrect right answers ($_targetScore pts) to unlock Stop 2!';

  @override
  void initState() {
    super.initState();
    _buildChoices();
  }

  void _buildChoices() {
    final tells = _shuffledDeck(_tellingPool, _random, previous: _lastCorrect);
    final others = _shuffledDeck(_otherPool, _random);
    _lastCorrect = tells.first;
    _options = [
      (text: tells.first, isTelling: true),
      (text: others[0], isTelling: false),
      (text: others[1], isTelling: false),
    ]..shuffle(_random);
  }

  void _pick(bool isTelling) {
    SoundManager.instance.playClick();
    setState(() {
      if (isTelling) {
        if (_correctCount < _goalCorrect) _correctCount++;
        _message = _correctCount >= _goalCorrect
            ? 'Stop 2 cleared! Tap "Complete Stop 2" to unlock Stop 3!'
            : 'Great job! $_correctCount/$_goalCorrect right (+$_pointsPerCorrect pts)';
      } else {
        _message = 'Try again! Look for a statement ending with (.).';
      }
      _buildChoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _correctCount >= _goalCorrect;
    final score = _correctCount * _pointsPerCorrect;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/telling_game.jpeg',
      title: 'Right: $_correctCount/$_goalCorrect • Score: $score',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._options.map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D47A1),
                  ),
                  onPressed: () => _pick(opt.isTelling),
                  child: Text(
                    opt.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
          if (done)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Complete Stop 2',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class _TellingSentenceRaceGame extends StatefulWidget {
  final String backgroundPath;

  const _TellingSentenceRaceGame({required this.backgroundPath});

  @override
  State<_TellingSentenceRaceGame> createState() =>
      _TellingSentenceRaceGameState();
}

class _TellingSentenceRaceGameState extends State<_TellingSentenceRaceGame> {
  final Random _random = Random.secure();
  static const int _goalSteps = 15;

  static const List<({String starter, String rightEnding, List<String> wrong})>
      _laps = [
    (
      starter: 'The dog runs across ___',
      rightEnding: 'the grassy yard.',
      wrong: ['the grassy yard?', 'the grassy yard!'],
    ),
    (
      starter: 'We write our names ___',
      rightEnding: 'on the top line.',
      wrong: ['on the top line?', 'on the top line!'],
    ),
    (
      starter: 'The sun shines brightly ___',
      rightEnding: 'in the blue sky.',
      wrong: ['in the blue sky?', 'in the blue sky!'],
    ),
    (
      starter: 'My little brother rides ___',
      rightEnding: 'his red bicycle.',
      wrong: ['his red bicycle?', 'his red bicycle!'],
    ),
    (
      starter: 'Butterflies land on ___',
      rightEnding: 'the pink flowers.',
      wrong: ['the pink flowers?', 'the pink flowers!'],
    ),
    (
      starter: 'The train stops at ___',
      rightEnding: 'the town station.',
      wrong: ['the town station?', 'the town station!'],
    ),
    (
      starter: 'Grandma bakes warm ___',
      rightEnding: 'chocolate cookies.',
      wrong: ['chocolate cookies?', 'chocolate cookies!'],
    ),
    (
      starter: 'Stars twinkle above ___',
      rightEnding: 'the quiet village.',
      wrong: ['the quiet village?', 'the quiet village!'],
    ),
    (
      starter: 'The turtle walks slowly ___',
      rightEnding: 'toward the pond.',
      wrong: ['toward the pond?', 'toward the pond!'],
    ),
    (
      starter: 'Our class plants ___',
      rightEnding: 'green bean seeds.',
      wrong: ['green bean seeds?', 'green bean seeds!'],
    ),
    (
      starter: 'The wind blows ___',
      rightEnding: 'the autumn leaves.',
      wrong: ['the autumn leaves?', 'the autumn leaves!'],
    ),
    (
      starter: 'Ducks swim together ___',
      rightEnding: 'in the clear lake.',
      wrong: ['in the clear lake?', 'in the clear lake!'],
    ),
    (
      starter: 'Father packs fresh ___',
      rightEnding: 'bananas for lunch.',
      wrong: ['bananas for lunch?', 'bananas for lunch!'],
    ),
    (
      starter: 'The clock rings loudly ___',
      rightEnding: 'at eight o\'clock.',
      wrong: ['at eight o\'clock?', 'at eight o\'clock!'],
    ),
    (
      starter: 'Raindrops tap gently ___',
      rightEnding: 'on the windowpane.',
      wrong: ['on the windowpane?', 'on the windowpane!'],
    ),
    (
      starter: 'A big brown bear ___',
      rightEnding: 'climbs the mountain.',
      wrong: ['climbs the mountain?', 'climbs the mountain!'],
    ),
    (
      starter: 'We sing songs together ___',
      rightEnding: 'in music class.',
      wrong: ['in music class?', 'in music class!'],
    ),
    (
      starter: 'The bakery smells sweet ___',
      rightEnding: 'with fresh bread.',
      wrong: ['with fresh bread?', 'with fresh bread!'],
    ),
    (
      starter: 'Squirrels hide acorns ___',
      rightEnding: 'inside tree holes.',
      wrong: ['inside tree holes?', 'inside tree holes!'],
    ),
    (
      starter: 'The storybook has ___',
      rightEnding: 'colorful pictures.',
      wrong: ['colorful pictures?', 'colorful pictures!'],
    ),
    (
      starter: 'Puffy white clouds ___',
      rightEnding: 'float across the sky.',
      wrong: ['float across the sky?', 'float across the sky!'],
    ),
    (
      starter: 'The baby sleeps soundly ___',
      rightEnding: 'in the warm crib.',
      wrong: ['in the warm crib?', 'in the warm crib!'],
    ),
    (
      starter: 'Bees buzz around ___',
      rightEnding: 'the blooming garden.',
      wrong: ['the blooming garden?', 'the blooming garden!'],
    ),
    (
      starter: 'We wash our hands ___',
      rightEnding: 'before eating dinner.',
      wrong: ['before eating dinner?', 'before eating dinner!'],
    ),
    (
      starter: 'The rooster crows early ___',
      rightEnding: 'at sunrise.',
      wrong: ['at sunrise?', 'at sunrise!'],
    ),
    (
      starter: 'Fresh green grass ___',
      rightEnding: 'grows in the meadow.',
      wrong: ['grows in the meadow?', 'grows in the meadow!'],
    ),
    (
      starter: 'The bus driver waves ___',
      rightEnding: 'to the pupils.',
      wrong: ['to the pupils?', 'to the pupils!'],
    ),
    (
      starter: 'Snowflakes drift softly ___',
      rightEnding: 'onto the ground.',
      wrong: ['onto the ground?', 'onto the ground!'],
    ),
    (
      starter: 'A red bird builds ___',
      rightEnding: 'a nest in the bush.',
      wrong: ['a nest in the bush?', 'a nest in the bush!'],
    ),
    (
      starter: 'We learn new words ___',
      rightEnding: 'every single day.',
      wrong: ['every single day?', 'every single day!'],
    ),
    (
      starter: 'The river flows gently ___',
      rightEnding: 'past the valley.',
      wrong: ['past the valley?', 'past the valley!'],
    ),
    (
      starter: 'Blueberries taste sweet ___',
      rightEnding: 'in the summer.',
      wrong: ['in the summer?', 'in the summer!'],
    ),
    (
      starter: 'The puppy chases ___',
      rightEnding: 'its own shadow.',
      wrong: ['its own shadow?', 'its own shadow!'],
    ),
    (
      starter: 'Our flag waves high ___',
      rightEnding: 'in the schoolyard.',
      wrong: ['in the schoolyard?', 'in the schoolyard!'],
    ),
    (
      starter: 'Fireflies glow brightly ___',
      rightEnding: 'in the evening air.',
      wrong: ['in the evening air?', 'in the evening air!'],
    ),
  ];

  late List<({String starter, String rightEnding, List<String> wrong})> _lapDeck;
  int _lapIndex = 0;
  late List<String> _choices;
  int _steps = 0;
  String _message =
      'Get $_goalSteps right answers to finish the island!';

  @override
  void initState() {
    super.initState();
    _lapDeck = _shuffledDeck(_laps, _random);
    _prepareLap();
  }

  void _prepareLap() {
    final currentLap = _lapDeck[_lapIndex];
    _choices = List.of([currentLap.rightEnding, ...currentLap.wrong])
      ..shuffle(_random);
  }

  void _advanceLap() {
    _lapIndex++;
    if (_lapIndex >= _lapDeck.length) {
      final lastLap = _lapDeck.last;
      _lapDeck = _shuffledDeck(_laps, _random, previous: lastLap);
      _lapIndex = 0;
    }
    _prepareLap();
  }

  void _chooseEnding(String ending) {
    SoundManager.instance.playClick();
    final currentLap = _lapDeck[_lapIndex];
    setState(() {
      if (ending == currentLap.rightEnding) {
        if (_steps < _goalSteps) _steps++;
        _message = _steps >= _goalSteps
            ? 'Finish line reached! Tap "Finish Island"!'
            : 'Fast finish! Right: $_steps/$_goalSteps';
      } else {
        _message = 'Telling sentences end with a period (.).';
      }
      _advanceLap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLap = _lapDeck[_lapIndex];
    final done = _steps >= _goalSteps;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/telling_race.jpeg',
      title: 'Race Progress: $_steps/$_goalSteps',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: (_steps / _goalSteps).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF43A047)),
          ),
          const SizedBox(height: 14),
          SentencePromptBox(text: currentLap.starter),
          const SizedBox(height: 12),
          ..._choices.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF9C4),
                    foregroundColor: const Color(0xFF3E2723),
                  ),
                  onPressed: () => _chooseEnding(c),
                  child: Text(
                    c,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
          if (done)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Finish Island',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. ASKING SENTENCES ISLAND (35 items per game, 15 right answers per stop)
// ============================================================================

class _AskingQuestGame extends StatefulWidget {
  final String backgroundPath;

  const _AskingQuestGame({required this.backgroundPath});

  @override
  State<_AskingQuestGame> createState() => _AskingQuestGameState();
}

class _AskingQuestGameState extends State<_AskingQuestGame> {
  final Random _random = Random.secure();
  static const int _treasureGoal = 15;

  static const List<({String text, bool isAsking})> _questClues = [
    (text: 'Where is the hidden treasure chest?', isAsking: true),
    (text: 'The golden key rests under the oak tree.', isAsking: false),
    (text: 'Can you see the red X on the map?', isAsking: true),
    (text: 'Please open the wooden map box.', isAsking: false),
    (text: 'Which path leads to the mountain cave?', isAsking: true),
    (text: 'What a giant island we found!', isAsking: false),
    (text: 'Who left the compass by the river?', isAsking: true),
    (text: 'Bright shells shine along the sandy shore.', isAsking: false),
    (text: 'How many gold coins are inside?', isAsking: true),
    (text: 'Do you hear the ocean waves?', isAsking: true),
    (text: 'The pirate ship sailed at noon.', isAsking: false),
    (text: 'Why is the lantern glowing bright?', isAsking: true),
    (text: 'Step carefully across the rope bridge.', isAsking: false),
    (text: 'Are there monkeys in those trees?', isAsking: true),
    (text: 'Hooray, we reached the top!', isAsking: false),
    (text: 'When does the ferry return to shore?', isAsking: true),
    (text: 'The map shows a sandy cove.', isAsking: false),
    (text: 'May I borrow your extra pencil?', isAsking: true),
    (text: 'Please keep the trail clean.', isAsking: false),
    (text: 'What color is the parrot\'s tail?', isAsking: true),
    (text: 'Did you pack enough snacks for today?', isAsking: true),
    (text: 'Green palm trees sway in the breeze.', isAsking: false),
    (text: 'Where can we find fresh drinking water?', isAsking: true),
    (text: 'Crabs scurry across the warm sand.', isAsking: false),
    (text: 'Will it rain before we get back?', isAsking: true),
    (text: 'The lagoon water is calm today.', isAsking: false),
    (text: 'Whose hat is lying near the palm?', isAsking: true),
    (text: 'A wooden boat floats near the dock.', isAsking: false),
    (text: 'How deep is the lagoon pool?', isAsking: true),
    (text: 'White seagulls fly above the waves.', isAsking: false),
    (text: 'Can we row across to the small cove?', isAsking: true),
    (text: 'The sun sets behind the distant hills.', isAsking: false),
    (text: 'Why are the dolphins swimming so close?', isAsking: true),
    (text: 'Please hand me the brass compass.', isAsking: false),
    (text: 'Are you ready to solve the next clue?', isAsking: true),
  ];

  late List<({String text, bool isAsking})> _deck;
  int _index = 0;
  int _treasures = 0;
  String _message =
      'Get $_treasureGoal right answers to unlock Stop 2!';

  @override
  void initState() {
    super.initState();
    _deck = _shuffledDeck(_questClues, _random);
  }

  void _answer(bool pickAsking) {
    SoundManager.instance.playClick();
    final current = _deck[_index];
    setState(() {
      if (pickAsking == current.isAsking) {
        if (_treasures < _treasureGoal) _treasures++;
        _message = _treasures >= _treasureGoal
            ? 'Stop 1 cleared! Tap "Complete Stop 1" to unlock Stop 2!'
            : 'Treasure found! ($_treasures/$_treasureGoal) "${current.text}"';
      } else {
        _message = 'Look for a question ending with (?).';
      }
      _index++;
      if (_index >= _deck.length) {
        final lastShown = _deck.last;
        _deck = _shuffledDeck(_questClues, _random, previous: lastShown);
        _index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _deck[_index];
    final done = _treasures >= _treasureGoal;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/asking_quest.jpeg',
      title: 'Sentence Quest ($_treasures/$_treasureGoal)',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SentencePromptBox(text: current.text),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _answer(true),
                  child: const Text(
                    'Asking (?)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _answer(false),
                  child: const Text(
                    'Not Asking',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          if (done) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Complete Stop 1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChooseAskingSentenceGame extends StatefulWidget {
  final String backgroundPath;

  const _ChooseAskingSentenceGame({required this.backgroundPath});

  @override
  State<_ChooseAskingSentenceGame> createState() =>
      _ChooseAskingSentenceGameState();
}

class _ChooseAskingSentenceGameState extends State<_ChooseAskingSentenceGame> {
  final Random _random = Random.secure();
  static const int _goalCorrect = 15;
  static const int _pointsPerCorrect = 10;
  static const int _targetScore = _goalCorrect * _pointsPerCorrect;

  static const List<String> _askingPool = [
    'Where is my blue pencil?',
    'What time does school start?',
    'Can you help me read this?',
    'Why is the sky so blue?',
    'Do you have an extra book?',
    'Who is knocking on the door?',
    'How many stars can you count?',
    'Did you finish your homework?',
    'Which crayon is your favorite?',
    'Is it raining outside right now?',
    'When is our art class?',
    'May I sit beside you?',
    'What is your favorite animal?',
    'Where did you put your bag?',
    'Can we play tag at recess?',
    'Why did the dog bark?',
    'How old is your little sister?',
    'Did you see the bright rainbow?',
  ];

  static const List<String> _otherPool = [
    'The school bus arrives at seven.',
    'Please close the classroom door.',
    'What a bright sunny day!',
    'Birds sing in the green trees.',
    'Hooray, we won the game!',
    'Please pass the yellow crayons.',
    'The puppy wags its happy tail.',
    'Watch out for that big puddle!',
    'Clean up your desk before lunch.',
    'We draw pictures in art class.',
    'Milk is good for strong bones.',
    'How tall that rainbow looks!',
    'Please lend me your eraser.',
    'The library has many tall shelves.',
    'What a delicious birthday cake!',
    'Stand behind the yellow line.',
    'Frogs hop beside the quiet pond.',
  ];

  late List<({String text, bool isAsking})> _options;
  String? _lastCorrect;
  int _correctCount = 0;
  String _message =
      'Get $_goalCorrect right answers ($_targetScore pts) to unlock Stop 2!';

  @override
  void initState() {
    super.initState();
    _buildChoices();
  }

  void _buildChoices() {
    final asks = _shuffledDeck(_askingPool, _random, previous: _lastCorrect);
    final others = _shuffledDeck(_otherPool, _random);
    _lastCorrect = asks.first;
    _options = [
      (text: asks.first, isAsking: true),
      (text: others[0], isAsking: false),
      (text: others[1], isAsking: false),
    ]..shuffle(_random);
  }

  void _pick(bool isAsking) {
    SoundManager.instance.playClick();
    setState(() {
      if (isAsking) {
        if (_correctCount < _goalCorrect) _correctCount++;
        _message = _correctCount >= _goalCorrect
            ? 'Stop 2 cleared! Tap "Complete Stop 2" to unlock Stop 3!'
            : 'Great job! $_correctCount/$_goalCorrect right (+$_pointsPerCorrect pts)';
      } else {
        _message = 'Try again! Look for a question ending with (.).';
      }
      _buildChoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _correctCount >= _goalCorrect;
    final score = _correctCount * _pointsPerCorrect;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/asking_game.jpeg',
      title: 'Right: $_correctCount/$_goalCorrect • Score: $score',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._options.map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D47A1),
                  ),
                  onPressed: () => _pick(opt.isAsking),
                  child: Text(
                    opt.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
          if (done)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Complete Stop 2',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class _AskingSentenceRaceGame extends StatefulWidget {
  final String backgroundPath;

  const _AskingSentenceRaceGame({required this.backgroundPath});

  @override
  State<_AskingSentenceRaceGame> createState() =>
      _AskingSentenceRaceGameState();
}

class _AskingSentenceRaceGameState extends State<_AskingSentenceRaceGame> {
  final Random _random = Random.secure();
  static const int _goalSteps = 15;

  static const List<({String starter, String rightEnding, List<String> wrong})>
      _laps = [
    (
      starter: 'Where did you leave ___',
      rightEnding: 'your yellow notebook?',
      wrong: ['your yellow notebook.', 'your yellow notebook!'],
    ),
    (
      starter: 'Can you help me ___',
      rightEnding: 'carry these books?',
      wrong: ['carry these books.', 'carry these books!'],
    ),
    (
      starter: 'What time does ___',
      rightEnding: 'the art class begin?',
      wrong: ['the art class begin.', 'the art class begin!'],
    ),
    (
      starter: 'Who is sitting in ___',
      rightEnding: 'the front row?',
      wrong: ['the front row.', 'the front row!'],
    ),
    (
      starter: 'Why are the birds ___',
      rightEnding: 'flying south today?',
      wrong: ['flying south today.', 'flying south today!'],
    ),
    (
      starter: 'How many apples are ___',
      rightEnding: 'in the basket?',
      wrong: ['in the basket.', 'in the basket!'],
    ),
    (
      starter: 'Do you know where ___',
      rightEnding: 'the library is?',
      wrong: ['the library is.', 'the library is!'],
    ),
    (
      starter: 'When will our picnic ___',
      rightEnding: 'start at the park?',
      wrong: ['start at the park.', 'start at the park!'],
    ),
    (
      starter: 'Which puzzle piece fits ___',
      rightEnding: 'in this corner?',
      wrong: ['in this corner.', 'in this corner!'],
    ),
    (
      starter: 'Are you ready for ___',
      rightEnding: 'the spelling test?',
      wrong: ['the spelling test.', 'the spelling test!'],
    ),
    (
      starter: 'What did you draw ___',
      rightEnding: 'on your paper?',
      wrong: ['on your paper.', 'on your paper!'],
    ),
    (
      starter: 'Could you pass me ___',
      rightEnding: 'the green ruler?',
      wrong: ['the green ruler.', 'the green ruler!'],
    ),
    (
      starter: 'Where does the little ___',
      rightEnding: 'kitten like to sleep?',
      wrong: ['kitten like to sleep.', 'kitten like to sleep!'],
    ),
    (
      starter: 'Why is the puppy ___',
      rightEnding: 'barking at the gate?',
      wrong: ['barking at the gate.', 'barking at the gate!'],
    ),
    (
      starter: 'How tall is that ___',
      rightEnding: 'oak tree outside?',
      wrong: ['oak tree outside.', 'oak tree outside!'],
    ),
    (
      starter: 'Did you bring your ___',
      rightEnding: 'water bottle today?',
      wrong: ['water bottle today.', 'water bottle today!'],
    ),
    (
      starter: 'Who wants to read ___',
      rightEnding: 'the next page?',
      wrong: ['the next page.', 'the next page!'],
    ),
    (
      starter: 'What kind of pet ___',
      rightEnding: 'do you have at home?',
      wrong: ['do you have at home.', 'do you have at home!'],
    ),
    (
      starter: 'Can we play hopscotch ___',
      rightEnding: 'after recess time?',
      wrong: ['after recess time.', 'after recess time!'],
    ),
    (
      starter: 'Where can we find ___',
      rightEnding: 'smooth sea shells?',
      wrong: ['smooth sea shells.', 'smooth sea shells!'],
    ),
    (
      starter: 'Why did the frog ___',
      rightEnding: 'jump into the pond?',
      wrong: ['jump into the pond.', 'jump into the pond!'],
    ),
    (
      starter: 'How many pages are ___',
      rightEnding: 'in your storybook?',
      wrong: ['in your storybook.', 'in your storybook!'],
    ),
    (
      starter: 'Do you like ___',
      rightEnding: 'chocolate ice cream?',
      wrong: ['chocolate ice cream.', 'chocolate ice cream!'],
    ),
    (
      starter: 'When is your ___',
      rightEnding: 'birthday celebration?',
      wrong: ['birthday celebration.', 'birthday celebration!'],
    ),
    (
      starter: 'Which color marker ___',
      rightEnding: 'did you use first?',
      wrong: ['did you use first.', 'did you use first!'],
    ),
    (
      starter: 'Are there any clouds ___',
      rightEnding: 'in the sky today?',
      wrong: ['in the sky today.', 'in the sky today!'],
    ),
    (
      starter: 'Who helped water ___',
      rightEnding: 'the classroom plants?',
      wrong: ['the classroom plants.', 'the classroom plants!'],
    ),
    (
      starter: 'What games do you ___',
      rightEnding: 'like to play outside?',
      wrong: ['like to play outside.', 'like to play outside!'],
    ),
    (
      starter: 'Can you count up ___',
      rightEnding: 'to thirty with me?',
      wrong: ['to thirty with me.', 'to thirty with me!'],
    ),
    (
      starter: 'Where is the bus ___',
      rightEnding: 'stopping this morning?',
      wrong: ['stopping this morning.', 'stopping this morning!'],
    ),
    (
      starter: 'Why is the baby ___',
      rightEnding: 'smiling so happily?',
      wrong: ['smiling so happily.', 'smiling so happily!'],
    ),
    (
      starter: 'How far can a ___',
      rightEnding: 'kangaroo jump at once?',
      wrong: ['kangaroo jump at once.', 'kangaroo jump at once!'],
    ),
    (
      starter: 'Did you remember ___',
      rightEnding: 'your gym shoes today?',
      wrong: ['your gym shoes today.', 'your gym shoes today!'],
    ),
    (
      starter: 'What song are we ___',
      rightEnding: 'singing in music class?',
      wrong: ['singing in music class.', 'singing in music class!'],
    ),
    (
      starter: 'May I open ___',
      rightEnding: 'the window for fresh air?',
      wrong: ['the window for fresh air.', 'the window for fresh air!'],
    ),
  ];

  late List<({String starter, String rightEnding, List<String> wrong})> _lapDeck;
  int _lapIndex = 0;
  late List<String> _choices;
  int _steps = 0;
  String _message =
      'Get $_goalSteps right answers to finish the island!';

  @override
  void initState() {
    super.initState();
    _lapDeck = _shuffledDeck(_laps, _random);
    _prepareLap();
  }

  void _prepareLap() {
    final currentLap = _lapDeck[_lapIndex];
    _choices = List.of([currentLap.rightEnding, ...currentLap.wrong])
      ..shuffle(_random);
  }

  void _advanceLap() {
    _lapIndex++;
    if (_lapIndex >= _lapDeck.length) {
      final lastLap = _lapDeck.last;
      _lapDeck = _shuffledDeck(_laps, _random, previous: lastLap);
      _lapIndex = 0;
    }
    _prepareLap();
  }

  void _chooseEnding(String ending) {
    SoundManager.instance.playClick();
    final currentLap = _lapDeck[_lapIndex];
    setState(() {
      if (ending == currentLap.rightEnding) {
        if (_steps < _goalSteps) _steps++;
        _message = _steps >= _goalSteps
            ? 'Finish line reached! Tap "Finish Island"!'
            : 'Fast finish! Right: $_steps/$_goalSteps';
      } else {
        _message = 'Asking sentences end with a question mark (?).';
      }
      _advanceLap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLap = _lapDeck[_lapIndex];
    final done = _steps >= _goalSteps;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/asking_race.jpeg',
      title: 'Race Progress: $_steps/$_goalSteps',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: (_steps / _goalSteps).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
          ),
          const SizedBox(height: 14),
          SentencePromptBox(text: currentLap.starter),
          const SizedBox(height: 12),
          ..._choices.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF9C4),
                    foregroundColor: const Color(0xFF3E2723),
                  ),
                  onPressed: () => _chooseEnding(c),
                  child: Text(
                    c,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
          if (done)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Finish Island',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. COMMANDING & REQUESTING SENTENCES ISLAND (35 items per game, 15 right)
// ============================================================================

class _CommandingQuestGame extends StatefulWidget {
  final String backgroundPath;

  const _CommandingQuestGame({required this.backgroundPath});

  @override
  State<_CommandingQuestGame> createState() => _CommandingQuestGameState();
}

class _CommandingQuestGameState extends State<_CommandingQuestGame> {
  final Random _random = Random.secure();
  static const int _treasureGoal = 15;

  static const List<({String text, bool isCommandOrRequest})> _questClues = [
    (text: 'Please open the wooden map box.', isCommandOrRequest: true),
    (text: 'The golden key rests under the oak tree.', isCommandOrRequest: false),
    (text: 'Follow the trail past the tall palm trees.', isCommandOrRequest: true),
    (text: 'Where is the hidden treasure chest?', isCommandOrRequest: false),
    (text: 'Please hand me the brass compass.', isCommandOrRequest: true),
    (text: 'Step carefully over the wooden bridge.', isCommandOrRequest: true),
    (text: 'Bright shells shine along the sandy shore.', isCommandOrRequest: false),
    (text: 'Please tie your shoelaces before running.', isCommandOrRequest: true),
    (text: 'What a giant island we found!', isCommandOrRequest: false),
    (text: 'Turn the page to read the clue.', isCommandOrRequest: true),
    (text: 'Please hold the lantern steady.', isCommandOrRequest: true),
    (text: 'Birds sing in the green trees.', isCommandOrRequest: false),
    (text: 'Listen closely to the guide.', isCommandOrRequest: true),
    (text: 'Can you see the red X?', isCommandOrRequest: false),
    (text: 'Please share the map with your partner.', isCommandOrRequest: true),
    (text: 'Stand behind the yellow line.', isCommandOrRequest: true),
    (text: 'The lagoon water is calm today.', isCommandOrRequest: false),
    (text: 'Please pick up the fallen branch.', isCommandOrRequest: true),
    (text: 'Hooray, we solved the riddle!', isCommandOrRequest: false),
    (text: 'Wait for your turn at the raft.', isCommandOrRequest: true),
    (text: 'Please pass the water jug down the row.', isCommandOrRequest: true),
    (text: 'Green palm trees sway in the breeze.', isCommandOrRequest: false),
    (text: 'Keep your voice low near the nest.', isCommandOrRequest: true),
    (text: 'Who left footprints by the water?', isCommandOrRequest: false),
    (text: 'Please draw a circle around the shell.', isCommandOrRequest: true),
    (text: 'Crabs scurry across the warm sand.', isCommandOrRequest: false),
    (text: 'Walk slowly along the narrow path.', isCommandOrRequest: true),
    (text: 'How colorful those coral reefs look!', isCommandOrRequest: false),
    (text: 'Please stack the life vests neatly.', isCommandOrRequest: true),
    (text: 'A wooden boat floats near the dock.', isCommandOrRequest: false),
    (text: 'Point to the north star on the chart.', isCommandOrRequest: true),
    (text: 'The sun sets behind the distant hills.', isCommandOrRequest: false),
    (text: 'Please help lift the heavy basket.', isCommandOrRequest: true),
    (text: 'Why is the tide coming in fast?', isCommandOrRequest: false),
    (text: 'Stay together as we cross the clearing.', isCommandOrRequest: true),
  ];

  late List<({String text, bool isCommandOrRequest})> _deck;
  int _index = 0;
  int _treasures = 0;
  String _message =
      'Get $_treasureGoal right answers to unlock Stop 2!';

  @override
  void initState() {
    super.initState();
    _deck = _shuffledDeck(_questClues, _random);
  }

  void _answer(bool pickCommand) {
    SoundManager.instance.playClick();
    final current = _deck[_index];
    setState(() {
      if (pickCommand == current.isCommandOrRequest) {
        if (_treasures < _treasureGoal) _treasures++;
        _message = _treasures >= _treasureGoal
            ? 'Stop 1 cleared! Tap "Complete Stop 1" to unlock Stop 2!'
            : 'Treasure found! ($_treasures/$_treasureGoal) "${current.text}"';
      } else {
        _message = 'Look for a command or polite request ("Please...").';
      }
      _index++;
      if (_index >= _deck.length) {
        final lastShown = _deck.last;
        _deck = _shuffledDeck(_questClues, _random, previous: lastShown);
        _index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _deck[_index];
    final done = _treasures >= _treasureGoal;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/commanding_quest.jpeg',
      title: 'Sentence Quest ($_treasures/$_treasureGoal)',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SentencePromptBox(text: current.text),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF6C00),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _answer(true),
                  child: const Text(
                    'Command / Request',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _answer(false),
                  child: const Text(
                    'Other',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          if (done) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Complete Stop 1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChooseCommandingSentenceGame extends StatefulWidget {
  final String backgroundPath;

  const _ChooseCommandingSentenceGame({required this.backgroundPath});

  @override
  State<_ChooseCommandingSentenceGame> createState() =>
      _ChooseCommandingSentenceGameState();
}

class _ChooseCommandingSentenceGameState
    extends State<_ChooseCommandingSentenceGame> {
  final Random _random = Random.secure();
  static const int _goalCorrect = 15;
  static const int _pointsPerCorrect = 10;
  static const int _targetScore = _goalCorrect * _pointsPerCorrect;

  static const List<String> _commandPool = [
    'Please close the classroom door.',
    'Wash your hands before eating.',
    'Please pass the colored crayons.',
    'Line up quietly in the hallway.',
    'Please speak softly in the library.',
    'Put your trash in the bin.',
    'Please lend me your eraser.',
    'Sit tall at your table.',
    'Please water the small plants.',
    'Push your chair in neatly.',
    'Please hand in your worksheet.',
    'Brush your teeth every morning.',
    'Please show me your drawing.',
    'Close your book when we finish.',
    'Please walk on the sidewalk.',
    'Hang your bag on the hook.',
    'Please wait for your turn.',
    'Keep your workspace tidy.',
  ];

  static const List<String> _otherPool = [
    'The school bus arrives at seven.',
    'Where is my blue pencil?',
    'What a bright sunny day!',
    'Birds sing in the green trees.',
    'Hooray, we won the game!',
    'My cat naps on the sunny mat.',
    'Why is the sky so blue?',
    'How tall that rainbow looks!',
    'We read books every afternoon.',
    'Can you help me read this?',
    'Apples grow on tall branches.',
    'Who is knocking on the door?',
    'What a delicious birthday cake!',
    'Frogs hop beside the quiet pond.',
    'Did you finish your homework?',
    'Milk is good for strong bones.',
    'What time does school start?',
  ];

  late List<({String text, bool isCommand})> _options;
  String? _lastCorrect;
  int _correctCount = 0;
  String _message =
      'Get $_goalCorrect right answers ($_targetScore pts) to unlock Stop 2!';

  @override
  void initState() {
    super.initState();
    _buildChoices();
  }

  void _buildChoices() {
    final cmds = _shuffledDeck(_commandPool, _random, previous: _lastCorrect);
    final others = _shuffledDeck(_otherPool, _random);
    _lastCorrect = cmds.first;
    _options = [
      (text: cmds.first, isCommand: true),
      (text: others[0], isCommand: false),
      (text: others[1], isCommand: false),
    ]..shuffle(_random);
  }

  void _pick(bool isCommand) {
    SoundManager.instance.playClick();
    setState(() {
      if (isCommand) {
        if (_correctCount < _goalCorrect) _correctCount++;
        _message = _correctCount >= _goalCorrect
            ? 'Stop 2 cleared! Tap "Complete Stop 2" to unlock Stop 3!'
            : 'Great job! $_correctCount/$_goalCorrect right (+$_pointsPerCorrect pts)';
      } else {
        _message = 'Try again! Look for an instruction or polite request.';
      }
      _buildChoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _correctCount >= _goalCorrect;
    final score = _correctCount * _pointsPerCorrect;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/commanding_game.jpeg',
      title: 'Right: $_correctCount/$_goalCorrect • Score: $score',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._options.map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D47A1),
                  ),
                  onPressed: () => _pick(opt.isCommand),
                  child: Text(
                    opt.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
          if (done)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Complete Stop 2',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommandingSentenceRaceGame extends StatefulWidget {
  final String backgroundPath;

  const _CommandingSentenceRaceGame({required this.backgroundPath});

  @override
  State<_CommandingSentenceRaceGame> createState() =>
      _CommandingSentenceRaceGameState();
}

class _CommandingSentenceRaceGameState
    extends State<_CommandingSentenceRaceGame> {
  final Random _random = Random.secure();
  static const int _goalSteps = 15;

  static const List<({String starter, String rightEnding, List<String> wrong})>
      _laps = [
    (
      starter: 'Please clean up ___',
      rightEnding: 'your study desk neatly.',
      wrong: ['your study desk neatly?', 'your study desk neatly!'],
    ),
    (
      starter: 'Open your notebooks ___',
      rightEnding: 'to page ten now.',
      wrong: ['to page ten now?', 'to page ten now!'],
    ),
    (
      starter: 'Please share your ___',
      rightEnding: 'colored crayons nicely.',
      wrong: ['colored crayons nicely?', 'colored crayons nicely!'],
    ),
    (
      starter: 'Bring your umbrella ___',
      rightEnding: 'before walking home.',
      wrong: ['before walking home?', 'before walking home!'],
    ),
    (
      starter: 'Please write your name ___',
      rightEnding: 'at the top of the sheet.',
      wrong: ['at the top of the sheet?', 'at the top of the sheet!'],
    ),
    (
      starter: 'Fold the paper ___',
      rightEnding: 'into two equal halves.',
      wrong: ['into two equal halves?', 'into two equal halves!'],
    ),
    (
      starter: 'Please speak softly ___',
      rightEnding: 'inside the reading corner.',
      wrong: ['inside the reading corner?', 'inside the reading corner!'],
    ),
    (
      starter: 'Put your coat ___',
      rightEnding: 'on the hook by the door.',
      wrong: ['on the hook by the door?', 'on the hook by the door!'],
    ),
    (
      starter: 'Please help me ___',
      rightEnding: 'erase the whiteboard.',
      wrong: ['erase the whiteboard?', 'erase the whiteboard!'],
    ),
    (
      starter: 'Drink a glass ___',
      rightEnding: 'of cool water after running.',
      wrong: ['of cool water after running?', 'of cool water after running!'],
    ),
    (
      starter: 'Please line up ___',
      rightEnding: 'beside the green wall.',
      wrong: ['beside the green wall?', 'beside the green wall!'],
    ),
    (
      starter: 'Check your answers ___',
      rightEnding: 'before turning in your work.',
      wrong: ['before turning in your work?', 'before turning in your work!'],
    ),
    (
      starter: 'Please pass the ___',
      rightEnding: 'bowl of fresh fruit.',
      wrong: ['bowl of fresh fruit?', 'bowl of fresh fruit!'],
    ),
    (
      starter: 'Keep your backpack ___',
      rightEnding: 'zipped tightly shut.',
      wrong: ['zipped tightly shut?', 'zipped tightly shut!'],
    ),
    (
      starter: 'Please say thank you ___',
      rightEnding: 'to the helper.',
      wrong: ['to the helper?', 'to the helper!'],
    ),
    (
      starter: 'Color inside ___',
      rightEnding: 'the lines of the drawing.',
      wrong: ['the lines of the drawing?', 'the lines of the drawing!'],
    ),
    (
      starter: 'Please turn off ___',
      rightEnding: 'the light when leaving.',
      wrong: ['the light when leaving?', 'the light when leaving!'],
    ),
    (
      starter: 'Take a deep breath ___',
      rightEnding: 'and start calmly.',
      wrong: ['and start calmly?', 'and start calmly!'],
    ),
    (
      starter: 'Please place the book ___',
      rightEnding: 'back on the shelf.',
      wrong: ['back on the shelf?', 'back on the shelf!'],
    ),
    (
      starter: 'Listen to the story ___',
      rightEnding: 'until the very end.',
      wrong: ['until the very end?', 'until the very end!'],
    ),
    (
      starter: 'Please wipe the ___',
      rightEnding: 'table with a damp cloth.',
      wrong: ['table with a damp cloth?', 'table with a damp cloth!'],
    ),
    (
      starter: 'Hold the railing ___',
      rightEnding: 'when going down the stairs.',
      wrong: ['when going down the stairs?', 'when going down the stairs!'],
    ),
    (
      starter: 'Please read the ___',
      rightEnding: 'directions out loud.',
      wrong: ['directions out loud?', 'directions out loud!'],
    ),
    (
      starter: 'Tuck your shirt ___',
      rightEnding: 'in before assembly.',
      wrong: ['in before assembly?', 'in before assembly!'],
    ),
    (
      starter: 'Please bring your ___',
      rightEnding: 'picture to the front.',
      wrong: ['picture to the front?', 'picture to the front!'],
    ),
    (
      starter: 'Sharpen your pencil ___',
      rightEnding: 'before the lesson begins.',
      wrong: ['before the lesson begins?', 'before the lesson begins!'],
    ),
    (
      starter: 'Please give the ___',
      rightEnding: 'extra paper to your friend.',
      wrong: ['extra paper to your friend?', 'extra paper to your friend!'],
    ),
    (
      starter: 'Look carefully at ___',
      rightEnding: 'the picture clues.',
      wrong: ['the picture clues?', 'the picture clues!'],
    ),
    (
      starter: 'Please close the ___',
      rightEnding: 'lid of the glue bottle.',
      wrong: ['lid of the glue bottle?', 'lid of the glue bottle!'],
    ),
    (
      starter: 'Sit quietly during ___',
      rightEnding: 'story time today.',
      wrong: ['story time today?', 'story time today!'],
    ),
    (
      starter: 'Please gather your ___',
      rightEnding: 'things for dismissal.',
      wrong: ['things for dismissal?', 'things for dismissal!'],
    ),
    (
      starter: 'Step gently over ___',
      rightEnding: 'the garden hose.',
      wrong: ['the garden hose?', 'the garden hose!'],
    ),
    (
      starter: 'Please ask a question ___',
      rightEnding: 'if you need help.',
      wrong: ['if you need help?', 'if you need help!'],
    ),
    (
      starter: 'Put the puzzle ___',
      rightEnding: 'pieces back in the box.',
      wrong: ['pieces back in the box?', 'pieces back in the box!'],
    ),
    (
      starter: 'Please smile for ___',
      rightEnding: 'our class photo.',
      wrong: ['our class photo?', 'our class photo!'],
    ),
  ];

  late List<({String starter, String rightEnding, List<String> wrong})> _lapDeck;
  int _lapIndex = 0;
  late List<String> _choices;
  int _steps = 0;
  String _message =
      'Get $_goalSteps right answers to finish the island!';

  @override
  void initState() {
    super.initState();
    _lapDeck = _shuffledDeck(_laps, _random);
    _prepareLap();
  }

  void _prepareLap() {
    final currentLap = _lapDeck[_lapIndex];
    _choices = List.of([currentLap.rightEnding, ...currentLap.wrong])
      ..shuffle(_random);
  }

  void _advanceLap() {
    _lapIndex++;
    if (_lapIndex >= _lapDeck.length) {
      final lastLap = _lapDeck.last;
      _lapDeck = _shuffledDeck(_laps, _random, previous: lastLap);
      _lapIndex = 0;
    }
    _prepareLap();
  }

  void _chooseEnding(String ending) {
    SoundManager.instance.playClick();
    final currentLap = _lapDeck[_lapIndex];
    setState(() {
      if (ending == currentLap.rightEnding) {
        if (_steps < _goalSteps) _steps++;
        _message = _steps >= _goalSteps
            ? 'Finish line reached! Tap "Finish Island"!'
            : 'Fast finish! Right: $_steps/$_goalSteps';
      } else {
        _message = 'Commands and requests usually end with a period (.).';
      }
      _advanceLap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLap = _lapDeck[_lapIndex];
    final done = _steps >= _goalSteps;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/commanding_race.jpeg',
      title: 'Race Progress: $_steps/$_goalSteps',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: (_steps / _goalSteps).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEF6C00)),
          ),
          const SizedBox(height: 14),
          SentencePromptBox(text: currentLap.starter),
          const SizedBox(height: 12),
          ..._choices.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF9C4),
                    foregroundColor: const Color(0xFF3E2723),
                  ),
                  onPressed: () => _chooseEnding(c),
                  child: Text(
                    c,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
          if (done)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Finish Island',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// 4. EXCLAMATORY SENTENCES ISLAND (35 items per game, 15 right answers per stop)
// ============================================================================

class _ExclamatoryQuestGame extends StatefulWidget {
  final String backgroundPath;

  const _ExclamatoryQuestGame({required this.backgroundPath});

  @override
  State<_ExclamatoryQuestGame> createState() => _ExclamatoryQuestGameState();
}

class _ExclamatoryQuestGameState extends State<_ExclamatoryQuestGame> {
  final Random _random = Random.secure();
  static const int _treasureGoal = 15;

  static const List<({String text, bool isExclamatory})> _questClues = [
    (text: 'What a giant treasure chest we found!', isExclamatory: true),
    (text: 'The golden key rests under the oak tree.', isExclamatory: false),
    (text: 'Hooray, our team found the hidden map!', isExclamatory: true),
    (text: 'Where is the secret cave?', isExclamatory: false),
    (text: 'How brightly that golden coin shines!', isExclamatory: true),
    (text: 'Watch out for that big puddle!', isExclamatory: true),
    (text: 'Birds sing in the green trees.', isExclamatory: false),
    (text: 'What an amazing surprise inside!', isExclamatory: true),
    (text: 'Please open the wooden map box.', isExclamatory: false),
    (text: 'How fast that dolphin jumped!', isExclamatory: true),
    (text: 'Yay, we reached the island!', isExclamatory: true),
    (text: 'The compass points north.', isExclamatory: false),
    (text: 'Oh no, my hat blew away!', isExclamatory: true),
    (text: 'Can you see the lighthouse?', isExclamatory: false),
    (text: 'What a wonderful adventure this is!', isExclamatory: true),
    (text: 'How loud the thunder roared!', isExclamatory: true),
    (text: 'Sailors follow the river.', isExclamatory: false),
    (text: 'Look out for that crab!', isExclamatory: true),
    (text: 'We walk along the shore.', isExclamatory: false),
    (text: 'How pretty that rainbow looks!', isExclamatory: true),
    (text: 'What a huge wave just crashed!', isExclamatory: true),
    (text: 'The lagoon water is calm today.', isExclamatory: false),
    (text: 'Hooray, we got a gold star!', isExclamatory: true),
    (text: 'Who left footprints by the water?', isExclamatory: false),
    (text: 'How funny that little monkey is!', isExclamatory: true),
    (text: 'Crabs scurry across the warm sand.', isExclamatory: false),
    (text: 'Watch out for that falling branch!', isExclamatory: true),
    (text: 'A wooden boat floats near the dock.', isExclamatory: false),
    (text: 'What a bright sunny day this is!', isExclamatory: true),
    (text: 'When does the ferry return to shore?', isExclamatory: false),
    (text: 'Yay, we solved the island puzzle!', isExclamatory: true),
    (text: 'White seagulls fly above the waves.', isExclamatory: false),
    (text: 'How exciting this treasure hunt is!', isExclamatory: true),
    (text: 'Please keep the picnic area clean.', isExclamatory: false),
    (text: 'Oh boy, look at that big whale!', isExclamatory: true),
  ];

  late List<({String text, bool isExclamatory})> _deck;
  int _index = 0;
  int _treasures = 0;
  String _message =
      'Get $_treasureGoal right answers to unlock Stop 2!';

  @override
  void initState() {
    super.initState();
    _deck = _shuffledDeck(_questClues, _random);
  }

  void _answer(bool pickExclamatory) {
    SoundManager.instance.playClick();
    final current = _deck[_index];
    setState(() {
      if (pickExclamatory == current.isExclamatory) {
        if (_treasures < _treasureGoal) _treasures++;
        _message = _treasures >= _treasureGoal
            ? 'Stop 1 cleared! Tap "Complete Stop 1" to unlock Stop 2!'
            : 'Treasure found! ($_treasures/$_treasureGoal) "${current.text}"';
      } else {
        _message = 'Look for an exclamatory sentence ending with (!).';
      }
      _index++;
      if (_index >= _deck.length) {
        final lastShown = _deck.last;
        _deck = _shuffledDeck(_questClues, _random, previous: lastShown);
        _index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _deck[_index];
    final done = _treasures >= _treasureGoal;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/exclamatory_quest.jpeg',
      title: 'Sentence Quest ($_treasures/$_treasureGoal)',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SentencePromptBox(text: current.text),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7043),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _answer(true),
                  child: const Text(
                    'Exclamatory (!)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _answer(false),
                  child: const Text(
                    'Not Exclamatory',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          if (done) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Complete Stop 1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChooseExclamatorySentenceGame extends StatefulWidget {
  final String backgroundPath;

  const _ChooseExclamatorySentenceGame({required this.backgroundPath});

  @override
  State<_ChooseExclamatorySentenceGame> createState() =>
      _ChooseExclamatorySentenceGameState();
}

class _ChooseExclamatorySentenceGameState
    extends State<_ChooseExclamatorySentenceGame> {
  final Random _random = Random.secure();
  static const int _goalCorrect = 15;
  static const int _pointsPerCorrect = 10;
  static const int _targetScore = _goalCorrect * _pointsPerCorrect;

  static const List<String> _exclamatoryPool = [
    'What a bright sunny day!',
    'Hooray, we won the game!',
    'How tall that rainbow looks!',
    'Watch out for that big puddle!',
    'What a delicious birthday cake!',
    'How exciting our field trip is!',
    'Yay, I got a gold star!',
    'What a huge pumpkin that is!',
    'How fast the runner zoomed!',
    'Bravo, everyone did a great job!',
    'Oh no, my ice cream dropped!',
    'What a cool robot that is!',
    'How loudly the bell rang!',
    'Hooray, summer vacation is here!',
    'What a surprise party!',
    'How high that kite flew!',
    'Yay, we finished on time!',
    'What a wonderful day to learn!',
  ];

  static const List<String> _otherPool = [
    'The school bus arrives at seven.',
    'Where is my blue pencil?',
    'Please close the classroom door.',
    'Birds sing in the green trees.',
    'Can you help me carry this?',
    'My cat naps on the sunny mat.',
    'What time does school start?',
    'Please pass the yellow crayons.',
    'We read books every afternoon.',
    'Do you have an extra book?',
    'Apples grow on tall branches.',
    'Who is knocking on the door?',
    'Clean up your desk before lunch.',
    'Frogs hop beside the quiet pond.',
    'Did you finish your homework?',
    'Milk is good for strong bones.',
    'Stand behind the yellow line.',
  ];

  late List<({String text, bool isExclamatory})> _options;
  String? _lastCorrect;
  int _correctCount = 0;
  String _message =
      'Get $_goalCorrect right answers ($_targetScore pts) to unlock Stop 2!';

  @override
  void initState() {
    super.initState();
    _buildChoices();
  }

  void _buildChoices() {
    final excls =
        _shuffledDeck(_exclamatoryPool, _random, previous: _lastCorrect);
    final others = _shuffledDeck(_otherPool, _random);
    _lastCorrect = excls.first;
    _options = [
      (text: excls.first, isExclamatory: true),
      (text: others[0], isExclamatory: false),
      (text: others[1], isExclamatory: false),
    ]..shuffle(_random);
  }

  void _pick(bool isExclamatory) {
    SoundManager.instance.playClick();
    setState(() {
      if (isExclamatory) {
        if (_correctCount < _goalCorrect) _correctCount++;
        _message = _correctCount >= _goalCorrect
            ? 'Stop 2 cleared! Tap "Complete Stop 2" to unlock Stop 3!'
            : 'Great job! $_correctCount/$_goalCorrect right (+$_pointsPerCorrect pts)';
      } else {
        _message = 'Try again! Look for strong feeling ending with (!).';
      }
      _buildChoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _correctCount >= _goalCorrect;
    final score = _correctCount * _pointsPerCorrect;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/exclamatory_game.jpeg',
      title: 'Right: $_correctCount/$_goalCorrect • Score: $score',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._options.map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D47A1),
                  ),
                  onPressed: () => _pick(opt.isExclamatory),
                  child: Text(
                    opt.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
          if (done)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Complete Stop 2',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExclamatorySentenceRaceGame extends StatefulWidget {
  final String backgroundPath;

  const _ExclamatorySentenceRaceGame({required this.backgroundPath});

  @override
  State<_ExclamatorySentenceRaceGame> createState() =>
      _ExclamatorySentenceRaceGameState();
}

class _ExclamatorySentenceRaceGameState
    extends State<_ExclamatorySentenceRaceGame> {
  final Random _random = Random.secure();
  static const int _goalSteps = 15;

  static const List<({String starter, String rightEnding, List<String> wrong})>
      _laps = [
    (
      starter: 'What a fast ___',
      rightEnding: 'red racecar that is!',
      wrong: ['red racecar that is.', 'red racecar that is?'],
    ),
    (
      starter: 'Hooray, our team ___',
      rightEnding: 'won the big race!',
      wrong: ['won the big race.', 'won the big race?'],
    ),
    (
      starter: 'How tall those ___',
      rightEnding: 'colorful balloons look!',
      wrong: ['colorful balloons look.', 'colorful balloons look?'],
    ),
    (
      starter: 'What a surprise ___',
      rightEnding: 'party this turned out to be!',
      wrong: ['party this turned out to be.', 'party this turned out to be?'],
    ),
    (
      starter: 'How loudly the ___',
      rightEnding: 'crowd cheered for us!',
      wrong: ['crowd cheered for us.', 'crowd cheered for us?'],
    ),
    (
      starter: 'Watch out for ___',
      rightEnding: 'that slippery step!',
      wrong: ['that slippery step.', 'that slippery step?'],
    ),
    (
      starter: 'What a sweet ___',
      rightEnding: 'little puppy that is!',
      wrong: ['little puppy that is.', 'little puppy that is?'],
    ),
    (
      starter: 'How high the ___',
      rightEnding: 'kite soared in the wind!',
      wrong: ['kite soared in the wind.', 'kite soared in the wind?'],
    ),
    (
      starter: 'Yay, we finally ___',
      rightEnding: 'found the golden key!',
      wrong: ['found the golden key.', 'found the golden key?'],
    ),
    (
      starter: 'What a funny ___',
      rightEnding: 'monkey face she made!',
      wrong: ['monkey face she made.', 'monkey face she made?'],
    ),
    (
      starter: 'How bright those ___',
      rightEnding: 'fireworks shine tonight!',
      wrong: ['fireworks shine tonight.', 'fireworks shine tonight?'],
    ),
    (
      starter: 'Oh no, I forgot ___',
      rightEnding: 'my lunchbox at home!',
      wrong: ['my lunchbox at home.', 'my lunchbox at home?'],
    ),
    (
      starter: 'What a clever ___',
      rightEnding: 'trick the magician did!',
      wrong: ['trick the magician did.', 'trick the magician did?'],
    ),
    (
      starter: 'How exciting the ___',
      rightEnding: 'roller coaster ride was!',
      wrong: ['roller coaster ride was.', 'roller coaster ride was?'],
    ),
    (
      starter: 'Hooray, the snow ___',
      rightEnding: 'finally started falling!',
      wrong: ['finally started falling.', 'finally started falling?'],
    ),
    (
      starter: 'What a giant ___',
      rightEnding: 'splash the whale made!',
      wrong: ['splash the whale made.', 'splash the whale made?'],
    ),
    (
      starter: 'How tasty that ___',
      rightEnding: 'freshly picked strawberry is!',
      wrong: ['freshly picked strawberry is.', 'freshly picked strawberry is?'],
    ),
    (
      starter: 'Look out, the ___',
      rightEnding: 'paint bucket is tipping!',
      wrong: ['paint bucket is tipping.', 'paint bucket is tipping?'],
    ),
    (
      starter: 'What a joyful ___',
      rightEnding: 'day at the carnival!',
      wrong: ['day at the carnival.', 'day at the carnival?'],
    ),
    (
      starter: 'How proud we feel ___',
      rightEnding: 'of our finished project!',
      wrong: ['of our finished project.', 'of our finished project?'],
    ),
    (
      starter: 'Yay, we caught ___',
      rightEnding: 'the frisbee in midair!',
      wrong: ['the frisbee in midair.', 'the frisbee in midair?'],
    ),
    (
      starter: 'What a huge ___',
      rightEnding: 'sandcastle we built!',
      wrong: ['sandcastle we built.', 'sandcastle we built?'],
    ),
    (
      starter: 'How colorful the ___',
      rightEnding: 'parade floats look today!',
      wrong: ['parade floats look today.', 'parade floats look today?'],
    ),
    (
      starter: 'Oh wow, look at ___',
      rightEnding: 'that shooting star!',
      wrong: ['that shooting star.', 'that shooting star?'],
    ),
    (
      starter: 'What a silly ___',
      rightEnding: 'hat the clown is wearing!',
      wrong: ['hat the clown is wearing.', 'hat the clown is wearing?'],
    ),
    (
      starter: 'How fast the ___',
      rightEnding: 'train zoomed past us!',
      wrong: ['train zoomed past us.', 'train zoomed past us?'],
    ),
    (
      starter: 'Hooray, we made ___',
      rightEnding: 'it to the treehouse!',
      wrong: ['it to the treehouse.', 'it to the treehouse?'],
    ),
    (
      starter: 'What a lucky ___',
      rightEnding: 'four-leaf clover I found!',
      wrong: ['four-leaf clover I found.', 'four-leaf clover I found?'],
    ),
    (
      starter: 'How sweet the ___',
      rightEnding: 'songbirds sound this morning!',
      wrong: ['songbirds sound this morning.', 'songbirds sound this morning?'],
    ),
    (
      starter: 'Watch out, that ___',
      rightEnding: 'ball is rolling fast!',
      wrong: ['ball is rolling fast.', 'ball is rolling fast?'],
    ),
    (
      starter: 'What an awesome ___',
      rightEnding: 'science project they built!',
      wrong: ['science project they built.', 'science project they built?'],
    ),
    (
      starter: 'How warm the ___',
      rightEnding: 'sunshine feels right now!',
      wrong: ['sunshine feels right now.', 'sunshine feels right now?'],
    ),
    (
      starter: 'Yay, our balloon ___',
      rightEnding: 'floated all the way up!',
      wrong: ['floated all the way up.', 'floated all the way up?'],
    ),
    (
      starter: 'What a brave ___',
      rightEnding: 'little puppy that is!',
      wrong: ['little puppy that is.', 'little puppy that is?'],
    ),
    (
      starter: 'How happy everyone ___',
      rightEnding: 'looks on field day!',
      wrong: ['looks on field day.', 'looks on field day?'],
    ),
  ];

  late List<({String starter, String rightEnding, List<String> wrong})> _lapDeck;
  int _lapIndex = 0;
  late List<String> _choices;
  int _steps = 0;
  String _message =
      'Get $_goalSteps right answers to finish the island!';

  @override
  void initState() {
    super.initState();
    _lapDeck = _shuffledDeck(_laps, _random);
    _prepareLap();
  }

  void _prepareLap() {
    final currentLap = _lapDeck[_lapIndex];
    _choices = List.of([currentLap.rightEnding, ...currentLap.wrong])
      ..shuffle(_random);
  }

  void _advanceLap() {
    _lapIndex++;
    if (_lapIndex >= _lapDeck.length) {
      final lastLap = _lapDeck.last;
      _lapDeck = _shuffledDeck(_laps, _random, previous: lastLap);
      _lapIndex = 0;
    }
    _prepareLap();
  }

  void _chooseEnding(String ending) {
    SoundManager.instance.playClick();
    final currentLap = _lapDeck[_lapIndex];
    setState(() {
      if (ending == currentLap.rightEnding) {
        if (_steps < _goalSteps) _steps++;
        _message = _steps >= _goalSteps
            ? 'Finish line reached! Tap "Finish Island"!'
            : 'Fast finish! Right: $_steps/$_goalSteps';
      } else {
        _message = 'Exclamatory sentences end with an exclamation mark (!).';
      }
      _advanceLap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLap = _lapDeck[_lapIndex];
    final done = _steps >= _goalSteps;
    return IslandMiniGameScaffold(
      backgroundPath: widget.backgroundPath,
      bannerImage: 'assets/images/exclamatory_race.jpeg',
      title: 'Race Progress: $_steps/$_goalSteps',
      message: _message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: (_steps / _goalSteps).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF7043)),
          ),
          const SizedBox(height: 14),
          SentencePromptBox(text: currentLap.starter),
          const SizedBox(height: 12),
          ..._choices.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF9C4),
                    foregroundColor: const Color(0xFF3E2723),
                  ),
                  onPressed: () => _chooseEnding(c),
                  child: Text(
                    c,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
          if (done)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Finish Island',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}