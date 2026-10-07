import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buat_laporan_detail.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({
    super.key,
    required this.onBack,
    required this.onNavigationChanged,
    this.showBottomNavigation = true,
  });

  final VoidCallback onBack;
  final ValueChanged<int> onNavigationChanged;
  final bool showBottomNavigation;

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _mint = Color(0xFFD3F7E9);

  static const Color _ink = Color(0xFF121212);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);

  static const Color _cardGrey = Color(0xFFEDF0F3);
  static const Color _cardBorder = Color(0xFFD1D6DD);
  static const Color _progressBackground = Color(0xFFE2E8F0);

  // Belum ada pilihan ketika halaman pertama kali dibuka.
  // Karena itu, semua kartu awalnya berwarna abu-abu.
  int? _selectedCategoryIndex;

  static const List<_ReportCategory> _categories = [
    _ReportCategory(
      title: 'Jalan Rusak',
      description: 'kerusakan jalan, berlubang, dll.',
      icon: Icons.warning_rounded,
      isRoad: true,
    ),
    _ReportCategory(
      title: 'Lampu Jalan',
      description: 'Lampu mati, berkedip, dll.',
      icon: Icons.lightbulb_rounded,
    ),
    _ReportCategory(
      title: 'Sampah / Kebersihan',
      description: 'Sampah menumpuk, lingkungan kotor, dll.',
      icon: Icons.delete_rounded,
    ),
    _ReportCategory(
      title: 'Fasilitas Umum',
      description: 'Taman, posyandu, balai warga, dll.',
      icon: Icons.apartment_rounded,
    ),
    _ReportCategory(
      title: 'Bantuan Warga',
      description: 'Bantuan sosial, warga membutuhkan.',
      icon: Icons.groups_rounded,
    ),
  ];

  TextStyle _textStyle({
    required double size,
    Color color = _ink,
    FontWeight weight = FontWeight.w400,
    double height = 1.3,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
    );
  }

  Future<void> _selectCategory(int index) async {
    setState(() {
      _selectedCategoryIndex = index;
    });

    // Saat ini detail yang dibuat adalah kategori Jalan Rusak.
    if (index != 0) return;

    final int? selectedTab = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (_) => const BuatLaporanDetailPage(),
      ),
    );

    if (!mounted) return;

    if (selectedTab != null) {
      widget.onNavigationChanged(selectedTab);
    }
  }

  Widget _header(double scale) {
    return SizedBox(
      height: 56 * scale,
      child: Row(
        children: [
          SizedBox(
            width: 48 * scale,
            child: IconButton(
              onPressed: widget.onBack,
              tooltip: 'Kembali',
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 30 * scale,
                color: _ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Buat Laporan',
              textAlign: TextAlign.center,
              style: _textStyle(
                size: 25 * scale,
                weight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 48 * scale),
        ],
      ),
    );
  }

  Widget _progress(double scale) {
    return Padding(
      padding: EdgeInsets.only(
        left: 46 * scale,
        right: 26 * scale,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Langkah 1 dari 3',
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: 1 / 3,
                ),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOutCubic,
                builder: (context, value, child) {
                  return Container(
                    height: 12 * scale,
                    decoration: BoxDecoration(
                      color: _progressBackground,
                      borderRadius: BorderRadius.circular(100),
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
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 14 * scale),
          Text(
            '1/3',
            style: _textStyle(
              size: 15 * scale,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryIcon(
    _ReportCategory category,
    double scale,
  ) {
    return Container(
      width: 48 * scale,
      height: 48 * scale,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _mint,
        borderRadius: BorderRadius.circular(6 * scale),
        border: Border.all(
          color: const Color(0xFFC4E0D5),
        ),
      ),
      child: category.isRoad
          ? SizedBox(
              width: 38 * scale,
              height: 40 * scale,
              child: const CustomPaint(
                painter: _RoadConePainter(
                  color: _darkGreen,
                ),
              ),
            )
          : Icon(
              category.icon,
              size: 38 * scale,
              color: _darkGreen,
            ),
    );
  }

  Widget _categoryCard(
    _ReportCategory category,
    int index,
    double scale,
  ) {
    final bool selected = _selectedCategoryIndex == index;
    final BorderRadius radius = BorderRadius.circular(13 * scale);

    return Semantics(
      button: true,
      selected: selected,
      label: category.title,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: selected ? _green : _cardGrey,
          borderRadius: radius,
          border: Border.all(
            color: selected ? _green : _cardBorder,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: radius,
            onTap: () {
  _selectCategory(index);
},
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 85 * scale,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 9 * scale,
                  vertical: 12 * scale,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _categoryIcon(category, scale),
                    SizedBox(width: 9 * scale),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            style: _textStyle(
                              size: 18 * scale,
                              color: selected ? Colors.white : _ink,
                              weight: FontWeight.w600,
                              height: 1.2,
                            ),
                            child: Text(category.title),
                          ),
                          SizedBox(height: 3 * scale),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            style: _textStyle(
                              size: 13 * scale,
                              color: selected ? Colors.white : _muted,
                              height: 1.25,
                            ),
                            child: Text(category.description),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3 * scale),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 25 * scale,
                      color: selected ? Colors.white : _ink,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(double scale) {
    return ListView(
      padding: EdgeInsets.only(
        top: 8 * scale,
        bottom: 12 * scale,
      ),
      children: [
        _header(scale),
        SizedBox(height: 2 * scale),
        _progress(scale),
        SizedBox(height: 14 * scale),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 28 * scale,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul tanpa garis bawah.
              Text(
                'Pilih jenis masalah',
                style: _textStyle(
                  size: 18 * scale,
                  weight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5 * scale),
              Text(
                'Pilih kategori yang sesuai\nlaporan Anda.',
                style: _textStyle(
                  size: 15 * scale,
                  color: _muted,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 22 * scale),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 26 * scale,
          ),
          child: Column(
            children: [
              for (int index = 0; index < _categories.length; index++) ...[
                _categoryCard(
                  _categories[index],
                  index,
                  scale,
                ),
                if (index < _categories.length - 1)
                  SizedBox(height: 32 * scale),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _navigationItem({
    required int index,
    required String label,
    required IconData icon,
    required double scale,
  }) {
    final bool selected = index == 1;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: () {
            widget.onNavigationChanged(index);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5 * scale,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 34 * scale,
                  color: selected ? _darkGreen : _neutral,
                ),
                SizedBox(height: 2 * scale),
                Text(
                  label,
                  style: _textStyle(
                    size: 12 * scale,
                    color: selected ? _darkGreen : _ink,
                    weight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigation(double scale) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: _cardBorder,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _navigationItem(
              index: 0,
              label: 'Beranda',
              icon: Icons.home_outlined,
              scale: scale,
            ),
            _navigationItem(
              index: 1,
              label: 'Lapor',
              icon: Icons.description_outlined,
              scale: scale,
            ),
            _navigationItem(
              index: 2,
              label: 'Riwayat',
              icon: Icons.access_time_rounded,
              scale: scale,
            ),
            _navigationItem(
              index: 3,
              label: 'Bantuan',
              icon: Icons.headset_mic_outlined,
              scale: scale,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double contentWidth =
        screenWidth > 480 ? 480.0 : screenWidth;
    final double scale = contentWidth / 390;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: _content(scale),
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNavigation
          ? Center(
              heightFactor: 1,
              child: SizedBox(
                width: contentWidth,
                child: _bottomNavigation(scale),
              ),
            )
          : null,
    );
  }
}

class _ReportCategory {
  const _ReportCategory({
    required this.title,
    required this.description,
    required this.icon,
    this.isRoad = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isRoad;
}

class _RoadConePainter extends CustomPainter {
  const _RoadConePainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path cone = Path()
      ..moveTo(size.width * 0.43, size.height * 0.08)
      ..quadraticBezierTo(
        size.width * 0.5,
        0,
        size.width * 0.57,
        size.height * 0.08,
      )
      ..lineTo(size.width * 0.86, size.height * 0.82)
      ..lineTo(size.width * 0.14, size.height * 0.82)
      ..close();

    canvas.drawPath(cone, paint);

    final Paint stripePaint = Paint()
      ..color = const Color(0xFFD3F7E9);

    canvas.save();
    canvas.clipPath(cone);

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height * 0.25,
        size.width,
        size.height * 0.08,
      ),
      stripePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height * 0.48,
        size.width,
        size.height * 0.08,
      ),
      stripePaint,
    );

    canvas.restore();

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.02,
          size.height * 0.84,
          size.width * 0.96,
          size.height * 0.12,
        ),
        Radius.circular(size.width * 0.04),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RoadConePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}