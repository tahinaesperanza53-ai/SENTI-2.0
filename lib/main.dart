import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'apply_screen.dart';
import 'learn_screen.dart';
import 'play_screen.dart';
import 'settings_button.dart';
import 'sound_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoundManager.instance.init();
  runApp(const LearnersGameApp());
}

class LearnersGameApp extends StatefulWidget {
  const LearnersGameApp({super.key});

  @override
  State<LearnersGameApp> createState() => _LearnersGameAppState();
}

class _LearnersGameAppState extends State<LearnersGameApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      SoundManager.instance.pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      SoundManager.instance.syncWithSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GameSettingsController.instance,
      builder: (context, _) {
        final scale = settingsTextScale();
        return MaterialApp(
          title: 'Are You Ready Learners?',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.fredokaTextTheme(
              Theme.of(context).textTheme,
            ),
            primarySwatch: Colors.amber,
          ),
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openScreen(BuildContext context, Widget screen) {
    SoundManager.instance.playClick();
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Home.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main Menu Content (Centered across the full screen)
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),
                    _ImageMenuButton(
                      imagePath: 'assets/images/Learn.jpeg',
                      onPressed: () =>
                          _openScreen(context, const LearnScreen()),
                    ),
                    const SizedBox(height: 12),
                    _ImageMenuButton(
                      imagePath: 'assets/images/Apply.jpeg',
                      onPressed: () =>
                          _openScreen(context, const ApplyScreen()),
                    ),
                    const SizedBox(height: 12),
                    _ImageMenuButton(
                      imagePath: 'assets/images/Play.jpeg',
                      onPressed: () => _openScreen(context, const PlayScreen()),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),

              // Placed after the SizedBox so the gear stays tappable on top
              const Positioned(top: 15, right: 15, child: SettingsButton()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageMenuButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const _ImageMenuButton({required this.imagePath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          width: 260,
          height: 75,
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
