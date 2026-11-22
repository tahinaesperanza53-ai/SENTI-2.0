import 'package:flutter/material.dart';

import 'do_what_i_say_game.dart';
import 'exclamatory_sentences_game.dart';
import 'feeling_blast_game.dart';
import 'question_catcher_game.dart';
import 'real_life_sentences_game.dart';
import 'sentence_builder_game.dart';
import 'sentence_race_game.dart';
import 'settings_button.dart';
import 'sound_manager.dart';

class ApplyScreen extends StatelessWidget {
  const ApplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'id': 'sentence_builder',
        'image': 'assets/images/1.jpeg',
        'background': 'assets/images/sb_bg.jpeg',
        'title': '1. Sentence Builder',
        'description': 'Arrange word tiles into a clear, complete sentence!',
      },
      {
        'id': 'question_catcher',
        'image': 'assets/images/2.jpeg',
        'background': 'assets/images/qc_bg.jpeg',
        'title': '2. Question Catcher',
        'description':
            'Catch the asking sentences that end with a question mark (?)!',
      },
      {
        'id': 'do_what_i_say',
        'image': 'assets/images/3.jpeg',
        'background': 'assets/images/dwis_bg.jpeg',
        'title': '3. Do What I Say',
        'description': 'Spot commanding and requesting sentences!',
      },
      {
        'id': 'feeling_blast',
        'image': 'assets/images/4.jpeg',
        'background': 'assets/images/fb_bg.jpeg',
        'title': '4. Feeling Blast',
        'description': 'Match feelings and lively sentences with energy!',
      },
      {
        'id': 'exclamatory_sentences',
        'image': 'assets/images/5.jpeg',
        'background': 'assets/images/es_bg.jpeg',
        'title': '5. Exclamatory Sentences',
        'description': 'Find sentences bursting with excitement and (!)!',
      },
      {
        'id': 'real_life_sentences',
        'image': 'assets/images/6.jpeg',
        'background': 'assets/images/rlrs_bg.jpeg',
        'title': '6. Real Life, Real Sentences',
        'description': 'Practice using sentence types in everyday situations!',
      },
      {
        'id': 'sentence_race',
        'image': 'assets/images/7.jpeg',
        'background': 'assets/images/sr_bg.jpeg',
        'title': '7. Sentence Race',
        'description': 'Complete the sentence fast to race to the finish!',
      },
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/apply_bg.jpeg'),
            fit: BoxFit.cover,
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

              // Activity Grid below the "Apply" banner
              Column(
                children: [
                  const SizedBox(height: 112),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(36, 4, 36, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.95,
                          ),
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final item = activities[index];
                        return _ApplyCardButton(
                          imagePath: item['image']!,
                          onTap: () {
                            SoundManager.instance.playClick();
                            _openActivityDialog(context, item);
                          },
                        );
                      },
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

  void _openActivityDialog(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          item['title']!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          item['description']!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                SoundManager.instance.playClick();
                Navigator.of(ctx).pop();

                final Widget destination;
                switch (item['id']) {
                  case 'sentence_builder':
                    destination = SentenceBuilderGameScreen(
                      backgroundPath: item['background']!,
                    );
                    break;
                  case 'question_catcher':
                    destination = QuestionCatcherGameScreen(
                      backgroundPath: item['background']!,
                    );
                    break;
                  case 'do_what_i_say':
                    destination = DoWhatISayGameScreen(
                      backgroundPath: item['background']!,
                    );
                    break;
                  case 'feeling_blast':
                    destination = FeelingBlastGameScreen(
                      backgroundPath: item['background']!,
                    );
                    break;
                  case 'exclamatory_sentences':
                    destination = ExclamatorySentencesGameScreen(
                      backgroundPath: item['background']!,
                    );
                    break;
                  case 'real_life_sentences':
                    destination = RealLifeSentencesGameScreen(
                      backgroundPath: item['background']!,
                    );
                    break;
                  case 'sentence_race':
                    destination = SentenceRaceGameScreen(
                      backgroundPath: item['background']!,
                    );
                    break;
                  default:
                    destination = ApplyActivityScreen(
                      title: item['title']!,
                      backgroundPath: item['background']!,
                      description: item['description']!,
                    );
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => destination),
                );
              },
              child: const Text(
                'Start',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplyActivityScreen extends StatelessWidget {
  final String title;
  final String backgroundPath;
  final String description;

  const ApplyActivityScreen({
    super.key,
    required this.title,
    required this.backgroundPath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundPath),
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
                        errorBuilder: (_, _, _) {
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplyCardButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _ApplyCardButton({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
