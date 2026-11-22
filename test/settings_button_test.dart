import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learners_game/apply_screen.dart';
import 'package:learners_game/learn_screen.dart';
import 'package:learners_game/main.dart';
import 'package:learners_game/play_screen.dart';

void main() {
  testWidgets('settings button opens on every screen', (tester) async {
    const screens = [
      HomeScreen(),
      LearnScreen(),
      ApplyScreen(),
      PlayScreen(),
    ];

    for (final screen in screens) {
      await tester.pumpWidget(MaterialApp(home: screen));

      final settingsButton = find.byTooltip('Settings');
      expect(settingsButton, findsOneWidget);

      await tester.tap(settingsButton);
      await tester.pumpAndSettle();
      expect(find.text('Game Settings'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    }
  });
}
