import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lapordesa/features/auth/models/demo_account.dart';
import 'package:lapordesa/features/auth/views/login_page.dart';
import 'package:lapordesa/features/auth/views/register_page.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    DemoAccount.phone = '0812356654';
    DemoAccount.password = 'Budi123';
  });
  Future<void> openLogin(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(authenticate: DemoAccount.authenticate),
        routes: {
          '/register': (context) => const RegisterPage(),
          '/home': (context) =>
              const Scaffold(body: Center(child: Text('Halaman Home'))),
        },
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Login menolak form kosong', (tester) async {
    await openLogin(tester);
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.text('Isi nomor HP 10–13 digit, diawali 0'), findsOneWidget);
    expect(find.text('Bagian ini wajib diisi'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
  testWidgets('Akun simulasi dapat login', (tester) async {
    await openLogin(tester);
    final inputs = find.byType(TextFormField);
    expect(inputs, findsNWidgets(2));
    await tester.enterText(inputs.at(0), '0812356654');
    await tester.enterText(inputs.at(1), 'Budi123');
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.text('Halaman Home'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
