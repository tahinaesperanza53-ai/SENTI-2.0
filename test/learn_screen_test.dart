import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learners_game/learn_screen.dart';

void main() {
  testWidgets('four sentence image buttons open their matching lessons', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LearnScreen()));

    const buttons = [
      ('telling.jpeg', 'Telling Sentences (Declarative)'),
      ('asking.jpeg', 'Asking Sentences (Interrogative)'),
      ('commanding.jpeg', 'Commanding & Requesting Sentences (Imperative)'),
      ('exclamatory.jpeg', 'Exclamatory Sentences'),
    ];

    for (final (image, title) in buttons) {
      final buttonImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/$image',
      );
      expect(buttonImage, findsOneWidget);

      await tester.tap(buttonImage);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);

      await tester.tap(find.text('Got it!'));
      await tester.pumpAndSettle();
    }
  });
}
