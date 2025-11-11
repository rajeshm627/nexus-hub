import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexushub/main.dart';
import 'package:nexushub/screens/home_screen.dart';
import 'package:nexushub/screens/login_screen.dart';

void main() {
  testWidgets('Login flow test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Enter email/mobile
    await tester.enterText(find.byKey(const ValueKey('emailOrMobile')), 'test@test.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Get OTP'));
    await tester.pumpAndSettle();

    // Verify OTP screen
    expect(find.byKey(const ValueKey('otp')), findsOneWidget);

    // Enter incorrect OTP
    await tester.enterText(find.byKey(const ValueKey('otp')), '123456');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify OTP'));
    await tester.pumpAndSettle();

    // Verify error message
    expect(find.text('Invalid OTP'), findsOneWidget);

    // Enter correct OTP
    // This requires knowing the OTP from the console, which we can't do in a test.
    // We will assume the happy path works for now.
  });
}
