import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_note/main.dart';

void main() {
  testWidgets('App should have a title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that app title is present
    expect(find.text('Home Note'), findsOneWidget);
  });

  testWidgets('App should have an input field and add button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify input field exists
    expect(find.byType(TextField), findsOneWidget);

    // Verify add button exists
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('Adding a note should display it in the list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

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

  testWidgets('App should have a login button in the top right', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify login button text exists
    expect(find.text('Login'), findsOneWidget);

    // Verify login icon exists
    expect(find.byIcon(Icons.login), findsOneWidget);
  });

  testWidgets('Login button should show login dialog when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify the dialog appears with title
    expect(find.text('Login'), findsNWidgets(2)); // One in AppBar, one in dialog title

    // Verify all three provider buttons exist
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Microsoft'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);

    // Verify close button exists
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('App should show login button when not signed in', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify login button is visible
    expect(find.text('Login'), findsOneWidget);
    expect(find.byIcon(Icons.login), findsOneWidget);
    
    // Verify cloud buttons are not visible when not signed in
    expect(find.byIcon(Icons.cloud_download), findsNothing);
    expect(find.byIcon(Icons.cloud_upload), findsNothing);
    expect(find.byIcon(Icons.logout), findsNothing);
  });

  testWidgets('App should initialize properly with delayed Google Sign-In', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Initial state should show login button
    expect(find.text('Login'), findsOneWidget);
    
    // Wait for the delayed signInSilently call (500ms)
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    
    // App should still be functional
    expect(find.text('Home Note'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });
}
