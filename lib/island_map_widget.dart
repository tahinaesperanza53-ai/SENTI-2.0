import 'package:flutter/material.dart';

import 'settings_button.dart';
import 'sound_manager.dart';

class IslandMapStop {
  final String id;
  final String title;
  final String stopLabel;
  final String bannerAsset;
  final Widget Function(BuildContext context) builder;

  const IslandMapStop({
    required this.id,
    required this.title,
    required this.stopLabel,
    required this.bannerAsset,
    required this.builder,
  });
}

class IslandAdventureMapScreen extends StatefulWidget {
  final String islandId;
  final String islandTitle;
  final String backgroundPath;
  final List<IslandMapStop> stops;
  final List<Offset> stopAnchors;

  const IslandAdventureMapScreen({
    super.key,
    required this.islandId,
    required this.islandTitle,
    required this.backgroundPath,
    required this.stops,
    this.stopAnchors = const [
      Offset(0.50, 0.77),
      Offset(0.56, 0.50),
      Offset(0.46, 0.25),
    ],
  }) : assert(stops.length == 3, 'IslandAdventureMapScreen expects 3 stops.');

  @override
  State<IslandAdventureMapScreen> createState() =>
      _IslandAdventureMapScreenState();
}

class _IslandAdventureMapScreenState extends State<IslandAdventureMapScreen> {
  final Set<String> _completedStopIds = {};

  int get _starsEarned => _completedStopIds.length;

  bool _isStopUnlocked(int index) {
    if (index == 0) return true;
    return _completedStopIds.contains(widget.stops[index - 1].id);
  }

  bool _isStopCompleted(int index) {
    return _completedStopIds.contains(widget.stops[index].id);
  }

  int get _activeStopIndex {
    for (int i = 0; i < widget.stops.length; i++) {
      if (!_isStopCompleted(i)) return i;
    }
    return widget.stops.length - 1;
  }

  Future<void> _openStop(int index) async {
    SoundManager.instance.playClick();

    if (!_isStopUnlocked(index)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complete "${widget.stops[index - 1].title}" first to unlock ${widget.stops[index].title}!',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final stop = widget.stops[index];
    final completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: stop.builder),
    );

