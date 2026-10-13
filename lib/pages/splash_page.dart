import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _ink = Color(0xFF12192B);
  static const Color _subtitleColor = Color(0xFF50617C);
  static const Color _loadingBackground = Color(0xFFE1E7EF);

  static const Duration _splashDuration = Duration(seconds: 15);

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _timer = Timer(_splashDuration, () {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed('/login');
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _logo(double scale) {
    return Image.asset(
      'assets/images/logo.png',
      width: 176 * scale,
      height: 176 * scale,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: 176 * scale,
          height: 176 * scale,
          child: Icon(
            Icons.home_outlined,
            size: 120 * scale,
            color: _green,
          ),
        );
      },
    );
  }

  Widget _brandName(double scale) {
    return Text.rich(
      const TextSpan(
        children: [
          TextSpan(
            text: 'Lapor',
            style: TextStyle(color: _ink),
          ),
          TextSpan(
            text: 'Desa',
            style: TextStyle(color: _green),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 36 * scale,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.6 * scale,
      ),
    );
  }

  Widget _subtitle(double scale) {
    return Text(
      'Bersama untuk lingkungan\n'
      'yang lebih baik',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 14 * scale,
        color: _subtitleColor,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
    );
  }

  Widget _loading(double scale) {
    return SizedBox(
      width: 142 * scale,
      height: 11 * scale,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ),
        duration: _splashDuration,
        curve: Curves.linear,
        builder: (context, value, child) {
          return Container(
            decoration: BoxDecoration(
              color: _loadingBackground,
              borderRadius: BorderRadius.circular(3 * scale),
            ),
            clipBehavior: Clip.antiAlias,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: value,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(3 * scale),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _slogan(double scale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Lingkungan\n'
          'Lebih Baik,\n'
          'Dimulai dari Kita',
          textAlign: TextAlign.center,
          style: GoogleFonts.caveat(
            fontSize: 18 * scale,
            color: _green,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        SizedBox(height: 3 * scale),
        SizedBox(
          width: 40 * scale,
          height: 5 * scale,
          child: const CustomPaint(
            painter: _SloganUnderlinePainter(),
          ),
        ),
      ],
    );
  }

  Widget _bottomIllustration(double width) {
    return Image.asset(
      'assets/images/splash_bottom.png',

      // Lebar mengikuti layar.
      // Tidak diberi tinggi tetap agar proporsi gambar terjaga.
      width: width,
      fit: BoxFit.fitWidth,
      alignment: Alignment.bottomCenter,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: width,
          height: width * 0.6,
          child: Center(
            child: Text(
              'Gambar splash_bottom.png belum ditemukan',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _subtitleColor,
              ),
            ),
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
        // Ilustrasi dapat mencapai bagian bawah layar.
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;

            // Proporsi berdasarkan screenshot Figma.
            // Ukuran ikut menyesuaikan layar emulator.
            final double scale = math.min(
              width / 300,
              height / 640,
            );

            return Stack(
              children: [
                // Ilustrasi melebar penuh dan menempel di bawah.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _bottomIllustration(width),
                ),

                // Logo, nama aplikasi, subtitle, dan loading.
                Positioned(
                  top: height * 0.11,
                  left: 16 * scale,
                  right: 16 * scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _logo(scale),
                      SizedBox(height: 5 * scale),
                      _brandName(scale),
                      SizedBox(height: 3 * scale),
                      _subtitle(scale),
                      SizedBox(height: 36 * scale),
                      _loading(scale),
                    ],
                  ),
                ),

                // Slogan di kanan, di atas ilustrasi.
                Positioned(
                  right: 17 * scale,
                  bottom: width * 0.60,
                  child: _slogan(scale),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SloganUnderlinePainter extends CustomPainter {
  const _SloganUnderlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF08935B)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.15,
        size.width,
        size.height * 0.4,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant _SloganUnderlinePainter oldDelegate,
  ) {
    return false;
  }
}