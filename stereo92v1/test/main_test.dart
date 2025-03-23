import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stereo92v1/main.dart';

void main() {
  testWidgets('Initial state is correct', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify the initial state
    expect(find.text('S T E R E O   9 2 - Más Radio.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Play button toggles play/pause', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Wait for the audio to start
    await tester.pumpAndSettle();

    // Verify the play button is displayed
    expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);

    // Tap the play button
    await tester.tap(find.byIcon(Icons.play_circle_outline));
    await tester.pump();

    // Verify the pause button is displayed
    expect(find.byIcon(Icons.pause_circle_outline), findsOneWidget);

    // Tap the pause button
    await tester.tap(find.byIcon(Icons.pause_circle_outline));
    await tester.pump();

    // Verify the play button is displayed again
    expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
  });
}
