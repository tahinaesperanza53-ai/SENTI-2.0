import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learners_game/apply_screen.dart';
import 'package:learners_game/play_screen.dart';

void main() {
  testWidgets('Apply and Play pages show their matching backgrounds', (
    tester,
  ) async {
    const screens = [
      (ApplyScreen(), 'assets/images/apply_bg.jpeg'),
      (PlayScreen(), 'assets/images/play_bg.jpeg'),
    ];

    for (final (screen, assetPath) in screens) {
      await tester.pumpWidget(MaterialApp(home: screen));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName == assetPath,
        ),
        findsOneWidget,
      );
    }
  });
}
