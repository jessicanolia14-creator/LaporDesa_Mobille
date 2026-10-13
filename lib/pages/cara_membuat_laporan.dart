import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CaraMembuatLaporanPage extends StatelessWidget {
  const CaraMembuatLaporanPage({super.key});

  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF121212);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _cardGrey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  static const List<_GuideStep> _steps = [
    _GuideStep(
      number: '1',
      title: 'Pilih Menu Laporan',
      description:
          'Buka aplikasi dan pilih menu Lapor pada navigasi bawah.',
      icon: Icons.description_outlined,
    ),
    _GuideStep(
      number: '2',
      title: 'Pilih Jenis Masalah',
      description:
          'Pilih kategori masalah sesuai dengan kondisi '
          'di lingkungan Anda.',
      icon: Icons.category_outlined,
    ),
    _GuideStep(
      number: '3',
      title: 'Pilih Jenis Masalah',
      description:
          'Tuliskan judul dan deskripsi laporan dengan jelas '
          'dan lengkap.',
      icon: Icons.edit_note_rounded,
    ),
    _GuideStep(
      number: '4',
      title: 'Tambahkan foto (opsional)',
      description:
          'Unggah foto untuk memperjelas kondisi laporan.',
      icon: Icons.add_photo_alternate_outlined,
    ),
    _GuideStep(
      number: '5',
      title: 'Tentukan lokasi',
      description:
          'Pilih lokasi kejadian pada peta atau masukkan alamat.',
      icon: Icons.location_on_outlined,
    ),
    _GuideStep(
      number: '6',
      title: 'Kirim laporan',
      description:
          'Pilih lokasi kejadian pada peta atau masukkan alamat.',
      icon: Icons.send_outlined,
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

  Widget _header(BuildContext context, double scale) {
    return SizedBox(
      height: 66 * scale,
      child: Row(
        children: [
          SizedBox(
            width: 48 * scale,
            child: IconButton(
              tooltip: 'Kembali',
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 30 * scale,
                color: _ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Bantuan',
              textAlign: TextAlign.center,
              style: _textStyle(
                size: 35 * scale,
                weight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(width: 48 * scale),
        ],
      ),
    );
  }

  Widget _guideHeading(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 17 * scale,
      ),
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(12 * scale),
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 25 * scale,
            color: Colors.white,
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Text(
              'Cara membuat laporan',
              style: _textStyle(
                size: 17 * scale,
                color: Colors.white,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepCard(_GuideStep step, double scale) {
    return Container(
      padding: EdgeInsets.all(14 * scale),
      decoration: BoxDecoration(
        color: _cardGrey,
        borderRadius: BorderRadius.circular(13 * scale),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35 * scale,
            height: 35 * scale,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _green,
              shape: BoxShape.circle,
            ),
            child: Text(
              step.number,
              style: _textStyle(
                size: 17 * scale,
                color: Colors.white,
                weight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: _textStyle(
                    size: 15 * scale,
                    weight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 5 * scale),
                Text(
                  step.description,
                  style: _textStyle(
                    size: 13 * scale,
                    color: _muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8 * scale),
          Container(
            width: 30 * scale,
            height: 30 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _mint,
              borderRadius: BorderRadius.circular(8 * scale),
            ),
            child: Icon(
              step.icon,
              size: 21 * scale,
              color: _darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, double scale) {
    return ListView(
      padding: EdgeInsets.only(
        top: 16 * scale,
        bottom: 24 * scale,
      ),
      children: [
        _header(context, scale),
        SizedBox(height: 12 * scale),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 23 * scale,
          ),
          child: Column(
            children: [
              _guideHeading(scale),
              SizedBox(height: 16 * scale),
              for (int index = 0; index < _steps.length; index++) ...[
                _stepCard(_steps[index], scale),
                if (index < _steps.length - 1)
                  SizedBox(height: 12 * scale),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _navigationItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required double scale,
  }) {
    final bool selected = index == 3;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: () {
            if (selected) return;

            Navigator.of(context).pop<int>(index);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8 * scale,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 34 * scale,
                  color: selected ? _darkGreen : _neutral,
                ),
                SizedBox(height: 4 * scale),
                Text(
                  label,
                  style: _textStyle(
                    size: 13 * scale,
                    color: selected ? _darkGreen : _ink,
                    weight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
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

  Widget _bottomNavigation(
    BuildContext context,
    double scale,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _navigationItem(
              context: context,
              index: 0,
              label: 'Beranda',
              icon: Icons.home_outlined,
              scale: scale,
            ),
            _navigationItem(
              context: context,
              index: 1,
              label: 'Lapor',
              icon: Icons.description_outlined,
              scale: scale,
            ),
            _navigationItem(
              context: context,
              index: 2,
              label: 'Riwayat',
              icon: Icons.access_time_rounded,
              scale: scale,
            ),
            _navigationItem(
              context: context,
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
            child: _content(context, scale),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: SizedBox(
          width: contentWidth,
          child: _bottomNavigation(context, scale),
        ),
      ),
    );
  }
}

class _GuideStep {
  const _GuideStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;
}