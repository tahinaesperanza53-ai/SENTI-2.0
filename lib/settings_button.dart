import 'package:flutter/material.dart';

import 'sound_manager.dart';

/// Shared settings state so chosen preferences stay saved across screens
class GameSettingsController extends ChangeNotifier {
  GameSettingsController._();
  static final GameSettingsController instance = GameSettingsController._();

  String language = 'English';
  String audioVoice = 'English';
  String textSize = 'Medium';
  bool soundOn = true;
  bool notificationsOn = true;

  void updateSettings({
    required String newLanguage,
    required String newAudioVoice,
    required String newTextSize,
    required bool newSoundOn,
    required bool newNotificationsOn,
  }) {
    language = newLanguage;
    audioVoice = newAudioVoice;
    textSize = newTextSize;
    soundOn = newSoundOn;
    notificationsOn = newNotificationsOn;
    notifyListeners();
  }
}

double settingsTextScale() {
  switch (GameSettingsController.instance.textSize) {
    case 'Small':
      return 0.9;
    case 'Large':
      return 1.2;
    case 'Medium':
    default:
      return 1.0;
  }
}

String localizedUiText({
  required String english,
  required String tagalog,
  required String cebuano,
}) {
  switch (GameSettingsController.instance.language) {
    case 'Tagalog':
      return tagalog;
    case 'Cebuano':
      return cebuano;
    case 'English':
    default:
      return english;
  }
}

class SettingsButton extends StatelessWidget {
  final VoidCallback? onResetProgress;

