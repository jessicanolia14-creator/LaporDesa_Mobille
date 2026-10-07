import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Palet warna LaporDesa.
  static const Color green = Color(0xFF08935B);
  static const Color ink = Color(0xFF12192B);
  static const Color subtitleColor = Color(0xFF64718A);
  static const Color loadingBackground = Color(0xFFE1E7EF);

  // Durasi splash dan loading.
  static const Duration splashDuration = Duration(seconds: 20);

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Mulai menghitung setelah splash pertama kali tampil.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _timer = Timer(splashDuration, () {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: 185,
      height: 185,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: 185,
          height: 185,
          child: CustomPaint(
            painter: _SplashLogoPainter(),
          ),
        );
      },
    );
  }

  Widget _buildBrandName() {
    return Text.rich(
      const TextSpan(
        children: [
          TextSpan(
            text: 'Lapor',
            style: TextStyle(color: ink),
          ),
          TextSpan(
            text: 'Desa',
            style: TextStyle(color: green),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      width: 150,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ),
        duration: splashDuration,
        builder: (context, value, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              color: green,
              backgroundColor: loadingBackground,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlogan() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 26),
        child: Text(
          'Lingkungan\n'
          'Lebih Baik,\n'
          'Dimulai dari Kita',
          textAlign: TextAlign.center,
          style: GoogleFonts.caveat(
            fontSize: 22,
            color: green,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomIllustration() {
    return Image.asset(
      'assets/images/splash_bottom.png',
      width: double.infinity,
      height: 220,
      fit: BoxFit.contain,
      alignment: Alignment.bottomCenter,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: double.infinity,
          height: 220,
          child: CustomPaint(
            painter: _SplashVillagePainter(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: constraints.maxHeight * 0.10,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          _buildLogo(),
                          const SizedBox(height: 8),
                          _buildBrandName(),
                          const SizedBox(height: 10),
                          Text(
                            'Bersama untuk lingkungan\n'
                            'yang lebih baik',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: subtitleColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 36),
                          _buildLoading(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        _buildSlogan(),
                        const SizedBox(height: 12),
                        _buildBottomIllustration(),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Logo cadangan jika logo.png belum tersedia.
class _SplashLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const darkGreen = Color(0xFF075E49);

    canvas.save();
    canvas.scale(
      size.width / 180,
      size.height / 180,
    );

    final paint = Paint()..color = darkGreen;

    // Matahari.
    canvas.drawCircle(
      const Offset(153, 26),
      13,
      Paint()..color = const Color(0xFFFFBD45),
    );

    // Badan rumah.
    canvas.drawRect(
      const Rect.fromLTWH(42, 75, 96, 71),
      paint,
    );

    // Atap rumah.
    canvas.drawPath(
      Path()
        ..moveTo(12, 82)
        ..lineTo(90, 13)
        ..lineTo(168, 82)
        ..lineTo(156, 97)
        ..lineTo(90, 40)
        ..lineTo(24, 97)
        ..close(),
      paint,
    );

    // Jendela.
    for (final x in [67.0, 92.0]) {
      for (final y in [81.0, 106.0]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, 20, 20),
            const Radius.circular(1),
          ),
          Paint()..color = Colors.white,
        );
      }
    }

    // Daun kiri.
    canvas.drawPath(
      Path()
        ..moveTo(91, 165)
        ..quadraticBezierTo(19, 164, 14, 113)
        ..quadraticBezierTo(78, 116, 91, 165)
        ..close(),
      paint,
    );

    // Daun kanan.
    canvas.drawPath(
      Path()
        ..moveTo(81, 170)
        ..quadraticBezierTo(100, 118, 169, 121)
        ..quadraticBezierTo(161, 171, 81, 170)
        ..close(),
      Paint()..color = const Color(0xFF60B63E),
    );

    // Garis daun.
    canvas.drawLine(
      const Offset(81, 168),
      const Offset(153, 136),
      Paint()
        ..color = darkGreen
        ..strokeWidth = 2,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Ilustrasi cadangan jika splash_bottom.png belum tersedia.
class _SplashVillagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const green = Color(0xFF08935B);
    const darkGreen = Color(0xFF075E49);

    // Bukit.
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..lineTo(0, size.height * 0.7)
        ..quadraticBezierTo(
          size.width * 0.3,
          0,
          size.width * 0.6,
          size.height * 0.7,
        )
        ..quadraticBezierTo(
          size.width * 0.8,
          size.height * 0.2,
          size.width,
          size.height * 0.7,
        )
        ..lineTo(size.width, size.height)
        ..close(),
      Paint()..color = const Color(0xFF84D2B7),
    );

    // Rumput.
    canvas.drawOval(
      Rect.fromLTWH(
        -30,
        size.height * 0.7,
        size.width + 60,
        size.height * 0.7,
      ),
      Paint()..color = const Color(0xFF87CE23),
    );

    // Rumah.
    for (final fraction in [0.15, 0.43, 0.73]) {
      final x = size.width * fraction;
      final y = size.height * 0.64;

      canvas.drawRect(
        Rect.fromLTWH(x, y, 40, 30),
        Paint()..color = const Color(0xFFFFE6A3),
      );

      canvas.drawPath(
        Path()
          ..moveTo(x - 6, y)
          ..lineTo(x + 20, y - 22)
          ..lineTo(x + 46, y)
          ..close(),
        Paint()..color = darkGreen,
      );

      canvas.drawRect(
        Rect.fromLTWH(x + 16, y + 12, 9, 18),
        Paint()..color = green,
      );
    }

    // Pohon.
    for (final fraction in [0.04, 0.91]) {
      final x = size.width * fraction;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, size.height * 0.48),
          width: 40,
          height: size.height * 0.7,
        ),
        Paint()..color = green,
      );

      canvas.drawLine(
        Offset(x, size.height * 0.4),
        Offset(x, size.height),
        Paint()
          ..color = darkGreen
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}