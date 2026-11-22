import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static const List<Map<String, String>> _topics = [
    {
      'image': 'assets/images/telling.jpeg',
      'title': 'Telling Sentences (Declarative)',
      'mark': 'Ends with a period ( . )',
      'explanation':
          'A telling sentence shares a fact, thought, or detail so someone learns something new.',
      'example': 'The cat sleeps on the sunny mat.',
      'tip': 'Look for a plain statement that tells you something.',
    },
    {
      'image': 'assets/images/asking.jpeg',
      'title': 'Asking Sentences (Interrogative)',
      'mark': 'Ends with a question mark ( ? )',
      'explanation':
          'An asking sentence asks a question when you want to find out an answer.',
      'example': 'Where is my blue pencil?',
      'tip': 'Often starts with words like Who, What, Where, When, Why, or Can.',
    },
    {
      'image': 'assets/images/commanding.jpeg',
      'title': 'Commanding & Requesting Sentences (Imperative)',
      'mark': 'Usually ends with a period ( . )',
      'explanation':
          'A commanding sentence tells someone what to do, and a requesting sentence asks politely.',
      'example': 'Please close the classroom door.',
      'tip': 'Watch for polite words like "Please" or action words at the start.',
    },
    {
      'image': 'assets/images/exclamatory.jpeg',
      'title': 'Exclamatory Sentences',
      'mark': 'Ends with an exclamation mark ( ! )',
      'explanation':
          'An exclamatory sentence shows strong feeling like excitement, surprise, or happiness.',
      'example': 'What a bright sunny day!',
      'tip': 'Read it with extra energy or feeling in your voice!',
    },
  ];

  void _showTopicDialog(BuildContext context, Map<String, String> topic) {
    SoundManager.instance.playClick();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          topic['title']!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFB300), width: 2),
                ),
                child: Text(
                  topic['mark']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE65100),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                topic['explanation']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15.5, height: 1.35),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E88E5), width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Example:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${topic['example']!}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                topic['tip']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                SoundManager.instance.playClick();
                Navigator.of(ctx).pop();
              },
              child: const Text('Got it!'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/learn_bg.jpeg'),
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
                    width: 48,
                    height: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/images/back.jpeg',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB74D),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white,
                                width: 2.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(top: 15, right: 15, child: SettingsButton()),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
                  child: Column(
                    children: List.generate(_topics.length, (index) {
                      final topic = _topics[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: SizedBox(
                          width: double.infinity,
                          height: 70,
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () => _showTopicDialog(context, topic),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.asset(
                                  topic['image']!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 70,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: Colors.amber,
                                          width: 2.5,
                                        ),
                                      ),
                                      child: Text(
                                        topic['title']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
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