  const SettingsButton({super.key, this.onResetProgress});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Settings',
      child: GestureDetector(
        onTap: () {
          SoundManager.instance.playClick();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) =>
                SettingsDialog(onResetProgress: onResetProgress),
          );
        },
        child: SizedBox(
          width: 55,
          height: 55,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/settings.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.amber,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsDialog extends StatefulWidget {
  final VoidCallback? onResetProgress;

  const SettingsDialog({super.key, this.onResetProgress});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late String _language;
  late String _audioVoice;
  late String _textSize;
  late bool _soundOn;
  late bool _notificationsOn;

  @override
  void initState() {
    super.initState();
    final current = GameSettingsController.instance;
    _language = current.language;
    _audioVoice = current.audioVoice;
    _textSize = current.textSize;
    _soundOn = current.soundOn;
    _notificationsOn = current.notificationsOn;
  }

  @override
  Widget build(BuildContext context) {
    final scale = settingsTextScale();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Main Rounded Card Container
            Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 28),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAFF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF42A5F5), width: 3.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Language
                    _buildSettingSection(
                      leading: const _CircleBadgeIcon(
                        icon: Icons.language_rounded,
                        iconColor: Color(0xFF1E88E5),
                      ),
                      title: 'Language',
                      options: const ['English', 'Tagalog', 'Cebuano'],
                      selectedValue: _language,
                      scale: scale,
                      onSelected: (val) {
                        setState(() => _language = val);
                        SoundManager.instance.playClick();
                      },
                    ),
                    const Divider(height: 18, color: Color(0xFFD6E4F0)),

                    // 2. Audio / Voice
                    _buildSettingSection(
                      leading: const _CircleBadgeIcon(
                        icon: Icons.volume_up_rounded,
                        iconColor: Color(0xFF1E88E5),
                      ),
                      title: 'Audio / Voice',
                      options: const ['English', 'Tagalog', 'Cebuano'],
                      selectedValue: _audioVoice,
                      scale: scale,
                      onSelected: (val) {
                        setState(() => _audioVoice = val);
                        SoundManager.instance.playClick();
                      },
                    ),
                    const Divider(height: 18, color: Color(0xFFD6E4F0)),

                    // 3. Aa Text Size
                    _buildSettingSection(
                      leading: const _CircleBadgeText(
                        label: 'Aa',
                        color: Color(0xFF7E57C2),
                      ),
                      title: 'Aa Text Size',
                      options: const ['Small', 'Medium', 'Large'],
                      selectedValue: _textSize,
                      scale: scale,
                      onSelected: (val) {
                        setState(() => _textSize = val);
                        SoundManager.instance.playClick();
                      },
                    ),
                    const Divider(height: 18, color: Color(0xFFD6E4F0)),

                    // 4. Sound
                    _buildSettingSection(
                      leading: const _CircleBadgeIcon(
                        icon: Icons.music_note_rounded,
                        iconColor: Color(0xFF5E35B1),
                      ),
                      title: 'Sound',
                      options: const ['On', 'Off'],
                      selectedValue: _soundOn ? 'On' : 'Off',
                      scale: scale,
                      onSelected: (val) {
                        final enabled = val == 'On';
                        setState(() => _soundOn = enabled);
                        GameSettingsController.instance.soundOn = enabled;
                        SoundManager.instance.syncWithSettings();
                        if (enabled) {
                          SoundManager.instance.playClick();
                        }
                      },
                    ),
                    const Divider(height: 18, color: Color(0xFFD6E4F0)),

                    // 5. Notifications
                    _buildSettingSection(
                      leading: const _CircleBadgeIcon(
                        icon: Icons.notifications_rounded,
                        iconColor: Color(0xFFFFB300),
                      ),
                      title: 'Notifications',
                      options: const ['On', 'Off'],
                      selectedValue: _notificationsOn ? 'On' : 'Off',
                      scale: scale,
                      onSelected: (val) {
                        setState(() => _notificationsOn = (val == 'On'));
                        SoundManager.instance.playClick();
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            // Top Wooden "Settings" Banner
            Positioned(
              top: 0,
              child: _WoodenSettingsBanner(
                onClose: () {
                  SoundManager.instance.playClick();
                  Navigator.of(context).pop();
                },
              ),
            ),

            // Bottom Action Buttons overlapping the lower border
            Positioned(
              bottom: -18,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  Expanded(
                    child: _BottomActionButton(
                      icon: Icons.school_rounded,
                      label: 'Teacher Mode / Reports',
                      gradientColors: const [
                        Color(0xFFFFB74D),
                        Color(0xFFEF6C00),
                      ],
                      borderColor: const Color(0xFFBF360C),
                      onTap: () {
                        SoundManager.instance.playClick();
                        _openTeacherModeDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BottomActionButton(
                      icon: Icons.save_rounded,
                      label: 'Save Changes',
                      gradientColors: const [
                        Color(0xFF9575CD),
                        Color(0xFF5E35B1),
                      ],
                      borderColor: const Color(0xFF311B92),
                      onTap: () async {
                        SoundManager.instance.playClick();
                        GameSettingsController.instance.updateSettings(
                          newLanguage: _language,
                          newAudioVoice: _audioVoice,
                          newTextSize: _textSize,
                          newSoundOn: _soundOn,
                          newNotificationsOn: _notificationsOn,
                        );
                        await SoundManager.instance.syncWithSettings();
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        if (_notificationsOn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Saved: $_language • Voice: $_audioVoice • Text: $_textSize • Sound: ${_soundOn ? 'On' : 'Off'}',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF2E7D32),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection({
    required Widget leading,
    required String title,
    required List<String> options,
    required String selectedValue,
    required double scale,
    required ValueChanged<String> onSelected,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textScaler: TextScaler.linear(scale),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B365D),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: options.map((option) {
                  final isSelected = option == selectedValue;
                  return _OptionPillButton(
                    label: option,
                    isSelected: isSelected,
                    scale: scale,
                    onTap: () => onSelected(option),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openTeacherModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Teacher Mode / Reports',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B365D),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Active Language: $_language'),
            Text('• Audio / Voice: $_audioVoice'),
            Text('• Text Size: $_textSize'),
            Text('• Sound: ${_soundOn ? 'On' : 'Off'}'),
            Text('• Notifications: ${_notificationsOn ? 'On' : 'Off'}'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Learner Progress Summary:\n'
                '• 4 Sentence Islands (Telling, Asking, Commanding & Requesting, Exclamatory)\n'
                '• 3 Stops per Island (15 right answers per stop)\n'
                '• 35 randomized items per game',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            if (widget.onResetProgress != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFC62828),
                    side: const BorderSide(color: Color(0xFFC62828)),
                  ),
                  onPressed: () {
                    SoundManager.instance.playClick();
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                    widget.onResetProgress?.call();
                  },
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Reset Progress'),
                ),
              ),
            ],
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF6C00),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                SoundManager.instance.playClick();
                Navigator.of(ctx).pop();
              },
              child: const Text('Back to Settings'),
            ),
          ),
        ],
      ),
    );
  }
}

class _WoodenSettingsBanner extends StatelessWidget {
  final VoidCallback onClose;

  const _WoodenSettingsBanner({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE68A2E), Color(0xFFC86414)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF7A3706), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco_rounded, color: Color(0xFF43A047), size: 22),
          const SizedBox(width: 6),
          const Icon(Icons.settings, color: Color(0xFFFFD54F), size: 30),
          const SizedBox(width: 8),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Color(0xFF6D3105),
                  offset: Offset(1.5, 1.5),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClose,
            child: const Icon(
              Icons.eco_rounded,
              color: Color(0xFF43A047),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  const _CircleBadgeIcon({required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFBBDEFB), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}

class _CircleBadgeText extends StatelessWidget {
  final String label;
  final Color color;

  const _CircleBadgeText({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFBBDEFB), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _OptionPillButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double scale;
  final VoidCallback onTap;

  const _OptionPillButton({
    required this.label,
    required this.isSelected,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? const [Color(0xFF43A047), Color(0xFF2E7D32)]
                : const [Color(0xFF78909C), Color(0xFF546E7A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1B5E20)
                : const Color(0xFF37474F),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 13,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              textScaler: TextScaler.linear(scale),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final Color borderColor;
  final VoidCallback onTap;

  const _BottomActionButton({
    required this.icon,
    required this.label,
    required this.gradientColors,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 19),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
