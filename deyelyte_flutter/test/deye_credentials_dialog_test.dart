import 'package:deyelyte_flutter/components/deye_credentials_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildApp(Widget dialog) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(builder: (context) => dialog),
    ),
  );
}

void main() {
  Future<void> pumpDialog(
    WidgetTester tester, {
    required Future<void> Function(String, String) onSave,
  }) async {
    await tester.pumpWidget(_buildApp(DeyeCredentialsDialog(onSave: onSave)));
  }

  testWidgets('renders username and password fields', (tester) async {
    await pumpDialog(tester, onSave: (_, __) async {});

    expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'App ID'), findsNothing);
    expect(find.widgetWithText(TextFormField, 'App Secret'), findsNothing);
  });

  testWidgets('Connect button is disabled when fields are empty', (tester) async {
    await pumpDialog(tester, onSave: (_, __) async {});

    final connectButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Connect'),
    );
    expect(connectButton.onPressed, isNull);
  });

  testWidgets('Connect button is enabled when both fields are filled',
      (tester) async {
    await pumpDialog(tester, onSave: (_, __) async {});

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'), 'user@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'secret');
    await tester.pump();

    final connectButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Connect'),
    );
    expect(connectButton.onPressed, isNotNull);
  });

  testWidgets('calls onSave with username and password', (tester) async {
    String? capturedUsername;
    String? capturedPassword;

    await pumpDialog(
      tester,
      onSave: (u, p) async {
        capturedUsername = u;
        capturedPassword = p;
      },
    );

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'), 'myuser');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'mypass');
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Connect'));
    await tester.pumpAndSettle();

    expect(capturedUsername, 'myuser');
    expect(capturedPassword, 'mypass');
  });

  testWidgets('Cancel dismisses the dialog without calling onSave',
      (tester) async {
    bool onSaveCalled = false;

    await pumpDialog(tester, onSave: (_, __) async { onSaveCalled = true; });

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(onSaveCalled, isFalse);
    expect(find.byType(DeyeCredentialsDialog), findsNothing);
  });

  testWidgets('shows error message when onSave throws', (tester) async {
    await pumpDialog(
      tester,
      onSave: (_, __) async { throw Exception('Invalid credentials'); },
    );

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'), 'u');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'p');
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Connect'));
    await tester.pumpAndSettle();

    expect(find.byType(DeyeCredentialsDialog), findsOneWidget);
    expect(find.textContaining('Invalid credentials'), findsOneWidget);
  });
}
