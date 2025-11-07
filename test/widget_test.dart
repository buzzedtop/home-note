import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_note/main.dart';

void main() {
  testWidgets('App should have a title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that app title is present
    expect(find.text('Home Note'), findsOneWidget);
  });

  testWidgets('App should have an input field and add button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify input field exists
    expect(find.byType(TextField), findsOneWidget);

    // Verify add button exists
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('Adding a note should display it in the list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Enter text in the text field
    await tester.enterText(find.byType(TextField), 'Test note');

    // Tap the add button
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Verify the note appears in the list
    expect(find.text('Test note'), findsOneWidget);
  });

  test('Note model should serialize to/from JSON', () {
    final note = Note(id: '123', content: 'Test content');
    final json = note.toJson();

    expect(json['id'], '123');
    expect(json['content'], 'Test content');

    final noteFromJson = Note.fromJson(json);
    expect(noteFromJson.id, '123');
    expect(noteFromJson.content, 'Test content');
  });
}
