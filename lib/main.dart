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

  // Palet warna LaporDesa.
  static const Color green = Color(0xFF08935B);
  static const Color ink = Color(0xFF12192B);
  static const Color muted = Color(0xFF7C8494);
  static const Color field = Color(0xFFEDF0F3);
  static const Color borderColor = Color(0xFFD9DDE4);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaporDesa',
      debugShowCheckedModeBanner: false,

      // Pengaturan tampilan seluruh aplikasi.
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          primary: green,
          surface: Colors.white,
        ),

        // Font utama aplikasi: Poppins.
        textTheme: ThemeData().textTheme.apply(
              fontFamily: GoogleFonts.poppins().fontFamily,
              bodyColor: ink,
              displayColor: ink,
            ),

        // Pengaturan AppBar.
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),

        // Pengaturan kolom input.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: field,
          hintStyle: const TextStyle(
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          errorMaxLines: 2,
        ),

        // Pengaturan tombol utama.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(0, 46),
            textStyle: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),

        // Pengaturan tombol teks.
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: green,
            textStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      // Aplikasi dimulai dari halaman Splash.
      initialRoute: '/splash',

      // Daftar halaman aplikasi.
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (_) => const ForgotPasswordPage(),
        '/home': (_) => const HomePage(),

      },
    );
  }
}