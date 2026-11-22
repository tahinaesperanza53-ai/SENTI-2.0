import 'package:flutter_test/flutter_test.dart';
import 'package:learners_game/main.dart';

void main() {
  testWidgets('app opens on the home screen', (tester) async {
    await tester.pumpWidget(const LearnersGameApp());

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
