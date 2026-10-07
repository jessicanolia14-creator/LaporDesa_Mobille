import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lapordesa/models/demo_account.dart';
import 'package:lapordesa/pages/login_page.dart';
import 'package:lapordesa/pages/register_page.dart';

void main() {
  setUp(() {
    // Tes tidak mengunduh font dari internet.
    GoogleFonts.config.allowRuntimeFetching = false;

    // Kembalikan akun simulasi sebelum setiap tes.
    DemoAccount.phone = '0812356654';
    DemoAccount.password = 'Budi123';
  });

  Future<void> openLogin(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          authenticate: DemoAccount.authenticate,
        ),
        routes: {
          '/register': (context) => const RegisterPage(),
        },
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets(
    'Login menolak form kosong',
    (WidgetTester tester) async {
      await openLogin(tester);

      final loginButton = find.widgetWithText(
        ElevatedButton,
        'Login',
      );

      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Isi nomor HP 10–13 digit, diawali 0'),
        findsOneWidget,
      );

      expect(
        find.text('Bagian ini wajib diisi'),
        findsOneWidget,
      );

      expect(
        find.byType(AlertDialog),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Akun simulasi dapat login',
    (WidgetTester tester) async {
      await openLogin(tester);

      final inputs = find.byType(TextFormField);

      expect(inputs, findsNWidgets(2));

      await tester.enterText(
        inputs.at(0),
        '0812356654',
      );

      await tester.enterText(
        inputs.at(1),
        'Budi123',
      );

      final loginButton = find.widgetWithText(
        ElevatedButton,
        'Login',
      );

      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(
        find.byType(AlertDialog),
        findsOneWidget,
      );

      expect(
        find.text('Login berhasil'),
        findsOneWidget,
      );
    },
  );
}