    if (completed == true && mounted) {
      setState(() {
        _completedStopIds.add(stop.id);
      });

      if (_completedStopIds.length == widget.stops.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Island completed! All 3 stops cleared!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final anchors = widget.stopAnchors;
    final allCleared = _completedStopIds.length == widget.stops.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.pop(context, allCleared);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _IslandTerrainPainter()),
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      widget.backgroundPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DottedTrailPainter(
                        points: anchors
                            .map((a) => Offset(a.dx * width, a.dy * height))
                            .toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: GestureDetector(
                      onTap: () {
                        SoundManager.instance.playClick();
                        Navigator.pop(context, allCleared);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF42A5F5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.22),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(top: 14, right: 14, child: SettingsButton()),
                  Positioned(
                    top: 14,
                    left: 72,
                    right: 72,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF8BC34A),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.islandTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 72,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFCA28),
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$_starsEarned / ${widget.stops.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...List.generate(widget.stops.length, (index) {
                    final stop = widget.stops[index];
                    final unlocked = _isStopUnlocked(index);
                    final completed = _isStopCompleted(index);
                    final isCurrent = _activeStopIndex == index && !completed;
                    final pos = anchors[index];

                    return Positioned(
                      left: (pos.dx * width) - 82,
                      top: (pos.dy * height) - 58,
                      width: 164,
                      child: _MapStopNode(
                        stop: stop,
                        stepNumber: index + 1,
                        isUnlocked: unlocked,
                        isCompleted: completed,
                        isCurrent: isCurrent,
                        onTap: () => _openStop(index),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _IslandTerrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final oceanPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), oceanPaint);

    final sandPath = Path()
      ..moveTo(w * 0.50, h * 0.14)
      ..cubicTo(w * 0.86, h * 0.18, w * 0.90, h * 0.45, w * 0.80, h * 0.72)
      ..cubicTo(w * 0.72, h * 0.90, w * 0.28, h * 0.90, w * 0.20, h * 0.72)
      ..cubicTo(w * 0.10, h * 0.45, w * 0.14, h * 0.18, w * 0.50, h * 0.14)
      ..close();

    canvas.drawPath(sandPath, Paint()..color = const Color(0xFFFFE082));

    final grassPath = Path()
      ..moveTo(w * 0.50, h * 0.18)
      ..cubicTo(w * 0.79, h * 0.22, w * 0.82, h * 0.46, w * 0.74, h * 0.69)
      ..cubicTo(w * 0.67, h * 0.84, w * 0.33, h * 0.84, w * 0.26, h * 0.69)
      ..cubicTo(w * 0.18, h * 0.46, w * 0.21, h * 0.22, w * 0.50, h * 0.18)
      ..close();

    canvas.drawPath(grassPath, Paint()..color = const Color(0xFF66BB6A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapStopNode extends StatelessWidget {
  final IslandMapStop stop;
  final int stepNumber;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback onTap;

  const _MapStopNode({
    required this.stop,
    required this.stepNumber,
    required this.isUnlocked,
    required this.isCompleted,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              width: 156,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF2E7D32)
                      : (isCurrent
                            ? const Color(0xFFFFD54F)
                            : const Color(0xFF90A4AE)),
                  width: isCurrent ? 3.5 : 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isCurrent
                        ? const Color(0xFFFFD54F).withValues(alpha: 0.65)
                        : Colors.black.withValues(alpha: 0.25),
                    blurRadius: isCurrent ? 12 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      stop.bannerAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Text(
                        stop.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  if (!isUnlocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_rounded,
                          color: Color(0xFFFFCA28),
                          size: 28,
                        ),
                      ),
                    ),
                  if (isCompleted)
                    Positioned(
                      top: 2,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ),
            Text(
              stop.stopLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DottedTrailPainter extends CustomPainter {
  final List<Offset> points;

  const _DottedTrailPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midY = (p0.dy + p1.dy) / 2;
      path.cubicTo(p0.dx, midY, p1.dx, midY, p1.dx, p1.dy);
    }

    final dotPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.fill;

    for (final metric in path.computeMetrics()) {
      const double step = 16.0;
      for (double dist = 0; dist < metric.length; dist += step) {
        final tangent = metric.getTangentForOffset(dist);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 3.8, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedTrailPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class GamePauseButton extends StatelessWidget {
  final VoidCallback? onRestart;
  final VoidCallback? onPauseStateChanged;

  const GamePauseButton({super.key, this.onRestart, this.onPauseStateChanged});

  Future<void> _openPauseDialog(BuildContext context) async {
    SoundManager.instance.playClick();
    onPauseStateChanged?.call();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDE7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: const BorderSide(color: Color(0xFF0288D1), width: 3.5),
        ),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF66BB6A), width: 2.5),
          ),
          child: const Text(
            'Pause',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PauseActionPill(
              label: 'Resume Game',
              icon: Icons.play_arrow_rounded,
              backgroundColor: const Color(0xFF43A047),
              onTap: () {
                SoundManager.instance.playClick();
                Navigator.of(ctx).pop();
              },
            ),
            const SizedBox(height: 10),
            _PauseActionPill(
              label: 'Restart Level',
              icon: Icons.refresh_rounded,
              backgroundColor: const Color(0xFFFB8C00),
              onTap: () {
                SoundManager.instance.playClick();
                Navigator.of(ctx).pop();
                onRestart?.call();
              },
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0288D1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SettingsButton(),
                  SizedBox(width: 10),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _PauseActionPill(
              label: 'Main Menu',
              icon: Icons.home_rounded,
              backgroundColor: const Color(0xFF8E24AA),
              onTap: () {
                SoundManager.instance.playClick();
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPauseDialog(context),
      child: SizedBox(
        width: 50,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            'assets/images/pause_btn.jpeg',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFCA28),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Icon(
                Icons.pause_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PauseActionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _PauseActionPill({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.white, width: 2.5),
          ),
          elevation: 3,
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class IslandMiniGameScaffold extends StatelessWidget {
  final String backgroundPath;
  final String bannerImage;
  final String title;
  final String message;
  final Widget child;
  final VoidCallback? onRestart;
  final VoidCallback? onPauseStateChanged;

  const IslandMiniGameScaffold({
    super.key,
    required this.backgroundPath,
    required this.bannerImage,
    required this.title,
    required this.message,
    required this.child,
    this.onRestart,
    this.onPauseStateChanged,
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
                    Navigator.pop(context, false);
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
              Positioned(
                top: 15,
                right: 15,
                child: GamePauseButton(
                  onRestart: onRestart,
                  onPauseStateChanged: onPauseStateChanged,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 74, 20, 24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFFFB300),
                        width: 3,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 84,
                          child: Image.asset(
                            bannerImage,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 10),
                        child,
                        const SizedBox(height: 12),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF263238),
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
      ),
    );
  }
}

class SentencePromptBox extends StatelessWidget {
  final String text;

  const SentencePromptBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E88E5), width: 2),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }
}
