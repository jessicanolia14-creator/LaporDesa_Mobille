import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({super.key});

  static const Color green = Color(0xFF08935B);
  static const Color darkGreen = Color(0xFF00865B);
  static const Color ink = Color(0xFF12192B);
  static const Color muted = Color(0xFF68717B);
  static const Color neutral = Color(0xFF506788);
  static const Color cardGrey = Color(0xFFEDF0F3);
  static const Color border = Color(0xFFD1D6DD);

  static const String mainImage =
      'assets/images/jalan_berlubang.png';

  static const List<String> otherImages = [
    'assets/images/jalan_detail_1.png',
    'assets/images/jalan_detail_2.png',
    'assets/images/jalan_detail_3.png',
  ];

  TextStyle _textStyle({
    required double size,
    Color color = ink,
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

  void _back(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _openHomeTab(BuildContext context, int index) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, index);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Widget _photo(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (context, error, stackTrace) {
        if (path != mainImage) {
          return _photo(mainImage);
        }

        return Container(
          color: cardGrey,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: muted,
            size: 40,
          ),
        );
      },
    );
  }

  void _showPhoto(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Tutup foto',
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: _photo(path),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, double scale) {
    return SizedBox(
      height: 60 * scale,
      child: Row(
        children: [
          SizedBox(
            width: 48 * scale,
            child: IconButton(
              tooltip: 'Kembali',
              onPressed: () => _back(context),
              icon: Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 30 * scale,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Detail Laporan',
              textAlign: TextAlign.center,
              style: _textStyle(
                size: 24 * scale,
                color: Colors.black,
                weight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 48 * scale),
        ],
      ),
    );
  }

  Widget _informationRow({
    required IconData icon,
    required String text,
    required double scale,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 21 * scale,
          color: Colors.black,
        ),
        SizedBox(width: 8 * scale),
        Expanded(
          child: Text(
            text,
            style: _textStyle(
              size: 14 * scale,
              color: muted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInformation(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jalan berlubang di depan RT01',
            style: _textStyle(
              size: 16 * scale,
              color: Colors.black,
              weight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6 * scale),
          _informationRow(
            icon: Icons.location_on_outlined,
            text: 'RT 01 / RW 01',
            scale: scale,
          ),
          SizedBox(height: 6 * scale),
          _informationRow(
            icon: Icons.calendar_month_outlined,
            text: '23 September 2026',
            scale: scale,
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi',
            style: _textStyle(
              size: 16 * scale,
              color: Colors.black,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3 * scale),
          Text(
            'Jalan Berlubang dan Membahayakan '
            'pengendara, terutama saat hujan.',
            style: _textStyle(
              size: 14 * scale,
              color: muted,
              height: 1.3,
            ),
          ),
          SizedBox(height: 8 * scale),
        ],
      ),
    );
  }

  Widget _buildOtherPhotos(
    BuildContext context,
    double scale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Lainnya',
          style: _textStyle(
            size: 21 * scale,
            color: Colors.black,
            weight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 14 * scale),
        Row(
          children: [
            for (int i = 0; i < otherImages.length; i++) ...[
              if (i > 0) SizedBox(width: 26 * scale),
              Expanded(
                child: Material(
                  color: cardGrey,
                  borderRadius: BorderRadius.circular(5 * scale),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      _showPhoto(context, otherImages[i]);
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: _photo(otherImages[i]),
                    ),
                  ),
                ),
              ),
            ],
          ],
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
    final isSelected = index == 0;

    return Expanded(
      child: InkWell(
        onTap: () => _openHomeTab(context, index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8 * scale),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 34 * scale,
                color: isSelected ? darkGreen : neutral,
              ),
              SizedBox(height: 4 * scale),
              Text(
                label,
                style: _textStyle(
                  size: 12 * scale,
                  color: isSelected ? darkGreen : Colors.black,
                  weight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(
    BuildContext context,
    double scale,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: border),
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
              icon: Icons.home_rounded,
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
              icon: Icons.access_time,
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final pageWidth = screenWidth > 480 ? 480.0 : screenWidth;
    final scale = pageWidth / 390.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SizedBox(
            width: pageWidth,
            child: ListView(
              padding: EdgeInsets.only(
                top: 8 * scale,
                bottom: 16 * scale,
              ),
              children: [
                _buildHeader(context, scale),

                SizedBox(height: 12 * scale),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24 * scale,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Foto utama: proporsi mengikuti screenshot.
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(6 * scale),
                        child: AspectRatio(
                          aspectRatio: 1.56,
                          child: _photo(mainImage),
                        ),
                      ),

                      SizedBox(height: 16 * scale),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12 * scale,
                            vertical: 4 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E1),
                            borderRadius:
                                BorderRadius.circular(4 * scale),
                          ),
                          child: Text(
                            'Diproses',
                            style: _textStyle(
                              size: 18 * scale,
                              color: const Color(0xFFD98200),
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16 * scale),

                      _buildInformation(scale),

                      SizedBox(height: 32 * scale),

                      const Divider(
                        color: border,
                        height: 1,
                      ),

                      SizedBox(height: 24 * scale),

                      _buildDescription(scale),

                      SizedBox(height: 20 * scale),

                      const Divider(
                        color: border,
                        height: 1,
                      ),

                      SizedBox(height: 14 * scale),

                      _buildOtherPhotos(context, scale),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: SizedBox(
          width: pageWidth,
          child: _buildNavigation(context, scale),
        ),
      ),
    );
  }
}