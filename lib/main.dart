import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LaporDesaApp());
}

class LaporDesaApp extends StatelessWidget {
  const LaporDesaApp({super.key});

  static const Color green = Color(0xFF08935B);
  static const Color ink = Color(0xFF12192B);
  static const Color muted = Color(0xFF7C8494);
  static const Color field = Color(0xFFEDF0F3);
  static const Color borderColor = Color(0xFFD9DDE4);

  TextStyle _poppins(TextStyle? originalStyle) {
    return GoogleFonts.poppins(
      textStyle: originalStyle,
      color: ink,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        brightness: Brightness.light,
      ),
    );

    final TextTheme originalTextTheme = baseTheme.textTheme;

    final TextTheme poppinsTextTheme = originalTextTheme.copyWith(
      displayLarge: _poppins(originalTextTheme.displayLarge),
      displayMedium: _poppins(originalTextTheme.displayMedium),
      displaySmall: _poppins(originalTextTheme.displaySmall),
      headlineLarge: _poppins(originalTextTheme.headlineLarge),
      headlineMedium: _poppins(originalTextTheme.headlineMedium),
      headlineSmall: _poppins(originalTextTheme.headlineSmall),
      titleLarge: _poppins(originalTextTheme.titleLarge),
      titleMedium: _poppins(originalTextTheme.titleMedium),
      titleSmall: _poppins(originalTextTheme.titleSmall),
      bodyLarge: _poppins(originalTextTheme.bodyLarge),
      bodyMedium: _poppins(originalTextTheme.bodyMedium),
      bodySmall: _poppins(originalTextTheme.bodySmall),
      labelLarge: _poppins(originalTextTheme.labelLarge),
      labelMedium: _poppins(originalTextTheme.labelMedium),
      labelSmall: _poppins(originalTextTheme.labelSmall),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LaporDesa',
      theme: baseTheme.copyWith(
        textTheme: poppinsTextTheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: field,
          hintStyle: GoogleFonts.poppins(
            color: muted,
            fontSize: 13,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: borderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: green,
              width: 1.5,
            ),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/': (_) => const SplashPage(),
        '/splash': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/forgot-password': (_) => const ForgotPasswordPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}